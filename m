Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DAB4F3EA4;
	Fri, 18 Sep 2026 13:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789737372; cv=none; b=d2FdskMGeHKj4REPgDbCWwmC9i2RVY7joFcuUWTs97szyivWNHyTh1fuki08p48cGrTxPcDYZUVsrUgm3Y6IqDT8fW8V1VDOK5qLdXZ0+a/zMnvUlk89I19yvHvfafrYs3NmqfeuyQ12bSdiH96oxJZP/JzHyM30ARW1+k+AuV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789737372; c=relaxed/simple;
	bh=qynii6GhHzMVM5/DVjoMe1a+dw4Z0EH+QolcTdLlVb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kXzXfY/dcPuhTW1AxP/szzwueMUcqlSZcgpdWQrHmWGGqh5vwIW3DgrwhH54fTagqegzi2OCiHOjG3BXyk9ZwsXaPBMltSyLoZgA0CBKhm21Yn7chbsODYTZoOIDGBBFXpzDUvHf3SgeEm9eV4ELDJ9aTRPNxqC2G+64vEwfiv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AWKbNfvS; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AWKbNfvS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=JK
	CbNkXuGe65gq/og33BZJ1qzVcPVm7F2fi1/Rwdm5s=; b=AWKbNfvSLOZOu4c6cM
	yF1iYocFbTSxmHnu0lH6E2J/z3iwHscimKTZc/wNimmoyTRIeUP2LnhZnmqYsS/c
	bw5lZW1RvXGifeh6uAP4/+8v9aSC3Of+MQRHt0/iItvNMKy6f5eDgjn6gl2u3745
	uIkaY0wRAAexaYROUPTrfJ8co=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgBnT8p9Oa1qcK1bAA--.11188S2;
	Fri, 18 Sep 2026 21:15:43 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: jeff.chen_1@nxp.com
Cc: francesco@dolcini.it,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: nxpwifi: bound debugfs output to the allocated page
Date: Fri, 18 Sep 2026 21:15:36 +0800
Message-ID: <20260918131537.904-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgBnT8p9Oa1qcK1bAA--.11188S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKr1xZw13ZFW5Zry8XFyUtrb_yoWfCw4fp3
	y5KrWjqw4xXrnxGrykta1UAw1FqwsFvrW3WrZ5Cw43ZayqyryFvryFgFWFqry5Cr4xtF1S
	vrs8K345K3WUGrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeD73UUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC-h9zHWqtOX9yXAAA3g

This patch fixes two page-buffer overflows in the nxpwifi debugfs
read paths.

Both nxpwifi_histogram_read() and nxpwifi_debug_read() allocate a
single get_zeroed_page() buffer and then format driver state with
unbounded sprintf() calls.  nxpwifi_debug_read() goes through
nxpwifi_debug_info_to_buffer(), which has no buffer-size parameter.

With enough populated histogram bins, nxpwifi_histogram_read() can
produce more than 25 KB while only 4096 bytes are allocated.  With
16 Rx reorder entries and win_size capped at 64,
nxpwifi_debug_info_to_buffer() can produce about 5168 bytes, also
past the page boundary.  This is therefore a potential local kernel
memory corruption / DoS when the nxpwifi debugfs directory is
readable.  The debugfs files are created with mode 0644, although the
default debugfs mount is 0700, so the actual exposure depends on the
debugfs mount mode.

Fix this by:

  - converting the histogram formatter to scnprintf() with the
    remaining page capacity;
  - adding an explicit buf_size argument to
    nxpwifi_debug_info_to_buffer();
  - updating the debugfs and devcoredump callers;
  - clamping tx_tbl_num, rx_tbl_num, and win_size to the fixed array
    sizes before formatting.

The patch passes:

  git apply --check
  scripts/checkpatch.pl --no-tree --strict

checkpatch reports 0 errors, 0 warnings, 0 checks.  I also compiled
the patched driver on x86_64 with CONFIG_NXPWIFI=m,
CONFIG_CFG80211=m, and CONFIG_DEBUG_FS=y; the kernel build and both
nxpwifi.ko and cfg80211.ko completed cleanly with no compiler or
modpost errors.

