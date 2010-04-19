Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48928 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0DSHQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 03:16:35 -0400
Received: by wyb39 with SMTP id 39so2297068wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 00:16:33 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/3] orinoco: use cfg80211_find_ie
Date: Mon, 19 Apr 2010 08:16:22 +0100
Message-Id: <1271661383-27839-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1271661383-27839-1-git-send-email-kilroyd@googlemail.com>
References: <1271661383-27839-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using a local function.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/main.h |   12 ------------
 drivers/net/wireless/orinoco/scan.c |    4 ++--
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.h b/drivers/net/wireless/orinoco/main.h
index 21ab36c..4dadf98 100644
--- a/drivers/net/wireless/orinoco/main.h
+++ b/drivers/net/wireless/orinoco/main.h
@@ -33,18 +33,6 @@ int orinoco_commit(struct orinoco_private *priv);
 void orinoco_reset(struct work_struct *work);
 
 /* Information element helpers - find a home for these... */
-static inline u8 *orinoco_get_ie(u8 *data, size_t len,
-				 enum ieee80211_eid eid)
-{
-	u8 *p = data;
-	while ((p + 2) < (data + len)) {
-		if (p[0] == eid)
-			return p;
-		p += p[1] + 2;
-	}
-	return NULL;
-}
-
 #define WPA_OUI_TYPE	"\x00\x50\xF2\x01"
 #define WPA_SELECTOR_LEN 4
 static inline u8 *orinoco_get_wpa_ie(u8 *data, size_t len)
diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
index 330d42d..4300d9d 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -127,7 +127,7 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 {
 	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct ieee80211_channel *channel;
-	u8 *ie;
+	const u8 *ie;
 	u64 timestamp;
 	s32 signal;
 	u16 capability;
@@ -136,7 +136,7 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 	int chan, freq;
 
 	ie_len = len - sizeof(*bss);
-	ie = orinoco_get_ie(bss->data, ie_len, WLAN_EID_DS_PARAMS);
+	ie = cfg80211_find_ie(WLAN_EID_DS_PARAMS, bss->data, ie_len);
 	chan = ie ? ie[2] : 0;
 	freq = ieee80211_dsss_chan_to_freq(chan);
 	channel = ieee80211_get_channel(wiphy, freq);
-- 
1.6.4.4

