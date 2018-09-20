Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46105 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731678AbeITOyz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:54:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id a108-v6so8565833wrc.13
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:26 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 02/20] mt76: add stbc entries to mt76_rate_power
Date: Thu, 20 Sep 2018 11:11:49 +0200
Message-Id: <15d756db7fef57befcc2e2e28e640be10493df88.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111250_306939_81AA0A74)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@nbd.name>

Add stbc tx power eeprom parsing support for mt76x2 driver.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h              | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c    | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c     | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c | 4 ++--
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index b4980959efa7..9febace6ef23 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -423,10 +423,11 @@ struct mt76_rate_power {
 		struct {
 			s8 cck[4];
 			s8 ofdm[8];
+			s8 stbc[8];
 			s8 ht[16];
 			s8 vht[10];
 		};
-		s8 all[38];
+		s8 all[46];
 	};
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
index 2cd0d8200a57..45f3439a6563 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -59,6 +59,8 @@ static int read_txpower(struct seq_file *file, void *data)
 			    ARRAY_SIZE(dev->rate_power.cck));
 	mt76_seq_puts_array(file, "OFDM", dev->rate_power.ofdm,
 			    ARRAY_SIZE(dev->rate_power.ofdm));
+	mt76_seq_puts_array(file, "STBC", dev->rate_power.stbc,
+			    ARRAY_SIZE(dev->rate_power.stbc));
 	mt76_seq_puts_array(file, "HT", dev->rate_power.ht,
 			    ARRAY_SIZE(dev->rate_power.ht));
 	mt76_seq_puts_array(file, "VHT", dev->rate_power.vht,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 1753bcb36356..807bf46e0dd9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -461,6 +461,7 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS4);
 	t->ht[4] = t->ht[5] = mt76x2_rate_power_val(val);
 	t->ht[6] = t->ht[7] = mt76x2_rate_power_val(val >> 8);
+	memcpy(t->stbc, t->ht, sizeof(t->stbc));
 
 	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS8);
 	t->ht[8] = t->ht[9] = mt76x2_rate_power_val(val);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
index 3b704a70fad1..42ca855c7579 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
@@ -227,9 +227,9 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_TX_PWR_CFG_2,
 		mt76x2_tx_power_mask(t.ht[4], t.ht[6], t.ht[8], t.ht[10]));
 	mt76_wr(dev, MT_TX_PWR_CFG_3,
-		mt76x2_tx_power_mask(t.ht[12], t.ht[14], t.ht[0], t.ht[2]));
+		mt76x2_tx_power_mask(t.ht[12], t.ht[14], t.stbc[0], t.stbc[2]));
 	mt76_wr(dev, MT_TX_PWR_CFG_4,
-		mt76x2_tx_power_mask(t.ht[4], t.ht[6], 0, 0));
+		mt76x2_tx_power_mask(t.stbc[4], t.stbc[6], 0, 0));
 	mt76_wr(dev, MT_TX_PWR_CFG_7,
 		mt76x2_tx_power_mask(t.ofdm[6], t.vht[8], t.ht[6], t.vht[8]));
 	mt76_wr(dev, MT_TX_PWR_CFG_8,
-- 
2.17.1
