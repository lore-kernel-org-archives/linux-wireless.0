Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42257 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbaE0Xkf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 19:40:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 27 May 2014 16:39:07 -0700
Subject: RE: [RFC] mwifiex: block work queue while suspended
Message-ID: <477F20668A386D41ADCC57781B1F70430F70F5E39F@SC-VEXCH1.marvell.com> (sfid-20140528_014039_185305_0E6BDB8D)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
 <20140526080110.GJ6118@us.netrek.org>
In-Reply-To: <20140526080110.GJ6118@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > To understand what is happening here could you apply attached debug
> > patch to generate logs, or enable dynamic_debug for that?
> 
> Here's a dynamic_debug log.
> 
> Note the point of failure is the "mmc0: Timeout waiting for hardware
> interrupt." message, which occurs in the driver SDIO interrupt
> function, which began execution in a critical time period after driver
> suspend but before platform suspend.
> 
> We use a GPIO to wake from WLAN.

This doesn't match the gpio parameter configured in hscfg command 0xe5.
 
> 
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.090061] Freezing remaining freezable tasks ... (elapsed
> 0.01 seconds) done.
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.113049] Suspending console(s) (use no_console_suspend to
> debug)

[...]

> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304049] mwifiex_sdio: cmd: mmc0:0001:1: suspend: PM flag =
> 0x3
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304049] mwifiex_sdio mmc0:0001:1: cmd: HS_CFG_CMD:
> condition:0xa gpio:0xff gap:0xff

gpio:0xff --> This configures firmware to use SDIO interface to wake up host.
Could you change the gpio parameter to the actual GPIO pin number (from 8787 point of view)?

> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304072] mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xe5,
> cmd_pending=1
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304083] mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD:
> (1401090251.944017): 0xe5, act 0x1, len 16, seqno 0x5f

[...]

> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304886] mwifiex_sdio mmc0:0001:1: event: hs_activated
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304903] mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xe5,
> cmd_pending=0
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304907] mwifiex_sdio: cmd: suspend with
> MMC_PM_KEEP_POWER|MMC_PM_WAKE_SDIO_IRQ
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307736] mmc0: keeping power over suspend
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307736] sdhci_wakeup_irq
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307749] sdhci_wakeup_irq
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307749] sdhci_wakeup_irq
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307751] sdhci_wakeup_irq
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307753] [galcore] enter gpu_suspend
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307793] [galcore] exit gpu_suspend, return 0
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307859] PM: suspend of devices complete after 194.744
> msecs
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.320018] olpc_ec_1_75_suspend: suspend sync 0000001f
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340038] PM: late suspend of devices complete after 32.172
> msecs
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340307] PM: noirq suspend of devices complete after 0.263
> msecs
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340417] mmp3_pm_enter_d2
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340417] before suspend
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340430] after resume
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.372814] PM: noirq resume of devices complete after 0.098
> msecs
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.391862] PM: early resume of devices complete after 18.934
> msecs
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.391873] [galcore] enter gpu_resume
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396056] [galcore] exit gpu_resume, return 0
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396056] sdhci_wakeup_irq
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396070] sdhci_wakeup_irq
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396072] sdhci_wakeup_irq
> May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396074] sdhci_wakeup_irq
> May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341764] mmc0: Timeout waiting for hardware interrupt.
> May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341784] mwifiex_sdio mmc0:0001:1: read mp_regs failed

I was expecting that mwifiex_sdio_resume handler is called before the SDIO interrupt function is called.

> May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341909] mwifiex_sdio mmc0:0001:1: cmd: HS_CFG_CMD:
> condition:0xffffffff gpio:0xff gap:0xff
> May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341909] mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xe5,
> cmd_pending=1
> May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341947] mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD:
> (1401090261.950120): 0xe5, act 0x1, len 16, seqno 0x61

Thanks,
Bing

