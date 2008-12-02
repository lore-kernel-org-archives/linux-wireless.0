Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43912 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYLBUES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:04:18 -0500
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx03.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mB2K1Dkc005633
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:04:16 +0200
Received: from [127.0.1.1] (essapo-nirac253161.europe.nokia.com [10.162.253.161])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mB2K4DRW016237
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:04:13 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v4 3/5] mac80211: add IEEE80211_HW_NO_DYNAMIC_PS flag
To: linux-wireless@vger.kernel.org
Date: Tue, 02 Dec 2008 22:04:12 +0200
Message-ID: <20081202200412.5507.63993.stgit@tikku> (sfid-20081202_210421_679598_BAB165DB)
In-Reply-To: <20081202200219.5507.83250.stgit@tikku>
References: <20081202200219.5507.83250.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 include/net/mac80211.h |    5 +++++
 net/mac80211/tx.c      |    3 ++-
 net/mac80211/wext.c    |    3 ++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6a1d4ea..89affd8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -846,6 +846,10 @@ enum ieee80211_tkip_key_type {
  *
  * @IEEE80211_HW_AMPDU_AGGREGATION:
  *	Hardware supports 11n A-MPDU aggregation.
+ *
+ * @IEEE80211_HW_NO_DYNAMIC_PS:
+ *	Hardware which don't have dynamic power save support, meaning
+ *	that power save is enabled in idle periods.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
@@ -858,6 +862,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_NOISE_DBM				= 1<<8,
 	IEEE80211_HW_SPECTRUM_MGMT			= 1<<9,
 	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<10,
+	IEEE80211_HW_NO_DYNAMIC_PS			= 1<<11,
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 60cbc28..9444a06 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1476,7 +1476,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		goto fail;
 	}
 
-	if (local->dynamic_ps_timeout > 0) {
+	if ((local->hw.flags & IEEE80211_HW_NO_DYNAMIC_PS) &&
+	    local->dynamic_ps_timeout > 0) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			netif_tx_stop_all_queues(local->mdev);
 			queue_work(local->hw.workqueue,
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 8815858..a666ced 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -989,7 +989,8 @@ set:
 		return ret;
 
 	if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
-		if (local->dynamic_ps_timeout > 0)
+		if ((local->hw.flags & IEEE80211_HW_NO_DYNAMIC_PS) &&
+		    local->dynamic_ps_timeout > 0)
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(local->dynamic_ps_timeout));
 		else {

