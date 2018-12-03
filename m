Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B109C07E85
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0278420850
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="twCj9I/2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0278420850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbeLCN1D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 08:27:03 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33014 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbeLCN1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 08:27:03 -0500
Received: by mail-pg1-f195.google.com with SMTP id z11so5738058pgu.0;
        Mon, 03 Dec 2018 05:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ovHXEcKhp7HhGQova+XzvJYhUI09evN1MU+T+RM8SLo=;
        b=twCj9I/2yXL1YZeUZNp7/tUA1o7cRzdn7i9BVMa8CkKabuxx4XlWZDuUpYfZFT5bvs
         H8aWRElA6nouA0UQ9p11XXQZ+h0RNTS68gXxLX7UwpNHlDv43l9VhM9RUwbLhePFLlIs
         c2dwEA9BtuFctkjlo5DRXF7Ulr8q5lSYJ2LFDQ0npTzgjH5DxtFDR3PVH5H4y61FjMuw
         iqbREsrjnHT0rz+Hd+VWNJcddyuSaEgSCpZdfudlisC30g7skGX+jVns35UK9DXirybx
         VRiXyBjcwGaFkxblssigmoZCKE4nT7Sp19Y/BVxX5Ike+MBok0i+FC3JTiy3wLGN20f1
         gPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ovHXEcKhp7HhGQova+XzvJYhUI09evN1MU+T+RM8SLo=;
        b=rRpnYAjUBg7lfM25/3XpEm2+PBnFd0EnwONuEvZEgVyq/tmLfvmtn/aUg5HZdjkBLD
         VVmPJNfLlnRcOee85yXtMGupyF082NYmIjYVPN2Irqkyb8eMx0QyOpJgFZnWD6lAQfue
         ac2EQgU/shM2a2MLEuJOEa9ZydTQ8tLuXASZq4vhpasIWBSYOLdefbSjpPjSqVPOH4Pm
         jS85FuszrSRshH53jxhsbAv6K/qAiO2CmZ+1SVcr6sbUw5FN1oG+HjTl251PgPpO38I8
         /XlLUdy3SzZiKNwTKXEin6OeFAdzayOzS4nb+Ro73aobdwUt9cy9KOI0s2852ZhLSZHC
         NaMw==
X-Gm-Message-State: AA+aEWbd1k6k0y4c6G2yjS45owImomziy5zt6T6rgdfpLBM/Et8qO/Cx
        lcFoPqpf5Wv2Dv9hYwTzU1I=
X-Google-Smtp-Source: AFSGD/UOUf54e+LyLiOUEf4CQFvkIIG06H93x4/xn0U7wORA6UOBBipm/34YmWIv0StXBg1EscY4Cg==
X-Received: by 2002:a63:1b1f:: with SMTP id b31mr13184699pgb.66.1543843561316;
        Mon, 03 Dec 2018 05:26:01 -0800 (PST)
Received: from localhost (68.168.130.77.16clouds.com. [68.168.130.77])
        by smtp.gmail.com with ESMTPSA id z127sm22430165pfb.80.2018.12.03.05.26.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 05:26:00 -0800 (PST)
From:   Yangtao Li <tiny.windzz@gmail.com>
To:     merez@codeaurora.org, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH] wireless/wil6210: convert to DEFINE_SHOW_ATTRIBUTE
Date:   Mon,  3 Dec 2018 08:25:57 -0500
Message-Id: <20181203132557.12269-1-tiny.windzz@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 240 ++++-----------------
 1 file changed, 42 insertions(+), 198 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index aa50813a0595..f64e2e6e9a55 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -124,7 +124,7 @@ static void wil_print_ring(struct seq_file *s, struct wil6210_priv *wil,
 	seq_puts(s, "}\n");
 }
 
