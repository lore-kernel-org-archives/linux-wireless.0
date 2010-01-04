Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52806 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0ADU4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:56:12 -0500
Date: Mon, 4 Jan 2010 21:56:07 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 09/14] mwl8k: fix changed flags handling in mwl8k_bss_info_changed()
Message-ID: <20100104205607.GI1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, mwl8k_bss_info_changed() would refuse to do anything if
the 'changed' argument indicated that the association status hadn't
changed.  Fix this up so that it will allow changing things like the
preamble type, the slot time and the CTS-to-self protection method
without having to reassociate.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   52 ++++++++++++++++++++++++++---------------
 1 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ea5e3f7..fac8864 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2958,57 +2958,71 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 				   u32 changed)
 {
 	struct mwl8k_priv *priv = hw->priv;
+	u32 ap_legacy_rates;
 	int rc;
 
-	if ((changed & BSS_CHANGED_ASSOC) == 0)
+	if (mwl8k_fw_lock(hw))
 		return;
 
-	priv->capture_beacon = false;
-
-	rc = mwl8k_fw_lock(hw);
-	if (rc)
-		return;
+	/*
+	 * No need to capture a beacon if we're no longer associated.
+	 */
+	if ((changed & BSS_CHANGED_ASSOC) && !vif->bss_conf.assoc)
+		priv->capture_beacon = false;
 
+	/*
+	 * Get the AP's legacy rates.
+	 */
+	ap_legacy_rates = 0;
 	if (vif->bss_conf.assoc) {
 		struct ieee80211_sta *ap;
-		u32 legacy_rate_mask;
 
 		rcu_read_lock();
-		ap = ieee80211_find_sta(vif, vif->bss_conf.bssid);
-		if (ap != NULL)
-			legacy_rate_mask = ap->supp_rates[IEEE80211_BAND_2GHZ];
-		rcu_read_unlock();
 
-		if (ap == NULL)
+		ap = ieee80211_find_sta(vif, vif->bss_conf.bssid);
+		if (ap == NULL) {
+			rcu_read_unlock();
 			goto out;
+		}
+
+		ap_legacy_rates = ap->supp_rates[IEEE80211_BAND_2GHZ];
+
+		rcu_read_unlock();
+	}
 
-		/* Install rates */
-		rc = mwl8k_cmd_set_rate(hw, vif, legacy_rate_mask);
+	if ((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc) {
+		rc = mwl8k_cmd_set_rate(hw, vif, ap_legacy_rates);
 		if (rc)
 			goto out;
 
-		/* Turn on rate adaptation */
 		rc = mwl8k_cmd_use_fixed_rate(hw, MWL8K_USE_AUTO_RATE,
 			MWL8K_UCAST_RATE, NULL);
 		if (rc)
 			goto out;
+	}
 
-		/* Set radio preamble */
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		rc = mwl8k_set_radio_preamble(hw,
 				vif->bss_conf.use_short_preamble);
 		if (rc)
 			goto out;
+	}
 
-		/* Set slot time */
+	if (changed & BSS_CHANGED_ERP_SLOT) {
 		rc = mwl8k_cmd_set_slot(hw, vif->bss_conf.use_short_slot);
 		if (rc)
 			goto out;
+	}
 
-		/* Set AID */
-		rc = mwl8k_cmd_set_aid(hw, vif, legacy_rate_mask);
+	if (((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc) ||
+	    (changed & (BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_HT))) {
+		rc = mwl8k_cmd_set_aid(hw, vif, ap_legacy_rates);
 		if (rc)
 			goto out;
+	}
 
+	if (vif->bss_conf.assoc &&
+	    (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_BEACON_INT))) {
 		/*
 		 * Finalize the join.  Tell rx handler to process
 		 * next beacon from our BSSID.
-- 
1.5.6.4
