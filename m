Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:53765 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYI1UGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 16:06:45 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1466435muf.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 13:06:44 -0700 (PDT)
Date: Sun, 28 Sep 2008 22:06:36 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 1/4] Do not initialize gcrypt twice.
Message-ID: <20080928200636.GA5657@PesaBook.pesa.homelinux.org> (sfid-20080928_220649_557552_75B1468D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>

---
 crda.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/crda.c b/crda.c
index 98d80f5..4c7681c 100644
--- a/crda.c
+++ b/crda.c
@@ -14,7 +14,7 @@
 
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
-#include <netlink/genl/ctrl.h>  
+#include <netlink/genl/ctrl.h>
 #include <netlink/msg.h>
 #include <netlink/attr.h>
 #include <linux/nl80211.h>
@@ -192,14 +192,12 @@ int main(int argc, char **argv)
 	int ok = 0;
 #endif
 #ifdef USE_GCRYPT
-	/* initialise */
-	gcry_check_version(NULL);
-
 	gcry_mpi_t mpi_e, mpi_n;
 	gcry_sexp_t rsa, signature, data;
 	__u8 hash[20];
 	int ok = 0;
 #endif
+
 	char *regdb = "/usr/lib/crda/regulatory.bin";
 
 	if (argc != 1) {
@@ -213,7 +211,7 @@ int main(int argc, char **argv)
 		return -EINVAL;
 	}
 
-	
+
 	if (!is_alpha2(env_country) && !is_world_regdom(env_country)) {
 		fprintf(stderr, "Invalid alpha2 set in COUNTRY\n");
 		return -EINVAL;
-- 
1.6.0.2

