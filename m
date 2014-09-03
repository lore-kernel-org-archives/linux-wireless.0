Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363AbaICMcr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/10] mac80211: Add RRM support to assoc request
Date: Wed,  3 Sep 2014 15:25:02 +0300
Message-Id: <1409747106-30717-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143251_203946_1531DA0A)
In-Reply-To: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

In case of a RRM-supporting connection, in the association request
frame: set the RRM capability flag, and add the required IEs.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a0b89da..42a4c5c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -355,6 +355,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_DISABLE_80P80MHZ	= BIT(12),
 	IEEE80211_STA_DISABLE_160MHZ	= BIT(13),
 	IEEE80211_STA_DISABLE_WMM	= BIT(14),
+	IEEE80211_STA_ENABLE_RRM	= BIT(15),
 };
 
 struct ieee80211_mgd_auth_data {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2b38968..5dbd4bc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -664,6 +664,9 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
 		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
 
+	if (ifmgd->flags & IEEE80211_STA_ENABLE_RRM)
+		capab |= WLAN_CAPABILITY_RADIO_MEASURE;
+
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, assoc_data->bss->bssid, ETH_ALEN);
@@ -729,16 +732,17 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
-	if (capab & WLAN_CAPABILITY_SPECTRUM_MGMT) {
-		/* 1. power capabilities */
+	if (capab & WLAN_CAPABILITY_SPECTRUM_MGMT ||
+	    capab & WLAN_CAPABILITY_RADIO_MEASURE) {
 		pos = skb_put(skb, 4);
 		*pos++ = WLAN_EID_PWR_CAPABILITY;
 		*pos++ = 2;
 		*pos++ = 0; /* min tx power */
 		 /* max tx power */
 		*pos++ = ieee80211_chandef_max_power(&chanctx_conf->def);
+	}
 
-		/* 2. supported channels */
+	if (capab & WLAN_CAPABILITY_SPECTRUM_MGMT) {
 		/* TODO: get this in reg domain format */
 		pos = skb_put(skb, 2 * sband->n_channels + 2);
 		*pos++ = WLAN_EID_SUPPORTED_CHANNELS;
@@ -4397,6 +4401,11 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		ifmgd->flags &= ~IEEE80211_STA_MFP_ENABLED;
 	}
 
+	if (req->flags & ASSOC_REQ_USE_RRM)
+		ifmgd->flags |= IEEE80211_STA_ENABLE_RRM;
+	else
+		ifmgd->flags &= ~IEEE80211_STA_ENABLE_RRM;
+
 	if (req->crypto.control_port)
 		ifmgd->flags |= IEEE80211_STA_CONTROL_PORT;
 	else
-- 
1.9.1

