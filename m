Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793071974;
	b=orEBBp/7KEW0wD8yrYqWhC1Y2oQ7Usx+2TlCzcWhZhhoDRMH6ra9ZTVkpFoHTm/N6AZ5
	 FLdJDnbUybpe/HX45mMS97ziw97WZjcyP79mvDjaYUjPGUlDu4vx9KUXc8qpbSoV2l2MH
	 KnyuuVc6SIvfKtCxAHanD9mY3uc71mwm+mxG7C2M00YlgQYG+zyqo/ubFZmUqXyeLuWUg
	 U7BosFFHLUBGXCmHTRel9rMZwqKMci9r5rk0BnO2EEdAB/ZGBl2hGkJPjc4v87mg0CdtW
	 4+f1Uhds/DghWePYLARvY/agw0R3c56GnzVBU26wHsfbK9IIV0q6hcV49uab4e56L8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793071974;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-MTK;
	bh=0IS8bvbb4WV+8sGmQv90uDMel32JWDdTT4z51qDcK3k=;
	b=gH/mPKj88FiL7i93HbvEW310S0QyRR1Rv1qlrtrQ0V/8nA6YnNuePD8NuJaDpKUW5eBz
	 89iL3XPEn0RehalN3sEStOv3hbRRS6viSjFqmVWGRNtbYSooxi8BM7P4HLjimgaViGfbH
	 r2p/cl4nUsl7YdNdU5i4lE6yWQ/HXagiypeQudDZEVRqdM3gFVPLiNYJttBLUemP/C7Qc
	 Gmv5+IVJkQvfpfxX2quUBjQTs/X9GZ5HseTYolAGF+Go+VQmvaWtc3Sk7NUiB/7WcHhk6
	 huPUsM/yUw+s/HulS6yMOArVoa8GSM/juIDN8frv0bRkse1xbJW3HwvQE3BDS0KMWTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=C1Xw80g6;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF796606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 03:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF796606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=C1Xw80g6
X-UUID: 0ff3206ad1b711f1b1788b6acf885367-20261027
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0IS8bvbb4WV+8sGmQv90uDMel32JWDdTT4z51qDcK3k=;
	b=C1Xw80g6vmOdnnF/q++Pf8tmg6laNkql5iEyw/XPpGK5H3OXbyg7dLS8M2OEaz5dH0zNr6mW6lXZ/tOj4yOhqvnhEdCxId1lHxBpFbOz/4YEHqtSbk2sjyrBGKIy+Z9WCiu8QaUHKu/IMYD+7+K2QkCahHETp/dXakUfxfztEe0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:0cb5add7-2562-43a4-9fb0-60e017ab7f46,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:291e20b,CLOUDID:ebb66e3d-7132-4bd9-9ada-f79a4f8833bf,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0ff3206ad1b711f1b1788b6acf885367-20261027
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 683280670; Tue, 27 Oct 2026 11:32:40 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 27 Oct 2026 11:32:38 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 27 Oct 2026 11:32:38 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Yung-lun.Chien@mediatek.com>,
	<jb.tsai@mediatek.com>, allen.chien <yung-lun.chien@mediatek.com>
Subject: [PATCH] wifi: mt76: add set_chip/get_chip debugfs for chip_config
Date: Tue, 27 Oct 2026 11:32:37 +0800
Message-ID: <20261027033237.288611-1-jb.tsai@mediatek.com>
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
X-MTK: N

From: "allen.chien" <yung-lun.chien@mediatek.com>

Add set_chip/get_chip debugfs for chip_config in mt76 driver

Signed-off-by: allen.chien <yung-lun.chien@mediatek.com>
---
 .../wireless/mediatek/mt76/mt7925/debugfs.c   | 180 ++++++++++++++++--
 1 file changed, 169 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index 9a5ea12b76c7..060ab59f969d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /* Copyright (C) 2023 MediaTek Inc. */
 
+#include <linux/seq_buf.h>
+
 #include "mt7925.h"
 #include "mcu.h"
 
