Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63980 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYLJFfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 00:35:42 -0500
Date: Tue, 09 Dec 2008 23:35:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Fix sparse warnings
Message-ID: <493f552d.zivnzjivWDMPej+O%Larry.Finger@lwfinger.net> (sfid-20081210_063601_735621_7AB49E32)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sparse yields the following warnings for b43legacy:

  CHECK   drivers/net/wireless/b43legacy/phy.c
drivers/net/wireless/b43legacy/phy.c:1304:31: warning: potentially expensive pointer subtraction
drivers/net/wireless/b43legacy/phy.c:1304:31: warning: potentially expensive pointer subtraction
drivers/net/wireless/b43legacy/phy.c:1304:31: warning: potentially expensive pointer subtraction
  CHECK   drivers/net/wireless/b43legacy/debugfs.c
drivers/net/wireless/b43legacy/debugfs.c:243:9: warning: memset with byte count of 131072

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.29 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43legacy/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/debugfs.c
+++ wireless-testing/drivers/net/wireless/b43legacy/debugfs.c
@@ -211,7 +211,7 @@ static ssize_t b43legacy_debugfs_read(st
 	struct b43legacy_dfs_file *dfile;
 	ssize_t uninitialized_var(ret);
 	char *buf;
-	const size_t bufsize = 1024 * 128;
+	const size_t bufsize = 1024 * 16; /* 16 KiB buffer */
 	const size_t buforder = get_order(bufsize);
 	int err = 0;
 
Index: wireless-testing/drivers/net/wireless/b43legacy/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/phy.c
+++ wireless-testing/drivers/net/wireless/b43legacy/phy.c
@@ -1296,12 +1296,10 @@ void b43legacy_lo_write(struct b43legacy
 	/* Sanity check. */
 	if (pair->low < -8 || pair->low > 8 ||
 	    pair->high < -8 || pair->high > 8) {
-		struct b43legacy_phy *phy = &dev->phy;
 		b43legacydbg(dev->wl,
 		       "WARNING: Writing invalid LOpair "
-		       "(low: %d, high: %d, index: %lu)\n",
-		       pair->low, pair->high,
-		       (unsigned long)(pair - phy->_lo_pairs));
+		       "(low: %d, high: %d)\n",
+		       pair->low, pair->high);
 		dump_stack();
 	}
 #endif
