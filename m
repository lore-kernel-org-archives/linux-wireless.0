Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41088 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab1BGPie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 10:38:34 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 07 Feb 2011 07:38:14 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH 1/1] ath9k: Update comments for not parsing DTIM period
Date: Mon, 7 Feb 2011 21:08:28 +0530
Message-ID: <1297093108-28541-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Add few comments for not parsing DTIM period from mac80211

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 87ba44c..fcb36ab 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -721,8 +721,9 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 		cur_conf->beacon_interval = 100;
 
 	/*
-	 * Some times we dont parse dtim period from mac80211, in that case
-	 * use a default value
+	 * We don't parse dtim period from mac80211 during the driver
+	 * initialization as it breaks association with hidden-ssid
+	 * AP and it causes latency in roaming
 	 */
 	if (cur_conf->dtim_period == 0)
 		cur_conf->dtim_period = 1;
-- 
1.7.0.4