@@ -286,13 +288,172 @@ static int mt7925_chip_reset(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_reset, NULL, mt7925_chip_reset, "%lld\n");
 
+#define MT7925_CHIP_CONFIG_SIZE	sizeof_field(struct mt76_connac_config, data)
+#define MT7925_CHIP_CONFIG_COLS	16
+/* Max reply is MT7925_CHIP_CONFIG_SIZE bytes. A full binary dump is the
+ * worst form: 16 bytes/row as "%04x: %*ph" = 20 * (6 + 47 + 1) = 1080
+ * chars + NUL, well under the 4x budget below. seq_buf bounds writes.
+ */
+#define MT7925_CHIP_CONFIG_DUMP_SIZE	(MT7925_CHIP_CONFIG_SIZE * 4)
+
+struct mt7925_chip_config_dbg {
+	struct mt792x_dev *dev;
+	int len;
+	char resp[MT7925_CHIP_CONFIG_DUMP_SIZE];
+};
+
+static char *
+mt7925_chip_config_copy_cmd(const char __user *userbuf, size_t count,
+			    char *buf, size_t buf_size)
+{
+	if (!count || count >= buf_size)
+		return ERR_PTR(-EINVAL);
+
+	if (copy_from_user(buf, userbuf, count))
+		return ERR_PTR(-EFAULT);
+
+	buf[count] = '\0';
+	buf = strim(buf);
+
+	return buf[0] ? buf : ERR_PTR(-EINVAL);
+}
+
+/* Format a firmware chip_config reply into buf; returns the number of bytes
+ * written (not counting the NUL seq_buf appends). An empty reply prints
+ * "no reply", an ASCII reply is printed verbatim, and a binary reply is
+ * dumped in MT7925_CHIP_CONFIG_COLS-byte rows. seq_buf tracks the write
+ * offset and stops on overflow, so the caller never has to budget bytes.
+ * Shared by get_chip and coex_info so the formatting logic lives in one
+ * place.
+ */
+static int
+mt7925_chip_config_format(char *buf, size_t size, u8 resp_type,
+			  const u8 *resp, int ret)
+{
+	struct seq_buf s;
+	int i;
+
+	seq_buf_init(&s, buf, size);
+
+	if (!ret)
+		seq_buf_puts(&s, "no reply\n");
+	else if (resp_type == CHIP_CONFIG_TYPE_ASCII)
+		seq_buf_printf(&s, "%.*s\n", ret, resp);
+	else
+		for (i = 0; i < ret; i += MT7925_CHIP_CONFIG_COLS)
+			seq_buf_printf(&s, "%04x: %*ph\n", i,
+				       min_t(int, MT7925_CHIP_CONFIG_COLS,
+					     ret - i), resp + i);
+
+	return seq_buf_used(&s);
+}
+
+static ssize_t
+mt7925_set_chip_write(struct file *file, const char __user *userbuf,
+		      size_t count, loff_t *ppos)
+{
+	struct mt792x_dev *dev = file->private_data;
+	char buf[MT7925_CHIP_CONFIG_SIZE];
+	char *cmd;
+	int ret;
+
+	cmd = mt7925_chip_config_copy_cmd(userbuf, count, buf, sizeof(buf));
+	if (IS_ERR(cmd))
+		return PTR_ERR(cmd);
+
+	mt792x_mutex_acquire(dev);
+	ret = mt7925_mcu_chip_config(dev, cmd);
+	mt792x_mutex_release(dev);
+
+	return ret ? ret : count;
+}
+
+static ssize_t
+mt7925_get_chip_write(struct file *file, const char __user *userbuf,
+		      size_t count, loff_t *ppos)
+{
+	struct mt7925_chip_config_dbg *ctx = file->private_data;
+	u8 resp[MT7925_CHIP_CONFIG_SIZE], resp_type;
+	char buf[MT7925_CHIP_CONFIG_SIZE];
+	int ret;
+	char *cmd;
+
+	cmd = mt7925_chip_config_copy_cmd(userbuf, count, buf, sizeof(buf));
+	if (IS_ERR(cmd))
+		return PTR_ERR(cmd);
+
+	mt792x_mutex_acquire(ctx->dev);
+	ret = mt7925_mcu_chip_config_query(ctx->dev, cmd, &resp_type, resp,
+					   sizeof(resp));
+	mt792x_mutex_release(ctx->dev);
+
+	ctx->len = 0;
+	if (ret < 0)
+		return ret;
+
+	ctx->len = mt7925_chip_config_format(ctx->resp, sizeof(ctx->resp),
+					     resp_type, resp, ret);
+
+	return count;
+}
+
+static ssize_t
+mt7925_get_chip_read(struct file *file, char __user *userbuf, size_t count,
+		     loff_t *ppos)
+{
+	struct mt7925_chip_config_dbg *ctx = file->private_data;
+
+	return simple_read_from_buffer(userbuf, count, ppos, ctx->resp,
+				       ctx->len);
+}
+
+static const struct file_operations fops_set_chip = {
+	.write = mt7925_set_chip_write,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static int mt7925_get_chip_open(struct inode *inode, struct file *file)
+{
+	struct mt792x_dev *dev = inode->i_private;
+	struct mt7925_chip_config_dbg *ctx;
+
+	ctx = kzalloc_obj(*ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->dev = dev;
+	file->private_data = ctx;
+
+	return 0;
+}
+
+static int mt7925_get_chip_release(struct inode *inode, struct file *file)
+{
+	struct mt7925_chip_config_dbg *ctx = file->private_data;
+
+	kfree(ctx);
+
+	return 0;
+}
+
+static const struct file_operations fops_get_chip = {
+	.read = mt7925_get_chip_read,
+	.write = mt7925_get_chip_write,
+	.open = mt7925_get_chip_open,
+	.release = mt7925_get_chip_release,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static int
 mt7925_coex_info(struct seq_file *s, void *data)
 {
-#define MT7925_CHIP_CONFIG_RESP_SIZE	320
 	struct mt792x_dev *dev = dev_get_drvdata(s->private);
-	u8 resp[MT7925_CHIP_CONFIG_RESP_SIZE], resp_type;
-	int i, ret;
+	char out[MT7925_CHIP_CONFIG_DUMP_SIZE];
+	u8 resp[MT7925_CHIP_CONFIG_SIZE], resp_type;
+	int ret;
 
 	mt792x_mutex_acquire(dev);
 	ret = mt7925_mcu_chip_config_query(dev, "coexBwcGetModeInfo 0",
@@ -302,14 +463,8 @@ mt7925_coex_info(struct seq_file *s, void *data)
 	if (ret < 0)
 		return ret;
 
-	if (!ret)
-		seq_puts(s, "no reply\n");
-	else if (resp_type == CHIP_CONFIG_TYPE_ASCII)
-		seq_printf(s, "%.*s\n", ret, resp);
-	else
-		for (i = 0; i < ret; i += 16)
-			seq_printf(s, "%04x: %*ph\n", i,
-				   min_t(int, 16, ret - i), resp + i);
+	ret = mt7925_chip_config_format(out, sizeof(out), resp_type, resp, ret);
+	seq_printf(s, "%.*s", ret, out);
 
 	return 0;
 }
@@ -339,6 +494,9 @@ int mt7925_init_debugfs(struct mt792x_dev *dev)
 	debugfs_create_file("chip_reset", 0600, dir, dev, &fops_reset);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "coex_info", dir,
 				    mt7925_coex_info);
+	debugfs_create_file("set_chip", 0200, dir, dev, &fops_set_chip);
+	/* pass dev as data: mt7925_get_chip_open() reads it from i_private */
+	debugfs_create_file("get_chip", 0600, dir, dev, &fops_get_chip);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "runtime_pm_stats", dir,
 				    mt792x_pm_stats);
 	debugfs_create_file("deep-sleep", 0600, dir, dev, &fops_ds);
-- 
2.45.2

