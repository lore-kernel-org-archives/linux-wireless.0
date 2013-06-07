Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:48610 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3FGRFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 13:05:51 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 5/5] ath9k: enable CSA functionality in ath9k
Date: Fri,  7 Jun 2013 19:05:45 +0200
Message-Id: <1370624745-2267-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130607_190602_136332_478EF1EB)
In-Reply-To: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cc5a98b..0418cc6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2319,6 +2319,11 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	clear_bit(SC_OP_SCANNING, &sc->sc_flags);
 }
 
+static void ath9k_channel_switch_beacon(struct ieee80211_vif *vif)
+{
+	vif->csa_active = 1;
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2366,4 +2371,5 @@ struct ieee80211_ops ath9k_ops = {
 #endif
 	.sw_scan_start	    = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
+	.channel_switch_beacon     = ath9k_channel_switch_beacon,
 };
-- 
1.7.10.4

