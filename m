Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:63780
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754515AbdHYCbM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:31:12 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 26/27] qtnfmac: include HTCAP and VHTCAP into config AP command
Date: Thu, 24 Aug 2017 19:30:23 -0700
Message-Id: <20170825023024.10565-27-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043115_784691_0F297A9A)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Include HT/VHT caps directly into command so that they won't have
to be searched for in IEs.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 1965061..dde2013 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -265,6 +265,24 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
 				s->beacon.assocresp_ies,
 				s->beacon.assocresp_ies_len);
 
+	if (s->ht_cap) {
+		struct qlink_tlv_hdr *tlv = (struct qlink_tlv_hdr *)
+			skb_put(cmd_skb, sizeof(*tlv) + sizeof(*s->ht_cap));
+
+		tlv->type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
+		tlv->len = cpu_to_le16(sizeof(*s->ht_cap));
+		memcpy(tlv->val, s->ht_cap, sizeof(*s->ht_cap));
+	}
+
+	if (s->vht_cap) {
+		struct qlink_tlv_hdr *tlv = (struct qlink_tlv_hdr *)
+			skb_put(cmd_skb, sizeof(*tlv) + sizeof(*s->vht_cap));
+
+		tlv->type = cpu_to_le16(WLAN_EID_VHT_CAPABILITY);
+		tlv->len = cpu_to_le16(sizeof(*s->vht_cap));
+		memcpy(tlv->val, s->ht_cap, sizeof(*s->vht_cap));
+	}
+
 	qtnf_bus_lock(vif->mac->bus);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-- 
2.9.5
