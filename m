Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43479 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1KQVXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:23:52 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: remove kfree_rcu() patch
Date: Thu, 17 Nov 2011 22:23:40 +0100
Message-Id: <1321565021-7290-2-git-send-email-hauke@hauke-m.de> (sfid-20111117_222355_468600_CD133529)
In-Reply-To: <1321565021-7290-1-git-send-email-hauke@hauke-m.de>
References: <1321565021-7290-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kfree_rcu() is now backported in compat, this patch is not needed any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/41-no-kfree-rcu.patch |   83 -----------------------------------------
 1 files changed, 0 insertions(+), 83 deletions(-)
 delete mode 100644 patches/41-no-kfree-rcu.patch

diff --git a/patches/41-no-kfree-rcu.patch b/patches/41-no-kfree-rcu.patch
deleted file mode 100644
index 0f71223..0000000
--- a/patches/41-no-kfree-rcu.patch
+++ /dev/null
@@ -1,83 +0,0 @@
---- a/net/mac80211/agg-tx.c
-+++ b/net/mac80211/agg-tx.c
-@@ -143,6 +143,16 @@ void ieee80211_assign_tid_tx(struct sta_
- 	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
- }
- 
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40))
-+static void kfree_tid_tx(struct rcu_head *rcu_head)
-+{
-+	struct tid_ampdu_tx *tid_tx =
-+	    container_of(rcu_head, struct tid_ampdu_tx, rcu_head);
-+
-+	kfree(tid_tx);
-+}
-+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) */
-+
- int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
- 				    enum ieee80211_back_parties initiator,
- 				    bool tx)
-@@ -165,7 +175,11 @@ int ___ieee80211_stop_tx_ba_session(stru
- 		/* not even started yet! */
- 		ieee80211_assign_tid_tx(sta, tid, NULL);
- 		spin_unlock_bh(&sta->lock);
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,40))
- 		kfree_rcu(tid_tx, rcu_head);
-+#else
-+		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
-+#endif
- 		return 0;
- 	}
- 
-@@ -324,7 +338,11 @@ void ieee80211_tx_ba_session_handle_star
- 		spin_unlock_bh(&sta->lock);
- 
- 		ieee80211_wake_queue_agg(local, tid);
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,40))
- 		kfree_rcu(tid_tx, rcu_head);
-+#else
-+		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
-+#endif
- 		return;
- 	}
- 
-@@ -700,7 +718,11 @@ void ieee80211_stop_tx_ba_cb(struct ieee
- 
- 	ieee80211_agg_splice_finish(local, tid);
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,40))
- 	kfree_rcu(tid_tx, rcu_head);
-+#else
-+	call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
-+#endif
- 
-  unlock_sta:
- 	spin_unlock_bh(&sta->lock);
---- a/net/mac80211/work.c
-+++ b/net/mac80211/work.c
-@@ -66,10 +66,25 @@ static void run_again(struct ieee80211_l
- 		mod_timer(&local->work_timer, timeout);
- }
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,40))
- void free_work(struct ieee80211_work *wk)
- {
- 	kfree_rcu(wk, rcu_head);
- }
-+#else
-+static void work_free_rcu(struct rcu_head *head)
-+{
-+	struct ieee80211_work *wk =
-+		container_of(head, struct ieee80211_work, rcu_head);
-+
-+	kfree(wk);
-+}
-+
-+void free_work(struct ieee80211_work *wk)
-+{
-+	call_rcu(&wk->rcu_head, work_free_rcu);
-+}
-+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) */
- 
- static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
- 				      struct ieee80211_supported_band *sband,
-- 
1.7.4.1

