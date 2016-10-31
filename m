Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35775 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761967AbcJaICc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 04:02:32 -0400
Received: by mail-pf0-f196.google.com with SMTP id s8so8096810pfj.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2016 01:02:32 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>
Subject: [PATCH 01/12] mwifiex: fix power save issue when suspend
Date: Mon, 31 Oct 2016 16:02:09 +0800
Message-Id: <1477900940-10549-1-git-send-email-huxinming820@marvell.com> (sfid-20161031_090242_333448_A0B65318)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

This patch fixes a corner case for "FROMLIST: mwifiex: fix corner case
power save issue", main process will check the power save condition in
PS_PRE_SLEEP status so the sleep handshake could continue.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

BUG=chrome-os-partner:58164
TEST=stress Wifi w/ power_save enabled

Change-Id: I5a36d9eaeb7fe5faaccc533e0d1ba1f3253666dc
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 3 ++-
 drivers/net/wireless/marvell/mwifiex/main.c   | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 5347728..9075be5 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1123,8 +1123,9 @@ mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 		mwifiex_dnld_sleep_confirm_cmd(adapter);
 	else
 		mwifiex_dbg(adapter, CMD,
-			    "cmd: Delay Sleep Confirm (%s%s%s)\n",
+			    "cmd: Delay Sleep Confirm (%s%s%s%s)\n",
 			    (adapter->cmd_sent) ? "D" : "",
+			    (adapter->data_sent) ? "T" : "",
 			    (adapter->curr_cmd) ? "C" : "",
 			    (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 2478ccd..f559ead 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -308,6 +308,11 @@ process_start:
 			/* We have tried to wakeup the card already */
 			if (adapter->pm_wakeup_fw_try)
 				break;
+			if (adapter->ps_state == PS_STATE_PRE_SLEEP) {
+				if (!adapter->cmd_sent && !adapter->curr_cmd)
+					mwifiex_check_ps_cond(adapter);
+			}
+
 			if (adapter->ps_state != PS_STATE_AWAKE)
 				break;
 			if (adapter->tx_lock_flag) {
-- 
1.8.1.4
