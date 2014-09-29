Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8403 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbaI2KpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 06:45:01 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <cluo@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kevin Gan <ganhy@marvell.com>
Subject: [PATCHv1 RESEND 1/3] mwifiex: fix soft lockup during iperf UDP RX
Date: Mon, 29 Sep 2014 21:44:13 +0530
Message-ID: <1412007255-4625-1-git-send-email-patila@marvell.com> (sfid-20140929_124511_605359_66B8E93B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A soft lockup was observed on ARM multicore platform while UDP
RX iperf was running on station.

Reason for this is delay_main_task was not taken into consideration while
jumping to process_start. Now if delay_main_task is true, we would exit
mwifiex_main_process instead of going to process_start again.
This ensure other process is scheduled on this CPU and soft lockup is avoided.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kevin Gan <ganhy@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index b522f7c..be52189 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -330,7 +330,8 @@ process_start:
 	} while (true);
 
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
-	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter)) {
+	if (!adapter->delay_main_work &&
+	    (adapter->int_status || IS_CARD_RX_RCVD(adapter))) {
 		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 		goto process_start;
 	}
-- 
1.8.1.4