-static int wil_ring_debugfs_show(struct seq_file *s, void *data)
+static int ring_show(struct seq_file *s, void *data)
 {
 	uint i;
 	struct wil6210_priv *wil = s->private;
@@ -183,18 +183,7 @@ static int wil_ring_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_ring_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_ring_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_ring = {
-	.open		= wil_ring_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(ring);
 
 static void wil_print_sring(struct seq_file *s, struct wil6210_priv *wil,
 			    struct wil_status_ring *sring)
@@ -240,7 +229,7 @@ static void wil_print_sring(struct seq_file *s, struct wil6210_priv *wil,
 	seq_puts(s, "}\n");
 }
 
-static int wil_srings_debugfs_show(struct seq_file *s, void *data)
+static int srings_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	int i = 0;
@@ -251,18 +240,7 @@ static int wil_srings_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_srings_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_srings_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_srings = {
-	.open		= wil_srings_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(srings);
 
 static void wil_seq_hexdump(struct seq_file *s, void *p, int len,
 			    const char *prefix)
@@ -348,7 +326,7 @@ static void wil_print_mbox_ring(struct seq_file *s, const char *prefix,
 	wil_halp_unvote(wil);
 }
 
-static int wil_mbox_debugfs_show(struct seq_file *s, void *data)
+static int mbox_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	int ret;
@@ -366,18 +344,7 @@ static int wil_mbox_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_mbox_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_mbox_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_mbox = {
-	.open		= wil_mbox_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(mbox);
 
 static int wil_debugfs_iomem_x32_set(void *data, u64 val)
 {
@@ -624,7 +591,7 @@ static int wil6210_debugfs_create_ITR_CNT(struct wil6210_priv *wil,
 	return 0;
 }
 
-static int wil_memread_debugfs_show(struct seq_file *s, void *data)
+static int memread_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	void __iomem *a;
@@ -645,18 +612,7 @@ static int wil_memread_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_memread_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_memread_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_memread = {
-	.open		= wil_memread_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(memread);
 
 static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos)
@@ -1053,7 +1009,7 @@ static void wil_seq_print_skb(struct seq_file *s, struct sk_buff *skb)
 }
 
 /*---------Tx/Rx descriptor------------*/
-static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
+static int txdesc_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	struct wil_ring *ring;
@@ -1146,21 +1102,10 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_txdesc_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_txdesc_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_txdesc = {
-	.open		= wil_txdesc_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(txdesc);
 
 /*---------Tx/Rx status message------------*/
-static int wil_status_msg_debugfs_show(struct seq_file *s, void *data)
+static int status_msg_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	int sring_idx = dbg_sring_index;
@@ -1202,19 +1147,7 @@ static int wil_status_msg_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_status_msg_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_status_msg_debugfs_show,
-			   inode->i_private);
-}
-
-static const struct file_operations fops_status_msg = {
-	.open		= wil_status_msg_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(status_msg);
 
 static int wil_print_rx_buff(struct seq_file *s, struct list_head *lh)
 {
@@ -1232,7 +1165,7 @@ static int wil_print_rx_buff(struct seq_file *s, struct list_head *lh)
 	return i;
 }
 
-static int wil_rx_buff_mgmt_debugfs_show(struct seq_file *s, void *data)
+static int rx_buff_mgmt_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	struct wil_rx_buff_mgmt *rbm = &wil->rx_buff_mgmt;
@@ -1257,19 +1190,7 @@ static int wil_rx_buff_mgmt_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_rx_buff_mgmt_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_rx_buff_mgmt_debugfs_show,
-			   inode->i_private);
-}
-
-static const struct file_operations fops_rx_buff_mgmt = {
-	.open		= wil_rx_buff_mgmt_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(rx_buff_mgmt);
 
 /*---------beamforming------------*/
 static char *wil_bfstatus_str(u32 status)
@@ -1299,7 +1220,7 @@ static bool is_all_zeros(void * const x_, size_t sz)
 	return true;
 }
 
-static int wil_bf_debugfs_show(struct seq_file *s, void *data)
+static int bf_show(struct seq_file *s, void *data)
 {
 	int rc;
 	int i;
@@ -1353,18 +1274,7 @@ static int wil_bf_debugfs_show(struct seq_file *s, void *data)
 	}
 	return 0;
 }
-
-static int wil_bf_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_bf_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_bf = {
-	.open		= wil_bf_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(bf);
 
 /*---------temp------------*/
 static void print_temp(struct seq_file *s, const char *prefix, s32 t)
@@ -1381,7 +1291,7 @@ static void print_temp(struct seq_file *s, const char *prefix, s32 t)
 	}
 }
 
