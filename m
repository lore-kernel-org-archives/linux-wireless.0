Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:34334 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaGNSoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 14:44:15 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so2723426wes.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2014 11:44:14 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] staging: vt6656: device.h remove old wireless stats
Date: Mon, 14 Jul 2014 19:43:05 +0100
Message-Id: <1405363386-5799-1-git-send-email-tvboxspy@gmail.com> (sfid-20140714_204418_489055_73506CD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are dead nolonger of use.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 2 --
 drivers/staging/vt6656/int.c    | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 436f109..a8b6c5f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -289,7 +289,6 @@ struct vnt_private {
 	u8 mac_hw;
 	/* netdev */
 	struct usb_device *usb;
-	struct net_device_stats stats;
 
 	u64 tsf_time;
 	u8 rx_rate;
@@ -437,7 +436,6 @@ struct vnt_private {
 	u8 byNewChannel;
 	u8 byChannelSwitchCount;
 
-	struct iw_statistics wstats; /* wireless stats */
 	struct ieee80211_low_level_stats low_stats;
 };
 
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 15841b8..dad1543 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -150,7 +150,6 @@ static int vnt_int_report_rate(struct vnt_private *priv, u8 pkt_no, u8 tsr)
 void INTnsProcessData(struct vnt_private *priv)
 {
 	struct vnt_interrupt_data *int_data;
-	struct net_device_stats *stats = &priv->stats;
 	struct ieee80211_low_level_stats *low_stats = &priv->low_stats;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
@@ -196,7 +195,4 @@ void INTnsProcessData(struct vnt_private *priv)
 	}
 
 	priv->int_buf.in_use = false;
-
-	stats->tx_errors = priv->wstats.discard.retries;
-	stats->tx_dropped = priv->wstats.discard.retries;
 }
-- 
2.0.1

