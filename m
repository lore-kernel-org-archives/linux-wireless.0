Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbZFJITp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 04:19:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 14/18] ath9k: remove unnecessary IEEE80211_TX_CTL_NO_ACK checks
Date: Wed, 10 Jun 2009 04:19:31 -0400
Message-Id: <1244621975-1238-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244621975-1238-1-git-send-email-lrodriguez@atheros.com>
References: <1244621975-1238-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We check for this condition early on in our mac80211 get_rate()
callback ath_get_rate(), so remove this check later down the path.

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 96d46d6..2c72901 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -777,7 +777,6 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
 	 */
 	if ((sc->sc_flags & SC_OP_PROTECT_ENABLE) &&
-	    !(tx_info->flags & IEEE80211_TX_CTL_NO_ACK) &&
 	    (rate_table->info[rix].phy == WLAN_RC_PHY_OFDM ||
 	     WLAN_RC_PHY_HT(rate_table->info[rix].phy))) {
 		rates[0].flags |= IEEE80211_TX_RC_USE_CTS_PROTECT;
@@ -882,9 +881,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	 *
 	 * FIXME: Fix duration
 	 */
-	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-	    (ieee80211_has_morefrags(fc) ||
-	     (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG))) {
+	if (ieee80211_has_morefrags(fc) ||
+	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
 		rates[1].count = rates[2].count = rates[3].count = 0;
 		rates[1].idx = rates[2].idx = rates[3].idx = 0;
 		rates[0].count = ATH_TXMAXTRY;
-- 
1.6.0.6

