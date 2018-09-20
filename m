Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37296 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbeITOzD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id u12-v6so8581175wrr.4
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:34 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 09/20] mt76x0: remove mt76x0_set_country_reg routine
Date: Thu, 20 Sep 2018 11:11:56 +0200
Message-Id: <249232763e7ee05755b26bbb0a05c933d2a1ae95.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112420_593867_AE21BA80)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove mt76x0_set_country_reg routine for the moment
since it is partial and it is not actually used

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  2 -
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 38 -------------------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  2 -
 3 files changed, 42 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index f9e305840176..932c0e41196c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -117,8 +117,6 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
 	seq_printf(file, "Power Amplifier type %lx\n",
 		   val & MT_EE_NIC_CONF_0_PA_TYPE);
-	seq_printf(file, "Reg channels: %hhu-%hhu\n", dev->ee->reg.start,
-		   dev->ee->reg.start + dev->ee->reg.num - 1);
 
 	seq_puts(file, "Per channel power:\n");
 	for (i = 0; i < 58; i++)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 6c492a21be26..5d08a7bb16ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -103,43 +103,6 @@ mt76x0_set_temp_offset(struct mt76x0_dev *dev, u8 *eeprom)
 		dev->ee->temp_off = -10;
 }
 
-static void
-mt76x0_set_country_reg(struct mt76x0_dev *dev, u8 *eeprom)
-{
-	/* Note: - region 31 is not valid for mt76x0 (see rtmp_init.c)
-	 *	 - comments in rtmp_def.h are incorrect (see rt_channel.c)
-	 */
-	static const struct reg_channel_bounds chan_bounds[] = {
-		/* EEPROM country regions 0 - 7 */
-		{  1, 11 },	{  1, 13 },	{ 10,  2 },	{ 10,  4 },
-		{ 14,  1 },	{  1, 14 },	{  3,  7 },	{  5,  9 },
-		/* EEPROM country regions 32 - 33 */
-		{  1, 11 },	{  1, 14 }
-	};
-	u8 val = eeprom[MT_EE_COUNTRY_REGION_2GHZ];
-	int idx = -1;
-
-	dev_dbg(dev->mt76.dev, "REG 2GHZ %u REG 5GHZ %u\n", val, eeprom[MT_EE_COUNTRY_REGION_5GHZ]);
-	if (val < 8)
-		idx = val;
-	if (val > 31 && val < 33)
-		idx = val - 32 + 8;
-
-	if (idx != -1)
-		dev_info(dev->mt76.dev,
-			 "EEPROM country region %02hhx (channels %hhd-%hhd)\n",
-			 val, chan_bounds[idx].start,
-			 chan_bounds[idx].start + chan_bounds[idx].num - 1);
-	else
-		idx = 5; /* channels 1 - 14 */
-
-	dev->ee->reg = chan_bounds[idx];
-
-	/* TODO: country region 33 is special - phy should be set to B-mode
-	 *	 before entering channel 14 (see sta/connect.c)
-	 */
-}
-
 static void
 mt76x0_set_rf_freq_off(struct mt76x0_dev *dev, u8 *eeprom)
 {
@@ -353,7 +316,6 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 
 	mt76x02_mac_setaddr(&dev->mt76, eeprom + MT_EE_MAC_ADDR);
 	mt76x0_set_chip_cap(dev, eeprom);
-	mt76x0_set_country_reg(dev, eeprom);
 	mt76x0_set_rf_freq_off(dev, eeprom);
 	mt76x0_set_temp_offset(dev, eeprom);
 	mt76x0_set_lna_gain(dev, eeprom);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index e58a30589aa2..dbfcbfa71291 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -41,8 +41,6 @@ struct mt76x0_eeprom_params {
 	u32 tx_pwr_cfg_5g[5][2];
 
 	u8 tx_pwr_per_chan[58];
-
-	struct reg_channel_bounds reg;
 };
 
 int mt76x0_eeprom_init(struct mt76x0_dev *dev);
-- 
2.17.1
