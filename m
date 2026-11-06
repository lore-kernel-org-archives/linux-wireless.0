Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953814;
	b=p7PwlEqnbqutHwo2kov7v+tkT4EakdDYrjKN39VS6BTr+5aqY/ulSRne/E5yURoArX9G
	 34cjwFkR/ueyXyrJ7V6+RRQbD3mFOL6H/rBUvoPXZhBGBukwaD6Es4JyoorxxpWKrLdub
	 Nx7VIxl/nyPrHaIJiWCScVYlcZtAY4IqR47I12xBmyPQcePMgsY4DWEzZ/jaltWQ8zti/
	 7J+C06H/shXfqxXC40GdXzy0Xa6uDDv17R8Y/BebvuNpl2Eonxgi8VHl3QW54PEPeBFnu
	 msBb9p65ln80t6J4igiaO4RJb6cR2/D9ZkQq2//lA1iamShULR3SJAIaPDF0uj3Q51Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953814;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-MTK;
	bh=UI5SWfaGG0/HtKLcyy36l0cuYxdzzfBYIUscL4SREyk=;
	b=OanltbWqZzD3QobslblAqHUmEZFkwWe1DSKYAjHt5072Ve/yq5IW4K3hvROZyVg4294G
	 9BNBrvo2KzCfzuv+QIqaJUjh4slGNdwkPQxbzVA1evfUi8M5r3FpBss/eNsDHuhxuPmUa
	 WE8KLhCd7rYIj9dZ20bKvg4FmwOukHnOHp324VXoe6hZbIAKpTfk/4tbhgcatEwYax1vS
	 uuOjNiw2ZtpjtsgTeVG8LYdaxkFaDF7Yczvw7uv5Rh7Wi5ZHi1/lzq3WsH2BjtUaYkwDa
	 WI1SE2VtcO65rSZBzrENF5Gm39xWH+mhVMvO19Q1E6gp2tB32SFH7kfypmry9wp/qyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=PTlKg6WW;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEA3606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:30:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CEA3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=PTlKg6WW
X-UUID: 4795056cd9bc11f18dc8c9802ae25ab1-20261106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=UI5SWfaGG0/HtKLcyy36l0cuYxdzzfBYIUscL4SREyk=;
	b=PTlKg6WWXBRw9YdCXX61b+KCd7cLeSEar5LDo7+A7f93pLGAMn09l4nwMwduRzvUDaTtempHAAWQ5quS4Vy3h6DSNd/Zg8mHJBNxIbdzGXs816jPjtF5BzWCFLv5M/itOH9slcPolhauSWit68Bh7Ofjmp9Ad42H7TztdbphKRg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:6e240c02-0a9b-4b84-a558-c2f92b46bb25,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:b0318ac,CLOUDID:ec727fae-cba0-45b9-b809-bd1d844f6e65,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4795056cd9bc11f18dc8c9802ae25ab1-20261106
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <james-ly.huang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 842750877; Fri, 06 Nov 2026 16:30:10 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Nov 2026 16:30:09 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Nov 2026 16:30:09 +0800
From: James-LY Huang <james-ly.huang@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<sean.wang@mediatek.com>, <jb.tsai@mediatek.com>, <kun.wu@mediatek.com>,
	<James-LY.Huang@mediatek.com>, james-ly huang <james-ly.huang@mediatek.com>
Subject: [PATCH v2 1/9] wifi: mt76: mt7925: drop P2P mgmt frames received on foreign channel
Date: Fri, 6 Nov 2026 16:29:56 +0800
Message-ID: <20261106083004.3156085-2-james-ly.huang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20261106083004.3156085-1-james-ly.huang@mediatek.com>
References: <20261106083004.3156085-1-james-ly.huang@mediatek.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: james-ly huang <james-ly.huang@mediatek.com>

Start a dedicated p2p.c/p2p.h module for the P2P-only logic the
generic mt7925 data paths hook into, and put the RX-side filter
there first:

  - a Probe Response received while P2P discovery walks the social
    channels may carry IEs advertising a band/channel other than the
    one it was received on (WFA P2P IE only) - drop it;
  - an active P2P GO only cares about broadcast Probe Requests that
    arrive on its own operating channel - drop foreign-channel ones.

