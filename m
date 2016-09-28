Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50850 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753180AbcI1Mtb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 08:49:31 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8SCnV3G022030
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:49:31 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 25r7vna8rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:49:30 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/8] mwifiex: Fix NULL pointer dereference in skb_dequeue()
Date: Wed, 28 Sep 2016 18:18:23 +0530
Message-ID: <1475066908-11771-3-git-send-email-akarwar@marvell.com> (sfid-20160928_144934_845789_DA74FF51)
In-Reply-To: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
References: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At couple of places in cleanup path, we are just going through the
skb queue and freeing them without unlinking. This leads to a crash
when other thread tries to do skb_dequeue() and use already freed node.

The problem is freed by unlinking skb before freeing it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |  4 +++-
 drivers/net/wireless/marvell/mwifiex/wmm.c      | 12 +++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 39ce76a..e83861f 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3070,8 +3070,10 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 	mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 
-	skb_queue_walk_safe(&priv->bypass_txq, skb, tmp)
+	skb_queue_walk_safe(&priv->bypass_txq, skb, tmp) {
+		skb_unlink(skb, &priv->bypass_txq);
 		mwifiex_write_data_complete(priv->adapter, skb, 0, -1);
+	}
 
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index 0eb2465..dea2fe6 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -503,8 +503,10 @@ mwifiex_wmm_del_pkts_in_ralist_node(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct sk_buff *skb, *tmp;
 
-	skb_queue_walk_safe(&ra_list->skb_head, skb, tmp)
+	skb_queue_walk_safe(&ra_list->skb_head, skb, tmp) {
+		skb_unlink(skb, &ra_list->skb_head);
 		mwifiex_write_data_complete(adapter, skb, 0, -1);
+	}
 }
 
 /*
@@ -600,11 +602,15 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 		priv->adapter->if_ops.clean_pcie_ring(priv->adapter);
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 
-	skb_queue_walk_safe(&priv->tdls_txq, skb, tmp)
+	skb_queue_walk_safe(&priv->tdls_txq, skb, tmp) {
+		skb_unlink(skb, &priv->tdls_txq);
 		mwifiex_write_data_complete(priv->adapter, skb, 0, -1);
+	}
 
-	skb_queue_walk_safe(&priv->bypass_txq, skb, tmp)
+	skb_queue_walk_safe(&priv->bypass_txq, skb, tmp) {
+		skb_unlink(skb, &priv->bypass_txq);
 		mwifiex_write_data_complete(priv->adapter, skb, 0, -1);
+	}
 	atomic_set(&priv->adapter->bypass_tx_pending, 0);
 
 	idr_for_each(&priv->ack_status_frames, mwifiex_free_ack_frame, NULL);
-- 
1.9.1
