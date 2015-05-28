Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbbE1Ps7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:48:59 -0400
Subject: [PATCH 18/20] X.509: Parse the keyUsage extension to detect
 key-signing keys [ver #5]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Thu, 28 May 2015 16:48:53 +0100
Message-ID: <20150528154853.1259.65019.stgit@warthog.procyon.org.uk> (sfid-20150528_175057_941803_22216C20)
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse the keyUsage extension to detect keys for which the purpose is key
signing and to restrict their use only to the verification of signatures on
keys.

Not-yet-signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/x509_cert_parser.c |   45 ++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 4d9e9a7f8fd2..82b869de1759 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -457,9 +457,51 @@ int x509_process_extension(void *context, size_t hdrlen,
 	struct x509_parse_context *ctx = context;
 	struct asymmetric_key_id *kid;
 	const unsigned char *v = value;
+	u32 shift, tmp;
 
 	pr_debug("Extension: %u\n", ctx->last_oid);
 
+	if (ctx->last_oid == OID_keyUsage) {
+		/* There's a bitstring inside the content that we want to get
+		 * at.  This bitstring is shuffled up so that the most
+		 * significant set bit is the MSB of the second byte.  The
+		 * first byte tells us how far we have to shift the string back
+		 * to put bit string bit 0 on a byte bit 0.
+		 */
+		if (vlen < 3)
+			return -EBADMSG;
+		if (v[0] != ASN1_BTS || v[1] != vlen - 2)
+			return -EBADMSG;
+		shift = v[2];
+		if (shift > 7)
+			return -EBADMSG;
+		v += 3;
+		vlen -= 3;
+		if (vlen > 2) {
+			/* We only care about the least significant 9 bits, but
+			 * they will be spread over up to two bytes (leading 0s
+			 * aren't stored).
+			 */
+			v += vlen - 2;
+			vlen = 2;
+		}
+
+		tmp = 0;
+		if (vlen == 2) {
+			tmp = (u32)*v << 8;
+			v++;
+		}
+		if (vlen >= 1)
+			tmp |= *v;
+		tmp >>= shift;
+		pr_debug("keyUsage %x\n", tmp);
+		/* check for keyCertSign */
+		if (tmp & (1 << 5))
+			ctx->cert->pub->usage_restriction =
+				PKEY_RESTRICTED_TO_KEY_SIGNING;
+		return 0;
+	}
+
 	if (ctx->last_oid == OID_subjectKeyIdentifier) {
 		/* Get hold of the key fingerprint */
 		if (ctx->cert->skid || vlen < 3)
@@ -492,7 +534,8 @@ int x509_process_extension(void *context, size_t hdrlen,
 		/* Get hold of the extended key usage information */
 		ctx->raw_extusage = v;
 		ctx->raw_extusage_size = vlen;
-		ctx->cert->pub->usage_restriction = PKEY_RESTRICTED_USAGE;
+		if (ctx->cert->pub->usage_restriction == PKEY_USAGE_NOT_SPECIFIED)
+			ctx->cert->pub->usage_restriction = PKEY_RESTRICTED_USAGE;
 		return 0;
 	}
 

