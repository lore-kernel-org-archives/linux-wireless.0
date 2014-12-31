Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32987 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbaLaKih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:37 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/9] mwifiex: wakeup pending wait queues
Date: Wed, 31 Dec 2014 02:36:42 -0800
Message-ID: <1420022206-11435-6-git-send-email-akarwar@marvell.com> (sfid-20141231_113842_475705_BD6D8D9E)
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wakeup pending wait queues in unload path. This will help to avoid
soft lockup issues in corner cases.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 524692a..b115e0f 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -408,6 +408,8 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 
 	del_timer(&adapter->wakeup_timer);
 	mwifiex_cancel_all_pending_cmd(adapter);
+	wake_up_interruptible(&adapter->cmd_wait_q.wait);
+	wake_up_interruptible(&adapter->hs_activate_wait_q);
 
 	/* Free lock variables */
 	mwifiex_free_lock_list(adapter);
-- 
1.8.1.4

