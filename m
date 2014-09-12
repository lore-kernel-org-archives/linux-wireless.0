Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46911 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626AbaILJKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 05:10:40 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 12/16] mwifiex: process TX even when scan is ongoing
Date: Fri, 12 Sep 2014 20:08:56 +0530
Message-ID: <1410532740-3173-13-git-send-email-patila@marvell.com> (sfid-20140912_111105_683288_E05CAD66)
In-Reply-To: <1410532740-3173-1-git-send-email-patila@marvell.com>
References: <1410532740-3173-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With channel scan gap, FW comes back to connected channel after each
single channel scan. So we can safely transfer data to FW during scan.
FW would send this data once on connected channel.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index dfa37ea..d6d2342 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -284,8 +284,9 @@ process_start:
 			    adapter->tx_lock_flag)
 				break;
 
-			if ((adapter->scan_processing &&
-			     !adapter->scan_delay_cnt) || adapter->data_sent ||
+			if ((!adapter->scan_chan_gap_enabled &&
+			     !adapter->scan_delay_cnt &&
+			     adapter->scan_processing) || adapter->data_sent ||
 			    mwifiex_wmm_lists_empty(adapter)) {
 				if (adapter->cmd_sent || adapter->curr_cmd ||
 				    (!is_command_pending(adapter)))
@@ -339,7 +340,8 @@ process_start:
 			}
 		}
 
-		if ((!adapter->scan_processing || adapter->scan_delay_cnt) &&
+		if ((adapter->scan_chan_gap_enabled ||
+		     (!adapter->scan_processing || adapter->scan_delay_cnt)) &&
 		    !adapter->data_sent && !mwifiex_wmm_lists_empty(adapter)) {
 			mwifiex_wmm_process_tx(adapter);
 			if (adapter->hs_activated) {
-- 
1.8.1.4

