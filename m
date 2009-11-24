Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757900AbZKXDaU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 22:30:20 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 7/8] iwmc3200wifi: Add stopped queue to debugfs
Date: Tue, 24 Nov 2009 11:33:32 +0800
Message-Id: <1259033613-25600-8-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259033613-25600-7-git-send-email-yi.zhu@intel.com>
References: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-2-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-3-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-4-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-5-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-6-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

We add the stopped queue count and display to the tx queue debugfs entry.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/debugfs.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/debugfs.c b/drivers/net/wireless/iwmc3200wifi/debugfs.c
index 1465379..be992ca 100644
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c
+++ b/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -158,6 +158,29 @@ static ssize_t iwm_debugfs_txq_read(struct file *filp, char __user *buffer,
 		}
 
 		spin_unlock_irqrestore(&txq->queue.lock, flags);
+
+		spin_lock_irqsave(&txq->stopped_queue.lock, flags);
+
+		len += snprintf(buf + len, buf_len - len,
+				"\tStopped Queue len:   %d\n",
+				skb_queue_len(&txq->stopped_queue));
+		for (j = 0; j < skb_queue_len(&txq->stopped_queue); j++) {
+			struct iwm_tx_info *tx_info;
+
+			skb = skb->next;
+			tx_info = skb_to_tx_info(skb);
+
+			len += snprintf(buf + len, buf_len - len,
+					"\tSKB #%d\n", j);
+			len += snprintf(buf + len, buf_len - len,
+					"\t\tsta:   %d\n", tx_info->sta);
+			len += snprintf(buf + len, buf_len - len,
+					"\t\tcolor: %d\n", tx_info->color);
+			len += snprintf(buf + len, buf_len - len,
+					"\t\ttid:   %d\n", tx_info->tid);
+		}
+
+		spin_unlock_irqrestore(&txq->stopped_queue.lock, flags);
 	}
 
 	ret = simple_read_from_buffer(buffer, len, ppos, buf, buf_len);
-- 
1.6.0.4

