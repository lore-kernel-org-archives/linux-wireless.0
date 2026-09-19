Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57392931D1;
	Sat, 19 Sep 2026 04:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789793111; cv=none; b=qaOFJHJ4uz/GiOtlWC22IkCqDhQV+KNMz3RYhSgu49SpQjikuMYVQb2LHTAyQ9msnFSqOPib+ovnr+Yl3UZkyFFjHM2vP5sdyoXlIjpgk+XjAO7BIsnm1E1LB7WZ6fwF8Zwfy3CjmBMq3k6DqmEdFBiZNRBVXRWoL8z/fbNtLXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789793111; c=relaxed/simple;
	bh=tn5UyaY0sIz5INcdZqqOxiKNSUE0fNcnvk+hv7WkAgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmjIpuTjDPjoCipqa7bxaZTanyHmZPDfAjasV2QnfSsauxKJ3VJuQxPl/XYGkM+SjpXP4F/L6QyawnJGUZqTbxrmRIQOV9+67lgQklQ5Do0NvKI2KPG4cCf/RA1EyX1i0FlPpilQjbqLmOX536ms5q3XWF8TJVjFCAtpITkRxCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AKcqY8A2; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AKcqY8A2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=RE
	xx4dUZuU5Mr/0HfnLBTiwlji4x3nTp/rvQE3Ef/5o=; b=AKcqY8A2mUzl4Fxjb7
	WQ/WHAN38xFK5qRpkdHVSfibeh4TbZamMEsNh37HbxbZBU9oEm/9CTH1L6JPG0jF
	nulqHt7vNFo9miiLsyXJkyf4f4rWHm+W2e4HTW/lHtHYi28bY2tFkzoqM0+bzazE
	QD8GgwNpm45PSVCw+spTF2vhQ=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD35yo7E65qH1DFBg--.16668S2;
	Sat, 19 Sep 2026 12:44:45 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: jeff.chen_1@nxp.com
Cc: francesco@dolcini.it,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] wifi: nxpwifi: bound debug info output
Date: Sat, 19 Sep 2026 12:44:39 +0800
Message-ID: <20260919044439.1042-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
In-Reply-To: <20260919040253.590-1-thy15333007817@163.com>
References: <20260919040253.590-1-thy15333007817@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD35yo7E65qH1DFBg--.16668S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GF4UJw1kJrykCF1fCFyrCrg_yoW7AFWxpa
	15trW8Wr4fXrnxGrWkKa1UA3WrXanIvrWfu395AanxJayvyrySvr1FgFWF9ryDCr4UJFna
	yF4DK3WrGF17GrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jehFxUUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4R0aw2quEz1gSgAA3l

nxpwifi_debug_read() provides a PAGE_SIZE buffer to
nxpwifi_debug_info_to_buffer(), which formats debug state with
unbounded sprintf() calls. The same helper is also used for the firmware
dump.

Pass the output size to the helper and use scnprintf() while formatting.
Clamp the debug table counts and window size to the backing array lengths
before accessing them.

Assisted-by: LLM
Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
 drivers/net/wireless/nxp/nxpwifi/debugfs.c |  2 +-
 drivers/net/wireless/nxp/nxpwifi/main.c    |  5 ++-
 drivers/net/wireless/nxp/nxpwifi/util.c    | 43 +++++++++++++---------
 drivers/net/wireless/nxp/nxpwifi/util.h    |  1 +
 4 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/debugfs.c b/drivers/net/wireless/nxp/nxpwifi/debugfs.c
index fd738a811..cd6e73a21 100644
--- a/drivers/net/wireless/nxp/nxpwifi/debugfs.c
+++ b/drivers/net/wireless/nxp/nxpwifi/debugfs.c
@@ -304,7 +304,7 @@ nxpwifi_debug_read(struct file *file, char __user *ubuf,
 	if (ret)
 		goto free_and_exit;
 
-	p += nxpwifi_debug_info_to_buffer(priv, p, &info);
+	p += nxpwifi_debug_info_to_buffer(priv, p, PAGE_SIZE, &info);
 
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *)page,
 				      (unsigned long)p - page);
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.c b/drivers/net/wireless/nxp/nxpwifi/main.c
index 55b962430..b4cac1df9 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.c
+++ b/drivers/net/wireless/nxp/nxpwifi/main.c
@@ -1113,7 +1113,10 @@ void nxpwifi_drv_info_dump(struct nxpwifi_adapter *adapter)
 				continue;
 			priv = adapter->priv[i];
 			nxpwifi_get_debug_info(priv, debug_info);
-			p += nxpwifi_debug_info_to_buffer(priv, p, debug_info);
+			p += nxpwifi_debug_info_to_buffer(priv, p,
+					  NXPWIFI_FW_DUMP_SIZE -
+					  (p - (char *)adapter->devdump_data),
+					  debug_info);
 			break;
 		}
 		kfree(debug_info);
