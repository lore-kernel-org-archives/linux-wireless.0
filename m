Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbbGQQSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:18:47 -0400
Subject: [PATCH 19/27] X.509: Change recorded SKID & AKID to not include
 Subject or Issuer
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:18:41 +0100
Message-ID: <20150717161841.2578.62256.stgit@warthog.procyon.org.uk> (sfid-20150717_182149_571472_B1CD5422)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The key identifiers fabricated from an X.509 certificate are currently:

 (A) Concatenation of serial number and issuer

 (B) Concatenation of subject and subjectKeyID (SKID)

When verifying one X.509 certificate with another, the AKID in the target
can be used to match the authoritative certificate.  The AKID can specify
the match in one or both of two ways:

 (1) Compare authorityCertSerialNumber and authorityCertIssuer from the AKID
     to identifier (A) above.

 (2) Compare keyIdentifier from the AKID plus the issuer from the target
     certificate to identifier (B) above.

When verifying a PKCS#7 message, the only available comparison is between
the IssuerAndSerialNumber field and identifier (A) above.

However, a subsequent patch adds CMS support.  Whilst CMS still supports a
match on IssuerAndSerialNumber as for PKCS#7, it also supports an
alternative - which is the SubjectKeyIdentifier field.  This is used to
match to an X.509 certificate on the SKID alone.  No subject information is
available to be used.

To this end change the fabrication of (B) above to be from the X.509 SKID
alone.  The AKID in keyIdentifier form then only matches on that and does
not include the issuer.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-By: David Woodhouse <David.Woodhouse@intel.com>
---

 crypto/asymmetric_keys/x509_cert_parser.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 6c130dd56f35..849fd760923e 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -454,9 +454,7 @@ int x509_process_extension(void *context, size_t hdrlen,
 
 		ctx->cert->raw_skid_size = vlen;
 		ctx->cert->raw_skid = v;
-		kid = asymmetric_key_generate_id(ctx->cert->raw_subject,
-						 ctx->cert->raw_subject_size,
-						 v, vlen);
+		kid = asymmetric_key_generate_id(v, vlen, "", 0);
 		if (IS_ERR(kid))
 			return PTR_ERR(kid);
 		ctx->cert->skid = kid;
@@ -553,9 +551,7 @@ int x509_akid_note_kid(void *context, size_t hdrlen,
 	if (ctx->cert->akid_skid)
 		return 0;
 
-	kid = asymmetric_key_generate_id(ctx->cert->raw_issuer,
-					 ctx->cert->raw_issuer_size,
-					 value, vlen);
+	kid = asymmetric_key_generate_id(value, vlen, "", 0);
 	if (IS_ERR(kid))
 		return PTR_ERR(kid);
 	pr_debug("authkeyid %*phN\n", kid->len, kid->data);

