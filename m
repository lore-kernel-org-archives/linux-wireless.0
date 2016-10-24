Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57841 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938751AbcJXOW2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:22:28 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <dmitry.torokhov@gmail.com>, <briannorris@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing' in shutdown_drv
Date: Mon, 24 Oct 2016 19:51:29 +0530
Message-ID: <1477318892-22877-2-git-send-email-akarwar@marvell.com> (sfid-20161024_162231_409325_1F5DD544)
In-Reply-To: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This variable is guarded by spinlock at all other places. This patch
takes care of missing spinlock usage in mwifiex_shutdown_drv().

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
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
