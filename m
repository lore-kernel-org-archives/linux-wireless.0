Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53398 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZJaV71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 17:59:27 -0400
Received: by bwz27 with SMTP id 27so4897834bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 14:59:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: disable channels with incomplete calibration data sets
Date: Sat, 31 Oct 2009 22:59:27 +0100
Cc: linville@tuxdriver.com, James Grossmann <cctsurf@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200910312259.27465.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Grossmann [1] reported that p54 spews out confusing
messages instead of preventing the mayhem from happening.

the reason is that "p54: generate channel list dynamically"
is not perfect. It didn't discard incomplete channel data
sets and therefore p54 advertised to support them as well.

[1]: http://marc.info/?l=linux-wireless&m=125699830215890

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: James Grossmann <cctsurf@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
this patch just removes the pointless verboseness.

I'm afraid, it doesn't fix any regressions,
include workarounds for damaged hardware, add support
for an unknown, unsupported eeprom layout or do 
any other magic stuff.
---
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 0efe67d..8e3818f 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -126,7 +126,7 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 	int ret = -ENOMEM;
 
 	if ((!list->entries) || (!list->band_channel_num[band]))
-		return 0;
+		return -EINVAL;
 
 	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
 	if (!tmp)
@@ -158,6 +158,7 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 			       (list->channels[i].data & CHAN_HAS_CURVE ? "" :
 				" [curve data]"),
 			       list->channels[i].index, list->channels[i].freq);
+			continue;
 		}
 
 		tmp->channels[j].band = list->channels[i].band;
@@ -165,7 +166,16 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 		j++;
 	}
 
-	tmp->n_channels = list->band_channel_num[band];
+	if (j == 0) {
+		printk(KERN_ERR "%s: Disabling totally damaged %s band.\n",
+		       wiphy_name(dev->wiphy), (band == IEEE80211_BAND_2GHZ) ?
+		       "2 GHz" : "5 GHz");
+
+		ret = -ENODATA;
+		goto err_out;
+	}
+
+	tmp->n_channels = j;
 	old = priv->band_table[band];
 	priv->band_table[band] = tmp;
 	if (old) {
@@ -228,13 +238,13 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 	struct p54_common *priv = dev->priv;
 	struct p54_channel_list *list;
 	unsigned int i, j, max_channel_num;
-	int ret = -ENOMEM;
+	int ret = 0;
 	u16 freq;
 
 	if ((priv->iq_autocal_len != priv->curve_data->entries) ||
 	    (priv->iq_autocal_len != priv->output_limit->entries))
-		printk(KERN_ERR "%s: EEPROM is damaged... you may not be able"
-				"to use all channels with this device.\n",
+		printk(KERN_ERR "%s: Unsupported or damaged EEPROM detected. "
+				"You may not be able to use all channels.\n",
 				wiphy_name(dev->wiphy));
 
 	max_channel_num = max_t(unsigned int, priv->output_limit->entries,
@@ -243,8 +253,10 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 				priv->curve_data->entries);
 
 	list = kzalloc(sizeof(*list), GFP_KERNEL);
-	if (!list)
+	if (!list) {
+		ret = -ENOMEM;
 		goto free;
+	}
 
 	list->max_entries = max_channel_num;
 	list->channels = kzalloc(sizeof(struct p54_channel_entry) *
@@ -282,13 +294,8 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 	     p54_compare_channels, NULL);
 
 	for (i = 0, j = 0; i < IEEE80211_NUM_BANDS; i++) {
-		if (list->band_channel_num[i]) {
-			ret = p54_generate_band(dev, list, i);
-			if (ret)
-				goto free;
-
+		if (p54_generate_band(dev, list, i) == 0)
 			j++;
-		}
 	}
 	if (j == 0) {
 		/* no useable band available. */
