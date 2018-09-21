Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55768 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390179AbeIUV7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 17:59:15 -0400
Subject: Re: [PATCH 02/20] mt76: add stbc entries to mt76_rate_power
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
 <15d756db7fef57befcc2e2e28e640be10493df88.1537433365.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <73834a66-5d00-d7b2-b46c-6ab360588fd4@nbd.name> (sfid-20180921_180945_427839_9C919300)
Date: Fri, 21 Sep 2018 18:09:37 +0200
MIME-Version: 1.0
In-Reply-To: <15d756db7fef57befcc2e2e28e640be10493df88.1537433365.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-20 11:11, Lorenzo Bianconi wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> Add stbc tx power eeprom parsing support for mt76x2 driver.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
I folded in the following extra change, and changed the description.
VHT8/9 also have STBC specific entries in the power registers.
I also added a distinction between vht[8/9] and ofdm[6/7], which
come from the same EEPROM value but have distinct register fields.

- Felix

---
--- a/mt76.h
+++ b/mt76.h
@@ -423,11 +423,11 @@ struct mt76_rate_power {
 		struct {
 			s8 cck[4];
 			s8 ofdm[8];
-			s8 stbc[8];
+			s8 stbc[10];
 			s8 ht[16];
 			s8 vht[10];
 		};
-		s8 all[46];
+		s8 all[48];
 	};
 };
 
--- a/mt76x2_eeprom.c
+++ b/mt76x2_eeprom.c
@@ -353,7 +353,6 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS4);
 	t->ht[4] = t->ht[5] = mt76x2_rate_power_val(val);
 	t->ht[6] = t->ht[7] = mt76x2_rate_power_val(val >> 8);
-	memcpy(t->stbc, t->ht, sizeof(t->stbc));
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS8);
 	t->ht[8] = t->ht[9] = mt76x2_rate_power_val(val);
@@ -375,6 +374,10 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 	if (!is_5ghz)
 		val >>= 8;
 	t->vht[8] = t->vht[9] = mt76x2_rate_power_val(val >> 8);
+
+	memcpy(t->stbc, t->ht, sizeof(t->stbc[0]) * 8);
+	t->stbc[8] = t->vht[8];
+	t->stbc[9] = t->vht[9];
 }
 EXPORT_SYMBOL_GPL(mt76x2_get_rate_power);
 
--- a/mt76x2_phy_common.c
+++ b/mt76x2_phy_common.c
@@ -231,11 +231,11 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_TX_PWR_CFG_4,
 		mt76x2_tx_power_mask(t.stbc[4], t.stbc[6], 0, 0));
 	mt76_wr(dev, MT_TX_PWR_CFG_7,
-		mt76x2_tx_power_mask(t.ofdm[6], t.vht[8], t.ht[6], t.vht[8]));
+		mt76x2_tx_power_mask(t.ofdm[7], t.vht[8], t.ht[7], t.vht[9]));
 	mt76_wr(dev, MT_TX_PWR_CFG_8,
-		mt76x2_tx_power_mask(t.ht[14], 0, t.vht[8], t.vht[8]));
+		mt76x2_tx_power_mask(t.ht[14], 0, t.vht[8], t.vht[9]));
 	mt76_wr(dev, MT_TX_PWR_CFG_9,
-		mt76x2_tx_power_mask(t.ht[6], 0, t.vht[8], t.vht[8]));
+		mt76x2_tx_power_mask(t.ht[7], 0, t.stbc[8], t.stbc[9]));
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_txpower);
 
