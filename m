Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47410 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752302AbcJ0JNZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 05:13:25 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 2/5] mwifiex: use spinlock for 'mwifiex_processing' in shutdown_drv
Date: Thu, 27 Oct 2016 14:42:40 +0530
Message-ID: <1477559563-18328-2-git-send-email-akarwar@marvell.com> (sfid-20161027_111339_302099_10A36BFF)
In-Reply-To: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This variable is guarded by spinlock at all other places. This patch
takes care of missing spinlock usage in mwifiex_shutdown_drv().

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 82839d9..8e5e424 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -670,11 +670,14 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 
 	adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING;
 	/* wait for mwifiex_process to complete */
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	if (adapter->mwifiex_processing) {
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 		mwifiex_dbg(adapter, WARN,
 			    "main process is still running\n");
 		return ret;
 	}
+	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 
 	/* cancel current command */
 	if (adapter->curr_cmd) {
-- 
1.9.1
