Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbbGQQT6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:19:58 -0400
Subject: [PATCH 25/27] X.509: Parse the keyUsage extension to detect
 key-signing keys
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:19:52 +0100
Message-ID: <20150717161952.2578.20500.stgit@warthog.procyon.org.uk> (sfid-20150717_182111_489827_E0D5CBF0)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse the keyUsage extension to detect keys for which the purpose is key
signing and to restrict their use only to the verification of signatures on
keys.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/x509_cert_parser.c |   39 ++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index da2fa399f859..b339dddd2674 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
+#include <linux/bitrev.h>
 #include "public_key.h"
 #include "x509_parser.h"
 #include "x509-asn1.h"
@@ -457,9 +458,44 @@ int x509_process_extension(void *context, size_t hdrlen,
 	struct x509_parse_context *ctx = context;
 	struct asymmetric_key_id *kid;
 	const unsigned char *v = value;
+	u32 nr_unused_bits, tmp;
 
 	pr_debug("Extension: %u\n", ctx->last_oid);
 
+	if (ctx->last_oid == OID_keyUsage) {
+		/* There's a bitstring inside the content that we want to get
+		 * at.  In the content of the bitstring, the first octet says
+		 * how many of the trailing bits are relevant.  Logical bits
+		 * 0-7 are in octet 1, bits 7-0 (note the inversion); 8-15 are
+		 * in octet 2, bits 7-0.
+		 *
+		 * [X.680 22.4, X.690 6.2 and X.690 8.6.2.1]
+		 */
+		if (vlen < 3)
+			return -EBADMSG;
+		if (v[0] != ASN1_BTS || v[1] != vlen - 2)
+			return -EBADMSG;
+		nr_unused_bits = v[2];
+		if (nr_unused_bits > 7)
+			return -EBADMSG;
+		vlen -= 3;
+		v += 3;
+		if (vlen == 0)
+			return 0;
+
+		tmp = v[0];
+		if (vlen == 1 && nr_unused_bits > 0)
+			tmp &= ~((1 << nr_unused_bits) - 1);
+		tmp = bitrev8(tmp);
+		pr_debug("keyUsage %x\n", tmp);
+
+		/* check for keyCertSign */
+		if (tmp & (1 << 5))
+			ctx->cert->pub->usage_restriction =
+				KEY_RESTRICTED_TO_KEY_SIGNING;
+		return 0;
+	}
+
 	if (ctx->last_oid == OID_subjectKeyIdentifier) {
 		/* Get hold of the key fingerprint */
 		if (ctx->cert->skid || vlen < 3)
@@ -490,7 +526,8 @@ int x509_process_extension(void *context, size_t hdrlen,
 		/* Get hold of the extended key usage information */
 		ctx->raw_extusage = v;
 		ctx->raw_extusage_size = vlen;
-		ctx->cert->pub->usage_restriction = KEY_RESTRICTED_USAGE;
+		if (ctx->cert->pub->usage_restriction == KEY_USAGE_NOT_SPECIFIED)
+			ctx->cert->pub->usage_restriction = KEY_RESTRICTED_USAGE;
 		return 0;
 	}
 

