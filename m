Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f170.google.com ([209.85.212.170]:51390 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab1ECX5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:39 -0400
Received: by mail-px0-f170.google.com with SMTP id 19so426563pxi.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:39 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 06/13] nl80211: allow installing keys for a meshif
Date: Tue,  3 May 2011 16:57:12 -0700
Message-Id: <1304467039-7730-7-git-send-email-javier@cozybit.com> (sfid-20110504_015744_368174_D24EEFD5)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Pedersen <thomas@cozybit.com>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/cfg.c     |    5 ++++-
 net/wireless/nl80211.c |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dbc5bcb..852cb85 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -136,7 +136,10 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	mutex_lock(&sdata->local->sta_mtx);
 
 	if (mac_addr) {
-		sta = sta_info_get_bss(sdata, mac_addr);
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			sta = sta_info_get(sdata, mac_addr);
+		else
+			sta = sta_info_get_bss(sdata, mac_addr);
 		if (!sta) {
 			ieee80211_key_free(sdata->local, key);
 			err = -ENOENT;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 49f220a..176d118 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -535,6 +535,7 @@ static int nl80211_key_allowed(struct wireless_dev *wdev)
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_MESH_POINT:
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		if (!wdev->current_bss)
-- 
1.7.1

