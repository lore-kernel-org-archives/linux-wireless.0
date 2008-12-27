Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:56038 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYL0VTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2008 16:19:52 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: initialize RC data for all mesh links upon allocation
Date: Sat, 27 Dec 2008 22:19:49 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>, andrey@cozybit.com,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812272219.49555.chunkeey@web.de> (sfid-20081227_221956_584396_AA65702F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a panic that might occur, if the device is part of a mesh
and tries to send with a higher rate index than "0".

kernel BUG at net/mac80211/rate.c:239! 
invalid opcode: 0000 [#1] SMP 
[...]
 Call Trace:
 <IRQ> <0> ? invoke_tx_handlers+0x474/0xb57 [mac80211]
 ? __ieee80211_tx_prepare+0x260/0x2a8 [mac80211]
 ? ieee80211_master_start_xmit+0x300/0x43a [mac80211]
 ? __qdisc_run+0xde/0x1da
 ? net_tx_action+0xb4/0x102
 Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
I'm not sure if we need a rate_control_rate_init in mesh_neighbour_update as well.
So, there's one patch[1] with and another one[2] without rate_control_rate_init in
mesh_neighbour_update...
---
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index faac101..1c1474d 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -107,6 +107,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 
 	sta->flags = WLAN_STA_AUTHORIZED;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	rate_control_rate_init(sta);
 
 	return sta;
 }
@@ -244,6 +245,7 @@ void mesh_neighbour_update(u8 *hw_addr, u64 rates, struct ieee80211_sub_if_data
 
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	rate_control_rate_init(sta);
 	if (peer_accepting_plinks && sta->plink_state == PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
 			sdata->u.mesh.mshcfg.auto_open_plinks)
---
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index faac101..a540ab8 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -107,6 +107,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 
 	sta->flags = WLAN_STA_AUTHORIZED;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	rate_control_rate_init(sta);
 
 	return sta;
 }
