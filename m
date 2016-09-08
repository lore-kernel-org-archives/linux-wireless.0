Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:44795 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751420AbcIHUAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 16:00:10 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Michal Kazior <michal.kazior@tieto.com>,
        Felix Fietkau <nbd@nbd.name>, Dave Taht <dave@taht.net>
Subject: [RFC] mac80211: Dynamically set CoDel parameters per station.
Date: Thu,  8 Sep 2016 21:59:15 +0200
Message-Id: <20160908195915.31478-1-toke@toke.dk> (sfid-20160908_220015_839744_5EE2B956)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CoDel can be too aggressive if a station sends at a very low rate. This
gets worse the more stations are present, as each station gets more
bursty the longer the round-robin scheduling between stations takes.

This is an attempt to dynamically adjust CoDel parameters per station.
It takes a rather simple approach and uses a simple binary designation
of a station as 'slow' if it has expected throughput less than eight
Mbps (i.e. the lowest couple of rates). In this case, CoDel is set to be
more lenient by adjusting its target to 50 ms and interval to 300 ms.
There's a built-in hysteresis so a station cannot flip between slow and
fast more than once every two seconds.

In this version the check is performed every time a packet is enqueued
to the intermediate queues; and the overhead of doing this is alleviated
a bit by caching the result and by the above-mentioned hysteresis. It
can probably be smarter about both when and how to do the scaling, but
this seems to alleviate some of the starvation I've seen with very slow
stations.

I'm not sure how this interacts with drivers that do rate-control in
firmware (such as ath10k). I assume they will just not be able to return
an expected rate (and so will be considered 'fast').

Cc: Michal Kazior <michal.kazior@tieto.com>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Dave Taht <dave@taht.net>
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
 net/mac80211/sta_info.c | 37 +++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h | 13 +++++++++++++
 net/mac80211/tx.c       | 14 +++++++++++++-
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 19f14c9..8bc9eba 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -20,6 +20,8 @@
 #include <linux/timer.h>
 #include <linux/rtnetlink.h>
=20
+#include <net/codel.h>
+#include <net/codel_impl.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
@@ -325,6 +327,10 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub=
_if_data *sdata,
 	INIT_WORK(&sta->drv_deliver_wk, sta_deliver_ps_frames);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
+
+	codel_params_init(&sta->cparams.cparams);
+	sta->cparams.cparams.ecn =3D true;
+
 #ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		sta->mesh =3D kzalloc(sizeof(*sta->mesh), gfp);
@@ -2314,3 +2320,34 @@ unsigned long ieee80211_sta_last_active(struct sta=
_info *sta)
 		return stats->last_rx;
 	return sta->status_stats.last_ack;
 }
+
+void sta_update_codel_params(struct sta_info *sta)
+{
+	u64 now =3D ktime_get_ns();
+	u32 thr;
+	bool slow;
+
+	if (likely(now - sta->cparams.update_time < STA_CPARAMS_HYSTERESIS))
+		return;
+
+	thr =3D sta_get_expected_throughput(sta);
+	slow =3D !!(thr && thr < STA_SLOW_THRESHOLD);
+
+	if (likely(slow =3D=3D sta->cparams.slow))
+		return;
+
+	net_info_ratelimited("%pM: updating CoDel params - throughput %d slow %=
s\n",
+			sta->addr, thr, slow ? "true" : "false");
+
+	if (slow) {
+		sta->cparams.cparams.target =3D MS2TIME(50);
+		sta->cparams.cparams.interval =3D MS2TIME(300);
+		sta->cparams.cparams.ecn =3D false;
+	} else {
+		sta->cparams.cparams.target =3D MS2TIME(5);
+		sta->cparams.cparams.interval =3D MS2TIME(100);
+		sta->cparams.cparams.ecn =3D true;
+	}
+	sta->cparams.update_time =3D now;
+	sta->cparams.slow =3D slow;
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 0556be3..928c52d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -384,6 +384,16 @@ struct ieee80211_sta_rx_stats {
 	u64 msdu[IEEE80211_NUM_TIDS + 1];
 };
=20
+#define STA_CPARAMS_HYSTERESIS 5 * NSEC_PER_SEC
+#define STA_SLOW_THRESHOLD 8000 /* 8 mbps */
+
+struct sta_codel_params {
+	struct codel_params cparams;
+	u64 update_time;
+	bool slow;
+};
+void sta_update_codel_params(struct sta_info *sta);
+
 /**
  * struct sta_info - STA information
  *
@@ -437,6 +447,7 @@ struct ieee80211_sta_rx_stats {
  * @known_smps_mode: the smps_mode the client thinks we are in. Relevant=
 for
  *	AP only.
  * @cipher_scheme: optional cipher scheme for this station
+ * @cparams: CoDel parameters for this station.
  * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERV=
ED)
  * @fast_tx: TX fastpath information
  * @fast_rx: RX fastpath information
@@ -540,6 +551,8 @@ struct sta_info {
 	enum ieee80211_smps_mode known_smps_mode;
 	const struct ieee80211_cipher_scheme *cipher_scheme;
=20
+	struct sta_codel_params cparams;
+
 	u8 reserved_tid;
=20
 	struct cfg80211_chan_def tdls_chandef;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index efc38e7..3973ab0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1339,12 +1339,19 @@ static struct sk_buff *fq_tin_dequeue_func(struct=
 fq *fq,
 	struct codel_vars *cvars;
 	struct codel_params *cparams;
 	struct codel_stats *cstats;
+	struct sta_info *sta;
=20
 	local =3D container_of(fq, struct ieee80211_local, fq);
 	txqi =3D container_of(tin, struct txq_info, tin);
-	cparams =3D &local->cparams;
 	cstats =3D &local->cstats;
=20
+	if (txqi->txq.sta) {
+		sta =3D container_of(txqi->txq.sta, struct sta_info, sta);
+		cparams =3D &sta->cparams.cparams;
+	} else
+		cparams =3D &local->cparams;
+
+
 	if (flow =3D=3D &txqi->def_flow)
 		cvars =3D &txqi->def_cvars;
 	else
@@ -1547,6 +1554,11 @@ static bool ieee80211_tx_frags(struct ieee80211_lo=
cal *local,
=20
 		txqi =3D ieee80211_get_txq(local, vif, sta, skb);
 		if (txqi) {
+			if (sta) {
+				struct sta_info *sti =3D container_of(sta, struct sta_info, sta);
+				sta_update_codel_params(sti);
+			}
+
 			info->control.vif =3D vif;
=20
 			__skb_unlink(skb, skbs);
--=20
2.9.3
