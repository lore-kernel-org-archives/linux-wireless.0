Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB692931FB
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 05:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791955615; cv=none; b=oB4wdGgijUjCoptKaEoAyCV3CbKa/4SeqPLePROCfGx4ZhKhLVVoZjwB5vWs9L9xqxdPDtI5aTUzNZR3fmxCuWn2lXbLo9urA+m53yEndNYnRPkf9xqEINPuePwkqLtBLmwtAD0bSzkHNLmljLwtCIglBZYUvDYVuuNr4l6q5xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791955615; c=relaxed/simple;
	bh=XUPOjvYL0RQwHo9aVc/tmupMrp98+qNy6+gA1BJyDyc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m8fMyvdDBNON8aGI8kMRyOJ5dk1vfC4g+rgAUNI6ru0JcwRKtsCRGWpr/bTAjSx+jinsF8Cydii9EmWZtKMZF+5M4/3SqHX80C8qtygXld7qbLLKgu1QGZXJHmCXNQnOfUWZ+zmxlnhmxZcSZSDgLRvFaf2XY56TOlaAg05j4Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=WDEgaDGH; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WDEgaDGH"
X-UUID: d7c04b40c78f11f1b1788b6acf885367-20261014
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=byZ4N/qHoBXhW8OYlmCrDCXnuN86R6tnu29nZnp05sg=;
	b=WDEgaDGHl8B2pljRx9aOAek00ZlGteNxXOsoiwaXKelnknZxk1K/kDNt0WblwFxFhI3wwxNgBXiUAX7dnOeYFn6xi8qJAttXfOTbcRapcuzOwjCX03tvxhSk0D14X411WQBZ3e1Clm/gM6fJ9N5U+xkwH4ygBaMu2Prmg8f7ABU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:34323064-fb16-4aac-8078-b8ba1543fa0f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:f5d85ee8-f6fb-422f-a060-fb969ff8dbb2,B
	ulkID:nil,BulkQuantity:0,SF:102|136|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d7c04b40c78f11f1b1788b6acf885367-20261014
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1910807139; Wed, 14 Oct 2026 13:26:43 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Oct 2026 13:26:42 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 14 Oct 2026 13:26:42 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>,
	<eason.lai@mediatek.com>, yin-chun.tsai <yin-chun.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925/mt7928: add debug cmds to check TX/RX status
Date: Wed, 14 Oct 2026 13:26:40 +0800
Message-ID: <20261014052641.1609444-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: "yin-chun.tsai" <yin-chun.tsai@mediatek.com>

Add some debug cmd including, WTBL, DMASHDL, PLE, and PSE info
for checking TX/RX path status.

Signed-off-by: yin-chun.tsai <yin-chun.tsai@mediatek.com>
---
 .../wireless/mediatek/mt76/mt7925/debugfs.c   | 531 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/regs.h  |  15 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |   1 +
 .../net/wireless/mediatek/mt76/mt792x_regs.h  |  70 +++
 4 files changed, 617 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index d01ff49de47a..442275dcc128 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2023 MediaTek Inc. */
 
 #include "mt7925.h"
+#include "mac.h"
 #include "mcu.h"
 
 static int
@@ -286,6 +287,524 @@ static int mt7925_chip_reset(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_reset, NULL, mt7925_chip_reset, "%lld\n");
 
