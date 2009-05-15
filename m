Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15535 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbZEONep (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 09:34:45 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 06:34:47 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Remove unused parameters which are passed to ath_beacon_config_X()
Date: Fri, 15 May 2009 18:59:21 +0530
Message-ID: <1242394162-9812-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1242394162-9812-1-git-send-email-vasanth@atheros.com>
References: <1242394162-9812-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 3a7154b..af5edb8 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -507,8 +507,7 @@ void ath_beacon_tasklet(unsigned long data)
  * slot. Slots that are not occupied will generate nothing.
  */
 static void ath_beacon_config_ap(struct ath_softc *sc,
-				 struct ath_beacon_config *conf,
-				 struct ath_vif *avp)
+				 struct ath_beacon_config *conf)
 {
 	u32 nexttbtt, intval;
 
@@ -553,8 +552,7 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
  * we've associated with.
  */
 static void ath_beacon_config_sta(struct ath_softc *sc,
-				  struct ath_beacon_config *conf,
-				  struct ath_vif *avp)
+				  struct ath_beacon_config *conf)
 {
 	struct ath9k_beacon_state bs;
 	int dtimperiod, dtimcount, sleepduration;
@@ -654,7 +652,6 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 
 static void ath_beacon_config_adhoc(struct ath_softc *sc,
 				    struct ath_beacon_config *conf,
-				    struct ath_vif *avp,
 				    struct ieee80211_vif *vif)
 {
 	u64 tsf;
@@ -720,14 +717,14 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 
 		switch(avp->av_opmode) {
 		case NL80211_IFTYPE_AP:
-			ath_beacon_config_ap(sc, &conf, avp);
+			ath_beacon_config_ap(sc, &conf);
 			break;
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_MESH_POINT:
-			ath_beacon_config_adhoc(sc, &conf, avp, vif);
+			ath_beacon_config_adhoc(sc, &conf, vif);
 			break;
 		case NL80211_IFTYPE_STATION:
-			ath_beacon_config_sta(sc, &conf, avp);
+			ath_beacon_config_sta(sc, &conf);
 			break;
 		default:
 			DPRINTF(sc, ATH_DBG_CONFIG,
-- 
1.5.5.1

