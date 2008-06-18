Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42950 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYFROxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 10:53:52 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/2] mac80211: add spectrum capabilities
Date: Wed, 18 Jun 2008 17:53:44 +0300
Message-Id: <1213800824-32107-2-git-send-email-tomas.winkler@intel.com> (sfid-20080618_165358_237047_C8B0B23F)
In-Reply-To: <1213800824-32107-1-git-send-email-tomas.winkler@intel.com>
References: <1213800824-32107-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add spectrum capability and required information
elements to association request providing AP has requested it and
it is supported by the driver

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/mlme.c    |   24 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7ab4ff6..6178c32 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -705,6 +705,10 @@ enum ieee80211_tkip_key_type {
  * @IEEE80211_HW_NOISE_DBM:
  *	Hardware can provide noise (radio interference) values in units dBm,
  *      decibel difference from one milliwatt.
+ *
+ * @IEEE80211_HW_SPECTRUM_MGMT:
+ * 	Hardware supports spectrum management defined in 802.11h
+ * 	Measurement, Channel Switch, Quieting, TPC
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE		= 1<<0,
@@ -716,6 +720,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SIGNAL_DB				= 1<<6,
 	IEEE80211_HW_SIGNAL_DBM				= 1<<7,
 	IEEE80211_HW_NOISE_DBM				= 1<<8,
+	IEEE80211_HW_SPECTRUM_MGMT			= 1<<9,
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0b79d92..bfd0919 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -747,6 +747,10 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		 * b-only mode) */
 		rates_len = ieee80211_compatible_rates(bss, sband, &rates);
 
+		if ((bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
+		    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
+			capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
+
 		ieee80211_rx_bss_put(dev, bss);
 	} else {
 		rates = ~0;
@@ -814,6 +818,26 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		}
 	}
 
+	if (capab & WLAN_CAPABILITY_SPECTRUM_MGMT) {
+		/* 1. power capabilities */
+		pos = skb_put(skb, 4);
+		*pos++ = WLAN_EID_PWR_CAPABILITY;
+		*pos++ = 2;
+		*pos++ = 0; /* min tx power */
+		*pos++ = local->hw.conf.channel->max_power; /* max tx power */
+
+		/* 2. supported channels */
+		/* TODO: get this in reg domain format */
+		pos = skb_put(skb, 2 * sband->n_channels + 2);
+		*pos++ = WLAN_EID_SUPPORTED_CHANNELS;
+		*pos++ = 2 * sband->n_channels;
+		for (i = 0; i < sband->n_channels; i++) {
+			*pos++ = ieee80211_frequency_to_channel(
+					sband->channels[i].center_freq);
+			*pos++ = 1; /* one channel in the subband*/
+		}
+	}
+
 	if (ifsta->extra_ie) {
 		pos = skb_put(skb, ifsta->extra_ie_len);
 		memcpy(pos, ifsta->extra_ie, ifsta->extra_ie_len);
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

