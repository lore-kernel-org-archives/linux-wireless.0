Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:45504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752905AbdJaBFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 21:05:09 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 6/9] qtnfmac: convert "Append IEs" command to QTN_TLV_ID_IE_SET usage
Date: Mon, 30 Oct 2017 18:04:52 -0700
Message-Id: <20171031010455.27772-7-igor.mitsyanko.os@quantenna.com> (sfid-20171031_020528_058061_57C4CB41)
In-Reply-To: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
References: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Data contained within "Append IEs" command (QLINK_CMD_MGMT_SET_APPIE)
duplicates QTN_TLV_ID_IE_SET TLV. Convert the command to use that TLV
instead.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 12 ++++++------
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 17 ++++-------------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 15 ---------------
 3 files changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 1a0c538..27b11dc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -217,10 +217,10 @@ static int qtnf_mgmt_set_appie(struct qtnf_vif *vif,
 	int ret = 0;
 
 	if (!info->beacon_ies || !info->beacon_ies_len) {
-		ret = qtnf_cmd_send_mgmt_set_appie(vif, QLINK_MGMT_FRAME_BEACON,
+		ret = qtnf_cmd_send_mgmt_set_appie(vif, QLINK_IE_SET_BEACON_IES,
 						   NULL, 0);
 	} else {
-		ret = qtnf_cmd_send_mgmt_set_appie(vif, QLINK_MGMT_FRAME_BEACON,
+		ret = qtnf_cmd_send_mgmt_set_appie(vif, QLINK_IE_SET_BEACON_IES,
 						   info->beacon_ies,
 						   info->beacon_ies_len);
 	}
@@ -230,11 +230,11 @@ static int qtnf_mgmt_set_appie(struct qtnf_vif *vif,
 
 	if (!info->proberesp_ies || !info->proberesp_ies_len) {
 		ret = qtnf_cmd_send_mgmt_set_appie(vif,
-						   QLINK_MGMT_FRAME_PROBE_RESP,
+						   QLINK_IE_SET_PROBE_RESP_IES,
 						   NULL, 0);
 	} else {
 		ret = qtnf_cmd_send_mgmt_set_appie(vif,
-						   QLINK_MGMT_FRAME_PROBE_RESP,
+						   QLINK_IE_SET_PROBE_RESP_IES,
 						   info->proberesp_ies,
 						   info->proberesp_ies_len);
 	}
@@ -244,11 +244,11 @@ static int qtnf_mgmt_set_appie(struct qtnf_vif *vif,
 
 	if (!info->assocresp_ies || !info->assocresp_ies_len) {
 		ret = qtnf_cmd_send_mgmt_set_appie(vif,
-						   QLINK_MGMT_FRAME_ASSOC_RESP,
+						   QLINK_IE_SET_ASSOC_RESP,
 						   NULL, 0);
 	} else {
 		ret = qtnf_cmd_send_mgmt_set_appie(vif,
-						   QLINK_MGMT_FRAME_ASSOC_RESP,
+						   QLINK_IE_SET_ASSOC_RESP,
 						   info->assocresp_ies,
 						   info->assocresp_ies_len);
 	}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 8d3cdba..294418c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -395,11 +395,10 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
 				 const u8 *buf, size_t len)
 {
 	struct sk_buff *cmd_skb;
-	struct qlink_cmd_mgmt_append_ie *cmd;
 	u16 res_code = QLINK_CMD_RESULT_OK;
 	int ret;
 
-	if (sizeof(*cmd) + len > QTNF_MAX_CMD_BUF_SIZE) {
+	if (len > QTNF_MAX_CMD_BUF_SIZE) {
 		pr_warn("VIF%u.%u: %u frame is too big: %zu\n", vif->mac->macid,
 			vif->vifid, frame_type, len);
 		return -E2BIG;
@@ -407,21 +406,13 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_MGMT_SET_APPIE,
-					    sizeof(*cmd));
+					    sizeof(struct qlink_cmd));
 	if (unlikely(!cmd_skb))
 		return -ENOMEM;
 
-	qtnf_bus_lock(vif->mac->bus);
-
-	cmd = (struct qlink_cmd_mgmt_append_ie *)cmd_skb->data;
-	cmd->type = frame_type;
-	cmd->flags = 0;
+	qtnf_cmd_tlv_ie_set_add(cmd_skb, frame_type, buf, len);
 
-	/* If len == 0 then IE buf for specified frame type
-	 * should be cleared on EP.
-	 */
-	if (len && buf)
-		qtnf_cmd_skb_put_buffer(cmd_skb, buf, len);
+	qtnf_bus_lock(vif->mac->bus);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 81effd2..43ce451 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -299,21 +299,6 @@ struct qlink_cmd_mgmt_frame_tx {
 } __packed;
 
 /**
- * struct qlink_cmd_mgmt_append_ie - data for QLINK_CMD_MGMT_SET_APPIE command
- *
- * @type: type of MGMT frame to appent requested IEs to, one of
- *	&enum qlink_mgmt_frame_type.
- * @flags: for future use.
- * @ie_data: IEs data to append.
- */
-struct qlink_cmd_mgmt_append_ie {
-	struct qlink_cmd chdr;
-	u8 type;
-	u8 flags;
-	u8 ie_data[0];
-} __packed;
-
-/**
  * struct qlink_cmd_get_sta_info - data for QLINK_CMD_GET_STA_INFO command
  *
  * @sta_addr: MAC address of the STA statistics is requested for.
-- 
2.9.5
