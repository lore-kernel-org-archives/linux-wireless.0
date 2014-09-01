Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5689 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbaIAHcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:32:01 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 14/17] mwifiex: process TX even when scan is ongoing
Date: Mon, 1 Sep 2014 18:29:02 +0530
Message-ID: <1409576345-13717-15-git-send-email-patila@marvell.com> (sfid-20140901_093206_423239_E19EC6C4)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With channel scan gap, FW comes back to connected channel after each
single channel scan. So we can safely transfer data to FW during scan.
FW would send this data once on connected channel.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index dfa37ea..1f1b7d7 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -284,8 +284,7 @@ process_start:
 			    adapter->tx_lock_flag)
 				break;
 
-			if ((adapter->scan_processing &&
-			     !adapter->scan_delay_cnt) || adapter->data_sent ||
+			if (adapter->data_sent ||
 			    mwifiex_wmm_lists_empty(adapter)) {
 				if (adapter->cmd_sent || adapter->curr_cmd ||
 				    (!is_command_pending(adapter)))
@@ -339,8 +338,7 @@ process_start:
 			}
 		}
 
-		if ((!adapter->scan_processing || adapter->scan_delay_cnt) &&
-		    !adapter->data_sent && !mwifiex_wmm_lists_empty(adapter)) {
+		if (!adapter->data_sent && !mwifiex_wmm_lists_empty(adapter)) {
 			mwifiex_wmm_process_tx(adapter);
 			if (adapter->hs_activated) {
 				adapter->is_hs_configured = false;
-- 
1.8.1.4

