Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34647 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1GOOUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 10:20:37 -0400
Received: by ewy4 with SMTP id 4so676905ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 07:20:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harshal Chhaya <harshal@gmail.com>
Subject: Re: carl9170: Beacons at lower Tx power than data frames?
Date: Fri, 15 Jul 2011 16:22:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com>
In-Reply-To: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107151622.43671.chunkeey@googlemail.com> (sfid-20110715_162043_370089_D196B5E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 14 July 2011 21:37:29 Harshal Chhaya wrote:
> I am working on an AP design that uses a TI-OMAP3 host processor with
> an Atheros AR9170 + AR9101 WLAN chipset. We are currently using
> carl9170 version 1.9.2 and carl9170 firmware version 1.9.4.
One question: have you considered ath9k_htc? I would certainly recommend
it over any ar9170 device.
 
> During network tests, several of the clients drop-off the network.
what tests? Also isn't there any verbose logs on the client/ap to why
they kick each other? 

> The packet captures show that the beacons sent by the AP are at a much
> lower power than the other data packets. Is this wide variation in the AP's
> transmit power the expected behavior with this driver/firmware/chipset?
> If not, where do I look to fix this.
Try this:
---
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index 261f893..3025f0b 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -391,7 +391,39 @@
 
 
 #define	AR9170_MAC_REG_BCN_HT1			(AR9170_MAC_REG_BASE + 0xda0)
+#define		AR9170_MAC_BCN_HT1_HT_EN		BIT(0)
+#define		AR9170_MAC_BCN_HT1_GF_PMB		BIT(1)
+#define		AR9170_MAC_BCN_HT1_SP_EXP		BIT(2)
+#define		AR9170_MAC_BCN_HT1_TX_BF		BIT(3)
+#define		AR9170_MAC_BCN_HT1_PWR_CTRL_S		4
+#define		AR9170_MAC_BCN_HT1_PWR_CTRL		0x70
+#define		AR9170_MAC_BCN_HT1_TX_ANT1		BIT(7)
+#define		AR9170_MAC_BCN_HT1_TX_ANT0		BIT(8)
+#define		AR9170_MAC_BCN_HT1_NUM_LFT_S		9
+#define		AR9170_MAC_BCN_HT1_NUM_LFT		0x600
+#define		AR9170_MAC_BCN_HT1_BWC_20M_EXT		BIT(16)
+#define		AR9170_MAC_BCN_HT1_BWC_40M_SHARED	BIT(17)
+#define		AR9170_MAC_BCN_HT1_BWC_40M_DUP		(BIT(16) | BIT(17))
+#define		AR9170_MAC_BCN_HT1_BF_MCS_S		18
+#define		AR9170_MAC_BCN_HT1_BF_MCS		0x1c0000
+#define		AR9170_MAC_BCN_HT1_TPC_S		21
+#define		AR9170_MAC_BCN_HT1_TPC			0x7e00000
+#define		AR9170_MAC_BCN_HT1_CHAIN_MASK_S		27
+#define		AR9170_MAC_BCN_HT1_CHAIN_MASK		0x38000000
+
 #define	AR9170_MAC_REG_BCN_HT2			(AR9170_MAC_REG_BASE + 0xda4)
+#define		AR9170_MAC_BCN_HT2_MCS_S		0
+#define		AR9170_MAC_BCN_HT2_MCS			0x7f
+#define		AR9170_MAC_BCN_HT2_BW40			BIT(8)
+#define		AR9170_MAC_BCN_HT2_SMOOTHING		BIT(9)
+#define		AR9170_MAC_BCN_HT2_SS			BIT(10)
+#define		AR9170_MAC_BCN_HT2_NSS			BIT(11)
+#define		AR9170_MAC_BCN_HT2_STBC_S		12
+#define		AR9170_MAC_BCN_HT2_STBC			0x3000
+#define		AR9170_MAC_BCN_HT2_ADV_COD		BIT(14)
+#define		AR9170_MAC_BCN_HT2_SGI			BIT(15)
+#define		AR9170_MAC_BCN_HT2_LEN_S		16
+#define		AR9170_MAC_BCN_HT2_LEN			0xffff0000
 
 #define	AR9170_MAC_REG_DMA_TXQX_ADDR_CURR	(AR9170_MAC_REG_BASE + 0xdc0)
 
diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index 385cf50..4a2e9ad 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -460,8 +460,10 @@ int carl9170_update_beacon(struct ar9170 *ar, const bool submit)
 	struct sk_buff *skb = NULL;
 	struct carl9170_vif_info *cvif;
 	struct ieee80211_tx_info *txinfo;
+	struct ieee80211_rate *rate;
 	__le32 *data, *old = NULL;
-	u32 word, off, addr, len;
+	u8 *txpower;
+	u32 word, ht1 = 0, chains, off, addr, len;
 	int i = 0, err = 0;
 
 	rcu_read_lock();
@@ -527,17 +529,43 @@ found:
 	}
 
 	i = txinfo->control.rates[0].idx;
-	if (txinfo->band != IEEE80211_BAND_2GHZ)
+	if (txinfo->band != IEEE80211_BAND_2GHZ) {
 		i += 4;
+		txpower = ar->power_5G_leg;
+	} else {
+		if (i < 4)
+			txpower = ar->power_2G_cck;
+		else
+			txpower = ar->power_2G_ofdm;
+	}
 
-	word = __carl9170_ratetable[i].hw_value & 0xf;
+	rate = &__carl9170_ratetable[i];
+	word = rate->hw_value & 0xf;
 	if (i < 4)
 		word |= ((skb->len + FCS_LEN) << (3 + 16)) + 0x0400;
 	else
 		word |= ((skb->len + FCS_LEN) << 16) + 0x0010;
 
+	SET_VAL(AR9170_MAC_BCN_HT1_PWR_CTRL, ht1, 7);
+	SET_VAL(AR9170_MAC_BCN_HT1_TPC, ht1,
+		txpower[(rate->hw_value & 0x30) >> 4]);
+
+	if (ar->eeprom.tx_mask == 1) {
+		chains = AR9170_TX_PHY_TXCHAIN_1;
+	} else {
+		chains = AR9170_TX_PHY_TXCHAIN_2;
+		if (rate && rate->bitrate >= 360)
+			chains = AR9170_TX_PHY_TXCHAIN_1;
+	}
+	if (chains == AR9170_TX_PHY_TXCHAIN_2)
+		ht1 |= AR9170_MAC_BCN_HT1_TX_ANT1;
+
+	ht1 |= AR9170_MAC_BCN_HT1_TX_ANT0;
+	SET_VAL(AR9170_MAC_BCN_HT1_CHAIN_MASK, ht1, chains);
+
 	carl9170_async_regwrite_begin(ar);
 	carl9170_async_regwrite(AR9170_MAC_REG_BCN_PLCP, word);
+	carl9170_async_regwrite(AR9170_MAC_REG_BCN_HT1, ht1);
 
 	for (i = 0; i < DIV_ROUND_UP(skb->len, 4); i++) {
 		/*
