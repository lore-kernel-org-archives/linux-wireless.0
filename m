Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48484 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbZCPKJO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 06:09:14 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 03:09:13 -0700
Message-ID: <18878.9292.503830.420780@gargle.gargle.HOWL> (sfid-20090316_110917_924435_02930279)
Date: Mon, 16 Mar 2009 15:35:00 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
From: Sujith <Sujith.Manoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<Jouni.Malinen@Atheros.com>, <me@bobcopeland.com>
Subject: [PATCH v2] mac80211: Tear down aggregation sessions for suspend/resume
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver has been notified with a STA_REMOVE, it tears down
the internal ADDBA state. On resume, trying to initiate aggregation would
fail because mac80211 has not cleared the operational state for that <TID,STA>.
This can be fixed by tearing down the existing sessions on a suspend.

Also, the driver can initiate a new BA session when suspend is in progress.
This is fixed by marking the station as being in suspend state and
denying ADDBA requests for such STAs.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---

(SMTP borkage, try again)

v2:
--
* Deny ADDBA requests if suspend is in progress.

 net/mac80211/agg-rx.c   |    8 ++++++++
 net/mac80211/agg-tx.c   |    9 +++++++++
 net/mac80211/pm.c       |   15 +++++++++++++++
 net/mac80211/sta_info.h |    3 +++
 4 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index a95affc..07656d8 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -197,6 +197,14 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 
 	status = WLAN_STATUS_REQUEST_DECLINED;
 
+	if (test_sta_flags(sta, WLAN_STA_SUSPEND)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Suspend in progress. "
+		       "Denying ADDBA request\n");
+#endif
+		goto end_no_lock;
+	}
+
 	/* sanity check for incoming parameters:
 	 * check if configuration can support the BA policy
 	 * and if buffer size does not exceeds max value */
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 1df116d..e5776ef 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -257,6 +257,15 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		goto unlock;
 	}
 
+	if (test_sta_flags(sta, WLAN_STA_SUSPEND)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Suspend in progress. "
+		       "Denying BA session request\n");
+#endif
+		ret = -EINVAL;
+		goto unlock;
+	}
+
 	spin_lock_bh(&sta->lock);
 
 	sdata = sta->sdata;
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index f845601..07929fb 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -21,6 +21,14 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	list_for_each_entry(sdata, &local->interfaces, list)
 		ieee80211_disable_keys(sdata);
 
+	/* Tear down aggregation sessions */
+	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		list_for_each_entry(sta, &local->sta_list, list) {
+			set_sta_flags(sta, WLAN_STA_SUSPEND);
+			ieee80211_sta_tear_down_BA_sessions(sta);
+		}
+	}
+
 	/* remove STAs */
 	if (local->ops->sta_notify) {
 		spin_lock_irqsave(&local->sta_lock, flags);
@@ -102,6 +110,13 @@ int __ieee80211_resume(struct ieee80211_hw *hw)
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 	}
 
+	/* Clear Suspend state so that ADDBA requests can be processed */
+	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		list_for_each_entry(sta, &local->sta_list, list) {
+			clear_sta_flags(sta, WLAN_STA_SUSPEND);
+		}
+	}
+
 	/* add back keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
 		if (netif_running(sdata->dev))
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 1f45573..5b223b2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -35,6 +35,8 @@
  *	IEEE80211_TX_CTL_CLEAR_PS_FILT control flag) when the next
  *	frame to this station is transmitted.
  * @WLAN_STA_MFP: Management frame protection is used with this STA.
+ * @WLAN_STA_SUSPEND: Set/cleared during a suspend/resume cycle.
+ *	Used to deny ADDBA requests (both TX and RX).
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -48,6 +50,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PSPOLL		= 1<<8,
 	WLAN_STA_CLEAR_PS_FILT	= 1<<9,
 	WLAN_STA_MFP		= 1<<10,
+	WLAN_STA_SUSPEND	= 1<<11
 };
 
 #define STA_TID_NUM 16
-- 
1.6.2

