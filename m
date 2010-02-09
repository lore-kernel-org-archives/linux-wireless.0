Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36119 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0BIGFR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 01:05:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 22:05:17 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2 v4] mac80211: Retry null data frame for power save.
Date: Tue, 9 Feb 2010 11:34:49 +0530
Message-ID: <1265695490-3004-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even if the null data frame is not acked by the AP, mac80211
goes into power save. This might lead to loss of frames
from the AP.
Prevent this by restarting dynamic_ps_timer when ack is not
received for null data frames.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 include/net/mac80211.h     |    6 ++++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   20 +++++++++++++++-----
 net/mac80211/status.c      |   16 ++++++++++++++--
 4 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 414d774..314e981 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -945,6 +945,11 @@ enum ieee80211_tkip_key_type {
  *	Hardware supports Unscheduled Automatic Power Save Delivery
  *	(U-APSD) in managed mode. The mode is configured with
  *	conf_tx() operation.
+ *
+ * @IEEE80211_HW_REPORTS_TX_ACK_STATUS:
+ *	Hardware can provide ack status reports of Tx frames to
+ *	the stack.
+ *
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -965,6 +970,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
+	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a591119..9dd98b6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -316,6 +316,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_CSA_RECEIVED	= BIT(5),
 	IEEE80211_STA_MFP_ENABLED	= BIT(6),
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
+	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 };
 
 struct ieee80211_if_managed {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7a79214..ee9443d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -434,8 +434,11 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 	} else {
 		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
 			ieee80211_send_nullfunc(local, sdata, 1);
-		conf->flags |= IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+
+		if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
+			conf->flags |= IEEE80211_CONF_PS;
+			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		}
 	}
 }
 
@@ -541,6 +544,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		container_of(work, struct ieee80211_local,
 			     dynamic_ps_enable_work);
 	struct ieee80211_sub_if_data *sdata = local->ps_sdata;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/* can only happen when PS was just disabled anyway */
 	if (!sdata)
@@ -549,11 +553,16 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	if (local->hw.conf.flags & IEEE80211_CONF_PS)
 		return;
 
-	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
+	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)))
 		ieee80211_send_nullfunc(local, sdata, 1);
 
-	local->hw.conf.flags |= IEEE80211_CONF_PS;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) ||
+	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
+		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+		local->hw.conf.flags |= IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
 }
 
 void ieee80211_dynamic_ps_timer(unsigned long data)
@@ -1892,6 +1901,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		return -ENOMEM;
 
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
+	ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 
 	for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
 		if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e57ad6b..c647556 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -188,6 +188,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	rcu_read_lock();
 
 	sband = local->hw.wiphy->bands[info->band];
+	fc = hdr->frame_control;
 
 	for_each_sta_info(local, hdr->addr1, sta, tmp) {
 		/* skip wrong virtual interface */
@@ -205,8 +206,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			return;
 		}
 
-		fc = hdr->frame_control;
-
 		if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
 		    (ieee80211_is_data_qos(fc))) {
 			u16 tid, ssn;
@@ -275,6 +274,19 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			local->dot11FailedCount++;
 	}
 
+	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
+		(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
+		local->ps_sdata && !(local->scanning)) {
+		if (info->flags & IEEE80211_TX_STAT_ACK) {
+			local->ps_sdata->u.mgd.flags |=
+					IEEE80211_STA_NULLFUNC_ACKED;
+			ieee80211_queue_work(&local->hw,
+					 &local->dynamic_ps_enable_work);
+		} else
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+					msecs_to_jiffies(10));
+	}
+
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);
 
-- 
1.6.6.1

