Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793330287;
	b=Snrx427Q8CCHu7mI0HbFotJz/l1aknYz4hVI7eFmrhAEviqGCpE86f2kedqAHn+WHHzz
	 EUHa4ZQ4HCaxUt/PQ6WGZGZm8emLC5J8W776wetdAFRgv3Ww2NESdvfiWVPe4y/EhfEzB
	 9RYv89833djhaTymbjf9YuIS4mKMUgH+I0NdZ2TWXTyxLbBRJUC8xoQIXLjTXe85RLTa/
	 xFCKq8NcATBmQElq8e38Bjw0KSjL0IKRAn0wptSZ1BxP9xbFJi8+g0rC/dTEByvT0DOKO
	 cbhV4wrMksk3ve/A+kUzEWO0+w8iaZWHt+CZxSDBDlOw7RRT6Llc3RNJ4zRVbkJWvyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793330287;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=6RRcv4Qw7VDJcKP4wbTzfqyN7JaE/6Jb2FDJuM1BHy0=;
	b=H/oH58pIL3g0/EIDhbIKkZjtro67YjXPrKUEoSqZeMQUqTVFJbk2P1ZGON/33gyjxgx0
	 sBKNyCpLjq8FW9KUxIGyPfqavNKOdhappT4Lh3DRcZHkFtRQRuKXfTzDs8XmMDNdhfeo3
	 pJ2doe7ncf2pbC+hrs6IbEqeKoY56j0Jge8I+z7V9chnNCXc6dbIp+2xHRfM5AhBwb3ZJ
	 ZLhTcxQVjmWcpyGNddC+0V1ViauFWeuicWPHRz/iHPVuvdgaEwkLAW38BybdGMwrUM9xG
	 3uQYQpxRv1hZL1dYxXomh0rx/dafgm53bwMdbD+gsXOSmWtCLGTtpShtekNkTL+9LHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=dXsuaTEQ;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2292D606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 03:18:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2292D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=dXsuaTEQ
X-UUID: 83182ef4d41011f1b1788b6acf885367-20261030
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=6RRcv4Qw7VDJcKP4wbTzfqyN7JaE/6Jb2FDJuM1BHy0=;
	b=dXsuaTEQzrs6b13PxS1wyBVBEfR/no/Mt1EGuWn+7l/jCDXzYz0EgLPISjsrl7UgLhl3p17E0OEOa/G8KmNpFiUXamFuny/3JSCmDbdwl+II2u0zhq1uNj31Ixrht6n1rGr1NroPXfboFSjfH8bGUwVnFzd0ALw/aCLsPFYktBE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:ebbba6bf-8259-45c4-9553-6f6b780e81fa,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:e9c52fbb-4006-44bb-949c-6e25a7b8dad4,B
	ulkID:nil,BulkQuantity:0,SF:102|136|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 83182ef4d41011f1b1788b6acf885367-20261030
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 417734057; Fri, 30 Oct 2026 11:18:00 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 30 Oct 2026 11:17:59 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 30 Oct 2026 11:17:59 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>,
	<michael.shih@mediatek.com>, <eason.lai@mediatek.com>
Subject: [PATCH v1] wifi: mt76: mt792x: Add MTK OUI support for wpa supplicant
Date: Fri, 30 Oct 2026 11:17:58 +0800
Message-ID: <20261030031758.3397910-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
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

From: Michael Shih <michael.shih@mediatek.com>

Implement MediaTek OUI vendor command in the mt76 driver by defining a
 wiphy_vendor_command table with a GET_CHIP_INFO sub-command handler.

Signed-off-by: Michael Shih <michael.shih@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  1 +
 .../net/wireless/mediatek/mt76/mt792x_core.c  |  2 +
 .../wireless/mediatek/mt76/mt792x_vendor.c    | 76 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt792x_vendor.h    | 36 +++++++++
 5 files changed, 116 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt792x_vendor.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt792x_vendor.h

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index cacdd2b13d05..90bf68f25cfd 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -38,7 +38,7 @@ mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 mt76-connac-lib-y := mt76_connac_mcu.o mt76_connac_mac.o mt76_connac3_mac.o
 
 mt792x-lib-y := mt792x_core.o mt792x_mac.o mt792x_trace.o \
-		mt792x_debugfs.o mt792x_dma.o
+		mt792x_debugfs.o mt792x_dma.o mt792x_vendor.o
 mt792x-lib-$(CONFIG_ACPI) += mt792x_acpi_sar.o
 mt792x-usb-y := mt792x_usb.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index a7d71e007da0..926e2cadb023 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -538,6 +538,7 @@ int mt792x_pm_stats(struct seq_file *s, void *data);
 int mt792x_pm_idle_timeout_set(void *data, u64 val);
 int mt792x_pm_idle_timeout_get(void *data, u64 *val);
 int mt792x_init_wiphy(struct ieee80211_hw *hw);
