Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:37741 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807AbaGQOON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:13 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so1956551wev.13
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:11 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/15] mac80211: set TDLS capab to zero on failure frames
Date: Thu, 17 Jul 2014 17:14:22 +0300
Message-Id: <1405606471-30128-7-git-send-email-arik@wizery.com> (sfid-20140717_161422_788019_1A47CE9A)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending setup-failure frames, set the capability field to zero, as
mandated by the specification (IEEE802.11-2012 8.5.13).

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 99d5ed3..398a413 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -46,11 +46,16 @@ static void ieee80211_tdls_add_ext_capab(struct sk_buff *skb)
 	*pos++ = WLAN_EXT_CAPA5_TDLS_ENABLED;
 }
 
-static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
+static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata,
+					u16 status_code)
 {
 	struct ieee80211_local *local = sdata->local;
 	u16 capab;
 
+	/* The capability will be 0 when sending a failure code */
+	if (status_code != 0)
+		return 0;
+
 	capab = 0;
 	if (ieee80211_get_sdata_band(sdata) != IEEE80211_BAND_2GHZ)
 		return capab;
@@ -207,7 +212,8 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		skb_put(skb, sizeof(tf->u.setup_req));
 		tf->u.setup_req.dialog_token = dialog_token;
 		tf->u.setup_req.capability =
-			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
+			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata,
+								 status_code));
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
 		tf->category = WLAN_CATEGORY_TDLS;
@@ -217,7 +223,8 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_resp.status_code = cpu_to_le16(status_code);
 		tf->u.setup_resp.dialog_token = dialog_token;
 		tf->u.setup_resp.capability =
-			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
+			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata,
+								 status_code));
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
 		tf->category = WLAN_CATEGORY_TDLS;
@@ -274,7 +281,8 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 		mgmt->u.action.u.tdls_discover_resp.dialog_token =
 			dialog_token;
 		mgmt->u.action.u.tdls_discover_resp.capability =
-			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
+			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata,
+								 status_code));
 		break;
 	default:
 		return -EINVAL;
-- 
1.9.1