-static int wil_temp_debugfs_show(struct seq_file *s, void *data)
+static int temp_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	s32 t_m, t_r;
@@ -1397,21 +1307,10 @@ static int wil_temp_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_temp_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_temp_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_temp = {
-	.open		= wil_temp_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(temp);
 
 /*---------freq------------*/
-static int wil_freq_debugfs_show(struct seq_file *s, void *data)
+static int freq_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	struct wireless_dev *wdev = wil->main_ndev->ieee80211_ptr;
@@ -1421,21 +1320,10 @@ static int wil_freq_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_freq_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_freq_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_freq = {
-	.open		= wil_freq_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(freq);
 
 /*---------link------------*/
-static int wil_link_debugfs_show(struct seq_file *s, void *data)
+static int link_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	struct station_info *sinfo;
@@ -1487,21 +1375,10 @@ static int wil_link_debugfs_show(struct seq_file *s, void *data)
 	kfree(sinfo);
 	return rc;
 }
-
-static int wil_link_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_link_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_link = {
-	.open		= wil_link_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(link);
 
 /*---------info------------*/
-static int wil_info_debugfs_show(struct seq_file *s, void *data)
+static int info_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	struct net_device *ndev = wil->main_ndev;
@@ -1536,18 +1413,7 @@ static int wil_info_debugfs_show(struct seq_file *s, void *data)
 #undef CHECK_QSTATE
 	return 0;
 }
-
-static int wil_info_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_info_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_info = {
-	.open		= wil_info_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(info);
 
 /*---------recovery------------*/
 /* mode = [manual|auto]
@@ -1663,7 +1529,7 @@ static void wil_print_rxtid_crypto(struct seq_file *s, int tid,
 	seq_puts(s, "\n");
 }
 
-static int wil_sta_debugfs_show(struct seq_file *s, void *data)
+static int sta_show(struct seq_file *s, void *data)
 __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 {
 	struct wil6210_priv *wil = s->private;
@@ -1745,20 +1611,9 @@ __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 
 	return 0;
 }
+DEFINE_SHOW_ATTRIBUTE(sta);
 
-static int wil_sta_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_sta_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_sta = {
-	.open		= wil_sta_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
-
-static int wil_mids_debugfs_show(struct seq_file *s, void *data)
+static int mids_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	struct wil6210_vif *vif;
@@ -1781,18 +1636,7 @@ static int wil_mids_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_mids_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_mids_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations fops_mids = {
-	.open		= wil_mids_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(mids);
 
 static int wil_tx_latency_debugfs_show(struct seq_file *s, void *data)
 __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
@@ -2436,23 +2280,23 @@ static const struct {
 	umode_t mode;
 	const struct file_operations *fops;
 } dbg_files[] = {
-	{"mbox",	0444,		&fops_mbox},
-	{"rings",	0444,		&fops_ring},
-	{"stations", 0444,		&fops_sta},
-	{"mids",	0444,		&fops_mids},
-	{"desc",	0444,		&fops_txdesc},
-	{"bf",		0444,		&fops_bf},
-	{"mem_val",	0644,		&fops_memread},
+	{"mbox",	0444,		&mbox_fops},
+	{"rings",	0444,		&ring_fops},
+	{"stations", 0444,		&sta_fops},
+	{"mids",	0444,		&mids_fops},
+	{"desc",	0444,		&txdesc_fops},
+	{"bf",		0444,		&bf_fops},
+	{"mem_val",	0644,		&memread_fops},
 	{"rxon",	0244,		&fops_rxon},
 	{"tx_mgmt",	0244,		&fops_txmgmt},
 	{"wmi_send", 0244,		&fops_wmi},
 	{"back",	0644,		&fops_back},
 	{"pmccfg",	0644,		&fops_pmccfg},
 	{"pmcdata",	0444,		&fops_pmcdata},
-	{"temp",	0444,		&fops_temp},
-	{"freq",	0444,		&fops_freq},
-	{"link",	0444,		&fops_link},
-	{"info",	0444,		&fops_info},
+	{"temp",	0444,		&temp_fops},
+	{"freq",	0444,		&freq_fops},
+	{"link",	0444,		&link_fops},
+	{"info",	0444,		&info_fops},
 	{"recovery", 0644,		&fops_recovery},
 	{"led_cfg",	0644,		&fops_led_cfg},
 	{"led_blink_time",	0644,	&fops_led_blink_time},
@@ -2460,9 +2304,9 @@ static const struct {
 	{"fw_version",	0444,		&fops_fw_version},
 	{"suspend_stats",	0644,	&fops_suspend_stats},
 	{"compressed_rx_status", 0644,	&fops_compressed_rx_status},
-	{"srings",	0444,		&fops_srings},
-	{"status_msg",	0444,		&fops_status_msg},
-	{"rx_buff_mgmt",	0444,	&fops_rx_buff_mgmt},
+	{"srings",	0444,		&srings_fops},
+	{"status_msg",	0444,		&status_msg_fops},
+	{"rx_buff_mgmt",	0444,	&rx_buff_mgmt_fops},
 	{"tx_latency",	0644,		&fops_tx_latency},
 	{"link_stats",	0644,		&fops_link_stats},
 	{"link_stats_global",	0644,	&fops_link_stats_global},
-- 
2.17.0

