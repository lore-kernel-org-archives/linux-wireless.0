Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:61097 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3IQPlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 11:41:45 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so2803174eae.38
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 08:41:44 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 08/11] wlcore: clarify and fix regulatory domain bit translation
Date: Tue, 17 Sep 2013 18:41:27 +0300
Message-Id: <1379432490-22157-8-git-send-email-eliad@wizery.com> (sfid-20130917_174155_003874_805BD397)
In-Reply-To: <1379432490-22157-1-git-send-email-eliad@wizery.com>
References: <1379432490-22157-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channels 52-64 were mapped incorrectly.

Refactor and document wlcore_get_reg_conf_ch_idx() in
order to make it clear what's going on there.

While on it, fix the return value check to consider
0 as a valid return value as well (indicates channel 1).

Reported-by: Yaniv Machani <yanivma@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c | 52 +++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index e3ae425..9e5416f8 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1607,33 +1607,43 @@ out:
 
 static int wlcore_get_reg_conf_ch_idx(enum ieee80211_band band, u16 ch)
 {
-	int idx = -1;
-
+	/*
+	 * map the given band/channel to the respective predefined
+	 * bit expected by the fw
+	 */
 	switch (band) {
-	case IEEE80211_BAND_5GHZ:
-		if (ch >= 8 && ch <= 16)
-			idx = ((ch-8)/4 + 18);
-		else if (ch >= 34 && ch <= 64)
-			idx = ((ch-34)/2 + 3 + 18);
-		else if (ch >= 100 && ch <= 140)
-			idx = ((ch-100)/4 + 15 + 18);
-		else if (ch >= 149 && ch <= 165)
-			idx = ((ch-149)/4 + 26 + 18);
-		else
-			idx = -1;
-		break;
 	case IEEE80211_BAND_2GHZ:
+		/* channels 1..14 are mapped to 0..13 */
 		if (ch >= 1 && ch <= 14)
-			idx = ch - 1;
-		else
-			idx = -1;
+			return ch - 1;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		switch (ch) {
+		case 8 ... 16:
+			/* channels 8,12,16 are mapped to 18,19,20 */
+			return 18 + (ch-8)/4;
+		case 34 ... 48:
+			/* channels 34,36..48 are mapped to 21..28 */
+			return 21 + (ch-34)/2;
+		case 52 ... 64:
+			/* channels 52,56..64 are mapped to 29..32 */
+			return 29 + (ch-52)/4;
+		case 100 ... 140:
+			/* channels 100,104..140 are mapped to 33..43 */
+			return 33 + (ch-100)/4;
+		case 149 ... 165:
+			/* channels 149,153..165 are mapped to 44..48 */
+			return 44 + (ch-149)/4;
+		default:
+			break;
+		}
 		break;
 	default:
-		wl1271_error("get reg conf ch idx - unknown band: %d",
-			     (int)band);
+		break;
 	}
 
-	return idx;
+	wl1271_error("%s: unknown band/channel: %d/%d", __func__, band, ch);
+	return -1;
 }
 
 void wlcore_set_pending_regdomain_ch(struct wl1271 *wl, u16 channel,
@@ -1646,7 +1656,7 @@ void wlcore_set_pending_regdomain_ch(struct wl1271 *wl, u16 channel,
 
 	ch_bit_idx = wlcore_get_reg_conf_ch_idx(band, channel);
 
-	if (ch_bit_idx > 0 && ch_bit_idx <= WL1271_MAX_CHANNELS)
+	if (ch_bit_idx >= 0 && ch_bit_idx <= WL1271_MAX_CHANNELS)
 		set_bit(ch_bit_idx, (long *)wl->reg_ch_conf_pending);
 }
 
-- 
1.8.3.rc1.35.g9b79519

