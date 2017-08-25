Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:63780
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754463AbdHYCbJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:31:09 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 23/27] qtnfmac: convert "Append IEs" command to QTN_TLV_ID_IE_SET usage
Date: Thu, 24 Aug 2017 19:30:20 -0700
Message-Id: <20170825023024.10565-24-igor.mitsyanko.os@quantenna.com> (sfid-20170825_044309_210430_52877AE0)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Data contained within "Append IEs" command (QLINK_CMD_MGMT_SET_APPIE)
duplicates QTN_TLV_ID_IE_SET TLV. Conver the command to use that TLV
instead.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 12 ++++++------
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 17 ++++-------------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 15 ---------------
 3 files changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 3faac7a..2497493 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -212,10 +212,10 @@ static int qtnf_mgmt_set_appie(struct qtnf_vif *vif,
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
@@ -225,11 +225,11 @@ static int qtnf_mgmt_set_appie(struct qtnf_vif *vif,
 
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
@@ -239,11 +239,11 @@ static int qtnf_mgmt_set_appie(struct qtnf_vif *vif,
 
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
index cc37114..2e30c26 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -394,11 +394,10 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
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
@@ -406,21 +405,13 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
 
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
index e584d2e..eba73fd 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -290,21 +290,6 @@ struct qlink_cmd_mgmt_frame_tx {
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
