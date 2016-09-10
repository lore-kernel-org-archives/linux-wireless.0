Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:33366 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751618AbcIJTdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Sep 2016 15:33:31 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Michal Kazior <michal.kazior@tieto.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH] mac80211: Dynamically set CoDel parameters per station.
Date: Sat, 10 Sep 2016 21:33:15 +0200
Message-Id: <20160910193315.30738-1-toke@toke.dk> (sfid-20160910_213335_452175_92ECE3F1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CoDel can be too aggressive if a station sends at a very low rate,
leading to starvation. This gets worse the more stations are present, as
each station gets more bursty the longer the round-robin scheduling
between stations takes.

This adds dynamic adjustment of CoDel parameters per station. It uses
the rate selection information to estimate throughput and sets more
lenient CoDel parameters if the estimated throughput is below a
threshold. To not change parameters too often, a hysteresis of two
seconds is added.

A new callback is added that drivers can use to notify mac80211 about
changes in expected throughput, so the same adjustment can be made for
cards that implement rate control in firmware. Drivers that don't use
this will just get the default parameters.

The threshold used and the CoDel parameters set for slow stations are
chosen to err on the side of caution. I.e. rather be too lenient than
too aggressive. A better algorithm can then be added later.

Cc: Michal Kazior <michal.kazior@tieto.com>
Cc: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
 include/net/mac80211.h  | 17 +++++++++++++++++
 net/mac80211/rate.c     |  2 ++
 net/mac80211/sta_info.c | 35 +++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h | 12 ++++++++++++
 net/mac80211/tx.c       |  9 ++++++++-
 5 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cca510a..6e0cf85 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4089,6 +4089,23 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *=
vif,
 			    int max_rates);
=20
 /**
+ * ieee80211_sta_set_expected_throughput - set the expected throughput f=
or a
+ * station
+ *
+ * Call this function to notify mac80211 about a change in expected thro=
ughput
+ * to a station. A driver for a device that does rate control in firmwar=
e can
+ * call this function when the expected throughput estimate towards a st=
ation
+ * changes. The information is used to tune the CoDel AQM applied to tra=
ffic
+ * going towards that station (which can otherwise be too aggressive and=
 cause
+ * slow stations to starve).
+ *
+ * @sta: the station to set throughput for.
+ * @thr: the current expected throughput in kbps.
+ */
+void ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
+					   u32 thr);
+
+/**
  * ieee80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 206698b..5370f5c 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -890,6 +890,8 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
=20
 	drv_sta_rate_tbl_update(hw_to_local(hw), sta->sdata, pubsta);
=20
+	sta_update_codel_params(sta, sta_get_expected_throughput(sta));
+
 	return 0;
 }
 EXPORT_SYMBOL(rate_control_set_rates);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 19f14c9..6deda4a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -20,6 +20,7 @@
 #include <linux/timer.h>
 #include <linux/rtnetlink.h>
=20
+#include <net/codel.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
@@ -419,6 +420,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_=
if_data *sdata,
=20
 	sta->sta.max_rc_amsdu_len =3D IEEE80211_MAX_MPDU_LEN_HT_BA;
=20
+	sta_update_codel_params(sta, 0);
+
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
=20
 	return sta;
@@ -2306,6 +2309,15 @@ u32 sta_get_expected_throughput(struct sta_info *s=
ta)
 	return thr;
 }
=20
+void ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
+					   u32 thr)
+{
+	struct sta_info *sta =3D container_of(pubsta, struct sta_info, sta);
+
+	sta_update_codel_params(sta, thr);
+}
+EXPORT_SYMBOL(ieee80211_sta_set_expected_throughput);
+
 unsigned long ieee80211_sta_last_active(struct sta_info *sta)
 {
 	struct ieee80211_sta_rx_stats *stats =3D sta_get_last_rx_stats(sta);
@@ -2314,3 +2326,26 @@ unsigned long ieee80211_sta_last_active(struct sta=
_info *sta)
 		return stats->last_rx;
 	return sta->status_stats.last_ack;
 }
+
+void sta_update_codel_params(struct sta_info *sta, u32 thr)
+{
+	u64 now =3D ktime_get_ns();
+
+	if (!sta->sdata->local->ops->wake_tx_queue)
+		return;
+
+	if (now - sta->cparams.update_time < STA_CPARAMS_HYSTERESIS)
+		return;
+
+	if (thr && thr < STA_SLOW_THRESHOLD) {
+		sta->cparams.params.target =3D MS2TIME(50);
+		sta->cparams.params.interval =3D MS2TIME(300);
+		sta->cparams.params.ecn =3D false;
+	} else {
+		sta->cparams.params.target =3D MS2TIME(20);
+		sta->cparams.params.interval =3D MS2TIME(100);
+		sta->cparams.params.ecn =3D true;
+	}
+	sta->cparams.params.ce_threshold =3D CODEL_DISABLED_THRESHOLD;
+	sta->cparams.update_time =3D now;
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 0556be3..ad088ff 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -384,6 +384,14 @@ struct ieee80211_sta_rx_stats {
 	u64 msdu[IEEE80211_NUM_TIDS + 1];
 };
=20
+#define STA_CPARAMS_HYSTERESIS (2L * NSEC_PER_SEC)
+#define STA_SLOW_THRESHOLD     8000 /* 8 Mbps */
+
+struct sta_codel_params {
+	struct codel_params params;
+	u64 update_time;
+};
+
 /**
  * struct sta_info - STA information
  *
@@ -437,6 +445,7 @@ struct ieee80211_sta_rx_stats {
  * @known_smps_mode: the smps_mode the client thinks we are in. Relevant=
 for
  *	AP only.
  * @cipher_scheme: optional cipher scheme for this station
+ * @cparams: CoDel parameters for this station.
  * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERV=
ED)
  * @fast_tx: TX fastpath information
  * @fast_rx: RX fastpath information
@@ -540,6 +549,8 @@ struct sta_info {
 	enum ieee80211_smps_mode known_smps_mode;
 	const struct ieee80211_cipher_scheme *cipher_scheme;
=20
+	struct sta_codel_params cparams;
+
 	u8 reserved_tid;
=20
 	struct cfg80211_chan_def tdls_chandef;
@@ -713,6 +724,7 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo);
=20
 u32 sta_get_expected_throughput(struct sta_info *sta);
+void sta_update_codel_params(struct sta_info *sta, u32 thr);
=20
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index efc38e7..ec60ac1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1342,9 +1342,16 @@ static struct sk_buff *fq_tin_dequeue_func(struct =
fq *fq,
=20
 	local =3D container_of(fq, struct ieee80211_local, fq);
 	txqi =3D container_of(tin, struct txq_info, tin);
-	cparams =3D &local->cparams;
 	cstats =3D &local->cstats;
=20
+	if (txqi->txq.sta) {
+		struct sta_info *sta =3D container_of(txqi->txq.sta,
+						    struct sta_info, sta);
+		cparams =3D &sta->cparams.params;
+	} else {
+		cparams =3D &local->cparams;
+	}
+
 	if (flow =3D=3D &txqi->def_flow)
 		cvars =3D &txqi->def_cvars;
 	else
--=20
2.9.3

base-commit: abc3750c31320f36e230f88b235a90e0a35f7032
