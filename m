Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44022 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2LMLPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 06:15:08 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1483074pad.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 03:15:07 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] [mac80211] use short slot time in mesh for 5GHz
Date: Thu, 13 Dec 2012 18:59:57 +0800
Message-Id: <1355396397-25298-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20121213_121512_705340_345D63A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use short slot time in 5GHz for mesh. The performance is
increased from 16.4Mbps to 23.4Mbps for two directly
connected mesh STAs operating in legacy rate using iperf
measurement. Almost similar to the results claimed in IBSS
mode.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1bf03f9..ee0d8a3 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -607,6 +607,13 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	u32 changed;
+
+	changed = BSS_CHANGED_BEACON |
+		  BSS_CHANGED_BEACON_ENABLED |
+		  BSS_CHANGED_HT |
+		  BSS_CHANGED_BASIC_RATES |
+		  BSS_CHANGED_BEACON_INT;
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
@@ -628,11 +635,13 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata->local,
 					  ieee80211_get_sdata_band(sdata));
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
-						BSS_CHANGED_BEACON_ENABLED |
-						BSS_CHANGED_HT |
-						BSS_CHANGED_BASIC_RATES |
-						BSS_CHANGED_BEACON_INT);
+
+	if (ieee80211_get_sdata_band(sdata) == IEEE80211_BAND_5GHZ) {
+		sdata->vif.bss_conf.use_short_slot = true;
+		changed |= BSS_CHANGED_ERP_SLOT;
+	}
+
+	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(sdata->dev);
 }
-- 
1.7.0.4

