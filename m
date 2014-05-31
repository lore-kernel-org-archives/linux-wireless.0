Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:58153 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaEaKvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:25 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so3007779wes.21
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/14] staging: vt6656: rename MACvWriteMultiAddr to vnt_mac_set_filter
Date: Sat, 31 May 2014 11:50:36 +0100
Message-Id: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125135_084089_FACC0F0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function sets the mac filter so rename to vnt_mac_set_filter

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c      | 2 +-
 drivers/staging/vt6656/mac.h      | 2 +-
 drivers/staging/vt6656/main_usb.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index cadf7cd..8c73f36 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -50,7 +50,7 @@
  * Return Value: none
  *
  */
-void MACvWriteMultiAddr(struct vnt_private *priv, u64 mc_filter)
+void vnt_mac_set_filter(struct vnt_private *priv, u64 mc_filter)
 {
 	__le64 le_mc = cpu_to_le64(mc_filter);
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 986ca95..b0e5d49 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -414,7 +414,7 @@ struct vnt_mac_set_key {
 	u8 key[WLAN_KEY_LEN_CCMP];
 } __packed;
 
-void MACvWriteMultiAddr(struct vnt_private *, u64);
+void vnt_mac_set_filter(struct vnt_private *, u64);
 void MACbShutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u8);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index bdb9de8..b297f3a 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1284,7 +1284,7 @@ void vnt_configure_filter(struct vnt_private *priv)
 	} else if ((netdev_mc_count(dev) > priv->multicast_limit) ||
 			(dev->flags & IFF_ALLMULTI)) {
 		mc_filter = ~0x0;
-		MACvWriteMultiAddr(priv, mc_filter);
+		vnt_mac_set_filter(priv, mc_filter);
 
 		priv->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
 	} else {
@@ -1294,7 +1294,7 @@ void vnt_configure_filter(struct vnt_private *priv)
 			mc_filter |= 1ULL << (bit_nr & 0x3f);
 		}
 
-		MACvWriteMultiAddr(priv, mc_filter);
+		vnt_mac_set_filter(priv, mc_filter);
 
 		priv->byRxMode &= ~(RCR_UNICAST);
 		priv->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
-- 
1.9.1

