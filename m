Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:33507 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753020AbXHaE64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 00:58:56 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 4/6] adm8211: Use IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED
Date: Fri, 31 Aug 2007 00:56:13 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <200708310056.13341.flamingice@sourmilk.net>
In-Reply-To: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
References: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This makes it possible to use channels > 11.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |   25 ++++++++--------
 drivers/net/wireless/adm8211.h |   63 ++++++++++++++++++++--------------------
 2 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 575182e..4af3008 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -85,7 +85,7 @@ static void adm8211_eeprom_register_write(struct eeprom_93cx6 *eeprom)
 static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
-	unsigned int words, channels;
+	unsigned int words, i;
 	struct ieee80211_chan_range chan_range;
 	u16 cr49;
 	struct eeprom_93cx6 eeprom = {
@@ -160,17 +160,17 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 	printk(KERN_DEBUG "%s (adm8211): Channel range: %d - %d\n",
 	       pci_name(priv->pdev), (int)chan_range.min, (int)chan_range.max);
 
-	channels = chan_range.max - chan_range.min + 1;
-	priv->modes[0].num_channels = channels;
-	priv->modes[0].channels = kmalloc(sizeof(struct ieee80211_channel) *
-					  channels, GFP_KERNEL);
-	if (!priv->modes[0].channels) {
-		kfree(priv->eeprom);
-		return -ENOMEM;
-	}
+	priv->modes[0].num_channels = chan_range.max - chan_range.min + 1;
+	priv->modes[0].channels = priv->channels;
+
+	memcpy(priv->channels, adm8211_channels, sizeof(adm8211_channels));
 
-	memcpy(priv->modes[0].channels, &adm8211_channels[chan_range.min - 1],
-	       sizeof(struct ieee80211_channel) * channels);
+	for (i = 1; i <= ARRAY_SIZE(adm8211_channels); i++)
+		if (i >= chan_range.min && i <= chan_range.max)
+			priv->channels[i - 1].flag =
+				IEEE80211_CHAN_W_SCAN |
+				IEEE80211_CHAN_W_ACTIVE_SCAN |
+				IEEE80211_CHAN_W_IBSS;
 
 	switch (priv->eeprom->specific_bbptype) {
 	case ADM8211_BBP_RFMD3000:
@@ -1877,7 +1877,8 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 
 	dev->extra_tx_headroom = sizeof(struct adm8211_tx_hdr);
-	dev->flags = IEEE80211_HW_WEP_INCLUDE_IV;
+	dev->flags = IEEE80211_HW_WEP_INCLUDE_IV |
+		     IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED;
 	/* IEEE80211_HW_RX_INCLUDES_FCS in promisc mode */
 
 	dev->channel_change_time = 1000;
diff --git a/drivers/net/wireless/adm8211.h b/drivers/net/wireless/adm8211.h
index 35f4658..926c66d 100644
--- a/drivers/net/wireless/adm8211.h
+++ b/drivers/net/wireless/adm8211.h
@@ -558,6 +558,37 @@ struct ieee80211_chan_range {
 	u8 max;
 };
 
+static const struct ieee80211_channel adm8211_channels[] = {
+	{ .chan = 1,
+	  .freq = 2412},
+	{ .chan = 2,
+	  .freq = 2417},
+	{ .chan = 3,
+	  .freq = 2422},
+	{ .chan = 4,
+	  .freq = 2427},
+	{ .chan = 5,
+	  .freq = 2432},
+	{ .chan = 6,
+	  .freq = 2437},
+	{ .chan = 7,
+	  .freq = 2442},
+	{ .chan = 8,
+	  .freq = 2447},
+	{ .chan = 9,
+	  .freq = 2452},
+	{ .chan = 10,
+	  .freq = 2457},
+	{ .chan = 11,
+	  .freq = 2462},
+	{ .chan = 12,
+	  .freq = 2467},
+	{ .chan = 13,
+	  .freq = 2472},
+	{ .chan = 14,
+	  .freq = 2484},
+};
+
 struct adm8211_priv {
 	struct pci_dev *pdev;
 	spinlock_t lock;
@@ -573,6 +604,7 @@ struct adm8211_priv {
 
 	struct ieee80211_low_level_stats stats;
 	struct ieee80211_hw_mode modes[1];
+	struct ieee80211_channel channels[ARRAY_SIZE(adm8211_channels)];
 	struct ieee80211_rate rates[ARRAY_SIZE(adm8211_rates)];
 	int mode;
 
@@ -624,35 +656,4 @@ static const struct ieee80211_chan_range cranges[] = {
 	{1,  14},	/* MMK2 */
 };
 
-static const struct ieee80211_channel adm8211_channels[] = {
-	{ .chan = 1,
-	  .freq = 2412},
-	{ .chan = 2,
-	  .freq = 2417},
-	{ .chan = 3,
-	  .freq = 2422},
-	{ .chan = 4,
-	  .freq = 2427},
-	{ .chan = 5,
-	  .freq = 2432},
-	{ .chan = 6,
-	  .freq = 2437},
-	{ .chan = 7,
-	  .freq = 2442},
-	{ .chan = 8,
-	  .freq = 2447},
-	{ .chan = 9,
-	  .freq = 2452},
-	{ .chan = 10,
-	  .freq = 2457},
-	{ .chan = 11,
-	  .freq = 2462},
-	{ .chan = 12,
-	  .freq = 2467},
-	{ .chan = 13,
-	  .freq = 2472},
-	{ .chan = 14,
-	  .freq = 2484},
-};
-
 #endif /* ADM8211_H */

