Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:33182 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYBJPE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:04:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] zd1211rw: Fix beacon filter flags thinko
Date: Sun, 10 Feb 2008 16:03:55 +0100
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200802101603.56095.mb@bu3sch.de> (sfid-20080210_150436_186402_A253CCC1)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must not clear the FIF_BCN_PRBRESP_PROMISC bit in the
new_flags. The zd-driver does support sending beacons and
probe responses to the host. What the flag does is say "Send me
all beacons and probe responses". And we actually do that. We always
do that, so we ignore the case when the bit is disabled. But that is
fine. But we must not clear the flag, as that tells mac80211 that
we do not support passing beacons and probe responses to the stack.
And that's not true.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Should probably go -stable, too.


Index: wireless-2.6/drivers/net/wireless/zd1211rw/zd_mac.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-02-10 15:56:18.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/zd1211rw/zd_mac.c	2008-02-10 15:57:51.000000000 +0100
@@ -765,13 +765,13 @@ static void set_rx_filter_handler(struct
 	if (r)
 		dev_err(zd_mac_dev(mac), "set_rx_filter_handler error %d\n", r);
 }
 
 #define SUPPORTED_FIF_FLAGS \
 	(FIF_PROMISC_IN_BSS | FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
-	FIF_OTHER_BSS)
+	FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC)
 static void zd_op_configure_filter(struct ieee80211_hw *hw,
 			unsigned int changed_flags,
 			unsigned int *new_flags,
 			int mc_count, struct dev_mc_list *mclist)
 {
 	struct zd_mc_hash hash;
