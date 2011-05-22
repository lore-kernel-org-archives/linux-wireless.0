Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58855 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1EVKsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 06:48:05 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: revert usage of kfree_rcu
Date: Sun, 22 May 2011 12:47:07 +0200
Message-Id: <1306061227-4159-3-git-send-email-hauke@hauke-m.de> (sfid-20110522_124809_788912_0D78F51D)
In-Reply-To: <1306061227-4159-1-git-send-email-hauke@hauke-m.de>
References: <1306061227-4159-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Backporting kfree_rcu() in compat does not work as
struct rcu_head->func is always interpreted as a pointer in older
kernel versions, but when using kfree_rcu() it is set to an offset.
rcu_head->func is used in some functions in the kernel not backported
by compat-wireless.

This patch is based on the patch posted by Ignacy Gawedzki <i@lri.fr>
on the mailing list.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/41-no-kfree-rcu.patch |   83 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 patches/41-no-kfree-rcu.patch

diff --git a/patches/41-no-kfree-rcu.patch b/patches/41-no-kfree-rcu.patch
new file mode 100644
index 0000000..1c50d38
--- /dev/null
+++ b/patches/41-no-kfree-rcu.patch
@@ -0,0 +1,83 @@
+--- a/net/mac80211/agg-tx.c
++++ b/net/mac80211/agg-tx.c
+@@ -144,6 +144,16 @@ void ieee80211_assign_tid_tx(struct sta_
+ 	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
+ }
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40))
++static void kfree_tid_tx(struct rcu_head *rcu_head)
++{
++	struct tid_ampdu_tx *tid_tx =
++	    container_of(rcu_head, struct tid_ampdu_tx, rcu_head);
++
++	kfree(tid_tx);
++}
++#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) */
++
+ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
+ 				    enum ieee80211_back_parties initiator,
+ 				    bool tx)
+@@ -166,7 +176,11 @@ int ___ieee80211_stop_tx_ba_session(stru
+ 		/* not even started yet! */
+ 		ieee80211_assign_tid_tx(sta, tid, NULL);
+ 		spin_unlock_bh(&sta->lock);
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,40))
+ 		kfree_rcu(tid_tx, rcu_head);
++#else
++		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
++#endif
+ 		return 0;
+ 	}
+ 
+@@ -325,7 +339,11 @@ void ieee80211_tx_ba_session_handle_star
+ 		spin_unlock_bh(&sta->lock);
+ 
+ 		ieee80211_wake_queue_agg(local, tid);
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,40))
+ 		kfree_rcu(tid_tx, rcu_head);
++#else
++		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
++#endif
+ 		return;
+ 	}
+ 
+@@ -710,7 +728,11 @@ void ieee80211_stop_tx_ba_cb(struct ieee
+ 
+ 	ieee80211_agg_splice_finish(local, tid);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,40))
+ 	kfree_rcu(tid_tx, rcu_head);
++#else
++	call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
++#endif
+ 
+  unlock_sta:
+ 	spin_unlock_bh(&sta->lock);
+--- a/net/mac80211/work.c
++++ b/net/mac80211/work.c
+@@ -65,10 +65,25 @@ static void run_again(struct ieee80211_l
+ 		mod_timer(&local->work_timer, timeout);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,40))
+ void free_work(struct ieee80211_work *wk)
+ {
+ 	kfree_rcu(wk, rcu_head);
+ }
++#else
++static void work_free_rcu(struct rcu_head *head)
++{
++	struct ieee80211_work *wk =
++		container_of(head, struct ieee80211_work, rcu_head);
++
++	kfree(wk);
++}
++
++void free_work(struct ieee80211_work *wk)
++{
++	call_rcu(&wk->rcu_head, work_free_rcu);
++}
++#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) */
+ 
+ static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
+ 				      struct ieee80211_supported_band *sband,
-- 
1.7.4.1

