Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33986 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2K0TBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 14:01:51 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC 2/3] mac80211: add spectral_scan function, hook it up in scanning
Date: Tue, 27 Nov 2012 20:01:23 +0100
Message-Id: <1354042885-32688-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121127_200201_261471_A0FC31CA)
In-Reply-To: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add spectral_scan function to driver functions, and hook it up
in the scanning code.

Using the spectral scan from within the scan function has the charme
that it already does all the channel surfing for us.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/mac80211.h    |    6 ++++++
 net/mac80211/driver-ops.h |   10 ++++++++++
 net/mac80211/scan.c       |    3 +++
 net/mac80211/trace.h      |    5 +++++
 4 files changed, 24 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e1293c7..8104b7d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2428,6 +2428,10 @@ enum ieee80211_rate_control_changed {
  * @restart_complete: Called after a call to ieee80211_restart_hw(), when the
  *	reconfiguration has completed. This can help the driver implement the
  *	reconfiguration step. This callback may sleep.
+ *
+ * @spectral_scan: Asks the driver to perform a spectral scan on the currently
+ *      selected channel. Results are stored in the drivers internal structures
+ *      currently.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2602,6 +2606,8 @@ struct ieee80211_ops {
 				     struct ieee80211_chanctx_conf *ctx);
 
 	void (*restart_complete)(struct ieee80211_hw *hw);
+
+	void	(*spectral_scan)(struct ieee80211_hw *hw);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 68c27aa..df6d582 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1004,4 +1004,14 @@ static inline void drv_restart_complete(struct ieee80211_local *local)
 	trace_drv_return_void(local);
 }
 
+static inline void drv_spectral_scan(struct ieee80211_local *local)
+{
+	might_sleep();
+
+	trace_drv_spectral_scan(local);
+	if (local->ops->spectral_scan)
+		local->ops->spectral_scan(&local->hw);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8e9bb168..cd8a17b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -665,6 +665,9 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 		return;
 	}
 
+	if (local->scan_req->spec_scan && local->ops->spectral_scan)
+		drv_spectral_scan(local);
+
 	/*
 	 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
 	 * (which unfortunately doesn't say _why_ step a) is done,
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index e9579b7..7efd325 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1421,6 +1421,11 @@ DEFINE_EVENT(local_only_evt, drv_restart_complete,
 	TP_ARGS(local)
 );
 
+DEFINE_EVENT(local_only_evt, drv_spectral_scan,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.7.10.4

