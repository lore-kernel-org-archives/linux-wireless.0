Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37876 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752421AbcKROBR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 09:01:17 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Shengzhen Li <szli@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v4 02/11] mwifiex: complete blocked power save handshake in main process
Date: Fri, 18 Nov 2016 19:30:25 +0530
Message-ID: <1479477634-27841-2-git-send-email-akarwar@marvell.com> (sfid-20161118_150120_226802_CF687AAE)
In-Reply-To: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
References: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

Power save handshake with firmware might be blocked by on-going
data transfer.
this patch check the PS status in main process and complete
previous blocked PS handshake.
this patch also remove redudant check before call
mwifiex_check_ps_cond function.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: 1. remove redudant check(Brain)
        2. reorgnized to follow tx_hw_pending patch
v4: Same as v2, v3
---
 drivers/net/wireless/marvell/mwifiex/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 948f5c2..9e7acb4 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -308,6 +308,9 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 			/* We have tried to wakeup the card already */
 			if (adapter->pm_wakeup_fw_try)
 				break;
+			if (adapter->ps_state == PS_STATE_PRE_SLEEP)
+				mwifiex_check_ps_cond(adapter);
+
 			if (adapter->ps_state != PS_STATE_AWAKE)
 				break;
 			if (adapter->tx_lock_flag) {
@@ -355,10 +358,8 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 
 		/* Check if we need to confirm Sleep Request
 		   received previously */
-		if (adapter->ps_state == PS_STATE_PRE_SLEEP) {
-			if (!adapter->cmd_sent && !adapter->curr_cmd)
-				mwifiex_check_ps_cond(adapter);
-		}
+		if (adapter->ps_state == PS_STATE_PRE_SLEEP)
+			mwifiex_check_ps_cond(adapter);
 
 		/* * The ps_state may have been changed during processing of
 		 * Sleep Request event.
-- 
1.9.1
