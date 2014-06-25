Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36483 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaFYUPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:10 -0400
Received: by mail-wi0-f174.google.com with SMTP id bs8so8627752wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:08 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/17] staging: vt6656: mac80211 conversion: create rx function.
Date: Wed, 25 Jun 2014 21:14:22 +0100
Message-Id: <1403727278-6666-2-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221700_252809_5B394729)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mac80211 header and depends.

Create new function vnt_rx_data to receive 80211 packets which is based
on RXbBulkInProcessData and rx them into mac80211

The function also relays dbm, tsf_time(as mactime) and sets byBBPreEDRSSI and
uCurrRSSI.

skb is modified slightly to skb_put the maxium tail room in PIPEnsBulkInUsbRead
and trim back in vnt_rx_data. dev_alloc_skb is used to reallocate the sk_buff.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/Kconfig    |   2 +-
 drivers/staging/vt6656/device.h   |   6 ++
 drivers/staging/vt6656/dpc.c      | 137 +++++++++++++++++++++++++++++++++++++-
 drivers/staging/vt6656/dpc.h      |   3 +
 drivers/staging/vt6656/main_usb.c |   2 +-
 drivers/staging/vt6656/usbpipe.c  |   4 +-
 6 files changed, 149 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/Kconfig b/drivers/staging/vt6656/Kconfig
index f89ab20..839db3a 100644
--- a/drivers/staging/vt6656/Kconfig
+++ b/drivers/staging/vt6656/Kconfig
@@ -1,6 +1,6 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
-	depends on USB && WLAN && m
+	depends on MAC80211 && USB && WLAN && m
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select FW_LOADER
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 11b863d..631f402 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -44,6 +44,7 @@
 #include <linux/timer.h>
 #include <linux/usb.h>
 #include <linux/crc32.h>
+#include <net/mac80211.h>
 
 #ifdef SIOCETHTOOL
 #define DEVICE_ETHTOOL_IOCTL_SUPPORT
