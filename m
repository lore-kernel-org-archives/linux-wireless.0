Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1BLW2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 17:28:19 -0500
Received: by fxm20 with SMTP id 20so3925899fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 14:28:17 -0800 (PST)
Message-Id: <22063045349cb651b39a410a66fcdfedf7eb3a0c.1297548925.git.chunkeey@googlemail.com>
In-Reply-To: <a1716888d72252e775f666c0caf6aa15cd0de33b.1297548925.git.chunkeey@googlemail.com>
References: <a1716888d72252e775f666c0caf6aa15cd0de33b.1297548925.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 12 Feb 2011 22:14:38 +0100
Subject: [PATCH 2/4] p54: p54_generate_band cleanup
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/eeprom.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index ec7d4b8..360bc78 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -145,25 +145,26 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 
 	for (i = 0, j = 0; (j < list->band_channel_num[band]) &&
 			   (i < list->entries); i++) {
+		struct p54_channel_entry *chan = &list->channels[i];
 
-		if (list->channels[i].band != band)
+		if (chan->band != band)
 			continue;
 
-		if (list->channels[i].data != CHAN_HAS_ALL) {
-			wiphy_err(dev->wiphy,
-				  "%s%s%s is/are missing for channel:%d [%d MHz].\n",
-				  (list->channels[i].data & CHAN_HAS_CAL ? "" :
+		if (chan->data != CHAN_HAS_ALL) {
+			wiphy_err(dev->wiphy, "%s%s%s is/are missing for "
+				  "channel:%d [%d MHz].\n",
+				  (chan->data & CHAN_HAS_CAL ? "" :
 				   " [iqauto calibration data]"),
-				  (list->channels[i].data & CHAN_HAS_LIMIT ? "" :
+				  (chan->data & CHAN_HAS_LIMIT ? "" :
 				   " [output power limits]"),
-				  (list->channels[i].data & CHAN_HAS_CURVE ? "" :
+				  (chan->data & CHAN_HAS_CURVE ? "" :
 				   " [curve data]"),
-				  list->channels[i].index, list->channels[i].freq);
+				  chan->index, chan->freq);
 			continue;
 		}
 
-		tmp->channels[j].band = list->channels[i].band;
-		tmp->channels[j].center_freq = list->channels[i].freq;
+		tmp->channels[j].band = chan->band;
+		tmp->channels[j].center_freq = chan->freq;
 		j++;
 	}
 
-- 
1.7.2.3

