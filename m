Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12643 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbYCEDnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 22:43:16 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: [linux-wireless] [RFC PATCH]iwlwifi: Fix for monitor mode captures management frames only.
Date: Tue, 4 Mar 2008 19:43:12 -0800
Message-ID: <BD524EA7912ED5469DFD0BAEF6BC752F035C2DAD@orsmsx411.amr.corp.intel.com> (sfid-20080305_034341_900060_BC7745CF)
From: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If monitor mode is set then mac80211 stack now passes the information to
driver.

>From 1e21ee62c88c5defacf49a4044d26677b8a79032 Mon Sep 17 00:00:00 2001
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Date: Tue, 4 Mar 2008 17:04:56 -0800
Subject: [PATCH] Monitor mode bug fix.
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    5 +++++
 net/mac80211/ieee80211.c                |   10 ++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c
b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3e122a9..5ed75aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3822,6 +3822,11 @@ static void iwl4965_rx_reply_rx(struct
iwl4965_priv *priv,
 	/* Find max signal strength (dBm) among 3 antenna/receiver
chains */
 	rx_status.ssi = iwl4965_calc_rssi(rx_start);
 
+	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
+		iwl4965_handle_data_packet(priv, 1, include_phy, rxb,
&rx_status);
+		return;
+	}
+
 	/* Meaningful noise values are available only from beacon
statistics,
 	 *   which are gathered only when associated, and indicate noise
 	 *   only for the associated network channel ...
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 484b063..85e37c8 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -327,6 +327,16 @@ static int ieee80211_open(struct net_device *dev)
 		netif_tx_lock_bh(local->mdev);
 		ieee80211_configure_filter(local);
 		netif_tx_unlock_bh(local->mdev);
+
+		conf.vif = &sdata->vif;
+		conf.type = sdata->vif.type;
+		conf.mac_addr = dev->dev_addr;
+		res = local->ops->add_interface(local_to_hw(local),
&conf);
+		if (res && !local->open_count && local->ops->stop)
+			local->ops->stop(local_to_hw(local));
+		if (res)
+			return res;
+
 		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
-- 
1.5.2.5


