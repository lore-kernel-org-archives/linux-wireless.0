Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbbGQQS7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:18:59 -0400
Subject: [PATCH 20/27] PKCS#7: Support CMS messages also [RFC5652]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:18:52 +0100
Message-ID: <20150717161852.2578.47865.stgit@warthog.procyon.org.uk> (sfid-20150717_182140_750893_2F0825B9)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since CMS is an evolution of PKCS#7, with much of the ASN.1 being
compatible, add support for CMS signed-data messages also [RFC5652 sec 5].

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-By: David Woodhouse <David.Woodhouse@intel.com>
---

 crypto/asymmetric_keys/pkcs7.asn1     |   10 +++++
 crypto/asymmetric_keys/pkcs7_parser.c |   62 +++++++++++++++++++++++++++++----
 crypto/asymmetric_keys/pkcs7_parser.h |    5 ++-
 3 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7.asn1 b/crypto/asymmetric_keys/pkcs7.asn1
index 05504431e1c1..6bf8ff4f7414 100644
--- a/crypto/asymmetric_keys/pkcs7.asn1
+++ b/crypto/asymmetric_keys/pkcs7.asn1
@@ -69,7 +69,7 @@ SignerInfos ::= CHOICE {
 
 SignerInfo ::= SEQUENCE {
 	version			INTEGER ({ pkcs7_note_signerinfo_version }),
-	issuerAndSerialNumber	IssuerAndSerialNumber,
+	sid			SignerIdentifier, -- CMS variant, not PKCS#7
 	digestAlgorithm		DigestAlgorithmIdentifier ({ pkcs7_sig_note_digest_algo }),
 	authenticatedAttributes	CHOICE {
 		aaSet		[0] IMPLICIT SetOfAuthenticatedAttribute
@@ -88,6 +88,12 @@ SignerInfo ::= SEQUENCE {
 	} OPTIONAL
 } ({ pkcs7_note_signed_info })
 
+SignerIdentifier ::= CHOICE {
+	-- RFC5652 sec 5.3
+	issuerAndSerialNumber IssuerAndSerialNumber,
+        subjectKeyIdentifier [0] IMPLICIT SubjectKeyIdentifier
+}
+
 IssuerAndSerialNumber ::= SEQUENCE {
 	issuer			Name ({ pkcs7_sig_note_issuer }),
 	serialNumber		CertificateSerialNumber ({ pkcs7_sig_note_serial })
@@ -95,6 +101,8 @@ IssuerAndSerialNumber ::= SEQUENCE {
 
 CertificateSerialNumber ::= INTEGER
 
+SubjectKeyIdentifier ::= OCTET STRING ({ pkcs7_sig_note_skid })
+
 SetOfAuthenticatedAttribute ::= SET OF AuthenticatedAttribute
 
 AuthenticatedAttribute ::= SEQUENCE {
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index ab427f04b299..826e2f3f507b 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -33,6 +33,9 @@ struct pkcs7_parse_context {
 	unsigned	raw_serial_size;
 	unsigned	raw_issuer_size;
 	const void	*raw_issuer;
+	const void	*raw_skid;
+	unsigned	raw_skid_size;
+	bool		expect_skid;
 };
 
 /*
@@ -249,15 +252,21 @@ int pkcs7_note_signeddata_version(void *context, size_t hdrlen,
 				  unsigned char tag,
 				  const void *value, size_t vlen)
 {
+	struct pkcs7_parse_context *ctx = context;
 	unsigned version;
 
 	if (vlen != 1)
 		goto unsupported;
 
-	version = *(const u8 *)value;
+	ctx->msg->version = version = *(const u8 *)value;
 	switch (version) {
 	case 1:
-		/* PKCS#7 SignedData [RFC2315 sec 9.1] */
+		/* PKCS#7 SignedData [RFC2315 sec 9.1]
+		 * CMS ver 1 SignedData [RFC5652 sec 5.1]
+		 */
+		break;
+	case 3:
+		/* CMS ver 3 SignedData [RFC2315 sec 5.1] */
 		break;
 	default:
 		goto unsupported;
@@ -277,6 +286,7 @@ int pkcs7_note_signerinfo_version(void *context, size_t hdrlen,
 				  unsigned char tag,
 				  const void *value, size_t vlen)
 {
+	struct pkcs7_parse_context *ctx = context;
 	unsigned version;
 
 	if (vlen != 1)
@@ -285,7 +295,18 @@ int pkcs7_note_signerinfo_version(void *context, size_t hdrlen,
 	version = *(const u8 *)value;
 	switch (version) {
 	case 1:
-		/* PKCS#7 SignerInfo [RFC2315 sec 9.2] */
+		/* PKCS#7 SignerInfo [RFC2315 sec 9.2]
+		 * CMS ver 1 SignerInfo [RFC5652 sec 5.3]
+		 */
+		if (ctx->msg->version != 1)
+			goto version_mismatch;
+		ctx->expect_skid = false;
+		break;
+	case 3:
+		/* CMS ver 3 SignerInfo [RFC2315 sec 5.3] */
+		if (ctx->msg->version == 1)
+			goto version_mismatch;
+		ctx->expect_skid = true;
 		break;
 	default:
 		goto unsupported;
@@ -296,6 +317,9 @@ int pkcs7_note_signerinfo_version(void *context, size_t hdrlen,
 unsupported:
 	pr_warn("Unsupported SignerInfo version\n");
 	return -EINVAL;
+version_mismatch:
+	pr_warn("SignedData-SignerInfo version mismatch\n");
+	return -EBADMSG;
 }
 
 /*
@@ -440,6 +464,22 @@ int pkcs7_sig_note_issuer(void *context, size_t hdrlen,
 }
 
 /*
+ * Note the issuing cert's subjectKeyIdentifier
+ */
+int pkcs7_sig_note_skid(void *context, size_t hdrlen,
+			unsigned char tag,
+			const void *value, size_t vlen)
+{
+	struct pkcs7_parse_context *ctx = context;
+
+	pr_devel("SKID: %02x %zu [%*ph]\n", tag, vlen, (unsigned)vlen, value);
+
+	ctx->raw_skid = value;
+	ctx->raw_skid_size = vlen;
+	return 0;
+}
+
+/*
  * Note the signature data
  */
 int pkcs7_sig_note_signature(void *context, size_t hdrlen,
@@ -472,13 +512,21 @@ int pkcs7_note_signed_info(void *context, size_t hdrlen,
 	struct asymmetric_key_id *kid;
 
 	/* Generate cert issuer + serial number key ID */
-	kid = asymmetric_key_generate_id(ctx->raw_serial,
-					 ctx->raw_serial_size,
-					 ctx->raw_issuer,
-					 ctx->raw_issuer_size);
+	if (!ctx->expect_skid) {
+		kid = asymmetric_key_generate_id(ctx->raw_serial,
+						 ctx->raw_serial_size,
+						 ctx->raw_issuer,
+						 ctx->raw_issuer_size);
+	} else {
+		kid = asymmetric_key_generate_id(ctx->raw_skid,
+						 ctx->raw_skid_size,
+						 "", 0);
+	}
 	if (IS_ERR(kid))
 		return PTR_ERR(kid);
 
+	pr_devel("SINFO KID: %u [%*phN]\n", kid->len, kid->len, kid->data);
+
 	sinfo->signing_cert_id = kid;
 	sinfo->index = ++ctx->sinfo_index;
 	*ctx->ppsinfo = sinfo;
diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index efc7dc9b8f9c..790dd7cec82c 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -33,7 +33,9 @@ struct pkcs7_signed_info {
 	unsigned	authattrs_len;
 	const void	*authattrs;
 
-	/* Issuing cert serial number and issuer's name */
+	/* Issuing cert serial number and issuer's name [PKCS#7 or CMS ver 1]
+	 * or issuing cert's SKID [CMS ver 3].
+	 */
 	struct asymmetric_key_id *signing_cert_id;
 
 	/* Message signature.
@@ -50,6 +52,7 @@ struct pkcs7_message {
 	struct x509_certificate *certs;	/* Certificate list */
 	struct x509_certificate *crl;	/* Revocation list */
 	struct pkcs7_signed_info *signed_infos;
+	u8		version;	/* Version of cert (1 -> PKCS#7 or CMS; 3 -> CMS) */
 
 	/* Content Data (or NULL) */
 	enum OID	data_type;	/* Type of Data */

