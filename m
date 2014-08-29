Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:33135 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaH2DVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 23:21:14 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Fix beacon configuration for channel contexts
Date: Fri, 29 Aug 2014 08:51:19 +0530
Message-Id: <1409282479-6735-1-git-send-email-sujith@msujith.org> (sfid-20140829_052118_372829_0EE287D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In channel context mode, when a new context is added,
mac80211 issues a bss_info_changed() notfication when
preparing the connection for the new interface/context.

But, this is done prior to the mgd_prepare_tx() call which
is where we switch to the new context. Since the current
context will be different when the earlier bss_info_changed()
is handled, the beacon information for the VIF is not
updated, but discarded since the rules for the current context
disallows it.

In the subsequent association process for the new context/vif,
this becomes a problem because the beacon parameters are invalid.
This causes problems with the TSF timer, causing large jumps.

To fix this, check if the beacon info is being updated for a
different context and if so, allow it without any checks since
we limit the max. interfaces to two anyway.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index b2f56d8..83f2f2f 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -514,6 +514,18 @@ static bool ath9k_allow_beacon_config(struct ath_softc *sc,
 				      struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_vif *avp = (void *)vif->drv_priv;
+
+	if (ath9k_is_chanctx_enabled()) {
+		/*
+		 * If the VIF is not present in the current channel context,
+		 * then we can't do the usual opmode checks. Allow the
+		 * beacon config for the VIF to be updated in this case and
+		 * return immediately.
+		 */
+		if (sc->cur_chan != avp->chanctx)
+			return true;
+	}
 
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
 		if ((vif->type != NL80211_IFTYPE_AP) ||
-- 
2.1.0

