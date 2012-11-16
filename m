Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([66.92.66.146]:37799 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab2KPVcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 16:32:32 -0500
From: Tim Shepard <shep@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Daniel Drake <dsd@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	John Rhodes <jrhodes@marvell.com>
Subject: Re: [PATCH] mwifiex: add support for SDIO card reset 
In-reply-to: Your message of Tue, 06 Nov 2012 20:35:48 -0800.
             <477F20668A386D41ADCC57781B1F7043083BBD66E3@SC-VEXCH1.marvell.com>
Date: Fri, 16 Nov 2012 16:32:20 -0500
Message-Id: <E1TZTWO-0004H9-00@www.xplot.org> (sfid-20121116_223253_081717_1547B73A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Bing,

I have now managed to test your patches from 6-November-2012, but I
still get system wedgeups eventually whenever a command timeout happens.

To make the timeouts happen regularly enough to test this, I went
back to a 3.5.2 kernel.org kernel (so I no longer have your
adjustment to HOST_SLEEP_CFG_GAP_DEF).  I applied your patch to the
functions mwifiex_cmd_timeout_func and mwifiex_sdio_suspend from your
e-mail and ran my suspend/resume in a loop test.  Diff against
kernel.org v3.5.2 linux included below (contains just your two
patches from 6-November-2012 e-mail).

The difference now is that the first such timeout on an attempted
suspend (while waiting for a response to the host sleep command) the
system fails to suspend but continues running.  The second time it
attempts to suspend, then it wedges the system.

I have complete serial console log from initial boot to wedge up of
four such cases, and have put them up at 

     http://dev.laptop.org/~shep/bzhao_20121106_tests/


It looks like the card is not getting reset as you had intended.  (I
need to investigate the control of having the card powered down on
suspend for other reasons anyway, so I might be able to figure this
out also.)



I did notice that the mwifiex_cmd_timeout_func incidents are
preceded by one of these (before the previous suspend attempt):

     mwifiex_sdio mmc1:0001:1: card_to_host_mpa failed: int status=0x1

but I also see that error message earlier in some of the logs in which
case things are still working after such an error.

Sometimes the above error is paired up with a "read iomem failed"
message like this:

 [ 4131.795129] mwifiex_sdio mmc1:0001:1: mwifiex_sdio_card_to_host: read iomem failed: -1
 [ 4131.823222] mwifiex_sdio mmc1:0001:1: card_to_host_mpa failed: int status=0x1

Maybe it would help to understand why these are happening and if they
are closer to the root cause of the timeouts in the first place.
(But remember, HOST_SLEEP_CFG_GAP_DEF is back to zero in these tests,
so that I could get enough events to test mwifiex_cmd_timeout_func.)

			-Tim Shepard
			 shep@laptop.org

 ___ _ ___ _   _ _ ___   ___     _ _ _ _   _   _ ___ _   _   _ ___ _ ___ _ ___

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 51e023e..f4e0919 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -873,9 +873,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		return;
 	}
 	cmd_node = adapter->curr_cmd;
-	if (cmd_node->wait_q_enabled)
-		adapter->cmd_wait_q.status = -ETIMEDOUT;
-
 	if (cmd_node) {
 		adapter->dbg.timeout_cmd_id =
 			adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index];
@@ -921,6 +918,12 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 
 		dev_err(adapter->dev, "ps_mode=%d ps_state=%d\n",
 			adapter->ps_mode, adapter->ps_state);
+
+		if (cmd_node->wait_q_enabled) {
+			adapter->cmd_wait_q.status = -ETIMEDOUT;
+			wake_up_interruptible(&adapter->cmd_wait_q.wait);
+			mwifiex_cancel_pending_ioctl(adapter);
+		}
 	}
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index fc8a9bf..8597a77 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -189,11 +189,14 @@ static int mwifiex_sdio_suspend(struct device *dev)
 
 	/* Enable the Host Sleep */
 	hs_actived = mwifiex_enable_hs(adapter);
-	if (hs_actived) {
-		pr_debug("cmd: suspend with MMC_PM_KEEP_POWER\n");
-		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	if (!hs_actived) {
+		dev_err(adapter->dev, "cmd: failed to suspend\n");
+		return -EFAULT;
 	}
 
+	dev_dbg(adapter->dev, "cmd: suspend with MMC_PM_KEEP_POWER\n");
+	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+
 	/* Indicate device suspended */
 	adapter->is_suspended = true;
 