mac.c hooks the filter in mt7925_queue_rx_skb() via the new
mt7925_p2p_rx_drop_chan_mismatch().

Signed-off-by: james-ly huang <james-ly.huang@mediatek.com>
---
v2: no change
---
 .../wireless/mediatek/mt76/mt7925/Makefile    |   2 +-
 .../net/wireless/mediatek/mt76/mt7925/mac.c   |  10 ++
 .../net/wireless/mediatek/mt76/mt7925/p2p.c   | 166 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/p2p.h   |  18 ++
 4 files changed, 195 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/p2p.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/Makefile b/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
index 33539121a15c..697a2bbce46c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_MT7925_COMMON) += mt7925-common.o
 obj-$(CONFIG_MT7925E) += mt7925e.o
 obj-$(CONFIG_MT7925U) += mt7925u.o
 
-mt7925-common-y := mac.o mcu.o regd.o main.o init.o debugfs.o nan.o
+mt7925-common-y := mac.o mcu.o regd.o main.o init.o debugfs.o nan.o p2p.o
 mt7925-common-$(CONFIG_NL80211_TESTMODE) += testmode.o
 mt7925e-y := pci.o pci_mac.o pci_mcu.o cached_cal.o
 mt7925u-y := usb.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 7af996abe294..6e67ef3c52fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -5,6 +5,7 @@
 #include <linux/etherdevice.h>
 #include <linux/timekeeping.h>
 #include "mt7925.h"
+#include "p2p.h"
 #include "../dma.h"
 #include "regd.h"
 #include "mac.h"
@@ -1459,6 +1460,15 @@ void mt7925_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 	case PKT_TYPE_NORMAL_MCU:
 	case PKT_TYPE_NORMAL:
 		if (!mt7925_mac_fill_rx(dev, skb)) {
+			struct mt76_rx_status *status =
+				(struct mt76_rx_status *)skb->cb;
+
+			if (!(status->flag & RX_FLAG_8023) &&
+			    mt7925_p2p_rx_drop_chan_mismatch(dev, skb)) {
+				dev_kfree_skb(skb);
+				return;
+			}
+
 			mt76_rx(&dev->mt76, q, skb);
 			return;
 		}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
