Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36514 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbeIFI0v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 04:26:51 -0400
Date: Thu, 6 Sep 2018 11:53:26 +0800
From: Louie Lu <git@louie.lu>
To: kvalo@codeaurora.org
Cc: ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        toke@toke.dk
Subject: [PATCH] ath9k: add reset for airtime station debugfs
Message-ID: <20180906035323.GA11337@nems_nctu_lu> (sfid-20180906_055335_938319_9EBE085D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let user can reset station airtime status by debugfs, it will
reset all airtime deficit to ATH_AIRTIME_QUANTUM and reset rx/tx
airtime accumulate to 0.

Signed-off-by: Louie Lu <git@louie.lu>
---
 drivers/net/wireless/ath/ath9k/debug_sta.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index ed8b77a74630..e8fcd3e1c470 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -286,9 +286,25 @@ static ssize_t read_airtime(struct file *file, char __user *user_buf,
 	return retval;
 }
 
+static ssize_t
+write_airtime_reset_stub(struct file *file, const char __user *ubuf,
+		   size_t count, loff_t *ppos)
+{
+	struct ath_node *an = file->private_data;
+	struct ath_airtime_stats *astats;
+	int i;
+
+	astats = &an->airtime_stats;
+	astats->rx_airtime = 0;
+	astats->tx_airtime = 0;
+	for (i = 0; i < 4; i++)
+		an->airtime_deficit[i] = ATH_AIRTIME_QUANTUM;
+	return count;
+}
 
 static const struct file_operations fops_airtime = {
 	.read = read_airtime,
+	.write = write_airtime_reset_stub,
 	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -304,5 +320,5 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 
 	debugfs_create_file("node_aggr", 0444, dir, an, &fops_node_aggr);
 	debugfs_create_file("node_recv", 0444, dir, an, &fops_node_recv);
-	debugfs_create_file("airtime", 0444, dir, an, &fops_airtime);
+	debugfs_create_file("airtime", 0644, dir, an, &fops_airtime);
 }
-- 
2.18.0