diff --git a/drivers/net/wireless/nxp/nxpwifi/util.c b/drivers/net/wireless/nxp/nxpwifi/util.c
index bbfefb81d..27a91e205 100644
--- a/drivers/net/wireless/nxp/nxpwifi/util.c
+++ b/drivers/net/wireless/nxp/nxpwifi/util.c
@@ -220,19 +220,24 @@ int nxpwifi_get_debug_info(struct nxpwifi_private *priv,
 }
 
 int nxpwifi_debug_info_to_buffer(struct nxpwifi_private *priv, char *buf,
+				 size_t buf_size,
 				 struct nxpwifi_debug_info *info)
 {
-	char *p = buf;
+	size_t used = 0;
 	struct nxpwifi_debug_data *d = &items[0];
 	size_t size, addr;
 	long val;
+	u32 tx_tbl_num, rx_tbl_num, win_size;
 	int i, j;
 
 	if (!info)
 		return 0;
 
+	tx_tbl_num = min_t(u32, info->tx_tbl_num, ARRAY_SIZE(info->tx_tbl));
+	rx_tbl_num = min_t(u32, info->rx_tbl_num, ARRAY_SIZE(info->rx_tbl));
+
 	for (i = 0; i < num_of_items; i++) {
-		p += sprintf(p, "%s=", d[i].name);
+		used += scnprintf(buf + used, buf_size - used, "%s=", d[i].name);
 
 		size = d[i].size / d[i].num;
 
@@ -260,41 +265,43 @@ int nxpwifi_debug_info_to_buffer(struct nxpwifi_private *priv, char *buf,
 				break;
 			}
 
-			p += sprintf(p, "%#lx ", val);
+			used += scnprintf(buf + used, buf_size - used, "%#lx ", val);
 			addr += size;
 		}
 
-		p += sprintf(p, "\n");
+		used += scnprintf(buf + used, buf_size - used, "\n");
 	}
 
-	if (info->tx_tbl_num) {
-		p += sprintf(p, "Tx BA stream table:\n");
-		for (i = 0; i < info->tx_tbl_num; i++)
-			p += sprintf(p, "tid = %d, ra = %pM\n",
+	if (tx_tbl_num) {
+		used += scnprintf(buf + used, buf_size - used, "Tx BA stream table:\n");
+		for (i = 0; i < tx_tbl_num; i++)
+			used += scnprintf(buf + used, buf_size - used, "tid = %d, ra = %pM\n",
 				     info->tx_tbl[i].tid, info->tx_tbl[i].ra);
 	}
 
-	if (info->rx_tbl_num) {
-		p += sprintf(p, "Rx reorder table:\n");
-		for (i = 0; i < info->rx_tbl_num; i++) {
-			p += sprintf(p, "tid = %d, ta = %pM, ",
+	if (rx_tbl_num) {
+		used += scnprintf(buf + used, buf_size - used, "Rx reorder table:\n");
+		for (i = 0; i < rx_tbl_num; i++) {
+			used += scnprintf(buf + used, buf_size - used, "tid = %d, ta = %pM, ",
 				     info->rx_tbl[i].tid,
 				     info->rx_tbl[i].ta);
-			p += sprintf(p, "start_win = %d, ",
+			used += scnprintf(buf + used, buf_size - used, "start_win = %d, ",
 				     info->rx_tbl[i].start_win);
-			p += sprintf(p, "win_size = %d, buffer: ",
+			used += scnprintf(buf + used, buf_size - used, "win_size = %d, buffer: ",
 				     info->rx_tbl[i].win_size);
 
-			for (j = 0; j < info->rx_tbl[i].win_size; j++)
-				p += sprintf(p, "%c ",
+			win_size = min_t(u32, info->rx_tbl[i].win_size,
+					 ARRAY_SIZE(info->rx_tbl[i].buffer));
+			for (j = 0; j < win_size; j++)
+				used += scnprintf(buf + used, buf_size - used, "%c ",
 					     info->rx_tbl[i].buffer[j] ?
 					     '1' : '0');
 
-			p += sprintf(p, "\n");
+			used += scnprintf(buf + used, buf_size - used, "\n");
 		}
 	}
 
-	return p - buf;
+	return used;
 }
 
 bool nxpwifi_is_channel_setting_allowable(struct nxpwifi_private *priv,
diff --git a/drivers/net/wireless/nxp/nxpwifi/util.h b/drivers/net/wireless/nxp/nxpwifi/util.h
index 1a47c8c5b..a0ec722e6 100644
--- a/drivers/net/wireless/nxp/nxpwifi/util.h
+++ b/drivers/net/wireless/nxp/nxpwifi/util.h
@@ -82,6 +82,7 @@ static inline dma_addr_t NXPWIFI_SKB_DMA_ADDR(struct sk_buff *skb)
 }
 
 int nxpwifi_debug_info_to_buffer(struct nxpwifi_private *priv, char *buf,
+				 size_t buf_size,
 				 struct nxpwifi_debug_info *info);
 
 static inline void le16_unaligned_add_cpu(__le16 *var, u16 val)
-- 
2.34.1

