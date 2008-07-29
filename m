Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbYG2LXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:23:49 -0400
Message-Id: <20080729112306.014768000@sipsolutions.net> (sfid-20080729_132353_041796_BAA9D3BD)
References: <20080729112249.877813000@sipsolutions.net>
Date: Tue, 29 Jul 2008 13:22:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: remove IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE
	flag
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot this in the previous patch that made it unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/main.c             |    3 +--
 drivers/net/wireless/b43legacy/main.c       |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +--
 drivers/net/wireless/rt2x00/rt2500usb.c     |    1 -
 drivers/net/wireless/rt2x00/rt61pci.c       |    1 -
 drivers/net/wireless/rt2x00/rt73usb.c       |    1 -
 drivers/net/wireless/zd1211rw/zd_mac.c      |    1 -
 include/net/mac80211.h                      |    1 -
 9 files changed, 4 insertions(+), 13 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-07-29 13:16:01.000000000 +0200
+++ everything/include/net/mac80211.h	2008-07-29 13:16:02.000000000 +0200
@@ -740,7 +740,6 @@ enum ieee80211_tkip_key_type {
  * 	Measurement, Channel Switch, Quieting, TPC
  */
 enum ieee80211_hw_flags {
-	IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE		= 1<<0,
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
 	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
 	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE		= 1<<3,
--- everything.orig/drivers/net/wireless/b43/main.c	2008-07-29 13:15:45.000000000 +0200
+++ everything/drivers/net/wireless/b43/main.c	2008-07-29 13:16:02.000000000 +0200
@@ -4645,8 +4645,7 @@ static int b43_wireless_init(struct ssb_
 	}
 
 	/* fill hw info */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-		    IEEE80211_HW_RX_INCLUDES_FCS |
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		    IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
 
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-07-29 13:15:45.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-07-29 13:16:02.000000000 +0200
@@ -3702,8 +3702,7 @@ static int b43legacy_wireless_init(struc
 	}
 
 	/* fill hw info */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-		    IEEE80211_HW_RX_INCLUDES_FCS |
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		    IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
 	hw->queues = 1; /* FIXME: hardware has more queues */
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2008-07-29 13:15:45.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-core.c	2008-07-29 13:16:02.000000000 +0200
@@ -818,8 +818,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	hw->rate_control_algorithm = "iwl-4965-rs";
 
 	/* Tell mac80211 our characteristics */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-		    IEEE80211_HW_SIGNAL_DBM |
+	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-07-29 13:16:01.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-07-29 13:16:02.000000000 +0200
@@ -7899,8 +7899,7 @@ static int iwl3945_pci_probe(struct pci_
 	priv->ibss_beacon = NULL;
 
 	/* Tell mac80211 our characteristics */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-		    IEEE80211_HW_SIGNAL_DBM |
+	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
 
 	/* 4 EDCA QOS priorities */
--- everything.orig/drivers/net/wireless/rt2x00/rt2500usb.c	2008-07-29 13:15:45.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2500usb.c	2008-07-29 13:16:02.000000000 +0200
@@ -1650,7 +1650,6 @@ static void rt2500usb_probe_hw_mode(stru
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_RX_INCLUDES_FCS |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_SIGNAL_DBM;
--- everything.orig/drivers/net/wireless/rt2x00/rt61pci.c	2008-07-29 13:15:45.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt61pci.c	2008-07-29 13:16:02.000000000 +0200
@@ -2278,7 +2278,6 @@ static void rt61pci_probe_hw_mode(struct
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_SIGNAL_DBM;
 	rt2x00dev->hw->extra_tx_headroom = 0;
--- everything.orig/drivers/net/wireless/rt2x00/rt73usb.c	2008-07-29 13:15:45.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt73usb.c	2008-07-29 13:16:02.000000000 +0200
@@ -1871,7 +1871,6 @@ static void rt73usb_probe_hw_mode(struct
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_SIGNAL_DBM;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-07-29 13:15:45.000000000 +0200
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2008-07-29 13:16:02.000000000 +0200
@@ -935,7 +935,6 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 		    IEEE80211_HW_SIGNAL_DB;
 
 	hw->max_signal = 100;

-- 

