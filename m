Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 093/113] rtl8xxxu: Set the correct TX descriptor bits for agg and break on 8723b
Date: Mon, 29 Feb 2016 17:05:31 -0500
Message-Id: <1456783551-28315-94-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232950_491197_C4AB8250)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Fixup victim of the relocated bits for AGG_ENABLE/AGG_BREAK in the 40
byte TX descriptor

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 62ed6af..48a669e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6953,6 +6953,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	u16 rate_flag = tx_info->control.rates[0].flags;
 	int tx_desc_size = priv->fops->tx_desc_size;
 	int ret;
+	bool txdesc40, ampdu_enable;
 
 	if (skb_headroom(skb) < tx_desc_size) {
 		dev_warn(dev,
@@ -6980,6 +6981,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	if (ieee80211_is_action(hdr->frame_control))
 		rtl8xxxu_dump_action(dev, hdr);
 
+	txdesc40 = (tx_desc_size == 40);
 	tx_info->rate_driver_data[0] = hw;
 
 	if (control && control->sta)
@@ -7028,6 +7030,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 		tx_desc->txdw5 |= cpu_to_le32(0x0001ff00);
 
 	/* (tx_info->flags & IEEE80211_TX_CTL_AMPDU) && */
+	ampdu_enable = false;
 	if (ieee80211_is_data_qos(hdr->frame_control) && sta) {
 		if (sta->ht_cap.ht_supported) {
 			u32 ampdu, val32;
@@ -7036,11 +7039,21 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 			val32 = ampdu << TXDESC_AMPDU_DENSITY_SHIFT;
 			tx_desc->txdw2 |= cpu_to_le32(val32);
 
+			ampdu_enable = true;
+		}
+	}
+
+	if (!txdesc40) {
+		if (ampdu_enable)
 			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_ENABLE_8723A);
-		} else
+		else
 			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_BREAK_8723A);
-	} else
-		tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_BREAK_8723A);
+	} else {
+		if (ampdu_enable)
+			tx_desc->txdw2 |= cpu_to_le32(TXDESC_AGG_ENABLE_8723B);
+		else
+			tx_desc->txdw2 |= cpu_to_le32(TXDESC_AGG_BREAK_8723B);
+	};
 
 	if (ieee80211_is_data_qos(hdr->frame_control))
 		tx_desc->txdw4 |= cpu_to_le32(TXDESC_QOS);
-- 
2.5.0

