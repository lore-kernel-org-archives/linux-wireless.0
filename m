Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32901 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965912AbcKAMIj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 08:08:39 -0400
Received: by mail-pf0-f194.google.com with SMTP id a136so8165546pfa.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2016 05:08:39 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH v2 02/12] mwifiex: complete blocked power save handshake in main process
Date: Tue,  1 Nov 2016 20:08:18 +0800
Message-Id: <1478002098-14189-2-git-send-email-huxinming820@marvell.com> (sfid-20161101_130941_657301_100BFFEE)
In-Reply-To: <1478002098-14189-1-git-send-email-huxinming820@marvell.com>
References: <1478002098-14189-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

Power save handshake with firmware might be blocked by on-going
data transfer.
this patch check the PS status in main process and complete
previous blocked PS handshake.
this patch also remove redudant check before call
mwifiex_check_ps_cond fuction.

---
v2: 1. remove redudant check(Brain)
	3. reorgnized to follow tx_hw_pending patch
---
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 2478ccd..d700c44 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -308,6 +308,9 @@ process_start:
 			/* We have tried to wakeup the card already */
 			if (adapter->pm_wakeup_fw_try)
 				break;
+			if (adapter->ps_state == PS_STATE_PRE_SLEEP)
+				mwifiex_check_ps_cond(adapter);
+
 			if (adapter->ps_state != PS_STATE_AWAKE)
 				break;
 			if (adapter->tx_lock_flag) {
@@ -355,10 +358,8 @@ process_start:
 
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
1.8.1.4
