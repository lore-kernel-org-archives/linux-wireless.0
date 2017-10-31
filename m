Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:45504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752996AbdJaBFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 21:05:12 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 8/9] qtnfmac: include HTCAP and VHTCAP into config AP command
Date: Mon, 30 Oct 2017 18:04:54 -0700
Message-Id: <20171031010455.27772-9-igor.mitsyanko.os@quantenna.com> (sfid-20171031_020547_529715_A49C3DF8)
In-Reply-To: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
References: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
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
index 5186116..c2f0b75 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -266,6 +266,24 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
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
+		memcpy(tlv->val, s->vht_cap, sizeof(*s->vht_cap));
+	}
+
 	qtnf_bus_lock(vif->mac->bus);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-- 
2.9.5
