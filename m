Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16711 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab0BCRUw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 12:20:52 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2010 09:20:52 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 1/3] ath9k: configure the beacon only if the STA is associated
Date: Wed, 3 Feb 2010 22:50:18 +0530
Message-ID: <1265217618-2018-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

beacons configuration SHOULD be done only if the STA is associated.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 422454f..d088ebf 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -577,6 +577,13 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	u64 tsf;
 	int num_beacons, offset, dtim_dec_count, cfp_dec_count;

+	/* No need to configure beacon if we are not associated */
+	if (!common->curaid) {
+		ath_print(common, ATH_DBG_BEACON,
+			 "STA is not yet associated..skipping beacon config\n");
+		return;
+	}
+
 	memset(&bs, 0, sizeof(bs));
 	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;

@@ -739,7 +746,6 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 	enum nl80211_iftype iftype;

 	/* Setup the beacon configuration parameters */
-
 	if (vif) {
 		struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;

--
1.6.6.1