new file mode 100644
index 000000000000..12d6eee8ce10
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/* Copyright (C) 2026 MediaTek Inc. */
+
+/* Everything in this file is P2P-only logic that the generic mt7925 data
+ * paths hook into: RX-side filtering of foreign-channel discovery frames,
+ * TX-side TXD (lifetime / retry / timestamp) overrides for off-channel and
+ * GO Probe Response frames, the per-P2P-interface BMC wcid bookkeeping,
+ * the pre-grant .change_chanctx gate and the P2P-only MCU event handlers
+ * (SAP aging timeout, BSS absence).
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/units.h>
+#include <net/mac80211.h>
+
+#include "../mt76.h"
+#include "../mt76_connac.h"
+#include "../mt792x.h"
+#include "mt7925.h"
+#include "mac.h"
+#include "mcu.h"
+#include "p2p.h"
+
+/* ------------------------------------------------------------------ */
+/* RX: foreign-channel discovery frames                                 */
+/* ------------------------------------------------------------------ */
+
+/* Channel number a management frame advertises in its own IEs: DSSS Parameter
+ * Set, or the HT Operation primary channel when there is no DS Params element.
+ */
+static u8 mt7925_rx_ie_chan(const u8 *ies, int ies_len)
+{
+	const struct ieee80211_ht_operation *ht_oper;
+	const struct element *elem;
+
+	elem = cfg80211_find_elem(WLAN_EID_DS_PARAMS, ies, ies_len);
+	if (elem && elem->datalen == 1)
+		return elem->data[0];
+
+	elem = cfg80211_find_elem(WLAN_EID_HT_OPERATION, ies, ies_len);
+	if (elem && elem->datalen >= sizeof(*ht_oper)) {
+		ht_oper = (const void *)elem->data;
+		return ht_oper->primary_chan;
+	}
+
+	return 0;
+}
+
+/* A Probe Response received while P2P discovery walks the social channels may
+ * carry IEs advertising a band/channel other than the one it was received on.
+ * Scope: only Probe Responses that carry the WFA P2P IE.
+ */
+static bool
+mt7925_rx_drop_p2p_probe_resp(struct sk_buff *skb,
+			      struct mt76_rx_status *status)
+{
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+	int hdr_len = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+	const u8 *ies;
+	int ies_len;
+	u8 ie_chan;
+
+	if (skb->len <= hdr_len)
+		return false;
+
+	ies = mgmt->u.probe_resp.variable;
+	ies_len = skb->len - hdr_len;
+
+	if (!cfg80211_find_vendor_ie(WLAN_OUI_WFA, WLAN_OUI_TYPE_WFA_P2P,
+				     ies, ies_len))
+		return false;
+
+	ie_chan = mt7925_rx_ie_chan(ies, ies_len);
+	if (!ie_chan)
+		return false;
+
+	if (ieee80211_channel_to_frequency(ie_chan, status->band) ==
+	    status->freq)
+		return false;
+
+	return true;
+}
+
+struct mt7925_rx_chan_iter_data {
+	u16 freq;
+	u8 band;
+	bool p2p_go_active;
+	bool chan_match;
+};
+
+static void mt7925_rx_chan_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt7925_rx_chan_iter_data *data = priv;
+	unsigned int link_id;
+
+	for (link_id = 0; link_id < ARRAY_SIZE(vif->link_conf); link_id++) {
+		struct ieee80211_chanctx_conf *ctx;
+		struct ieee80211_bss_conf *conf;
+
+		conf = rcu_dereference(vif->link_conf[link_id]);
+		if (!conf)
+			continue;
+
+		ctx = rcu_dereference(conf->chanctx_conf);
+		if (!ctx || !ctx->def.chan)
+			continue;
+
+		if (vif->type == NL80211_IFTYPE_AP && vif->p2p)
+			data->p2p_go_active = true;
+
+		if (ctx->def.chan->band == data->band &&
+		    ctx->def.chan->center_freq == data->freq)
+			data->chan_match = true;
+	}
+}
+
+/* An active P2P GO only cares about broadcast Probe Requests that arrive on its
+ * own operating channel. Drop foreign-channel broadcast Probe Requests.
+ */
+static bool
+mt7925_rx_drop_go_probe_req(struct mt792x_dev *dev, struct sk_buff *skb,
+			    struct mt76_rx_status *status)
+{
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+	struct mt7925_rx_chan_iter_data data = {
+		.freq = status->freq,
+		.band = status->band,
+	};
+
+	if (!is_broadcast_ether_addr(mgmt->da))
+		return false;
+
+	if (test_bit(MT76_STATE_ROC, &dev->mphy.state))
+		return false;
+
+	ieee80211_iterate_active_interfaces_atomic(dev->mt76.hw,
+						   IEEE80211_IFACE_ITER_RESUME_ALL,
+						   mt7925_rx_chan_iter, &data);
+
+	if (!data.p2p_go_active || data.chan_match)
+		return false;
+
+	return true;
+}
+
+/* Drop management frames whose own notion of the channel contradicts the
+ * channel the hardware reported them on.
+ */
+bool
+mt7925_p2p_rx_drop_chan_mismatch(struct mt792x_dev *dev, struct sk_buff *skb)
+{
+	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (skb->len < sizeof(struct ieee80211_hdr_3addr) || !status->freq)
+		return false;
+
+	if (ieee80211_is_probe_resp(hdr->frame_control))
+		return mt7925_rx_drop_p2p_probe_resp(skb, status);
+
+	if (ieee80211_is_probe_req(hdr->frame_control))
+		return mt7925_rx_drop_go_probe_req(dev, skb, status);
+
+	return false;
+}
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
new file mode 100644
index 000000000000..ed51670d9633
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear */
+/* Copyright (C) 2026 MediaTek Inc. */
+
+#ifndef __MT7925_P2P_H
+#define __MT7925_P2P_H
+
+#include <net/mac80211.h>
+
+#include "../mt76.h"
+#include "../mt792x.h"
+
+/* TX/RX path overrides, BMC wcid bookkeeping and the P2P-only MCU event
+ * handlers.
+ */
+bool mt7925_p2p_rx_drop_chan_mismatch(struct mt792x_dev *dev,
+				      struct sk_buff *skb);
+
+#endif /* __MT7925_P2P_H */
-- 
2.45.2

