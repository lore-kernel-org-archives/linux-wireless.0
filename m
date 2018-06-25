Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47712 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754974AbeFYJnH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 05:43:07 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 1/2] mwifiex: replace rx_pkt_lock by rx_reorder_tbl_lock
Date: Mon, 25 Jun 2018 15:12:54 +0530
Message-ID: <1529919775-21274-1-git-send-email-gbhat@marvell.com> (sfid-20180625_114345_262069_D6C210D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At present driver spinlock protects iteration of list
rx_reorder_tbl_ptr with rx_reorder_tbl_lock. To protect the
individual items in this list, it uses rx_pkt_lock. But, we can
use a single rx_reorder_tbl_lock for both purposes. This patch
replaces rx_pkt_lock by rx_reorder_tbl_lock.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 19 ++++++++++---------
 drivers/net/wireless/marvell/mwifiex/init.c          |  1 -
 drivers/net/wireless/marvell/mwifiex/main.h          |  3 ---
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 7ab44cd..5380fba 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -118,18 +118,18 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 		      tbl->win_size;
 
 	for (i = 0; i < pkt_to_send; ++i) {
-		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
+		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 		rx_tmp_ptr = NULL;
 		if (tbl->rx_reorder_ptr[i]) {
 			rx_tmp_ptr = tbl->rx_reorder_ptr[i];
 			tbl->rx_reorder_ptr[i] = NULL;
 		}
-		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 		if (rx_tmp_ptr)
 			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
 	}
 
-	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	/*
 	 * We don't have a circular buffer, hence use rotation to simulate
 	 * circular buffer
@@ -140,7 +140,7 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 	}
 
 	tbl->start_win = start_win;
-	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 }
 
 /*
@@ -160,18 +160,19 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 	unsigned long flags;
 
 	for (i = 0; i < tbl->win_size; ++i) {
-		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
+		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 		if (!tbl->rx_reorder_ptr[i]) {
-			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
+					       flags);
 			break;
 		}
 		rx_tmp_ptr = tbl->rx_reorder_ptr[i];
 		tbl->rx_reorder_ptr[i] = NULL;
-		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
 	}
 
-	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	/*
 	 * We don't have a circular buffer, hence use rotation to simulate
 	 * circular buffer
@@ -184,7 +185,7 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 		}
 	}
 	tbl->start_win = (tbl->start_win + i) & (MAX_TID_VALUE - 1);
-	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 }
 
 /*
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index d239e92..dab02d7 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -439,7 +439,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
 			priv = adapter->priv[i];
-			spin_lock_init(&priv->rx_pkt_lock);
 			spin_lock_init(&priv->wmm.ra_list_spinlock);
 			spin_lock_init(&priv->curr_bcn_buf_lock);
 			spin_lock_init(&priv->sta_list_spinlock);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 69ac0a2..d2b54be 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -616,9 +616,6 @@ struct mwifiex_private {
 	struct list_head rx_reorder_tbl_ptr;
 	/* spin lock for rx_reorder_tbl_ptr queue */
 	spinlock_t rx_reorder_tbl_lock;
-	/* spin lock for Rx packets */
-	spinlock_t rx_pkt_lock;
-
 #define MWIFIEX_ASSOC_RSP_BUF_SIZE  500
 	u8 assoc_rsp_buf[MWIFIEX_ASSOC_RSP_BUF_SIZE];
 	u32 assoc_rsp_size;
-- 
1.9.1