@@ -392,6 +393,8 @@ typedef struct __device_opt {
 } OPTIONS, *POPTIONS;
 
 struct vnt_private {
+	/* mac80211 */
+	struct ieee80211_hw *hw;
 	/* netdev */
 	struct usb_device *usb;
 	struct net_device *dev;
@@ -402,6 +405,9 @@ struct vnt_private {
 	struct work_struct read_work_item;
 	struct work_struct rx_mng_work_item;
 
+	u64 tsf_time;
+	u8 rx_rate;
+
 	u32 rx_buf_sz;
 	int multicast_limit;
 	u8 byRxMode;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index c0ec5b3..0b9c923 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -900,7 +900,7 @@ void RXvFreeRCB(struct vnt_rcb *rcb, int re_alloc_skb)
 	}
 
 	if (re_alloc_skb == true) {
-		rcb->skb = netdev_alloc_skb(priv->dev, priv->rx_buf_sz);
+		rcb->skb = dev_alloc_skb(priv->rx_buf_sz);
 		/* TODO error handling */
 		if (!rcb->skb) {
 			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
@@ -969,3 +969,138 @@ void RXvMngWorkItem(struct work_struct *work)
 	pDevice->bIsRxMngWorkItemQueued = false;
 }
 
+int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
+	unsigned long bytes_received)
+{
+	struct ieee80211_hw *hw = priv->hw;
+	struct ieee80211_supported_band *sband;
+	struct sk_buff *skb;
+	struct ieee80211_rx_status rx_status = { 0 };
+	struct ieee80211_hdr *hdr;
+	__le16 fc;
+	u8 *rsr, *new_rsr, *rssi, *frame;
+	__le64 *tsf_time;
+	u32 frame_size;
+	int ii, r;
+	u8 *rx_sts, *rx_rate, *sq, *sq_3;
+	u32 wbk_status;
+	u8 *skb_data;
+	u16 *pay_load_len;
+	u16 pay_load_with_padding;
+	u8 rate_idx = 0;
+	u8 rate[MAX_RATE] = {2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108};
+	long rx_dbm;
+
+	skb = ptr_rcb->skb;
+
+	/* [31:16]RcvByteCount ( not include 4-byte Status ) */
+	wbk_status = *((u32 *)(skb->data));
+	frame_size = wbk_status >> 16;
+	frame_size += 4;
+
+	if (bytes_received != frame_size) {
+		dev_dbg(&priv->usb->dev, "------- WRONG Length 1\n");
+		return false;
+	}
+
+	if ((bytes_received > 2372) || (bytes_received <= 40)) {
+		/* Frame Size error drop this packet.*/
+		dev_dbg(&priv->usb->dev, "------ WRONG Length 2\n");
+		return false;
+	}
+
+	skb_data = (u8 *)skb->data;
+
+	rx_sts = skb_data+4;
+	rx_rate = skb_data+5;
+
+	/* real Frame Size = USBframe_size -4WbkStatus - 4RxStatus */
+	/* -8TSF - 4RSR - 4SQ3 - ?Padding */
+
+	/* if SQ3 the range is 24~27, if no SQ3 the range is 20~23 */
+
+	pay_load_len = (u16 *) (skb_data + 6);
+
+	/*Fix hardware bug => PLCP_Length error */
+	if (((bytes_received - (*pay_load_len)) > 27) ||
+		((bytes_received - (*pay_load_len)) < 24) ||
+			(bytes_received < (*pay_load_len))) {
+		dev_dbg(&priv->usb->dev, "Wrong PLCP Length %x\n",
+							*pay_load_len);
+		return false;
+	}
+
+	sband = hw->wiphy->bands[hw->conf.chandef.chan->band];
+
+	for (r = RATE_1M; r < MAX_RATE; r++) {
+		if (*rx_rate == rate[r])
+			break;
+	}
+
+	priv->rx_rate = r;
+
+	for (ii = 0; ii < sband->n_bitrates; ii++) {
+		if (sband->bitrates[ii].hw_value == r) {
+			rate_idx = ii;
+				break;
+		}
+	}
+
+	if (ii == sband->n_bitrates) {
+		dev_dbg(&priv->usb->dev, "Wrong RxRate %x\n", *rx_rate);
+		return false;
+	}
+
+	pay_load_with_padding = ((*pay_load_len / 4) +
+		((*pay_load_len % 4) ? 1 : 0)) * 4;
+
+	tsf_time = (__le64 *)(skb_data + 8 + pay_load_with_padding);
+
+	priv->tsf_time = le64_to_cpu(*tsf_time);
+
+	if (priv->byBBType == BB_TYPE_11G) {
+		sq_3 = skb_data + 8 + pay_load_with_padding + 12;
+		sq = sq_3;
+	} else {
+		sq = skb_data + 8 + pay_load_with_padding + 8;
+		sq_3 = sq;
+	}
+
+	new_rsr = skb_data + 8 + pay_load_with_padding + 9;
+	rssi = skb_data + 8 + pay_load_with_padding + 10;
+	rsr = skb_data + 8 + pay_load_with_padding + 11;
+
+	frame_size = *pay_load_len;
+
+	vnt_rf_rssi_to_dbm(priv, *rssi, &rx_dbm);
+
+	priv->byBBPreEDRSSI = (u8)rx_dbm + 1;
+	priv->uCurrRSSI = priv->byBBPreEDRSSI;
+
+	frame = skb_data + 8;
+
+	skb_pull(skb, 8);
+	skb_trim(skb, frame_size);
+
+	rx_status.mactime = priv->tsf_time;
+	rx_status.band = hw->conf.chandef.chan->band;
+	rx_status.signal = rx_dbm;
+	rx_status.flag = 0;
+	rx_status.freq = hw->conf.chandef.chan->center_freq;
+
+	hdr = (struct ieee80211_hdr *)(skb->data);
+	fc = hdr->frame_control;
+
+	rx_status.rate_idx = rate_idx;
+
+	if (ieee80211_has_protected(fc)) {
+		if (priv->byLocalID > REV_ID_VT3253_A1)
+			rx_status.flag = RX_FLAG_DECRYPTED;
+	}
+
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+
+	ieee80211_rx_irqsafe(priv->hw, skb);
+
+	return true;
+}
diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index 8d52434..45da7b2 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -41,4 +41,7 @@ void RXvFreeRCB(struct vnt_rcb *pRCB, int bReAllocSkb);
 int RXbBulkInProcessData(struct vnt_private *, struct vnt_rcb *pRCB,
 	unsigned long BytesToIndicate);
 
+int vnt_rx_data(struct vnt_private *, struct vnt_rcb *,
+	unsigned long bytes_recieved);
+
 #endif /* __RXTX_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4662a3e..ebbb10d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -793,7 +793,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 			goto free_rx_tx;
 		}
 
-		rcb->skb = netdev_alloc_skb(priv->dev, priv->rx_buf_sz);
+		rcb->skb = dev_alloc_skb(priv->rx_buf_sz);
 		if (rcb->skb == NULL) {
 			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
 						" Failed to alloc rx skb\n");
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index e4751b7..e30150e 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -242,7 +242,7 @@ int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
 	usb_fill_bulk_urb(urb,
 		priv->usb,
 		usb_rcvbulkpipe(priv->usb, 2),
-		(void *) (rcb->skb->data),
+		skb_put(rcb->skb, skb_tailroom(rcb->skb)),
 		MAX_TOTAL_SIZE_WITH_ALL_HEADERS,
 		s_nsBulkInUsbIoCompleteRead,
 		rcb);
@@ -297,7 +297,7 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 	if (urb->actual_length) {
 		spin_lock_irqsave(&priv->lock, flags);
 
-		if (RXbBulkInProcessData(priv, rcb, urb->actual_length) == true)
+		if (vnt_rx_data(priv, rcb, urb->actual_length))
 			re_alloc_skb = true;
 
 		spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.9.1

