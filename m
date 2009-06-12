Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47443 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZFLFcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 01:32:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 22:32:10 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Make sure we configure a non-zero beacon interval
Date: Fri, 12 Jun 2009 10:55:55 +0530
Message-ID: <1244784355-4157-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the sanity check on beacon interval
which was done only for mesh mode to all operating
modes just to be safe.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 3639a2e..45c4ea5 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -674,13 +674,6 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 
 	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
 
-	/*
-	 * It looks like mac80211 may end up using beacon interval of zero in
-	 * some cases (at least for mesh point). Avoid getting into an
-	 * infinite loop by using a bit safer value instead..
-	 */
-	if (intval == 0)
-		intval = 100;
 
 	/* Pull nexttbtt forward to reflect the current TSF */
 
@@ -745,6 +738,14 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 		iftype = sc->sc_ah->opmode;
 	}
 
+	/*
+	 * It looks like mac80211 may end up using beacon interval of zero in
+	 * some cases (at least for mesh point). Avoid getting into an
+	 * infinite loop by using a bit safer value instead. To be safe,
+	 * do sanity check on beacon interval for all operating modes.
+	 */
+	if (cur_conf->beacon_interval == 0)
+		cur_conf->beacon_interval = 100;
 
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
-- 
1.5.5.1