+/* WTBL dump
+ *
+ * Usage:
+ *   echo <idx> > /sys/kernel/debug/ieee80211/phy1/mt76/wtbl_idx
+ *   cat  /sys/kernel/debug/ieee80211/phy1/mt76/get_wtbl
+ *
+ * LMAC WTBL has 36 dwords per entry (connac3x).
+ */
+#define MT792x_WTBL_LMAC_DWORDS	36
+
+static int
+mt7925_wtbl_idx_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+
+	dev->wtbl_dump_idx = (u32)val;
+
+	return 0;
+}
+
+static int
+mt7925_wtbl_idx_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->wtbl_dump_idx;
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_wtbl_idx, mt7925_wtbl_idx_get,
+			 mt7925_wtbl_idx_set, "%llu\n");
+
+static int
+mt7925_wtbl_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 idx = dev->wtbl_dump_idx;
+	u32 wdu_cr, wducr_val, base;
+	u32 dw0, dw1;
+	int i;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "WTBL direct dump not supported on this interface\n");
+		return 0;
+	}
+
+	if (idx >= MT792x_WTBL_SIZE) {
+		seq_printf(s, "Invalid WTBL idx %u (max %u)\n",
+			   idx, MT792x_WTBL_SIZE - 1);
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	/* mt7925_mac_wtbl_lmac_addr() writes WDUCR group selection and
+	 * returns the mapped register address for DW 0 of this WCID.
+	 */
+	base = mt7925_mac_wtbl_lmac_addr(dev, idx, 0);
+	wdu_cr = is_mt7928(&dev->mt76) ? MT7928_WTBLON_TOP_WDUCR :
+					  MT7925_WTBLON_TOP_WDUCR;
+	wducr_val = mt76_rr(dev, wdu_cr);
+
+	/* DW0[15:0] + DW1[31:0] encode the link address */
+	dw0 = mt76_rr(dev, base);
+	dw1 = mt76_rr(dev, base + 4);
+
+	seq_printf(s, "Dump WTBL info of WLAN_IDX: %u\n", idx);
+	seq_printf(s, "LMAC WTBL Addr: group:0x%08x=0x%08x addr: 0x%08x\n",
+		   wdu_cr, wducr_val, base);
+	seq_printf(s, "LinkAddr: %02x:%02x:%02x:%02x:%02x:%02x\n",
+		   dw1 & 0xff, (dw1 >> 8) & 0xff,
+		   (dw1 >> 16) & 0xff, (dw1 >> 24) & 0xff,
+		   dw0 & 0xff, (dw0 >> 8) & 0xff);
+
+	seq_puts(s, "\nLMAC WTBL raw data:\n");
+	for (i = 0; i < MT792x_WTBL_LMAC_DWORDS; i++)
+		seq_printf(s, "DW%02d: 0x%08x\n", i,
+			   mt76_rr(dev, base + i * 4));
+
+	mt792x_mutex_release(dev);
+
+	return 0;
+}
+
+/* mt7925_dmashdl_read: standard DMASHDL (MT7925/MT7927 only).
+ * MT7928 uses DMASHDL Lite; see mt7928_dmashdl_lite_read below.
+ */
+static int
+mt7925_dmashdl_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 total_src = 0, total_rsv = 0;
+	u32 ffa_cnt, free_pg_cnt;
+	u32 ple_rsv, ple_src;
+	u32 val;
+	int i;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "DMASHDL dump not supported on this interface\n");
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	seq_puts(s, "DMASHDL Info:\n");
+
+	val = mt76_rr(dev, MT_DMASHDL_REFILL);
+	seq_printf(s, "\tRefill control(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_REFILL, val);
+
+	val = mt76_rr(dev, MT_DMASHDL_PKT_MAX_SIZE);
+	seq_printf(s, "\tPkt max size(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_PKT_MAX_SIZE, val);
+	seq_printf(s, "\t\tPLE pkt max=0x%03lx, PSE pkt max=0x%03lx\n",
+		   FIELD_GET(MT_DMASHDL_PKT_MAX_SIZE_PLE, val),
+		   FIELD_GET(MT_DMASHDL_PKT_MAX_SIZE_PSE, val));
+
+	val = mt76_rr(dev, MT_DMASHDL_ERROR_FLAG_CTRL);
+	seq_printf(s, "\tError flag ctrl(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_ERROR_FLAG_CTRL, val);
+
+	for (i = 0; i < 15; i++) {
+		u32 quota = mt76_rr(dev, MT_DMASHDL_GROUP_QUOTA(i));
+		u32 status = mt76_rr(dev, MT_DMASHDL_STATUS_RD_GP(i));
+		u32 rsv = FIELD_GET(MT_DMASHDL_STATUS_RD_GP_RSV, status);
+		u32 src = FIELD_GET(MT_DMASHDL_STATUS_RD_GP_SRC, status);
+
+		seq_printf(s, "\tGroup %2d: quota(min/max)=0x%03lx/0x%03lx, used/rsv=0x%03x/0x%03x\n",
+			   i,
+			   FIELD_GET(MT_DMASHDL_GROUP_QUOTA_MIN, quota),
+			   FIELD_GET(MT_DMASHDL_GROUP_QUOTA_MAX, quota),
+			   src, rsv);
+		total_src += src;
+		total_rsv += rsv;
+	}
+
+	val = mt76_rr(dev, MT_DMASHDL_STATUS_RD);
+	free_pg_cnt = FIELD_GET(MT_DMASHDL_STATUS_RD_FREE_PG, val);
+	ffa_cnt = FIELD_GET(MT_DMASHDL_STATUS_RD_FFA, val);
+	seq_printf(s, "\tStatus_RD(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_STATUS_RD, val);
+	seq_printf(s, "\t\tfree page cnt=0x%03x, ffa cnt=0x%03x\n",
+		   free_pg_cnt, ffa_cnt);
+
+	/* Counter mismatch check against PLE HIF page counters */
+	seq_puts(s, "\nDMASHDL Counter Check:\n");
+	val = mt76_rr(dev, MT_PLE_HIF_PG_INFO);
+	ple_rsv = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	ple_src = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	seq_printf(s, "\tPLE: used/rsv pages of HIF group=0x%03x/0x%03x\n",
+		   ple_src, ple_rsv);
+	seq_printf(s, "\tDMASHDL: total used pages of group0~14=0x%03x\n",
+		   total_src);
+	if (ple_src != total_src)
+		seq_puts(s, "\t[MISMATCH] PLE used pages != DMASHDL total used\n");
+	seq_printf(s, "\tDMASHDL: total rsv pages of group0~14=0x%03x\n",
+		   total_rsv);
+	seq_printf(s, "\tDMASHDL: total ffa pages=0x%03x, total free pages=0x%03x\n",
+		   ffa_cnt, free_pg_cnt);
+	if (free_pg_cnt != total_rsv + ffa_cnt)
+		seq_puts(s, "\t[MISMATCH] free pages != rsv + ffa\n");
+	if (free_pg_cnt != ple_rsv)
+		seq_puts(s, "\t[MISMATCH] free pages != PLE rsv pages\n");
+	if (ple_src == total_src && free_pg_cnt == total_rsv + ffa_cnt &&
+	    free_pg_cnt == ple_rsv)
+		seq_puts(s, "\tDMASHDL: no counter mismatch\n");
+
+	mt792x_mutex_release(dev);
+	return 0;
+}
+
+/* mt7928_dmashdl_lite_read: DMASHDL Lite (MT7928 only, base 0x20026200).
+ * Unlike full DMASHDL, Lite splits runtime state into separate registers:
+ *   GROUP_CONTROL (+0x100): min/max quota (config)
+ *   GROUP_SRC_CNT (+0x200): pages sourced (in-use) per group (runtime)
+ *   GROUP_ACK_CNT (+0x300): pages acknowledged (returned) per group (runtime)
+ *   GROUP_VALID   (+0x400): bitmap of groups with active page allocations
+ */
+static int
+mt7928_dmashdl_lite_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 disable0, disable1, valid0, valid1;
+	u32 total_src = 0, total_ack = 0;
+	u32 ple_rsv, ple_src;
+	u32 val;
+	int i;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "DMASHDL Lite dump not supported on this interface\n");
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	seq_puts(s, "DMASHDL Lite Info (MT7928):\n");
+
+	val = mt76_rr(dev, MT_DMASHDL_LITE_MAIN_CONTROL);
+	seq_printf(s, "\tMain control(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_MAIN_CONTROL, val);
+
+	val = mt76_rr(dev, MT_DMASHDL_LITE_PAGE_SIZE);
+	seq_printf(s, "\tPage size(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_PAGE_SIZE, val);
+	seq_printf(s, "\t\tPSE page size=0x%04lx, PLE page size=0x%04lx\n",
+		   FIELD_GET(MT_DMASHDL_LITE_PSE_PAGE_SIZE_MASK, val),
+		   FIELD_GET(MT_DMASHDL_LITE_PLE_PAGE_SIZE_MASK, val));
+
+	val = mt76_rr(dev, MT_DMASHDL_LITE_PKT_MAX_SIZE);
+	seq_printf(s, "\tPkt max size(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_PKT_MAX_SIZE, val);
+	seq_printf(s, "\t\tPSE pkt max=0x%04lx, PLE pkt max=0x%04lx\n",
+		   FIELD_GET(MT_DMASHDL_LITE_PSE_PKT_MAX_SIZE_MASK, val),
+		   FIELD_GET(MT_DMASHDL_LITE_PLE_PKT_MAX_SIZE_MASK, val));
+
+	val = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_SN_CHK0);
+	seq_printf(s, "\tGroup SN check[31:0](0x%08x):  0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_SN_CHK0, val);
+	val = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_SN_CHK1);
+	seq_printf(s, "\tGroup SN check[63:32](0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_SN_CHK1, val);
+	val = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_UDF_CHK0);
+	seq_printf(s, "\tGroup UDF check[31:0](0x%08x):  0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_UDF_CHK0, val);
+	val = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_UDF_CHK1);
+	seq_printf(s, "\tGroup UDF check[63:32](0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_UDF_CHK1, val);
+
+	disable0 = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_DISABLE0);
+	seq_printf(s, "\tGroup disable[31:0](0x%08x):  0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_DISABLE0, disable0);
+	disable1 = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_DISABLE1);
+	seq_printf(s, "\tGroup disable[63:32](0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_DISABLE1, disable1);
+
+	valid0 = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_VALID_0_31);
+	seq_printf(s, "\tGroup valid[31:0](0x%08x):  0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_VALID_0_31, valid0);
+	valid1 = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_VALID_32_63);
+	seq_printf(s, "\tGroup valid[63:32](0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_VALID_32_63, valid1);
+
+	seq_puts(s, "\tQ mapping (q2group):\n");
+	for (i = 0; i < 8; i++) {
+		val = mt76_rr(dev, MT_DMASHDL_LITE_Q_MAP(i));
+		seq_printf(s, "\t\tQ_MAP[%d](0x%08x): 0x%08x\n",
+			   i, MT_DMASHDL_LITE_Q_MAP(i), val);
+	}
+
+	seq_puts(s, "\tGroup status (skipping disabled+zero quota):\n");
+	for (i = 0; i < DMASHDL_LITE_GROUP_NUM; i++) {
+		u32 disable = i < 32 ? disable0 : disable1;
+		bool enabled = !(disable & BIT(i % 32));
+		u32 quota, min_q, max_q, src, ack_reg;
+		u32 pktin, add_ret, ret;
+
+		quota = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_QUOTA(i));
+		if (!enabled && !quota)
+			continue;
+
+		min_q = FIELD_GET(MT_DMASHDL_LITE_GROUP_MIN_QUOTA_MASK, quota);
+		max_q = FIELD_GET(MT_DMASHDL_LITE_GROUP_MAX_QUOTA_MASK, quota);
+		src     = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_SRC_CNT(i));
+		src     = FIELD_GET(MT_DMASHDL_LITE_GROUP_SRC_CNT_MASK, src);
+		ack_reg = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_ACK_CNT(i));
+		pktin   = FIELD_GET(MT_DMASHDL_LITE_ACK_PKTIN_CNT,   ack_reg);
+		add_ret = FIELD_GET(MT_DMASHDL_LITE_ACK_ADD_RET_CNT, ack_reg);
+		ret     = FIELD_GET(MT_DMASHDL_LITE_ACK_RET_CNT,     ack_reg);
+
+		seq_printf(s, "\tGroup %2d: quota(min/max)=0x%03x/0x%03x, src=0x%02x, ack(add_ret/pktin/ret)=0x%02x/0x%02x/0x%02x%s\n",
+			   i, min_q, max_q, src, add_ret, pktin, ret,
+			   enabled ? "" : " [disabled]");
+		if (enabled) {
+			total_src += src;
+			total_ack += ret;
+		}
+	}
+	seq_printf(s, "\tTotal (enabled groups): src=0x%03x, ack_ret=0x%03x\n",
+		   total_src, total_ack);
+
+	/* Counter mismatch check against PLE HIF page counters */
+	seq_puts(s, "\nDMASHDL Lite Counter Check:\n");
+	val = mt76_rr(dev, MT_PLE_HIF_PG_INFO);
+	ple_rsv = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	ple_src = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	seq_printf(s, "\tPLE: used/rsv pages of HIF group=0x%03x/0x%03x\n",
+		   ple_src, ple_rsv);
+	seq_printf(s, "\tDMASHDL Lite: total src=0x%03x, total ack_ret=0x%03x\n",
+		   total_src, total_ack);
+	if (ple_src != total_src)
+		seq_puts(s, "\t[MISMATCH] PLE used pages != DMASHDL Lite total src\n");
+	else
+		seq_puts(s, "\tDMASHDL Lite: no counter mismatch\n");
+
+	seq_puts(s, "\nPLE Page Counters:\n");
+
+	val = mt76_rr(dev, MT_PLE_FREEPG_CNT);
+	seq_printf(s, "\tPLE free pages(0x%08x): total=0x%03lx, ffa=0x%03lx\n",
+		   MT_PLE_FREEPG_CNT,
+		   FIELD_GET(MT_WF_FREEPG_FREE_CNT, val),
+		   FIELD_GET(MT_WF_FREEPG_FFA_CNT, val));
+
+	val = mt76_rr(dev, MT_PLE_HIF_WMTXD_PG_INFO);
+	seq_printf(s, "\tPLE WMTXD group(0x%08x):     used/rsv=0x%03lx/0x%03lx\n",
+		   MT_PLE_HIF_WMTXD_PG_INFO,
+		   FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val),
+		   FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val));
+
+	val = mt76_rr(dev, MT_PLE_HIF_TXCMD_PG_INFO);
+	seq_printf(s, "\tPLE HIF_TXCMD group(0x%08x): used/rsv=0x%03lx/0x%03lx\n",
+		   MT_PLE_HIF_TXCMD_PG_INFO,
+		   FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val),
+		   FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val));
+
+	val = mt76_rr(dev, MT_PLE_CPU_PG_INFO);
+	seq_printf(s, "\tPLE CPU group(0x%08x):       used/rsv=0x%03lx/0x%03lx\n",
+		   MT_PLE_CPU_PG_INFO,
+		   FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val),
+		   FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val));
+
+	mt792x_mutex_release(dev);
+	return 0;
+}
+
+static int
+mt7925_ple_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 pbuf_ctrl, val;
+	u32 fpg_cnt, ffa_cnt, fpg_head, fpg_tail;
+	u32 max_q, min_q, rsv_pg, used_pg;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "PLE dump not supported on this interface\n");
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	pbuf_ctrl = mt76_rr(dev, MT_PLE_PBUF_CTRL);
+	seq_puts(s, "PLE Configuration Info:\n");
+	seq_printf(s, "\tPacket Buffer Control(0x%08x): 0x%08x\n",
+		   MT_PLE_PBUF_CTRL, pbuf_ctrl);
+	seq_printf(s, "\t\tPage Size=%d(%d bytes/page), Offset=%d, Total=%d pages\n",
+		   (int)FIELD_GET(MT_WF_PBUF_PAGE_SIZE, pbuf_ctrl),
+		   FIELD_GET(MT_WF_PBUF_PAGE_SIZE, pbuf_ctrl) ? 128 : 64,
+		   (int)FIELD_GET(MT_WF_PBUF_PBUF_OFFSET, pbuf_ctrl),
+		   (int)FIELD_GET(MT_WF_PBUF_TOTAL_PAGES, pbuf_ctrl));
+
+	val = mt76_rr(dev, MT_PLE_INT_N9_ERR_STS);
+	seq_printf(s, "\tINT_N9_ERR_STS(0x%08x): 0x%08x\n",
+		   MT_PLE_INT_N9_ERR_STS, val);
+	val = mt76_rr(dev, MT_PLE_INT_N9_ERR_STS_1);
+	seq_printf(s, "\tINT_N9_ERR_STS_1(0x%08x): 0x%08x\n",
+		   MT_PLE_INT_N9_ERR_STS_1, val);
+
+	seq_puts(s, "PLE Page Flow Control:\n");
+
+	val = mt76_rr(dev, MT_PLE_FREEPG_CNT);
+	fpg_cnt = FIELD_GET(MT_WF_FREEPG_FREE_CNT, val);
+	ffa_cnt = FIELD_GET(MT_WF_FREEPG_FFA_CNT, val);
+	seq_printf(s, "\tFree page counter(0x%08x): 0x%08x\n",
+		   MT_PLE_FREEPG_CNT, val);
+	seq_printf(s, "\t\ttotal free=0x%03x, ffa=0x%03x\n", fpg_cnt, ffa_cnt);
+
+	val = mt76_rr(dev, MT_PLE_FREEPG_HEAD_TAIL);
+	fpg_head = FIELD_GET(MT_WF_FREEPG_HEAD, val);
+	fpg_tail = FIELD_GET(MT_WF_FREEPG_TAIL, val);
+	seq_printf(s, "\tFree page head/tail(0x%08x): 0x%08x\n",
+		   MT_PLE_FREEPG_HEAD_TAIL, val);
+	seq_printf(s, "\t\ttail/head=0x%03x/0x%03x\n", fpg_tail, fpg_head);
+
+	/* HIF group */
+	val = mt76_rr(dev, MT_PLE_PG_HIF_GROUP);
+	max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);
+	min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);
+	seq_printf(s, "\tHIF group quota(0x%08x): 0x%08x (max/min=0x%03x/0x%03x)\n",
+		   MT_PLE_PG_HIF_GROUP, val, max_q, min_q);
+	val = mt76_rr(dev, MT_PLE_HIF_PG_INFO);
+	used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	seq_printf(s, "\tHIF group status(0x%08x): 0x%08x (used/rsv=0x%03x/0x%03x)\n",
+		   MT_PLE_HIF_PG_INFO, val, used_pg, rsv_pg);
+
+	/* WMTXD group */
+	val = mt76_rr(dev, MT_PLE_PG_HIF_WMTXD_GROUP);
+	max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);
+	min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);
+	seq_printf(s, "\tWMTXD group quota(0x%08x): 0x%08x (max/min=0x%03x/0x%03x)\n",
+		   MT_PLE_PG_HIF_WMTXD_GROUP, val, max_q, min_q);
+	val = mt76_rr(dev, MT_PLE_HIF_WMTXD_PG_INFO);
+	used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	seq_printf(s, "\tWMTXD group status(0x%08x): 0x%08x (used/rsv=0x%03x/0x%03x)\n",
+		   MT_PLE_HIF_WMTXD_PG_INFO, val, used_pg, rsv_pg);
+
+	/* HIF_TXCMD group */
+	val = mt76_rr(dev, MT_PLE_PG_HIF_TXCMD_GROUP);
+	max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);
+	min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);
+	seq_printf(s, "\tHIF_TXCMD group quota(0x%08x): 0x%08x (max/min=0x%03x/0x%03x)\n",
+		   MT_PLE_PG_HIF_TXCMD_GROUP, val, max_q, min_q);
+	val = mt76_rr(dev, MT_PLE_HIF_TXCMD_PG_INFO);
+	used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	seq_printf(s, "\tHIF_TXCMD group status(0x%08x): 0x%08x (used/rsv=0x%03x/0x%03x)\n",
+		   MT_PLE_HIF_TXCMD_PG_INFO, val, used_pg, rsv_pg);
+
+	/* CPU group */
+	val = mt76_rr(dev, MT_PLE_PG_CPU_GROUP);
+	max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);
+	min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);
+	seq_printf(s, "\tCPU group quota(0x%08x): 0x%08x (max/min=0x%03x/0x%03x)\n",
+		   MT_PLE_PG_CPU_GROUP, val, max_q, min_q);
+	val = mt76_rr(dev, MT_PLE_CPU_PG_INFO);
+	used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	seq_printf(s, "\tCPU group status(0x%08x): 0x%08x (used/rsv=0x%03x/0x%03x)\n",
+		   MT_PLE_CPU_PG_INFO, val, used_pg, rsv_pg);
+
+	val = mt76_rr(dev, MT_PLE_QUEUE_EMPTY);
+	seq_printf(s, "\tQueue empty(0x%08x): 0x%08x%s\n",
+		   MT_PLE_QUEUE_EMPTY, val,
+		   (val & MT_PLE_QUEUE_EMPTY_ALL_AC) ? " [ALL AC EMPTY]" : "");
+
+	mt792x_mutex_release(dev);
+	return 0;
+}
+
+static int
+mt7925_pse_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 pbuf_ctrl, val;
+	u32 fpg_cnt, ffa_cnt, fpg_head, fpg_tail;
+	u32 max_q, min_q, rsv_pg, used_pg;
+	static const struct {
+		const char *name;
+		u32 qreg, ireg;
+	} pse_groups[] = {
+		{ "HIF0",  MT_PSE_PG_HIF0_GROUP,  MT_PSE_HIF0_PG_INFO },
+		{ "HIF1",  MT_PSE_PG_HIF1_GROUP,  MT_PSE_HIF1_PG_INFO },
+		{ "HIF2",  MT_PSE_PG_HIF2_GROUP,  MT_PSE_HIF2_PG_INFO },
+		{ "CPU",   MT_PSE_PG_CPU_GROUP,   MT_PSE_CPU_PG_INFO },
+		{ "PLE",   MT_PSE_PG_PLE_GROUP,   MT_PSE_PLE_PG_INFO },
+		{ "LMAC0", MT_PSE_PG_LMAC0_GROUP, MT_PSE_LMAC0_PG_INFO },
+		{ "LMAC1", MT_PSE_PG_LMAC1_GROUP, MT_PSE_LMAC1_PG_INFO },
+		{ "LMAC2", MT_PSE_PG_LMAC2_GROUP, MT_PSE_LMAC2_PG_INFO },
+		{ "LMAC3", MT_PSE_PG_LMAC3_GROUP, MT_PSE_LMAC3_PG_INFO },
+		{ "MDP",   MT_PSE_PG_MDP_GROUP,   MT_PSE_MDP_PG_INFO },
+	};
+	int i;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "PSE dump not supported on this interface\n");
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	pbuf_ctrl = mt76_rr(dev, MT_PSE_PBUF_CTRL);
+	seq_puts(s, "PSE Configuration Info:\n");
+	seq_printf(s, "\tPacket Buffer Control(0x%08x): 0x%08x\n",
+		   MT_PSE_PBUF_CTRL, pbuf_ctrl);
+	seq_printf(s, "\t\tPage Size=%d(%d bytes/page), Offset=%d, Total=%d pages\n",
+		   (int)FIELD_GET(MT_WF_PBUF_PAGE_SIZE, pbuf_ctrl),
+		   FIELD_GET(MT_WF_PBUF_PAGE_SIZE, pbuf_ctrl) ? 256 : 128,
+		   (int)FIELD_GET(MT_WF_PBUF_PBUF_OFFSET, pbuf_ctrl),
+		   (int)FIELD_GET(MT_WF_PBUF_TOTAL_PAGES, pbuf_ctrl));
+
+	val = mt76_rr(dev, MT_PSE_INT_N9_ERR_STS);
+	seq_printf(s, "\tINT_N9_ERR_STS(0x%08x): 0x%08x\n",
+		   MT_PSE_INT_N9_ERR_STS, val);
+	val = mt76_rr(dev, MT_PSE_INT_N9_ERR1_STS);
+	seq_printf(s, "\tINT_N9_ERR1_STS(0x%08x): 0x%08x\n",
+		   MT_PSE_INT_N9_ERR1_STS, val);
+
+	val = mt76_rr(dev, MT_PSE_QUEUE_EMPTY);
+	seq_printf(s, "\tQueue empty(0x%08x): 0x%08x\n",
+		   MT_PSE_QUEUE_EMPTY, val);
+
+	seq_puts(s, "PSE Page Flow Control:\n");
+
+	val = mt76_rr(dev, MT_PSE_FREEPG_CNT);
+	fpg_cnt = FIELD_GET(MT_WF_FREEPG_FREE_CNT, val);
+	ffa_cnt = FIELD_GET(MT_WF_FREEPG_FFA_CNT, val);
+	seq_printf(s, "\tFree page counter(0x%08x): 0x%08x\n",
+		   MT_PSE_FREEPG_CNT, val);
+	seq_printf(s, "\t\ttotal free=0x%03x, ffa=0x%03x\n", fpg_cnt, ffa_cnt);
+
+	val = mt76_rr(dev, MT_PSE_FREEPG_HEAD_TAIL);
+	fpg_head = FIELD_GET(MT_WF_FREEPG_HEAD, val);
+	fpg_tail = FIELD_GET(MT_WF_FREEPG_TAIL, val);
+	seq_printf(s, "\tFree page head/tail(0x%08x): 0x%08x\n",
+		   MT_PSE_FREEPG_HEAD_TAIL, val);
+	seq_printf(s, "\t\ttail/head=0x%03x/0x%03x\n", fpg_tail, fpg_head);
+
+	for (i = 0; i < ARRAY_SIZE(pse_groups); i++) {
+		u32 qreg = pse_groups[i].qreg, ireg = pse_groups[i].ireg;
+
+		val = mt76_rr(dev, qreg);
+		max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);
+		min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);
+		seq_printf(s, "\t%s group quota(0x%08x): 0x%08x (max/min=0x%03x/0x%03x)\n",
+			   pse_groups[i].name, qreg, val, max_q, min_q);
+
+		val = mt76_rr(dev, ireg);
+		used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+		rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+		seq_printf(s, "\t%s group status(0x%08x): 0x%08x (used/rsv=0x%03x/0x%03x)\n",
+			   pse_groups[i].name, ireg, val, used_pg, rsv_pg);
+	}
+
+	mt792x_mutex_release(dev);
+	return 0;
+}
+
 int mt7925_init_debugfs(struct mt792x_dev *dev)
 {
 	struct dentry *dir;
@@ -313,5 +832,17 @@ int mt7925_init_debugfs(struct mt792x_dev *dev)
 				    mt792x_pm_stats);
 	debugfs_create_file("deep-sleep", 0600, dir, dev, &fops_ds);
 
