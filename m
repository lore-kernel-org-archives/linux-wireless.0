Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:55784 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1ELCmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 22:42:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove mwifiex_recv_complete function
Date: Wed, 11 May 2011 19:47:11 -0700
Message-Id: <1305168432-15569-1-git-send-email-bzhao@marvell.com> (sfid-20110512_044241_425597_C1D578B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The function
- increments dropped rx_packet count if status code
  passed to it is "-1".
- frees SKB buffer.

But currently the function is being called with "0" status code.
This patch replaces above function by dev_kfree_skb_any() call.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    6 +++---
 drivers/net/wireless/mwifiex/main.h   |    4 ----
 drivers/net/wireless/mwifiex/util.c   |   25 -------------------------
 3 files changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 5c75399..cd89fed 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -91,7 +91,7 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 	cmd_node->wait_q_enabled = false;
 
 	if (cmd_node->resp_skb) {
-		mwifiex_recv_complete(adapter, cmd_node->resp_skb, 0);
+		dev_kfree_skb_any(cmd_node->resp_skb);
 		cmd_node->resp_skb = NULL;
 	}
 }
@@ -339,7 +339,7 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 		}
 		if (!cmd_array[i].resp_skb)
 			continue;
-		mwifiex_recv_complete(adapter, cmd_array[i].resp_skb, 0);
+		dev_kfree_skb_any(cmd_array[i].resp_skb);
 	}
 	/* Release struct cmd_ctrl_node */
 	if (adapter->cmd_pool) {
@@ -402,7 +402,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 	adapter->event_cause = 0;
 	adapter->event_skb = NULL;
 
-	mwifiex_recv_complete(adapter, skb, 0);
+	dev_kfree_skb_any(skb);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index b4bb5ec..672701d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -692,10 +692,6 @@ int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter);
 
 int mwifiex_dnld_fw(struct mwifiex_adapter *, struct mwifiex_fw_image *);
 
-int mwifiex_recv_complete(struct mwifiex_adapter *,
-			  struct sk_buff *skb,
-			  int status);
-
 int mwifiex_recv_packet(struct mwifiex_adapter *, struct sk_buff *skb);
 
 int mwifiex_process_event(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index a8d53aa..d412915 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -177,31 +177,6 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 }
 
 /*
- * Receive packet completion callback handler.
- *
- * This function updates the statistics and frees the buffer SKB.
- */
-int mwifiex_recv_complete(struct mwifiex_adapter *adapter,
-			  struct sk_buff *skb, int status)
-{
-	struct mwifiex_private *priv;
-	struct mwifiex_rxinfo *rx_info;
-
-	if (!skb)
-		return 0;
-
-	rx_info = MWIFIEX_SKB_RXCB(skb);
-	priv = mwifiex_bss_index_to_priv(adapter, rx_info->bss_index);
-
-	if (priv && (status == -1))
-		priv->stats.rx_dropped++;
-
-	dev_kfree_skb_any(skb);
-
-	return 0;
-}
-
-/*
  * IOCTL completion callback handler.
  *
  * This function is called when a pending IOCTL is completed.
-- 
1.7.0.2

