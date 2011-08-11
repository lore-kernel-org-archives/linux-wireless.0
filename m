Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38525 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1HKNlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 09:41:22 -0400
Received: by fxh19 with SMTP id 19so1666514fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 06:41:21 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/3] b43: support new RX header, noticed to be used in 598.314+ fw
Date: Thu, 11 Aug 2011 16:20:23 +0200
Message-Id: <1313072423-15512-4-git-send-email-zajec5@gmail.com> (sfid-20110811_154126_068002_3F7DE227)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/pio.c  |   10 +++++++++-
 drivers/net/wireless/b43/xmit.c |   21 ++++++++++++++++-----
 drivers/net/wireless/b43/xmit.h |   19 ++++++++++++++++---
 3 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 6e4228c..ce8a4bd 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -676,7 +676,15 @@ data_ready:
 		goto rx_error;
 	}
 
-	macstat = le32_to_cpu(rxhdr->mac_status);
+	switch (dev->fw.hdr_format) {
+	case B43_FW_HDR_598:
+		macstat = le32_to_cpu(rxhdr->format_598.mac_status);
+		break;
+	case B43_FW_HDR_410:
+	case B43_FW_HDR_351:
+		macstat = le32_to_cpu(rxhdr->format_351.mac_status);
+		break;
+	}
 	if (macstat & B43_RX_MAC_FCSERR) {
 		if (!(q->dev->wl->filter_flags & FIF_FCSFAIL)) {
 			/* Drop frames with failed FCS. */
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index b02170d..5b82409 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -653,8 +653,9 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	struct ieee80211_hdr *wlhdr;
 	const struct b43_rxhdr_fw4 *rxhdr = _rxhdr;
 	__le16 fctl;
-	u16 phystat0, phystat3, chanstat, mactime;
-	u32 macstat;
+	u16 phystat0, phystat3;
+	u16 uninitialized_var(chanstat), uninitialized_var(mactime);
+	u32 uninitialized_var(macstat);
 	u16 chanid;
 	u16 phytype;
 	int padding;
@@ -664,9 +665,19 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	/* Get metadata about the frame from the header. */
 	phystat0 = le16_to_cpu(rxhdr->phy_status0);
 	phystat3 = le16_to_cpu(rxhdr->phy_status3);
-	macstat = le32_to_cpu(rxhdr->mac_status);
-	mactime = le16_to_cpu(rxhdr->mac_time);
-	chanstat = le16_to_cpu(rxhdr->channel);
+	switch (dev->fw.hdr_format) {
+	case B43_FW_HDR_598:
+		macstat = le32_to_cpu(rxhdr->format_598.mac_status);
+		mactime = le16_to_cpu(rxhdr->format_598.mac_time);
+		chanstat = le16_to_cpu(rxhdr->format_598.channel);
+		break;
+	case B43_FW_HDR_410:
+	case B43_FW_HDR_351:
+		macstat = le32_to_cpu(rxhdr->format_351.mac_status);
+		mactime = le16_to_cpu(rxhdr->format_351.mac_time);
+		chanstat = le16_to_cpu(rxhdr->format_351.channel);
+		break;
+	}
 	phytype = chanstat & B43_RX_CHAN_PHYTYPE;
 
 	if (unlikely(macstat & B43_RX_MAC_FCSERR)) {
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index dccf7c1..dc37297 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -250,9 +250,22 @@ struct b43_rxhdr_fw4 {
 	} __packed;
 	__le16 phy_status2;	/* PHY RX Status 2 */
 	__le16 phy_status3;	/* PHY RX Status 3 */
-	__le32 mac_status;	/* MAC RX status */
-	__le16 mac_time;
-	__le16 channel;
+	union {
+		/* Tested with 598.314, 644.1001 and 666.2 */
+		struct {
+			PAD_BYTES(1);
+			__le32 mac_status;	/* MAC RX status */
+			__le16 mac_time;
+			__le16 channel;
+		} format_598 __packed;
+
+		/* Tested with 351.126, 410.2160, 478.104 and 508.* */
+		struct {
+			__le32 mac_status;	/* MAC RX status */
+			__le16 mac_time;
+			__le16 channel;
+		} format_351 __packed;
+	} __packed;
 } __packed;
 
 /* PHY RX Status 0 */
-- 
1.7.3.4

