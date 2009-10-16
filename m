Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbZJPPUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 11:20:09 -0400
Date: Fri, 16 Oct 2009 10:18:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43: Fix Bugzilla #14181 and the bug from the previous 'fix'
Message-ID: <4ad88eb1.FolvJT9+bpKHVONd%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 93bad2b757586fb153ef73b028953a8dcaccde77 entitled "b43: Fix PPC crash
in rfkill polling on unload" fixed the bug reported in Bugzilla No. 14181;
however, it introduced a new bug. Whenever the radio switch was turned off,
it was necessary to unload and reload the driver for it to recognize the
switch again.

This patch fixes both the original bug in #14181 and the bug introduced by
the previous patch. It must be stated, however, that if there is a BCM4306/3
with an rfkill switch (not yet proven), then the driver will need an
unload/reload cycle to turn the device back on.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4501,7 +4501,6 @@ static void b43_op_stop(struct ieee80211
 
 	cancel_work_sync(&(wl->beacon_update_trigger));
 
-	wiphy_rfkill_stop_polling(hw->wiphy);
 	mutex_lock(&wl->mutex);
 	if (b43_status(dev) >= B43_STAT_STARTED) {
 		dev = b43_wireless_core_stop(dev);
Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43/rfkill.c
@@ -33,7 +33,8 @@ bool b43_is_hw_radio_enabled(struct b43_
 		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
 			return 1;
 	} else {
-		if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
+		if (b43_status(dev) >= B43_STAT_STARTED &&
+		    b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
 		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
 			return 1;
 	}
