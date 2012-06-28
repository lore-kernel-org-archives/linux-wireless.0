Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40452 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab2F1MC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 08:02:56 -0400
Received: by wgbdr13 with SMTP id dr13so2124583wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 05:02:54 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: allow calling ieee80211_ap_probereq_get() during auth/assoc
Date: Thu, 28 Jun 2012 15:03:13 +0300
Message-Id: <1340884993-31432-1-git-send-email-eliad@wizery.com> (sfid-20120628_140304_539345_68902FA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers might need getting the probe request
(e.g. in order to extract the ssid) even during
auth/assoc.

Make ieee80211_ap_probereq_get() support it
by considering auth_data/assoc_data as well.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4b8e0a4..1ad9a59 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1621,6 +1621,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct cfg80211_bss *cbss;
 	struct sk_buff *skb;
 	const u8 *ssid;
 	int ssid_len;
@@ -1630,16 +1631,22 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 
 	ASSERT_MGD_MTX(ifmgd);
 
-	if (!ifmgd->associated)
+	if (ifmgd->associated)
+		cbss = ifmgd->associated;
+	else if (ifmgd->auth_data)
+		cbss = ifmgd->auth_data->bss;
+	else if (ifmgd->assoc_data)
+		cbss = ifmgd->assoc_data->bss;
+	else
 		return NULL;
 
-	ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
+	ssid = ieee80211_bss_get_ie(cbss, WLAN_EID_SSID);
 	if (WARN_ON_ONCE(ssid == NULL))
 		ssid_len = 0;
 	else
 		ssid_len = ssid[1];
 
-	skb = ieee80211_build_probe_req(sdata, ifmgd->associated->bssid,
+	skb = ieee80211_build_probe_req(sdata, cbss->bssid,
 					(u32) -1, ssid + 2, ssid_len,
 					NULL, 0, true);
 
-- 
1.7.6.401.g6a319

