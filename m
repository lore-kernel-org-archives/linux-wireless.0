Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49383 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1KALLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 07:11:03 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix lockdep warning
Date: Tue, 1 Nov 2011 16:38:50 +0530
Message-ID: <1320145730-3007-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111101_121108_246616_DD442597)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following is the lockdep warning which detects possible
deadlock condition with the way ar->lock and ar->list_lock
are being used.

  (&(&ar->lock)->rlock){+.-...}, at: [<ffffffffa0492d13>] ath6kl_indicate_tx_activity+0x83/0x110 [ath6kl]
 but this lock took another, SOFTIRQ-unsafe lock in the past:
  (&(&ar->list_lock)->rlock){+.+...}

 and interrupts could create inverse lock ordering between them.

 other info that might help us debug this:
  Possible interrupt unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&(&ar->list_lock)->rlock);
                                local_irq_disable();
                                lock(&(&ar->lock)->rlock);
                                lock(&(&ar->list_lock)->rlock);
   <Interrupt>
     lock(&(&ar->lock)->rlock);

  *** DEADLOCK ***

softirqs have to be disabled when acquiring ar->list_lock to avoid
the above deadlock condition. When the above warning printed the
interface is still up and running without issue.

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++----
 drivers/net/wireless/ath/ath6kl/init.c     |    8 ++++----
 drivers/net/wireless/ath/ath6kl/main.c     |    6 +++---
 drivers/net/wireless/ath/ath6kl/txrx.c     |   14 +++++++-------
 drivers/net/wireless/ath/ath6kl/wmi.c      |    4 ++--
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 994c646..7dd5c49 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1324,9 +1324,9 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 	struct ath6kl *ar = wiphy_priv(wiphy);
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 
-	spin_lock(&ar->list_lock);
+	spin_lock_bh(&ar->list_lock);
 	list_del(&vif->list);
-	spin_unlock(&ar->list_lock);
+	spin_unlock_bh(&ar->list_lock);
 
 	ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
 
@@ -2302,9 +2302,9 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	if (type == NL80211_IFTYPE_ADHOC)
 		ar->ibss_if_active = true;
 
-	spin_lock(&ar->list_lock);
+	spin_lock_bh(&ar->list_lock);
 	list_add_tail(&vif->list, &ar->vif_list);
-	spin_unlock(&ar->list_lock);
+	spin_unlock_bh(&ar->list_lock);
 
 	return ndev;
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index a0b81c3..4dd5812 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1706,17 +1706,17 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 		return;
 	}
 
-	spin_lock(&ar->list_lock);
+	spin_lock_bh(&ar->list_lock);
 	list_for_each_entry_safe(vif, tmp_vif, &ar->vif_list, list) {
 		list_del(&vif->list);
-		spin_unlock(&ar->list_lock);
+		spin_unlock_bh(&ar->list_lock);
 		ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
 		rtnl_lock();
 		ath6kl_deinit_if_data(vif);
 		rtnl_unlock();
-		spin_lock(&ar->list_lock);
+		spin_lock_bh(&ar->list_lock);
 	}
-	spin_unlock(&ar->list_lock);
+	spin_unlock_bh(&ar->list_lock);
 
 	clear_bit(WMI_READY, &ar->flag);
 
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 3b2a7e8..20694b5 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1096,15 +1096,15 @@ struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar)
 {
 	struct ath6kl_vif *vif;
 
-	spin_lock(&ar->list_lock);
+	spin_lock_bh(&ar->list_lock);
 	if (list_empty(&ar->vif_list)) {
-		spin_unlock(&ar->list_lock);
+		spin_unlock_bh(&ar->list_lock);
 		return NULL;
 	}
 
 	vif = list_first_entry(&ar->vif_list, struct ath6kl_vif, list);
 
-	spin_unlock(&ar->list_lock);
+	spin_unlock_bh(&ar->list_lock);
 
 	return vif;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 9dfd7f5..06e4912 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -470,10 +470,10 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 
 stop_adhoc_netq:
 	/* FIXME: Locking */
-	spin_lock(&ar->list_lock);
+	spin_lock_bh(&ar->list_lock);
 	list_for_each_entry(vif, &ar->vif_list, list) {
 		if (vif->nw_type == ADHOC_NETWORK) {
-			spin_unlock(&ar->list_lock);
+			spin_unlock_bh(&ar->list_lock);
 
 			spin_lock_bh(&vif->if_lock);
 			set_bit(NETQ_STOPPED, &vif->flags);
@@ -483,7 +483,7 @@ stop_adhoc_netq:
 			return action;
 		}
 	}
-	spin_unlock(&ar->list_lock);
+	spin_unlock_bh(&ar->list_lock);
 
 	return action;
 }
@@ -637,16 +637,16 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 	__skb_queue_purge(&skb_queue);
 
 	/* FIXME: Locking */
-	spin_lock(&ar->list_lock);
+	spin_lock_bh(&ar->list_lock);
 	list_for_each_entry(vif, &ar->vif_list, list) {
 		if (test_bit(CONNECTED, &vif->flags) &&
 		    !flushing[vif->fw_vif_idx]) {
-			spin_unlock(&ar->list_lock);
+			spin_unlock_bh(&ar->list_lock);
 			netif_wake_queue(vif->ndev);
-			spin_lock(&ar->list_lock);
+			spin_lock_bh(&ar->list_lock);
 		}
 	}
-	spin_unlock(&ar->list_lock);
+	spin_unlock_bh(&ar->list_lock);
 
 	if (wake_event)
 		wake_up(&ar->event_wq);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index d3db5b3..ece67a5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -89,14 +89,14 @@ struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx)
 		return NULL;
 
 	/* FIXME: Locking */
-	spin_lock(&ar->list_lock);
+	spin_lock_bh(&ar->list_lock);
 	list_for_each_entry(vif, &ar->vif_list, list) {
 		if (vif->fw_vif_idx == if_idx) {
 			found = vif;
 			break;
 		}
 	}
-	spin_unlock(&ar->list_lock);
+	spin_unlock_bh(&ar->list_lock);
 
 	return found;
 }
-- 
1.7.0.4

