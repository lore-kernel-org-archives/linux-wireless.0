Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0074.outbound.protection.outlook.com ([104.47.38.74]:27801
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751024AbeAVMq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:46:58 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 01/11] qtnfmac: remove struct qlink_cmd_set_mac_acl
Date: Mon, 22 Jan 2018 15:46:24 +0300
Message-Id: <20180122124634.8430-2-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134703_723499_B2AC2E6C)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasily Ulyanov <vulyanov@quantenna.com>

TLV is used to pass ACL data to firmware in start_ap cfg80211 callback.
Use the same approach in set_mac_acl cfg80211 callback.

Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 15 +++++++++------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 10 ----------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 6ffe4837bbdb..b47b06bd680f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -187,7 +187,8 @@ static bool qtnf_cmd_start_ap_can_fit(const struct qtnf_vif *vif,
 		len += sizeof(struct qlink_tlv_chandef);
 
 	if (s->acl)
-		len += qtnf_cmd_acl_data_size(s->acl);
+		len += sizeof(struct qlink_tlv_hdr) +
+		       qtnf_cmd_acl_data_size(s->acl);
 
 	if (len > (sizeof(struct qlink_cmd) + QTNF_MAX_CMD_BUF_SIZE)) {
 		pr_err("VIF%u.%u: can not fit AP settings: %u\n",
@@ -2637,19 +2638,21 @@ int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 {
 	struct qtnf_bus *bus = vif->mac->bus;
 	struct sk_buff *cmd_skb;
-	struct qlink_cmd_set_mac_acl *cmd;
+	struct qlink_tlv_hdr *tlv;
+	size_t acl_size = qtnf_cmd_acl_data_size(params);
 	u16 res_code;
 	int ret;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_SET_MAC_ACL,
-					    sizeof(*cmd) +
-					    qtnf_cmd_acl_data_size(params));
+					    sizeof(struct qlink_cmd));
 	if (unlikely(!cmd_skb))
 		return -ENOMEM;
 
-	cmd = (struct qlink_cmd_set_mac_acl *)cmd_skb->data;
-	qlink_acl_data_cfg2q(params, &cmd->acl);
+	tlv = skb_put(cmd_skb, sizeof(*tlv) + acl_size);
+	tlv->type = cpu_to_le16(QTN_TLV_ID_ACL_DATA);
+	tlv->len = cpu_to_le16(acl_size);
+	qlink_acl_data_cfg2q(params, (struct qlink_acl_data *)tlv->val);
 
 	qtnf_bus_lock(bus);
 	ret = qtnf_cmd_send(bus, cmd_skb, &res_code);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 6a1f960228a1..f4d49565161e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -663,16 +663,6 @@ struct qlink_acl_data {
 	struct qlink_mac_address mac_addrs[0];
 } __packed;
 
-/**
- * struct qlink_cmd_set_mac_acl - data for QLINK_CMD_SET_MAC_ACL command
- *
- * @acl: ACL data.
- */
-struct qlink_cmd_set_mac_acl {
-	struct qlink_cmd chdr;
-	struct qlink_acl_data acl;
-} __packed;
-
 /* QLINK Command Responses messages related definitions
  */
 
-- 
2.11.0
