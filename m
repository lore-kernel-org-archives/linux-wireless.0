Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:38673 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZADQdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 11:33:52 -0500
Received: by ewy10 with SMTP id 10so7494709ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2009 08:33:49 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix TX short preamble detection
Date: Sun, 4 Jan 2009 17:33:25 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901041733.25464.IvDoorn@gmail.com> (sfid-20090104_173354_108176_24DF1694)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The short preamble mode was not correctly detected during TX,
rt2x00 used the rate->hw_value_short field but mac80211 is not
using this field that way.
Instead the flag IEEE80211_TX_RC_USE_SHORT_PREAMBLE should be
used to determine if the frame should be send out using
short preamble or not.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    8 +++-----
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   11 -----------
 drivers/net/wireless/rt2x00/rt2x00queue.c |    2 +-
 3 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index ab8aa97..12331b1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -523,13 +523,11 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
 {
 	entry->flags = 0;
 	entry->bitrate = rate->bitrate;
-	entry->hw_value = rt2x00_create_rate_hw_value(index, 0);
-	entry->hw_value_short = entry->hw_value;
+	entry->hw_value =index;
+	entry->hw_value_short = index;
 
-	if (rate->flags & DEV_RATE_SHORT_PREAMBLE) {
+	if (rate->flags & DEV_RATE_SHORT_PREAMBLE)
 		entry->flags |= IEEE80211_RATE_SHORT_PREAMBLE;
-		entry->hw_value_short |= rt2x00_create_rate_hw_value(index, 1);
-	}
 }
 
 static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 8381985..92918f3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -52,22 +52,11 @@ struct rt2x00_rate {
 
 extern const struct rt2x00_rate rt2x00_supported_rates[12];
 
-static inline u16 rt2x00_create_rate_hw_value(const u16 index,
-					      const u16 short_preamble)
-{
-	return (short_preamble << 8) | (index & 0xff);
-}
-
 static inline const struct rt2x00_rate *rt2x00_get_rate(const u16 hw_value)
 {
 	return &rt2x00_supported_rates[hw_value & 0xff];
 }
 
-static inline int rt2x00_get_rate_preamble(const u16 hw_value)
-{
-	return (hw_value & 0xff00);
-}
-
 /*
  * Radio control handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index fc28e23..c1e5a05 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -232,7 +232,7 @@ static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
 		 * When preamble is enabled we should set the
 		 * preamble bit for the signal.
 		 */
-		if (rt2x00_get_rate_preamble(rate->hw_value))
+		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 			txdesc->signal |= 0x08;
 	}
 }
-- 
1.5.6.1

