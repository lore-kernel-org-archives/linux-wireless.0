Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43807 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1BLW2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 17:28:19 -0500
Received: by fxm20 with SMTP id 20so3925900fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 14:28:17 -0800 (PST)
Message-Id: <a1716888d72252e775f666c0caf6aa15cd0de33b.1297548925.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 12 Feb 2011 21:49:38 +0100
Subject: [PATCH 1/4] p54: sort channel list by frequency instead of channel index
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some channel indices of the low 5GHz band clash with
those of the 2.4GHz band. Therefore we should go
with the channel's center frequency.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/eeprom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 35b09aa..ec7d4b8 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -93,7 +93,7 @@ static int p54_compare_channels(const void *_a,
 	const struct p54_channel_entry *a = _a;
 	const struct p54_channel_entry *b = _b;
 
-	return a->index - b->index;
+	return a->freq - b->freq;
 }
 
 static int p54_fill_band_bitrates(struct ieee80211_hw *dev,
@@ -291,7 +291,7 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 		}
 	}
 
-	/* sort the list by the channel index */
+	/* sort the channel list by frequency */
 	sort(list->channels, list->entries, sizeof(struct p54_channel_entry),
 	     p54_compare_channels, NULL);
 
-- 
1.7.2.3

