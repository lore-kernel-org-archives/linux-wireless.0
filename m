Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:7922 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYDABDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 21:03:15 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1054936wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 18:03:12 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Cc: johannes@sipsolutions.net
Date: Mon, 31 Mar 2008 16:00:13 -0700
Subject: [PATCH 1/2] mac80211: check for mesh_config length on incoming management frames
Message-ID: <47f189ce.0a528c0a.4608.0322@mx.google.com> (sfid-20080401_020317_021930_45A006D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/ieee80211_sta.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index cfe6fcc..feec201 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2153,11 +2153,14 @@ ieee80211_rx_mesh_bss_get(struct net_device *dev, u8 *mesh_id, int mesh_id_len,
 
 static struct ieee80211_sta_bss *
 ieee80211_rx_mesh_bss_add(struct net_device *dev, u8 *mesh_id, int mesh_id_len,
-			  u8 *mesh_cfg, int freq)
+			  u8 *mesh_cfg, int mesh_config_len, int freq)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 
+	if (mesh_config_len != MESH_CFG_LEN)
+		return NULL;
+
 	bss = kzalloc(sizeof(*bss), GFP_ATOMIC);
 	if (!bss)
 		return NULL;
@@ -2530,7 +2533,8 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 #ifdef CONFIG_MAC80211_MESH
 		if (elems.mesh_config)
 			bss = ieee80211_rx_mesh_bss_add(dev, elems.mesh_id,
-				elems.mesh_id_len, elems.mesh_config, freq);
+				elems.mesh_id_len, elems.mesh_config,
+				elems.mesh_config_len, freq);
 		else
 #endif
 			bss = ieee80211_rx_bss_add(dev, mgmt->bssid, freq,
-- 
1.5.4.3



