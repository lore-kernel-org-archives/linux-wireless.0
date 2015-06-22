Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19779 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932964AbbFVIG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:06:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xsAO015567
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:06:57 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1v55hgut60-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:06:57 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 04/17] mwifiex: add tdls channel switch status
Date: Mon, 22 Jun 2015 19:06:10 +0530
Message-ID: <1434980183-2901-5-git-send-email-patila@marvell.com> (sfid-20150622_100701_755908_B6C9CEA8)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add new tdls status used for tdls channel switch.
Driver in turn would block cmd path and data path if tdls
channel switching. Data path to non tdls peer should be blocked
if tdls channel switch to off-channel.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h |  3 ++
 drivers/net/wireless/mwifiex/main.c | 14 +++++++--
 drivers/net/wireless/mwifiex/main.h |  3 ++
 drivers/net/wireless/mwifiex/util.c | 59 +++++++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 51e3447..098e1f1 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -141,6 +141,9 @@ enum mwifiex_tdls_status {
 	TDLS_SETUP_COMPLETE,
 	TDLS_SETUP_FAILURE,
 	TDLS_LINK_TEARDOWN,
+	TDLS_CHAN_SWITCHING,
+	TDLS_IN_BASE_CHAN,
+	TDLS_IN_OFF_CHAN,
 };
 
 enum mwifiex_tdls_error_code {
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3ba4e0e..2a2e5db 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -299,9 +299,15 @@ process_start:
 
 			if ((!adapter->scan_chan_gap_enabled &&
 			     adapter->scan_processing) || adapter->data_sent ||
+			     mwifiex_is_tdls_chan_switching
+			     (mwifiex_get_priv(adapter,
+					       MWIFIEX_BSS_ROLE_STA)) ||
 			    (mwifiex_wmm_lists_empty(adapter) &&
 			     skb_queue_empty(&adapter->tx_data_q))) {
 				if (adapter->cmd_sent || adapter->curr_cmd ||
+					!mwifiex_is_send_cmd_allowed
+						(mwifiex_get_priv(adapter,
+						MWIFIEX_BSS_ROLE_STA)) ||
 				    (!is_command_pending(adapter)))
 					break;
 			}
@@ -342,7 +348,9 @@ process_start:
 			continue;
 		}
 
-		if (!adapter->cmd_sent && !adapter->curr_cmd) {
+		if (!adapter->cmd_sent && !adapter->curr_cmd &&
+		    mwifiex_is_send_cmd_allowed
+		    (mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA))) {
 			if (mwifiex_exec_next_cmd(adapter) == -1) {
 				ret = -1;
 				break;
@@ -365,7 +373,9 @@ process_start:
 
 		if ((adapter->scan_chan_gap_enabled ||
 		     !adapter->scan_processing) &&
-		    !adapter->data_sent && !mwifiex_wmm_lists_empty(adapter)) {
+		    !adapter->data_sent && !mwifiex_wmm_lists_empty(adapter) &&
+		    !mwifiex_is_tdls_chan_switching
+			(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA))) {
 			mwifiex_wmm_process_tx(adapter);
 			if (adapter->hs_activated) {
 				adapter->is_hs_configured = false;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 2106a5c..d27e6aa 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1461,6 +1461,9 @@ struct mwifiex_sta_node *
 mwifiex_add_sta_entry(struct mwifiex_private *priv, const u8 *mac);
 struct mwifiex_sta_node *
 mwifiex_get_sta_entry(struct mwifiex_private *priv, const u8 *mac);
+u8 mwifiex_is_tdls_chan_switching(struct mwifiex_private *priv);
+u8 mwifiex_is_tdls_off_chan(struct mwifiex_private *priv);
+u8 mwifiex_is_send_cmd_allowed(struct mwifiex_private *priv);
 int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 				 u8 action_code, u8 dialog_token,
 				 u16 status_code, const u8 *extra_ies,
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 790e619..2504e42 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -531,6 +531,65 @@ mwifiex_get_sta_entry(struct mwifiex_private *priv, const u8 *mac)
 	return NULL;
 }
 
+static struct mwifiex_sta_node *
+mwifiex_get_tdls_sta_entry(struct mwifiex_private *priv, u8 status)
+{
+	struct mwifiex_sta_node *node;
+
+	list_for_each_entry(node, &priv->sta_list, list) {
+		if (node->tdls_status == status)
+			return node;
+	}
+
+	return NULL;
+}
+
+/* If tdls channel switching is on-going, tx data traffic should be
+ * blocked until the switching stage completed.
+ */
+u8 mwifiex_is_tdls_chan_switching(struct mwifiex_private *priv)
+{
+	struct mwifiex_sta_node *sta_ptr;
+
+	if (!priv || !ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info))
+		return false;
+
+	sta_ptr = mwifiex_get_tdls_sta_entry(priv, TDLS_CHAN_SWITCHING);
+	if (sta_ptr)
+		return true;
+
+	return false;
+}
+
+u8 mwifiex_is_tdls_off_chan(struct mwifiex_private *priv)
+{
+	struct mwifiex_sta_node *sta_ptr;
+
+	if (!priv || !ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info))
+		return false;
+
+	sta_ptr = mwifiex_get_tdls_sta_entry(priv, TDLS_IN_OFF_CHAN);
+	if (sta_ptr)
+		return true;
+
+	return false;
+}
+
+/* If tdls channel switching is on-going or tdls operate on off-channel,
+ * cmd path should be blocked until tdls switched to base-channel.
+ */
+u8 mwifiex_is_send_cmd_allowed(struct mwifiex_private *priv)
+{
+	if (!priv || !ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info))
+		return true;
+
+	if (mwifiex_is_tdls_chan_switching(priv) ||
+	    mwifiex_is_tdls_off_chan(priv))
+		return false;
+
+	return true;
+}
+
 /* This function will add a sta_node entry to associated station list
  * table with the given mac address.
  * If entry exist already, existing entry is returned.
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
