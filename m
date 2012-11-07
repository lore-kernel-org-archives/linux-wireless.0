Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:49732 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575Ab2KGEoW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 23:44:22 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Tim Shepard <shep@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Daniel Drake <dsd@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	John Rhodes <jrhodes@marvell.com>
Date: Tue, 6 Nov 2012 20:35:48 -0800
Subject: RE: [PATCH] mwifiex: add support for SDIO card reset 
Message-ID: <477F20668A386D41ADCC57781B1F7043083BBD66E3@SC-VEXCH1.marvell.com> (sfid-20121107_054434_668465_A958085C)
References: Your message of Thu, 01 Nov 2012 18:44:14 -0700.
             <1351820654-24433-1-git-send-email-bzhao@marvell.com>
  <E1TUP4U-0002Fm-00@www.xplot.org>
In-Reply-To: <E1TUP4U-0002Fm-00@www.xplot.org>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tim,

> Bing,
> 
> I am trying to figure out if this patch would help in the situation I
> told you about in September.
> 
> I was doing suspend/resume testing using
> 
>   rtcwake -s 6 -mmem

Since the command times out in 10 seconds, please change the sleep time to 11 or longer for your tests. For example,

rtcwake -s 12 -mmem

> 
> in a loop to test the ability of the mwifiex driver to suspend/resume.
> 
> I was seeing sporadic failures (wedgeups), and the majority of those
> failures I saw printed the printouts in mwifiex_cmd_timeout_func with
> cmd = 0xe5 which is CMD_802_11_HS_CFG_ENH.  When this happens, two
> minutes later I get notified that the rtcwake thread is blocked, like
> this:
> 
>       INFO: task rtcwake:3495 blocked for more than 120 seconds.

In this case, we should wake up the command wait queue and cancel the pending iotcl when timeout happens.

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index c9528b3..0847cf0 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -890,9 +890,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		return;
 	}
 	cmd_node = adapter->curr_cmd;
-	if (cmd_node->wait_q_enabled)
-		adapter->cmd_wait_q.status = -ETIMEDOUT;
-
 	if (cmd_node) {
 		adapter->dbg.timeout_cmd_id =
 			adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index];
@@ -941,6 +938,12 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 
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

> 
> 
> 
> I believe the hang happens when mwifiex_sdio_suspend() is called in
> the rtcwake thread it winds winds up blocked waiting on a wait queue
> in mwifiex_enable_hs() because when the timeout happens it never gets
> woken up.
> 
> Reading your patch today, I don't see how your patch will add a new
> way to get that hung thread unblocked.

Above change should get the hung thread unblocked.

> 
> (I'm also not sure doing the reset of the card will work properly while
>  the system is in the middle of trying to suspend, but that's a
>  different question.)

When suspend command (0xe5) fails we should return failure to MMC core. Once the card is reset the next suspend attempt will likely succeed.

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 90a87b5..9779fae 100644
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

Please give it a try with this card reset patch and above two changes applied.

Thanks,
Bing

