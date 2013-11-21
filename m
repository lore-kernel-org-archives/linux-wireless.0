Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39902 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3KUN2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 08:28:48 -0500
Received: by mail-ee0-f53.google.com with SMTP id b57so4676002eek.40
        for <linux-wireless@vger.kernel.org>; Thu, 21 Nov 2013 05:28:47 -0800 (PST)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH 2/2] mac80211: Update opmode  during adding new station
Date: Thu, 21 Nov 2013 14:28:15 +0100
Message-Id: <1385040495-13482-2-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131121_142857_619255_B55556DC)
In-Reply-To: <1385040495-13482-1-git-send-email-marek.kwaczynski@tieto.com>
References: <1385040495-13482-1-git-send-email-marek.kwaczynski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update Operating mode is needed when User Space received Assoc
Request contains Operating mode notification element.
---
 net/mac80211/cfg.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 95667b0..710b5d7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1383,6 +1383,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 	int layer2_update;
+	enum ieee80211_band band;
 
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
@@ -1425,6 +1426,12 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		rate_control_rate_init(sta);
 
+	if (params->vht_opmode_used) {
+		band = ieee80211_get_sdata_band(sdata);
+		ieee80211_vht_handle_opmode(sdata, sta, params->vht_opmode,
+					    band, 0);
+	}
+
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		sdata->vif.type == NL80211_IFTYPE_AP;
 
-- 
1.7.9.5

