Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53200 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaFPQi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:56 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 24/25] wil6210: interrupt statistics
Date: Mon, 16 Jun 2014 19:37:22 +0300
Message-ID: <1402936643-31819-25-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190458_363875_D18BECB4)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track number of interrupts and Tx/Rx packets;
expose through debugfs 'info'. Reset upon read.
Used to analyse effectivness of interrupt coalescing and NAPI.
Read twice with some interval like
cat info > /dev/null; sleep 1; cat info

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c   | 11 +++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |  2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 8bf00ac..94ac69a 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -851,10 +851,21 @@ static const struct file_operations fops_link = {
 /*---------info------------*/
 static int wil_info_debugfs_show(struct seq_file *s, void *data)
 {
+	struct wil6210_priv *wil = s->private;
+	struct net_device *ndev = wil_to_ndev(wil);
 	int is_ac = power_supply_is_system_supplied();
+	int rx = atomic_xchg(&wil->isr_count_rx, 0);
+	int tx = atomic_xchg(&wil->isr_count_tx, 0);
+	static ulong rxf_old, txf_old;
+	ulong rxf = ndev->stats.rx_packets;
+	ulong txf = ndev->stats.tx_packets;
 
 	/* >0 : AC; 0 : battery; <0 : error */
 	seq_printf(s, "AC powered : %d\n", is_ac);
+	seq_printf(s, "Rx irqs:packets : %8d : %8ld\n", rx, rxf - rxf_old);
+	seq_printf(s, "Tx irqs:packets : %8d : %8ld\n", tx, txf - txf_old);
+	rxf_old = rxf;
+	txf_old = txf;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index e4aba53..67f1002 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -208,6 +208,7 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 
 	/* Rx IRQ will be enabled when NAPI processing finished */
 
+	atomic_inc(&wil->isr_count_rx);
 	return IRQ_HANDLED;
 }
 
@@ -246,6 +247,7 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 
 	/* Tx IRQ will be enabled when NAPI processing finished */
 
+	atomic_inc(&wil->isr_count_tx);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index fd6ff09..4249066 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -412,6 +412,7 @@ struct wil6210_priv {
 	struct mutex mutex; /* for wil6210_priv access in wil_{up|down} */
 	/* statistics */
 	struct wil6210_stats stats;
+	atomic_t isr_count_rx, isr_count_tx;
 	/* debugfs */
 	struct dentry *debug;
 	struct debugfs_blob_wrapper fw_code_blob;
-- 
1.9.1