I do not have nxpwifi hardware or a runtime test environment, so the
overflow sizes above are static upper-bound estimates and have not
been reproduced with KASAN.  The practical exposure also depends on
the debugfs mount mode, as noted above.

Assisted-by: LLM Codex
Signed-off-by: Heyang Tan <thy15333007817@163.com>

---
 drivers/net/wireless/nxp/nxpwifi/debugfs.c | 31 +++++++++-------
 drivers/net/wireless/nxp/nxpwifi/main.c    |  5 ++-
 drivers/net/wireless/nxp/nxpwifi/util.c    | 43 +++++++++++++---------
 drivers/net/wireless/nxp/nxpwifi/util.h    |  1 +
 4 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/debugfs.c b/drivers/net/wireless/nxp/nxpwifi/debugfs.c
index ccaf0eae3..cd6e73a21 100644
--- a/drivers/net/wireless/nxp/nxpwifi/debugfs.c
+++ b/drivers/net/wireless/nxp/nxpwifi/debugfs.c
@@ -211,25 +211,26 @@ nxpwifi_histogram_read(struct file *file, char __user *ubuf,
 
 	phist_data = priv->hist_data;
 
-	p += sprintf(p, "\n"
+	p += scnprintf(p, PAGE_SIZE - (p - (char *)page), "\n"
 		     "total samples = %d\n",
 		     atomic_read(&phist_data->num_samples));
 
-	p += sprintf(p,
+	p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
 		     "rx rates (in Mbps): 0=1M   1=2M 2=5.5M  3=11M   4=6M   5=9M  6=12M\n"
 		     "7=18M  8=24M  9=36M  10=48M  11=54M 12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)\n");
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info)) {
-		p += sprintf(p,
+		p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
 			     "44-53=MCS0-9(VHT:BW20) 54-63=MCS0-9(VHT:BW40) 64-73=MCS0-9(VHT:BW80)\n\n");
 	} else {
-		p += sprintf(p, "\n");
+		p += scnprintf(p, PAGE_SIZE - (p - (char *)page), "\n");
 	}
 
 	for (i = 0; i < NXPWIFI_MAX_RX_RATES; i++) {
 		value = atomic_read(&phist_data->rx_rate[i]);
 		if (value)
-			p += sprintf(p, "rx_rate[%02d] = %d\n", i, value);
+			p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+				       "rx_rate[%02d] = %d\n", i, value);
 	}
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info)) {
@@ -237,27 +238,31 @@ nxpwifi_histogram_read(struct file *file, char __user *ubuf,
 		     i++) {
 			value = atomic_read(&phist_data->rx_rate[i]);
 			if (value)
-				p += sprintf(p, "rx_rate[%02d] = %d\n",
-					   i, value);
+				p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+					       "rx_rate[%02d] = %d\n",
+					       i, value);
 		}
 	}
 
 	for (i = 0; i < NXPWIFI_MAX_SNR; i++) {
 		value =  atomic_read(&phist_data->snr[i]);
 		if (value)
-			p += sprintf(p, "snr[%02ddB] = %d\n", i, value);
+			p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+				       "snr[%02ddB] = %d\n", i, value);
 	}
 	for (i = 0; i < NXPWIFI_MAX_NOISE_FLR; i++) {
 		value = atomic_read(&phist_data->noise_flr[i]);
 		if (value)
-			p += sprintf(p, "noise_flr[%02ddBm] = %d\n",
-				     (int)(i - 128), value);
+			p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+				       "noise_flr[%02ddBm] = %d\n",
+				       (int)(i - 128), value);
 	}
 	for (i = 0; i < NXPWIFI_MAX_SIG_STRENGTH; i++) {
 		value = atomic_read(&phist_data->sig_str[i]);
 		if (value)
-			p += sprintf(p, "sig_strength[-%02ddBm] = %d\n",
-				i, value);
+			p += scnprintf(p, PAGE_SIZE - (p - (char *)page),
+				       "sig_strength[-%02ddBm] = %d\n",
+				       i, value);
 	}
 
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *)page,
@@ -299,7 +304,7 @@ nxpwifi_debug_read(struct file *file, char __user *ubuf,
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

