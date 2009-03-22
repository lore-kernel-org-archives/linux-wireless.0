Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51756 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZCVT5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 15:57:43 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v4 3/5] mac80211: disable power save when scanning
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 22 Mar 2009 21:57:21 +0200
Message-ID: <20090322195720.26460.66178.stgit@tikku> (sfid-20090322_205745_396808_1034067F)
In-Reply-To: <20090322195619.26460.48292.stgit@tikku>
References: <20090322195619.26460.48292.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

When software scanning we need to disable power save so that all possible
probe responses and beacons are received. For hardware scanning assume that
hardware will take care of that and document that assumption.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 include/net/mac80211.h |   12 +++++----
 net/mac80211/scan.c    |   64 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index daa539a..174dc1d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1307,11 +1307,13 @@ enum ieee80211_ampdu_mlme_action {
  *
  * @hw_scan: Ask the hardware to service the scan request, no need to start
  *	the scan state machine in stack. The scan must honour the channel
- *	configuration done by the regulatory agent in the wiphy's registered
- *	bands. When the scan finishes, ieee80211_scan_completed() must be
- *	called; note that it also must be called when the scan cannot finish
- *	because the hardware is turned off! Anything else is a bug!
- *	Returns a negative error code which will be seen in userspace.
+ *	configuration done by the regulatory agent in the wiphy's
+ *	registered bands. The hardware (or the driver) needs to make sure
+ *	that power save is disabled. When the scan finishes,
+ *	ieee80211_scan_completed() must be called; note that it also must
+ *	be called when the scan cannot finish because the hardware is
+ *	turned off! Anything else is a bug! Returns a negative error code
+ *	which will be seen in userspace.
  *
  * @sw_scan_start: Notifier function that is called just before a software scan
  *	is started. Can be NULL, if the driver doesn't need this notification.
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 46f35dc..3bf9839 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -214,6 +214,66 @@ void ieee80211_scan_failed(struct ieee80211_local *local)
 	local->scan_req = NULL;
 }
 
+/*
+ * inform AP that we will go to sleep so that it will buffer the frames
+ * while we scan
+ */
+static void ieee80211_scan_ps_enable(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	bool ps = false;
+
+	/* FIXME: what to do when local->pspolling is true? */
+
+	del_timer_sync(&local->dynamic_ps_timer);
+	cancel_work_sync(&local->dynamic_ps_enable_work);
+
+	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+		ps = true;
+		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+
+	if (!ps || !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
+		/*
+		 * If power save was enabled, no need to send a nullfunc
+		 * frame because AP knows that we are sleeping. But if the
+		 * hardware is creating the nullfunc frame for power save
+		 * status (ie. IEEE80211_HW_PS_NULLFUNC_STACK is not
+		 * enabled) and power save was enabled, the firmware just
+		 * sent a null frame with power save disabled. So we need
+		 * to send a new nullfunc frame to inform the AP that we
+		 * are again sleeping.
+		 */
+		ieee80211_send_nullfunc(local, sdata, 1);
+}
+
+/* inform AP that we are awake again, unless power save is enabled */
+static void ieee80211_scan_ps_disable(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	if (!local->powersave)
+		ieee80211_send_nullfunc(local, sdata, 0);
+	else {
+		/*
+		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
+		 * will send a nullfunc frame with the powersave bit set
+		 * even though the AP already knows that we are sleeping.
+		 * This could be avoided by sending a null frame with power
+		 * save bit disabled before enabling the power save, but
+		 * this doesn't gain anything.
+		 *
+		 * When IEEE80211_HW_PS_NULLFUNC_STACK is enabled, no need
+		 * to send a nullfunc frame because AP already knows that
+		 * we are sleeping, let's just enable power save mode in
+		 * hardware.
+		 */
+		local->hw.conf.flags |= IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+}
+
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -268,7 +328,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 		/* Tell AP we're back */
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED) {
-				ieee80211_send_nullfunc(local, sdata, 0);
+				ieee80211_scan_ps_disable(sdata);
 				netif_tx_wake_all_queues(sdata->dev);
 			}
 		} else
@@ -441,7 +501,7 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED) {
 				netif_tx_stop_all_queues(sdata->dev);
-				ieee80211_send_nullfunc(local, sdata, 1);
+				ieee80211_scan_ps_enable(sdata);
 			}
 		} else
 			netif_tx_stop_all_queues(sdata->dev);