+	debugfs_create_file("wtbl_idx", 0600, dir, dev, &fops_wtbl_idx);
+	debugfs_create_devm_seqfile(dev->mt76.dev, "get_wtbl", dir,
+				    mt7925_wtbl_read);
+	debugfs_create_devm_seqfile(dev->mt76.dev, "dmashdl_info", dir,
+				    is_mt7928(&dev->mt76) ?
+				    mt7928_dmashdl_lite_read :
+				    mt7925_dmashdl_read);
+	debugfs_create_devm_seqfile(dev->mt76.dev, "ple_info", dir,
+				    mt7925_ple_read);
+	debugfs_create_devm_seqfile(dev->mt76.dev, "pse_info", dir,
+				    mt7925_pse_read);
+
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
index e040dff321dd..8d7e995c8fb8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
@@ -131,8 +131,23 @@
 #define MT_DMASHDL_LITE_GROUP_UDF_CHK0		MT_DMASHDL_LITE(0x020)
 #define MT_DMASHDL_LITE_GROUP_UDF_CHK1		MT_DMASHDL_LITE(0x024)
 #define MT_DMASHDL_LITE_Q_MAPPING0		MT_DMASHDL_LITE(0x028)
+#define MT_DMASHDL_LITE_Q_MAP(_n)	MT_DMASHDL_LITE(0x028 + ((_n) << 2))
 #define MT_DMASHDL_LITE_GROUP0_QUOTA		MT_DMASHDL_LITE(0x100)
