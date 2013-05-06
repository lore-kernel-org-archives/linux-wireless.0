Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51166 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab3EFTOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 15:14:10 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC 4/4] ath9k: enable CSA functionality in ath9k
Date: Mon,  6 May 2013 21:13:55 +0200
Message-Id: <1367867635-3459-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130506_211419_430799_258FEDBD)
In-Reply-To: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a383483..e68f62f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2341,6 +2341,11 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	sc->scanning = 0;
 }
 
+static void ath9k_channel_switch_beacon(struct ieee80211_vif *vif)
+{
+	vif->csa_active = 1;
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2388,4 +2393,5 @@ struct ieee80211_ops ath9k_ops = {
 #endif
 	.sw_scan_start	    = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
+	.channel_switch_beacon     = ath9k_channel_switch_beacon,
 };
-- 
1.7.10.4

