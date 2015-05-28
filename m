Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbbE1PtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:49:17 -0400
Subject: [PATCH 20/20] sign-file: use .p7s instead of .pkcs7 file extension
 [ver #5]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Thu, 28 May 2015 16:49:10 +0100
Message-ID: <20150528154910.1259.44636.stgit@warthog.procyon.org.uk> (sfid-20150528_174938_945563_72A03E3A)
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@suse.com>

The file extension .p7s is much more common, use that.

Cc: Kyle McMartin <kyle@kernel.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/sign-file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 94109c9e8ce6..cf9eb7f79868 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -249,7 +249,7 @@ int main(int argc, char **argv)
 	if (save_pkcs7) {
 		char *pkcs7_name;
 
-		ERR(asprintf(&pkcs7_name, "%s.pkcs7", module_name) < 0, "asprintf");
+		ERR(asprintf(&pkcs7_name, "%s.p7s", module_name) < 0, "asprintf");
 		b = BIO_new_file(pkcs7_name, "wb");
 		ERR(!b, "%s", pkcs7_name);
 		ERR(i2d_PKCS7_bio_stream(b, pkcs7, NULL, 0) < 0, "%s", pkcs7_name);