+#define MT_DMASHDL_LITE_GROUP_QUOTA(_n)	MT_DMASHDL_LITE(0x100 + ((_n) << 2))
 #define MT_DMASHDL_LITE_GROUP_MIN_QUOTA_MASK		GENMASK(12, 0)
 #define MT_DMASHDL_LITE_GROUP_MAX_QUOTA_MASK		GENMASK(28, 16)
 
+/* DMASHDL Lite per-group runtime status registers */
+#define MT_DMASHDL_LITE_GROUP_SRC_CNT(_n)	\
+	MT_DMASHDL_LITE(0x200 + ((_n) << 2))
+#define MT_DMASHDL_LITE_GROUP_SRC_CNT_MASK	GENMASK(12, 0)
+#define MT_DMASHDL_LITE_GROUP_ACK_CNT(_n)	\
+	MT_DMASHDL_LITE(0x300 + ((_n) << 2))
+/* ACK_CNT[23:0]: [7:0]=pktin_cnt, [15:8]=add_return_cnt, [23:16]=return_cnt */
+#define MT_DMASHDL_LITE_ACK_PKTIN_CNT		GENMASK(7, 0)
+#define MT_DMASHDL_LITE_ACK_ADD_RET_CNT		GENMASK(15, 8)
+#define MT_DMASHDL_LITE_ACK_RET_CNT		GENMASK(23, 16)
+#define MT_DMASHDL_LITE_GROUP_VALID_0_31	MT_DMASHDL_LITE(0x400)
+#define MT_DMASHDL_LITE_GROUP_VALID_32_63	MT_DMASHDL_LITE(0x404)
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index a7d71e007da0..361e87a0f867 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -324,6 +324,7 @@ struct mt792x_dev {
 
 	u8 fw_debug;
 	u8 fw_features;
+	u32 wtbl_dump_idx;
 
 	struct mt76_connac_pm pm;
 	struct mt76_connac_coredump coredump;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_regs.h b/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
index 3587f61e098a..be15ca62ef6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_regs.h
@@ -526,4 +526,74 @@
 #define MT7927_PCIE2AP_REMAP_WF_0_54_VAL	0x00001807
 #define MT7927_SEMA_OWN_STA			0x40000
 #define MT7927_SEMA_OWN_STA_REP			0x40400
+
+/* PLE additional registers for debugfs */
+#define MT_PLE_PBUF_CTRL		MT_PLE(0x004)
+#define MT_PLE_PG_HIF_GROUP		MT_PLE(0x00c)
+#define MT_PLE_PG_HIF_WMTXD_GROUP	MT_PLE(0x010)
+#define MT_PLE_PG_HIF_TXCMD_GROUP	MT_PLE(0x014)
+#define MT_PLE_PG_CPU_GROUP		MT_PLE(0x018)
+#define MT_PLE_INT_N9_ERR_STS		MT_PLE(0x304)
+#define MT_PLE_INT_N9_ERR_STS_1	MT_PLE(0x308)
+#define MT_PLE_QUEUE_EMPTY		MT_PLE(0x360)
+#define MT_PLE_QUEUE_EMPTY_ALL_AC	BIT(24)
+#define MT_PLE_FREEPG_CNT		MT_PLE(0x3a0)
+#define MT_PLE_FREEPG_HEAD_TAIL		MT_PLE(0x3a4)
+#define MT_PLE_HIF_PG_INFO		MT_PLE(0x3a8)
+#define MT_PLE_HIF_WMTXD_PG_INFO	MT_PLE(0x3ac)
+#define MT_PLE_HIF_TXCMD_PG_INFO	MT_PLE(0x3b0)
+#define MT_PLE_CPU_PG_INFO		MT_PLE(0x3b4)
+
+/* Common field masks shared by PLE/PSE group quota and page info registers */
+#define MT_WF_GROUP_QUOTA_MAX		GENMASK(27, 16)
+#define MT_WF_GROUP_QUOTA_MIN		GENMASK(11, 0)
+#define MT_WF_PG_INFO_SRC_CNT		GENMASK(27, 16)
+#define MT_WF_PG_INFO_RSV_CNT		GENMASK(11, 0)
+#define MT_WF_FREEPG_FFA_CNT		GENMASK(27, 16)
+#define MT_WF_FREEPG_FREE_CNT		GENMASK(11, 0)
+#define MT_WF_FREEPG_TAIL		GENMASK(27, 16)
+#define MT_WF_FREEPG_HEAD		GENMASK(11, 0)
+#define MT_WF_PBUF_PAGE_SIZE		BIT(31)
+#define MT_WF_PBUF_PBUF_OFFSET		GENMASK(25, 17)
+#define MT_WF_PBUF_TOTAL_PAGES		GENMASK(11, 0)
+
+/* PSE */
+#define MT_PSE(ofs)			(MT_PSE_BASE + (ofs))
+#define MT_PSE_PBUF_CTRL		MT_PSE(0x004)
+#define MT_PSE_INT_N9_ERR_STS		MT_PSE(0x034)
+#define MT_PSE_INT_N9_ERR1_STS		MT_PSE(0x038)
+#define MT_PSE_QUEUE_EMPTY		MT_PSE(0x0b0)
+#define MT_PSE_PG_HIF0_GROUP		MT_PSE(0x110)
+#define MT_PSE_PG_HIF1_GROUP		MT_PSE(0x114)
+#define MT_PSE_PG_CPU_GROUP		MT_PSE(0x118)
+#define MT_PSE_PG_PLE_GROUP		MT_PSE(0x11c)
+#define MT_PSE_PG_LMAC0_GROUP		MT_PSE(0x124)
+#define MT_PSE_PG_LMAC1_GROUP		MT_PSE(0x128)
+#define MT_PSE_PG_LMAC2_GROUP		MT_PSE(0x12c)
+#define MT_PSE_PG_LMAC3_GROUP		MT_PSE(0x130)
+#define MT_PSE_PG_MDP_GROUP		MT_PSE(0x134)
+#define MT_PSE_PG_HIF2_GROUP		MT_PSE(0x140)
+#define MT_PSE_HIF0_PG_INFO		MT_PSE(0x150)
+#define MT_PSE_HIF1_PG_INFO		MT_PSE(0x154)
+#define MT_PSE_CPU_PG_INFO		MT_PSE(0x158)
+#define MT_PSE_PLE_PG_INFO		MT_PSE(0x15c)
+#define MT_PSE_LMAC0_PG_INFO		MT_PSE(0x164)
+#define MT_PSE_LMAC1_PG_INFO		MT_PSE(0x168)
+#define MT_PSE_LMAC2_PG_INFO		MT_PSE(0x16c)
+#define MT_PSE_LMAC3_PG_INFO		MT_PSE(0x170)
+#define MT_PSE_MDP_PG_INFO		MT_PSE(0x174)
+#define MT_PSE_HIF2_PG_INFO		MT_PSE(0x180)
+#define MT_PSE_FREEPG_CNT		MT_PSE(0x3a0)
+#define MT_PSE_FREEPG_HEAD_TAIL		MT_PSE(0x3a4)
+
+/* DMASHDL additional registers for debugfs */
+#define MT_DMASHDL_ERROR_FLAG_CTRL	MT_DMA_SHDL(0x0dc)
+#define MT_DMASHDL_STATUS_RD		MT_DMA_SHDL(0x100)
+#define MT_DMASHDL_STATUS_RD_FREE_PG	GENMASK(27, 16)
+#define MT_DMASHDL_STATUS_RD_FFA	GENMASK(11, 0)
+#define MT_DMASHDL_STATUS_RD_GP(_n)	MT_DMA_SHDL(0x140 + ((_n) << 2))
+#define MT_DMASHDL_STATUS_RD_GP_RSV	GENMASK(27, 16)
+#define MT_DMASHDL_STATUS_RD_GP_SRC	GENMASK(11, 0)
+#define MT_DMASHDL_RD_GP_PKT_CNT(_n)	MT_DMA_SHDL(0x180 + ((_n) << 2))
+
 #endif /* __MT792X_REGS_H */
-- 
2.18.0