+void mt792x_vendor_register(struct ieee80211_hw *hw);
 struct ieee80211_ops *
 mt792x_get_mac80211_ops(struct device *dev,
 			const struct ieee80211_ops *mac80211_ops,
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 3ce6c6ceac81..eb50548c4d51 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -854,6 +854,8 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 
 	hw->max_tx_fragments = 4;
 
+	mt792x_vendor_register(hw);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt792x_init_wiphy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_vendor.c b/drivers/net/wireless/mediatek/mt76/mt792x_vendor.c
new file mode 100644
index 000000000000..d1f1560d8641
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_vendor.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: ISC
+/* Copyright (C) 2026 MediaTek Inc. */
+
+#include <linux/module.h>
+#include <net/netlink.h>
+#include <net/cfg80211.h>
+
+#include "mt792x.h"
+#include "mt792x_vendor.h"
+
+static const struct nla_policy
+mtk_vendor_chip_info_policy[MTK_VENDOR_ATTR_CHIP_INFO_MAX + 1] = {
+	[MTK_VENDOR_ATTR_CHIP_INFO_ID]  = { .type = NLA_U32 },
+	[MTK_VENDOR_ATTR_CHIP_INFO_OUI] = { .type = NLA_U32 },
+};
+
+static int
+mt792x_vendor_get_chip_info(struct wiphy *wiphy, struct wireless_dev *wdev,
+			    const void *data, int data_len)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct mt792x_phy *phy = mt792x_hw_phy(hw);
+	struct sk_buff *skb;
+
+	/* reply payload: two u32 attributes */
+	skb = cfg80211_vendor_cmd_alloc_reply_skb(wiphy,
+						  2 * (nla_total_size(sizeof(u32))));
+	if (!skb)
+		return -ENOMEM;
+
+	if (nla_put_u32(skb, MTK_VENDOR_ATTR_CHIP_INFO_ID,
+			phy->dev->mt76.rev) ||
+	    nla_put_u32(skb, MTK_VENDOR_ATTR_CHIP_INFO_OUI,
+			MTK_NL80211_VENDOR_ID)) {
+		kfree_skb(skb);
+		return -ENOBUFS;
+	}
+
+	return cfg80211_vendor_cmd_reply(skb);
+}
+
+static const struct wiphy_vendor_command mt792x_vendor_commands[] = {
+	{
+		.info = {
+			.vendor_id = MTK_NL80211_VENDOR_ID,
+			.subcmd    = MTK_NL80211_VENDOR_SUBCMD_GET_CHIP_INFO,
+		},
+		.flags = WIPHY_VENDOR_CMD_NEED_WDEV |
+			 WIPHY_VENDOR_CMD_NEED_NETDEV,
+		.doit    = mt792x_vendor_get_chip_info,
+		.policy  = mtk_vendor_chip_info_policy,
+		.maxattr = MTK_VENDOR_ATTR_CHIP_INFO_MAX,
+	},
+};
+
+static const struct nl80211_vendor_cmd_info mt792x_vendor_events[] = {
+	[MTK_NL80211_VENDOR_EVENT_CHIP_INFO] = {
+		.vendor_id = MTK_NL80211_VENDOR_ID,
+		.subcmd    = MTK_NL80211_VENDOR_SUBCMD_GET_CHIP_INFO,
+	},
+};
+
+void mt792x_vendor_register(struct ieee80211_hw *hw)
+{
+	struct wiphy *wiphy = hw->wiphy;
+
+	wiphy->vendor_commands   = mt792x_vendor_commands;
+	wiphy->n_vendor_commands = ARRAY_SIZE(mt792x_vendor_commands);
+	wiphy->vendor_events     = mt792x_vendor_events;
+	wiphy->n_vendor_events   = ARRAY_SIZE(mt792x_vendor_events);
+
+	dev_info(wiphy->dev.parent,
+		 "mt792x: registered %u vendor cmd(s), OUI=0x%06x\n",
+		 wiphy->n_vendor_commands, MTK_NL80211_VENDOR_ID);
+}
+EXPORT_SYMBOL_GPL(mt792x_vendor_register);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_vendor.h b/drivers/net/wireless/mediatek/mt76/mt792x_vendor.h
new file mode 100644
index 000000000000..ab728cfd0912
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_vendor.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: ISC */
+/* Copyright (C) 2026 MediaTek Inc. */
+
+#ifndef __MT792X_VENDOR_H
+#define __MT792X_VENDOR_H
+
+/* MediaTek nl80211 vendor OUI (24-bit OUI placed in the low 24 bits).
+ * This is the value advertised to user space (e.g. wpa_supplicant's
+ * wiphy_info_handler) via NL80211_ATTR_VENDOR_DATA in the GET_WIPHY reply.
+ */
+#define MTK_NL80211_VENDOR_ID		0x000ce7
+
+/* vendor sub-commands (defined by the vendor) */
+enum mtk_nl80211_vendor_subcmds {
+	MTK_NL80211_VENDOR_SUBCMD_UNSPEC	= 0,
+	MTK_NL80211_VENDOR_SUBCMD_GET_CHIP_INFO	= 1,
+};
+
+/* vendor event indexes (used by cfg80211_vendor_event*) */
+enum mtk_nl80211_vendor_events {
+	MTK_NL80211_VENDOR_EVENT_CHIP_INFO	= 0,
+};
+
+/* attributes carried in the GET_CHIP_INFO vendor command reply */
+enum mtk_vendor_attr_chip_info {
+	MTK_VENDOR_ATTR_CHIP_INFO_INVALID	= 0,
+	MTK_VENDOR_ATTR_CHIP_INFO_ID		= 1,
+	MTK_VENDOR_ATTR_CHIP_INFO_OUI		= 2,
+
+	/* keep last */
+	__MTK_VENDOR_ATTR_CHIP_INFO_MAX,
+	MTK_VENDOR_ATTR_CHIP_INFO_MAX =
+		__MTK_VENDOR_ATTR_CHIP_INFO_MAX - 1,
+};
+
+#endif /* __MT792X_VENDOR_H */
-- 
2.45.2

