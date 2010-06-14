Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0FNSYz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Dor Shaish <dor.shaish@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwlwifi: Fix null pointer referencing in iwl_dbgfs_rx_queue_read.
Date: Mon, 14 Jun 2010 11:24:48 -0700
Message-Id: <1276539892-12471-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
References: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

Test for null pointer prior to access.
Print "Not Allocated" if null pointer.

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d9f21bb..cee3d12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1018,8 +1018,13 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 						rxq->write);
 	pos += scnprintf(buf + pos, bufsz - pos, "free_count: %u\n",
 						rxq->free_count);
-	pos += scnprintf(buf + pos, bufsz - pos, "closed_rb_num: %u\n",
+	if (rxq->rb_stts) {
+		pos += scnprintf(buf + pos, bufsz - pos, "closed_rb_num: %u\n",
 			 le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF);
+	} else {
+		pos += scnprintf(buf + pos, bufsz - pos,
+					"closed_rb_num: Not Allocated\n");
+	}
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-- 
1.7.0.4

