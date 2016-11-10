Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32814 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755627AbcKJL5m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 06:57:42 -0500
Received: by mail-pf0-f195.google.com with SMTP id 144so3985573pfv.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2016 03:57:42 -0800 (PST)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH RESEND v2 02/11] mwifiex: complete blocked power save handshake in main process
Date: Thu, 10 Nov 2016 19:57:03 +0800
Message-Id: <1478779032-5165-2-git-send-email-huxinming820@marvell.com> (sfid-20161110_125750_833019_45855EBE)
In-Reply-To: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

Power save handshake with firmware might be blocked by on-going
data transfer.
this patch check the PS status in main process and complete
previous blocked PS handshake.
this patch also remove redudant check before call
mwifiex_check_ps_cond fuction.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: 1. remove redudant check(Brain)
	2. reorgnized to follow tx_hw_pending patch
---
 drivers/net/wireless/marvell/mwifiex/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 20c9b77..c710d5e 100644
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
1.8.1.4
