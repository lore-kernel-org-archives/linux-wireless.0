Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37920 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbeCIJlw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 04:41:52 -0500
Received: by mail-wr0-f194.google.com with SMTP id n7so8372277wrn.5
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2018 01:41:52 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt7601u: let mac80211 validate rx CCMP PN
Date: Fri,  9 Mar 2018 10:41:41 +0100
Message-Id: <9ccb187ffdba10f63148402aa38a5db436c52935.1520588242.git.lorenzo.bianconi@redhat.com> (sfid-20180309_104156_948645_1DB3EC31)
In-Reply-To: <cover.1520588242.git.lorenzo.bianconi@redhat.com>
References: <cover.1520588242.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently the hardware does not perform CCMP PN validation so
let mac80211 take care of possible replay attacks in sw.
Moreover indicate ICV and MIC had been stripped setting corresponding
bits in ieee80211_rx_status.
The fix has been validated using 4.2.1 and 4.1.3 tests from the WiFi
Alliance vulnerability detection tool.

Fixes: c869f77d6abb ("add mt7601u driver")
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Tested-by: David Park <david.park@hitemengineering.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/initvals.h |  1 +
 drivers/net/wireless/mediatek/mt7601u/mac.c      | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/initvals.h b/drivers/net/wireless/mediatek/mt7601u/initvals.h
index ec11ff66969d..2dc6b68e7fb9 100644
--- a/drivers/net/wireless/mediatek/mt7601u/initvals.h
+++ b/drivers/net/wireless/mediatek/mt7601u/initvals.h
@@ -139,6 +139,7 @@ static const struct mt76_reg_pair mac_common_vals[] = {
 	{ MT_TXOP_HLDR_ET,		0x00000002 },
 	{ MT_XIFS_TIME_CFG,		0x33a41010 },
 	{ MT_PWR_PIN_CFG,		0x00000000 },
+	{ MT_PN_PAD_MODE,		0x00000001 },
 };
 
 static const struct mt76_reg_pair mac_chip_vals[] = {
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index 4d3077941138..d55d7040a56d 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -480,8 +480,16 @@ u32 mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb,
 
 	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_DECRYPT)) {
 		status->flag |= RX_FLAG_DECRYPTED;
-		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
+		status->flag |= RX_FLAG_MMIC_STRIPPED;
+		status->flag |= RX_FLAG_MIC_STRIPPED;
+		status->flag |= RX_FLAG_ICV_STRIPPED;
+		status->flag |= RX_FLAG_IV_STRIPPED;
 	}
+	/* let mac80211 take care of PN validation since apparently
+	 * the hardware does not support it
+	 */
+	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_PN_LEN))
+		status->flag &= ~RX_FLAG_IV_STRIPPED;
 
 	status->chains = BIT(0);
 	rssi = mt7601u_phy_get_rssi(dev, rxwi, rate);
-- 
2.14.3
