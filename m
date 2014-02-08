Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8386 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbaBHAa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:30:57 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 28/30] mwifiex: disable all TDLS link during disconnection
Date: Fri, 7 Feb 2014 16:30:41 -0800
Message-ID: <1391819442-21239-9-git-send-email-bzhao@marvell.com> (sfid-20140208_020008_974790_E73BCC95)
In-Reply-To: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
References: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

During deauthenticate/link lost event, disable all TDLS links as
TDLS would not work when infra connection is not active.
Also this will avoid an issue where ping to peer station doesn't
work after reassociation to AP where we had created TDLS link in
earlier association.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h      |  1 +
 drivers/net/wireless/mwifiex/sta_event.c |  4 ++++
 drivers/net/wireless/mwifiex/tdls.c      | 35 ++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 631e07f..9bb66ea 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1234,6 +1234,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 				       u8 *buf, int len);
 int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action);
 int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, u8 *mac);
+void mwifiex_disable_all_tdls_links(struct mwifiex_private *priv);
 bool mwifiex_is_bss_in_11ac_mode(struct mwifiex_private *priv);
 u8 mwifiex_get_center_freq_index(struct mwifiex_private *priv, u8 band,
 				 u32 pri_chan, u8 chan_bw);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index de4a6af..92ff7b3 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -54,6 +54,10 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 
 	priv->scan_block = false;
 
+	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
+	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info))
+		mwifiex_disable_all_tdls_links(priv);
+
 	/* Free Tx and Rx packets, report disconnect to upper layer */
 	mwifiex_clean_txrx(priv);
 
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 770dcd7..5efd456 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -1007,3 +1007,38 @@ int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, u8 *mac)
 
 	return TDLS_NOT_SETUP;
 }
+
+void mwifiex_disable_all_tdls_links(struct mwifiex_private *priv)
+{
+	struct mwifiex_sta_node *sta_ptr;
+	struct mwifiex_ds_tdls_oper tdls_oper;
+	unsigned long flags;
+
+	if (list_empty(&priv->sta_list))
+		return;
+
+	list_for_each_entry(sta_ptr, &priv->sta_list, list) {
+		memset(&tdls_oper, 0, sizeof(struct mwifiex_ds_tdls_oper));
+
+		if (sta_ptr->is_11n_enabled) {
+			mwifiex_11n_cleanup_reorder_tbl(priv);
+			spin_lock_irqsave(&priv->wmm.ra_list_spinlock,
+					  flags);
+			mwifiex_11n_delete_all_tx_ba_stream_tbl(priv);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
+		}
+
+		mwifiex_restore_tdls_packets(priv, sta_ptr->mac_addr,
+					     TDLS_LINK_TEARDOWN);
+		memcpy(&tdls_oper.peer_mac, sta_ptr->mac_addr, ETH_ALEN);
+		tdls_oper.tdls_action = MWIFIEX_TDLS_DISABLE_LINK;
+		if (mwifiex_send_cmd_async(priv, HostCmd_CMD_TDLS_OPER,
+					   HostCmd_ACT_GEN_SET, 0, &tdls_oper))
+			dev_warn(priv->adapter->dev,
+				 "Disable link failed for TDLS peer %pM",
+				 sta_ptr->mac_addr);
+	}
+
+	mwifiex_del_all_sta_list(priv);
+}
-- 
1.8.2.3

