Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59618 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbZJVSxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:48 -0400
Date: Thu, 22 Oct 2009 20:21:43 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 27/28] mwl8k: implement AP firmware EDCA parameter configuration
Message-ID: <20091022182143.GC1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   49 +++++++++++++++++++++++++++++++----------
 1 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 4eda6f9..8e4631a 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2271,17 +2271,34 @@ struct mwl8k_cmd_set_edca_params {
 	/* TX opportunity in units of 32 us */
 	__le16 txop;
 
-	/* Log exponent of max contention period: 0...15*/
-	__u8 log_cw_max;
+	union {
+		struct {
+			/* Log exponent of max contention period: 0...15 */
+			__le32 log_cw_max;
+
+			/* Log exponent of min contention period: 0...15 */
+			__le32 log_cw_min;
+
+			/* Adaptive interframe spacing in units of 32us */
+			__u8 aifs;
+
+			/* TX queue to configure */
+			__u8 txq;
+		} ap;
+		struct {
+			/* Log exponent of max contention period: 0...15 */
+			__u8 log_cw_max;
 
-	/* Log exponent of min contention period: 0...15 */
-	__u8 log_cw_min;
+			/* Log exponent of min contention period: 0...15 */
+			__u8 log_cw_min;
 
-	/* Adaptive interframe spacing in units of 32us */
-	__u8 aifs;
+			/* Adaptive interframe spacing in units of 32us */
+			__u8 aifs;
 
-	/* TX queue to configure */
-	__u8 txq;
+			/* TX queue to configure */
+			__u8 txq;
+		} sta;
+	};
 } __attribute__((packed));
 
 #define MWL8K_SET_EDCA_CW	0x01
@@ -2297,6 +2314,7 @@ mwl8k_set_edca_params(struct ieee80211_hw *hw, __u8 qnum,
 		__u16 cw_min, __u16 cw_max,
 		__u8 aifs, __u16 txop)
 {
+	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_set_edca_params *cmd;
 	int rc;
 
@@ -2314,10 +2332,17 @@ mwl8k_set_edca_params(struct ieee80211_hw *hw, __u8 qnum,
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le16(MWL8K_SET_EDCA_ALL);
 	cmd->txop = cpu_to_le16(txop);
-	cmd->log_cw_max = (u8)ilog2(cw_max + 1);
-	cmd->log_cw_min = (u8)ilog2(cw_min + 1);
-	cmd->aifs = aifs;
-	cmd->txq = qnum;
+	if (priv->ap_fw) {
+		cmd->ap.log_cw_max = cpu_to_le32(ilog2(cw_max + 1));
+		cmd->ap.log_cw_min = cpu_to_le32(ilog2(cw_min + 1));
+		cmd->ap.aifs = aifs;
+		cmd->ap.txq = qnum;
+	} else {
+		cmd->sta.log_cw_max = (u8)ilog2(cw_max + 1);
+		cmd->sta.log_cw_min = (u8)ilog2(cw_min + 1);
+		cmd->sta.aifs = aifs;
+		cmd->sta.txq = qnum;
+	}
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
-- 
1.5.6.4
