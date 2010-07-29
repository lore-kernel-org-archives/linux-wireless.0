Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0G2KGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 06:06:05 -0400
Subject: [RFC] mac80211: remove IEEE80211_HW_SPECTRUM_MGMT
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Tomas Winkler <tomas.winkler@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 12:05:59 +0200
Message-ID: <1280397959.3823.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IEEE80211_HW_SPECTRUM_MGMT hardware flag is
not really useful, since drivers need to add it
to get CSA support. The documentation states that
drivers should set it when they support 802.11h
measurement, channel switching, quieting and TPC.
Some drivers set the flag without supporting TPC,
for example ath9k_htc. Measurements are not done
at all, and quieting is also not supported. All
this hasn't stopped us from claiming we have the
necessary spectrum management implemented. But
the flag itself is pretty useless, so remove it.

Maybe we should have separate flags for "will honour
power_level" and actually implement quieting/measurement,
but right now I think this patch makes sense?

 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 -
 drivers/net/wireless/ath/ath9k/init.c         |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    3 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |    3 +--
 include/net/mac80211.h                        |    5 -----
 net/mac80211/work.c                           |    3 +--
 6 files changed, 3 insertions(+), 13 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/htc_drv_init.c	2010-07-29 11:57:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/htc_drv_init.c	2010-07-29 11:57:50.000000000 +0200
@@ -692,7 +692,6 @@ static void ath9k_set_hw_capab(struct at
 
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_AMPDU_AGGREGATION |
-		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_SUPPORTS_PS |
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/init.c	2010-07-29 11:57:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/init.c	2010-07-29 11:57:52.000000000 +0200
@@ -626,7 +626,6 @@ void ath9k_set_hw_capab(struct ath_softc
 		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
-		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-07-29 11:57:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-07-29 11:57:57.000000000 +0200
@@ -3184,8 +3184,7 @@ static int iwl_mac_setup_register(struct
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_SPECTRUM_MGMT;
+		    IEEE80211_HW_AMPDU_AGGREGATION;
 
 	if (!priv->cfg->broken_powersave)
 		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-07-29 11:57:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-07-29 11:58:03.000000000 +0200
@@ -3879,8 +3879,7 @@ static int iwl3945_setup_mac(struct iwl_
 	hw->vif_data_size = sizeof(struct iwl_vif_priv);
 
 	/* Tell mac80211 our characteristics */
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_SPECTRUM_MGMT;
+	hw->flags = IEEE80211_HW_SIGNAL_DBM;
 
 	if (!priv->cfg->broken_powersave)
 		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
--- wireless-testing.orig/include/net/mac80211.h	2010-07-29 11:57:47.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-07-29 11:58:27.000000000 +0200
@@ -985,10 +985,6 @@ enum ieee80211_tkip_key_type {
  *	one milliwatt. This is the preferred method since it is standardized
  *	between different devices. @max_signal does not need to be set.
  *
- * @IEEE80211_HW_SPECTRUM_MGMT:
- * 	Hardware supports spectrum management defined in 802.11h
- * 	Measurement, Channel Switch, Quieting, TPC
- *
  * @IEEE80211_HW_AMPDU_AGGREGATION:
  *	Hardware supports 11n A-MPDU aggregation.
  *
@@ -1049,7 +1045,6 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SIGNAL_UNSPEC			= 1<<5,
 	IEEE80211_HW_SIGNAL_DBM				= 1<<6,
 	/* use this hole */
-	IEEE80211_HW_SPECTRUM_MGMT			= 1<<8,
 	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<9,
 	IEEE80211_HW_SUPPORTS_PS			= 1<<10,
 	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
--- wireless-testing.orig/net/mac80211/work.c	2010-07-29 11:57:47.000000000 +0200
+++ wireless-testing/net/mac80211/work.c	2010-07-29 11:58:35.000000000 +0200
@@ -263,8 +263,7 @@ static void ieee80211_send_assoc(struct
 	if (wk->assoc.capability & WLAN_CAPABILITY_PRIVACY)
 		capab |= WLAN_CAPABILITY_PRIVACY;
 
-	if ((wk->assoc.capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
-	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
+	if (wk->assoc.capability & WLAN_CAPABILITY_SPECTRUM_MGMT)
 		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);


