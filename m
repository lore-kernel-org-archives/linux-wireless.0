Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0078.outbound.protection.outlook.com ([104.47.38.78]:26304
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751156AbeAVMrQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:16 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 11/11] qtnfmac: remove redundant 'unlikely' checks
Date: Mon, 22 Jan 2018 15:46:34 +0300
Message-Id: <20180122124634.8430-12-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134723_108413_D2E60712)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 52 +++++++++++------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 2820b0318c6a..deca0060eb27 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -215,7 +215,7 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_START_AP,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	cmd = (struct qlink_cmd_start_ap *)cmd_skb->data;
@@ -335,7 +335,7 @@ int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_STOP_AP,
 					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -369,7 +369,7 @@ int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u16 frame_type, bool reg)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_REGISTER_MGMT,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -412,7 +412,7 @@ int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_SEND_MGMT_FRAME,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -458,7 +458,7 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_MGMT_SET_APPIE,
 					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_cmd_tlv_ie_set_add(cmd_skb, frame_type, buf, len);
@@ -713,8 +713,7 @@ int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u8 *sta_mac,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_GET_STA_INFO,
 					    sizeof(*cmd));
-
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -779,7 +778,7 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_vif *vif,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    cmd_type,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -852,7 +851,7 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_DEL_INTF,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -1657,7 +1656,7 @@ int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
 					    QLINK_CMD_MAC_INFO,
 					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(mac->bus);
@@ -1695,7 +1694,7 @@ int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
 					    QLINK_CMD_GET_HW_INFO,
 					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(bus);
@@ -1875,7 +1874,7 @@ int qtnf_cmd_send_init_fw(struct qtnf_bus *bus)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
 					    QLINK_CMD_FW_INIT,
 					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(bus);
@@ -1924,7 +1923,7 @@ int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_ADD_KEY,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -1977,7 +1976,7 @@ int qtnf_cmd_send_del_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_DEL_KEY,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -2018,7 +2017,7 @@ int qtnf_cmd_send_set_default_key(struct qtnf_vif *vif, u8 key_index,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_SET_DEFAULT_KEY,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -2053,7 +2052,7 @@ int qtnf_cmd_send_set_default_mgmt_key(struct qtnf_vif *vif, u8 key_index)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_SET_DEFAULT_MGMT_KEY,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -2108,7 +2107,7 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_CHANGE_STA,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -2160,7 +2159,7 @@ int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_DEL_STA,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -2230,7 +2229,7 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
 					    QLINK_CMD_SCAN,
 					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(mac->bus);
@@ -2300,7 +2299,7 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_CONNECT,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	cmd = (struct qlink_cmd_connect *)cmd_skb->data;
@@ -2402,7 +2401,7 @@ int qtnf_cmd_send_disconnect(struct qtnf_vif *vif, u16 reason_code)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_DISCONNECT,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(vif->mac->bus);
@@ -2436,7 +2435,7 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif, bool up)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_UPDOWN_INTF,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	cmd = (struct qlink_cmd_updown *)cmd_skb->data;
@@ -2597,8 +2596,7 @@ int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, vif->vifid,
 					    QLINK_CMD_CHAN_SWITCH,
 					    sizeof(*cmd));
-
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(mac->bus);
@@ -2650,7 +2648,7 @@ int qtnf_cmd_get_channel(struct qtnf_vif *vif, struct cfg80211_chan_def *chdef)
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_CHAN_GET,
 					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	qtnf_bus_lock(bus);
@@ -2689,7 +2687,7 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_START_CAC,
 					    sizeof(*cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	cmd = (struct qlink_cmd_start_cac *)cmd_skb->data;
@@ -2727,7 +2725,7 @@ int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_SET_MAC_ACL,
 					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
+	if (!cmd_skb)
 		return -ENOMEM;
 
 	tlv = skb_put(cmd_skb, sizeof(*tlv) + acl_size);
-- 
2.11.0
