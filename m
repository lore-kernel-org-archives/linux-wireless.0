Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44725 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865Ab1KCSd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 14:33:27 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k: Improve debugfs printout for stations.
Date: Thu,  3 Nov 2011 11:33:13 -0700
Message-Id: <1320345193-27164-1-git-send-email-greearb@candelatech.com> (sfid-20111103_193330_852560_58BC2763)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Add interface address so it can be mapped to a local
interface.  Add max-ampdu and mpdu-density.

Print out the tid->baw_size

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 1c269f5... 3d3b44f... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 327aa28... 8e7e57c... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 93fbe6f... f8c87d3... M	drivers/net/wireless/ath/ath9k/main.c
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/debug.c |   13 +++++++++----
 drivers/net/wireless/ath/ath9k/main.c  |    6 ++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1c269f5..3d3b44f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -252,6 +252,7 @@ struct ath_node {
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct list_head list; /* for sc->nodes */
 	struct ieee80211_sta *sta; /* station struct we're part of */
+	struct ieee80211_vif *vif; /* interface with which we're associated */
 #endif
 	struct ath_atx_tid tid[WME_NUM_TID];
 	struct ath_atx_ac ac[WME_NUM_AC];
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 327aa28..8e7e57c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -708,24 +708,29 @@ static ssize_t read_file_stations(struct file *file, char __user *user_buf,
 
 	len += snprintf(buf + len, size - len,
 			"Stations:\n"
-			" tid: addr sched paused buf_q-empty an ac\n"
+			" tid: addr sched paused buf_q-empty an ac baw\n"
 			" ac: addr sched tid_q-empty txq\n");
 
 	spin_lock(&sc->nodes_lock);
 	list_for_each_entry(an, &sc->nodes, list) {
+		unsigned short ma = an->maxampdu;
+		if (ma == 0)
+			ma = 65535; /* see ath_lookup_rate */
 		len += snprintf(buf + len, size - len,
-				"%pM\n", an->sta->addr);
+				"iface: %pM  sta: %pM max-ampdu: %hu mpdu-density: %uus\n",
+				an->vif->addr, an->sta->addr, ma,
+				(unsigned int)(an->mpdudensity));
 		if (len >= size)
 			goto done;
 
 		for (q = 0; q < WME_NUM_TID; q++) {
 			struct ath_atx_tid *tid = &(an->tid[q]);
 			len += snprintf(buf + len, size - len,
-					" tid: %p %s %s %i %p %p\n",
+					" tid: %p %s %s %i %p %p %hu\n",
 					tid, tid->sched ? "sched" : "idle",
 					tid->paused ? "paused" : "running",
 					skb_queue_empty(&tid->buf_q),
-					tid->an, tid->ac);
+					tid->an, tid->ac, tid->baw_size);
 			if (len >= size)
 				goto done;
 		}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 93fbe6f..f8c87d3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -630,7 +630,8 @@ set_timer:
 	}
 }
 
-static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
+static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
+			    struct ieee80211_vif *vif)
 {
 	struct ath_node *an;
 	an = (struct ath_node *)sta->drv_priv;
@@ -640,6 +641,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 	list_add(&an->list, &sc->nodes);
 	spin_unlock(&sc->nodes_lock);
 	an->sta = sta;
+	an->vif = vif;
 #endif
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		ath_tx_node_init(sc, an);
@@ -1798,7 +1800,7 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 	struct ieee80211_key_conf ps_key = { };
 
-	ath_node_attach(sc, sta);
+	ath_node_attach(sc, sta, vif);
 
 	if (vif->type != NL80211_IFTYPE_AP &&
 	    vif->type != NL80211_IFTYPE_AP_VLAN)
-- 
1.7.3.4

