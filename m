Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53526 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab1DBBjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 21:39:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/3] ath9k: use the hw opmode to select the beacon timer mode
Date: Sat,  2 Apr 2011 03:39:48 +0200
Message-Id: <1301708388-8416-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1301708388-8416-2-git-send-email-nbd@openwrt.org>
References: <1301708388-8416-1-git-send-email-nbd@openwrt.org>
 <1301708388-8416-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the beacon timers are global, the individual vif type should not
be used to determine the beacon timer configuration mode, use the
global opmode instead.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 24861b2..f688527 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -700,7 +700,7 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 	if (cur_conf->dtim_period == 0)
 		cur_conf->dtim_period = 1;
 
-	switch (iftype) {
+	switch (sc->sc_ah->opmode) {
 	case NL80211_IFTYPE_AP:
 		ath_beacon_config_ap(sc, cur_conf);
 		break;
-- 
1.7.3.2

