Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbbGQQSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:18:13 -0400
Subject: [PATCH 16/27] PKCS#7: Check content type and versions
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:18:06 +0100
Message-ID: <20150717161806.2578.85483.stgit@warthog.procyon.org.uk> (sfid-20150717_182224_009500_D6FB4D60)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We only support PKCS#7 signed-data [RFC2315 sec 9] content at the top level,
so reject anything else.  Further, check that the version numbers in
SignedData and SignerInfo are 1 in both cases.

Note that we don't restrict the inner content type.  In the PKCS#7 code we
don't parse the data attached there, but merely verify the signature over
it.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-By: David Woodhouse <David.Woodhouse@intel.com>
---

 crypto/asymmetric_keys/pkcs7.asn1     |    6 +--
 crypto/asymmetric_keys/pkcs7_parser.c |   75 +++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7.asn1 b/crypto/asymmetric_keys/pkcs7.asn1
index a5a14ef28c86..05504431e1c1 100644
--- a/crypto/asymmetric_keys/pkcs7.asn1
+++ b/crypto/asymmetric_keys/pkcs7.asn1
@@ -1,12 +1,12 @@
 PKCS7ContentInfo ::= SEQUENCE {
-	contentType	ContentType,
+	contentType	ContentType ({ pkcs7_check_content_type }),
 	content		[0] EXPLICIT SignedData OPTIONAL
 }
 
 ContentType ::= OBJECT IDENTIFIER ({ pkcs7_note_OID })
 
 SignedData ::= SEQUENCE {
-	version			INTEGER,
+	version			INTEGER ({ pkcs7_note_signeddata_version }),
 	digestAlgorithms	DigestAlgorithmIdentifiers,
 	contentInfo		ContentInfo,
 	certificates		CHOICE {
@@ -68,7 +68,7 @@ SignerInfos ::= CHOICE {
 }
 
 SignerInfo ::= SEQUENCE {
-	version			INTEGER,
+	version			INTEGER ({ pkcs7_note_signerinfo_version }),
 	issuerAndSerialNumber	IssuerAndSerialNumber,
 	digestAlgorithm		DigestAlgorithmIdentifier ({ pkcs7_sig_note_digest_algo }),
 	authenticatedAttributes	CHOICE {
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 3bd5a1e4c493..ab427f04b299 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -226,6 +226,79 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 }
 
 /*
+ * We only support signed data [RFC2315 sec 9].
+ */
+int pkcs7_check_content_type(void *context, size_t hdrlen,
+			     unsigned char tag,
+			     const void *value, size_t vlen)
+{
+	struct pkcs7_parse_context *ctx = context;
+
+	if (ctx->last_oid != OID_signed_data) {
+		pr_warn("Only support pkcs7_signedData type\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Note the SignedData version
+ */
+int pkcs7_note_signeddata_version(void *context, size_t hdrlen,
+				  unsigned char tag,
+				  const void *value, size_t vlen)
+{
+	unsigned version;
+
+	if (vlen != 1)
+		goto unsupported;
+
+	version = *(const u8 *)value;
+	switch (version) {
+	case 1:
+		/* PKCS#7 SignedData [RFC2315 sec 9.1] */
+		break;
+	default:
+		goto unsupported;
+	}
+
+	return 0;
+
+unsupported:
+	pr_warn("Unsupported SignedData version\n");
+	return -EINVAL;
+}
+
+/*
+ * Note the SignerInfo version
+ */
+int pkcs7_note_signerinfo_version(void *context, size_t hdrlen,
+				  unsigned char tag,
+				  const void *value, size_t vlen)
+{
+	unsigned version;
+
+	if (vlen != 1)
+		goto unsupported;
+
+	version = *(const u8 *)value;
+	switch (version) {
+	case 1:
+		/* PKCS#7 SignerInfo [RFC2315 sec 9.2] */
+		break;
+	default:
+		goto unsupported;
+	}
+
+	return 0;
+
+unsupported:
+	pr_warn("Unsupported SignerInfo version\n");
+	return -EINVAL;
+}
+
+/*
  * Extract a certificate and store it in the context.
  */
 int pkcs7_extract_cert(void *context, size_t hdrlen,
@@ -326,7 +399,7 @@ int pkcs7_sig_note_authenticated_attr(void *context, size_t hdrlen,
 }
 
 /*
- * Note the set of auth attributes for digestion purposes [RFC2315 9.3]
+ * Note the set of auth attributes for digestion purposes [RFC2315 sec 9.3]
  */
 int pkcs7_sig_note_set_of_authattrs(void *context, size_t hdrlen,
 				    unsigned char tag,

