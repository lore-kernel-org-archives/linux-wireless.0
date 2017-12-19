Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0045.outbound.protection.outlook.com ([104.47.42.45]:64231
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965110AbdLSL3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:29:31 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH v2 07/10] qtnfmac: fill wiphy's extended capabilities
Date: Tue, 19 Dec 2017 14:28:53 +0300
Message-Id: <20171219112856.22463-8-sergey.matyukevich.os@quantenna.com> (sfid-20171219_122942_213306_FB0A1541)
In-Reply-To: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
References: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasily Ulyanov <vulyanov@quantenna.com>

These are needed to inform userspace about features the hardware
supports (e.g. BSS Transition Management 802.11v)

Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 44 +++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/core.c     |  2 ++
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  3 ++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  1 +
 4 files changed, 50 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 7089f3eb7a87..839e86b99837 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1029,6 +1029,10 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 	struct qlink_iface_comb_num *comb;
 	size_t tlv_full_len;
 	const struct qlink_tlv_hdr *tlv;
+	u8 *ext_capa = NULL;
+	u8 *ext_capa_mask = NULL;
+	u8 ext_capa_len = 0;
+	u8 ext_capa_mask_len = 0;
 
 	mac->macinfo.n_limits = 0;
 
@@ -1092,6 +1096,18 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 			if (limits[rec].types)
 				rec++;
 			break;
+		case WLAN_EID_EXT_CAPABILITY:
+			if (unlikely(tlv_value_len > U8_MAX))
+				return -EINVAL;
+			ext_capa = (u8 *)tlv->val;
+			ext_capa_len = tlv_value_len;
+			break;
+		case QTN_TLV_ID_EXT_CAPABILITY_MASK:
+			if (unlikely(tlv_value_len > U8_MAX))
+				return -EINVAL;
+			ext_capa_mask = (u8 *)tlv->val;
+			ext_capa_mask_len = tlv_value_len;
+			break;
 		default:
 			break;
 		}
@@ -1112,6 +1128,34 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 		return -EINVAL;
 	}
 
+	if (ext_capa_len != ext_capa_mask_len) {
+		pr_err("MAC%u: ext_capa/_mask lengths mismatch: %u != %u\n",
+		       mac->macid, ext_capa_len, ext_capa_mask_len);
+		return -EINVAL;
+	}
+
+	if (ext_capa_len > 0) {
+		ext_capa = kmemdup(ext_capa, ext_capa_len, GFP_KERNEL);
+		if (!ext_capa)
+			return -ENOMEM;
+
+		ext_capa_mask =
+			kmemdup(ext_capa_mask, ext_capa_mask_len, GFP_KERNEL);
+		if (!ext_capa_mask) {
+			kfree(ext_capa);
+			return -ENOMEM;
+		}
+	} else {
+		ext_capa = NULL;
+		ext_capa_mask = NULL;
+	}
+
+	kfree(mac->macinfo.extended_capabilities);
+	kfree(mac->macinfo.extended_capabilities_mask);
+	mac->macinfo.extended_capabilities = ext_capa;
+	mac->macinfo.extended_capabilities_mask = ext_capa_mask;
+	mac->macinfo.extended_capabilities_len = ext_capa_len;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 518a2fe927f7..ccd982b1c957 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -381,6 +381,8 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus, unsigned int macid)
 	}
 
 	kfree(mac->macinfo.limits);
+	kfree(mac->macinfo.extended_capabilities);
+	kfree(mac->macinfo.extended_capabilities_mask);
 	kfree(wiphy->iface_combinations);
 	wiphy_free(wiphy);
 	bus->mac[macid] = NULL;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 8e42d1bdc65f..d7e295efb07d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -106,6 +106,9 @@ struct qtnf_mac_info {
 	struct ieee80211_vht_cap vht_cap_mod_mask;
 	struct ieee80211_iface_limit *limits;
 	size_t n_limits;
+	u8 *extended_capabilities;
+	u8 *extended_capabilities_mask;
+	u8 extended_capabilities_len;
 };
 
 struct qtnf_chan_stats {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 1f150be98820..f4d7d1603e3c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -1020,6 +1020,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_KEY			= 0x0302,
 	QTN_TLV_ID_SEQ			= 0x0303,
 	QTN_TLV_ID_IE_SET		= 0x0305,
+	QTN_TLV_ID_EXT_CAPABILITY_MASK	= 0x0306,
 };
 
 struct qlink_tlv_hdr {
-- 
2.11.0
