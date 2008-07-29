Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17150 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbYG2Frs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:48 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:48 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 15/16] ath9k: Don't set the channel in ath_rate_init().
Date: Mon, 28 Jul 2008 22:47:24 -0700
Message-ID: <9ef806c861e93ddde2fc0797e1845d9343567799.1217309552.git.lrodriguez@atheros.com> (sfid-20080729_081546_892049_C3F65C44)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 996b54c..22b6550 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -2034,21 +2034,15 @@ static void ath_rate_init(void *priv, void *priv_sta,
 	struct ieee80211_hw *hw = local_to_hw(local);
 	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ath_softc *sc = hw->priv;
-	struct hal_channel hchan;
 	int i, j = 0;
 
-	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	sta->txrate_idx = rate_lowest_index(local, sband, sta);
 
-	hchan.channel = conf->channel->center_freq;
-	hchan.channelFlags = ath_chan2flags(conf->channel, sc);
-	if (ath_set_channel(sc, &hchan) < 0)
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: Unable to set channel\n",
-			__func__);
 	ath_setup_rates(local, sta);
-	if (conf->flags&IEEE80211_CONF_SUPPORT_HT_MODE) {
+	if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
 		for (i = 0; i < MCS_SET_SIZE; i++) {
 			if (conf->ht_conf.supp_mcs_set[i/8] & (1<<(i%8)))
 				((struct ath_rate_node *)
-- 
1.5.4.3

