Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:44811 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab1DNAW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 20:22:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: remove redundant "return" at end of void function
Date: Wed, 13 Apr 2011 17:27:07 -0700
Message-Id: <1302740829-21315-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1302740829-21315-1-git-send-email-bzhao@marvell.com>
References: <1302740829-21315-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

The return statement at the last line of a void function
is not necessary.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |    6 ------
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    4 ----
 drivers/net/wireless/mwifiex/cfg80211.c      |    2 --
 drivers/net/wireless/mwifiex/cmdevt.c        |   13 +------------
 drivers/net/wireless/mwifiex/debugfs.c       |    3 ---
 drivers/net/wireless/mwifiex/init.c          |    6 ------
 drivers/net/wireless/mwifiex/main.c          |    3 ---
 drivers/net/wireless/mwifiex/sdio.c          |    4 ----
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |    2 --
 drivers/net/wireless/mwifiex/wmm.c           |    2 --
 10 files changed, 1 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index edf4c27..c57107a 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -543,8 +543,6 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 	if (curr_tx_buf_size != tx_buf)
 		mwifiex_send_cmd_async(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
 				       HostCmd_ACT_GEN_SET, 0, &tx_buf);
-
-	return;
 }
 
 /*
@@ -582,8 +580,6 @@ void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 	list_del(&tx_ba_tsr_tbl->list);
 
 	kfree(tx_ba_tsr_tbl);
-
-	return;
 }
 
 /*
@@ -662,8 +658,6 @@ void mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 		list_add_tail(&new_node->list, &priv->tx_ba_stream_tbl_ptr);
 		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	}
-
-	return;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index ef46d0a..6736fc6 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -309,8 +309,6 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_add_tail(&new_node->list, &priv->rx_reorder_tbl_ptr);
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
-
-	return;
 }
 
 /*
@@ -610,8 +608,6 @@ void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 		(u16) event->origninator << DELBA_INITIATOR_POS);
 	delba.reason_code = cpu_to_le16(WLAN_REASON_QSTA_TIMEOUT);
 	mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_DELBA, 0, 0, &delba);
-
-	return;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index a1ff490..74b6cf2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1428,6 +1428,4 @@ done:
 		memset(priv->cfg_bssid, 0, ETH_ALEN);
 		priv->disconnect = 0;
 	}
-
-	return;
 }
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index bb6fecd..776146a 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -94,8 +94,6 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 		mwifiex_recv_complete(adapter, cmd_node->resp_skb, 0);
 		cmd_node->resp_skb = NULL;
 	}
-
-	return;
 }
 
 /*
@@ -536,7 +534,7 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 {
 	unsigned long flags;
 
-	if (cmd_node == NULL)
+	if (!cmd_node)
 		return;
 
 	if (cmd_node->wait_q_enabled)
@@ -548,8 +546,6 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
 	list_add_tail(&cmd_node->list, &adapter->cmd_free_q);
 	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
-
-	return;
 }
 
 /*
@@ -594,8 +590,6 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
 	dev_dbg(adapter->dev, "cmd: QUEUE_CMD: cmd=%#x is queued\n", command);
-
-	return;
 }
 
 /*
@@ -871,8 +865,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	}
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
-
-	return;
 }
 
 /*
@@ -989,8 +981,6 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 	}
 	adapter->cmd_wait_q.status = -1;
 	mwifiex_complete_cmd(adapter);
-
-	return;
 }
 
 /*
@@ -1094,7 +1084,6 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 	adapter->is_hs_configured = false;
 	mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
 				   MWIFIEX_BSS_ROLE_ANY), false);
-	return;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 77d7c77..7ddcb06 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -735,8 +735,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
-
-	return;
 }
 
 /*
@@ -749,7 +747,6 @@ mwifiex_dev_debugfs_remove(struct mwifiex_private *priv)
 		return;
 
 	debugfs_remove_recursive(priv->dfs_dev_dir);
-	return;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 26931d5..1b79a5a 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -299,8 +299,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->adhoc_awake_period = 0;
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
-
-	return;
 }
 
 /*
@@ -339,8 +337,6 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 	adapter->if_ops.cleanup_if(adapter);
 
 	dev_kfree_skb_any(adapter->sleep_cfm);
-
-	return;
 }
 
 /*
@@ -428,8 +424,6 @@ void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 			list_del(&priv->rx_reorder_tbl_ptr);
 		}
 	}
-
-	return;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index df665db..77abfc3 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -505,7 +505,6 @@ mwifiex_fill_buffer(struct sk_buff *skb)
 	 */
 	do_gettimeofday(&tv);
 	skb->tstamp = timeval_to_ktime(tv);
-	return;
 }
 
 /*
@@ -820,8 +819,6 @@ mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 	wiphy_unregister(priv->wdev->wiphy);
 	wiphy_free(priv->wdev->wiphy);
 	kfree(priv->wdev);
-
-	return;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index f207756..fa46df5 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -859,8 +859,6 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		adapter->int_status |= sdio_ireg;
 		spin_unlock_irqrestore(&adapter->int_lock, flags);
 	}
-
-	return;
 }
 
 /*
@@ -891,8 +889,6 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 
 	mwifiex_interrupt_status(adapter);
 	queue_work(adapter->workqueue, &adapter->main_work);
-
-	return;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 8743c11..20ce8cb 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -103,8 +103,6 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 	adapter->curr_cmd = NULL;
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-
-	return;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 1cfbc6b..6ce6f94 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1232,6 +1232,4 @@ mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter)
 		if (mwifiex_dequeue_tx_packet(adapter))
 			break;
 	} while (true);
-
-	return;
 }
-- 
1.7.0.2

