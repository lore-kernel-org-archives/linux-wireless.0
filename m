Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([216.94.44.85]:6297 "EHLO mail.lenbrook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab2AXRXf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 12:23:35 -0500
Message-ID: <4F1EE912.3080707@lenbrook.com> (sfid-20120124_182338_521383_B44A9995)
Date: Tue, 24 Jan 2012 12:23:30 -0500
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath6kl warning with stable compat-wireless-3.3-rc1-2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just doing some testing of compat-wireless-3.3-rc1-2 with ath6kl built 
against 2.6.35.3 for arm freescale imx51.  Every once in a while I get 
the below warning.  ath6kl seams stable regardless.

[  524.161702] WARNING: at 
/home/jbagg/Projects/NMB/compat-wireless-3.3-rc1-2/drivers/net/wireless/ath/ath6kl/sdio.c:474 
sdio_irq_thread+0x104/0x23c()
[  524.174936] Modules linked in: ath6kl cfg80211 compat
[  524.180085] [<80027508>] (unwind_backtrace+0x0/0xf0) from 
[<80046368>] (warn_slowpath_common+0x4c/0x64)
[  524.189508] [<80046368>] (warn_slowpath_common+0x4c/0x64) from 
[<80046398>] (warn_slowpath_null+0x18/0x1c)
[  524.199189] [<80046398>] (warn_slowpath_null+0x18/0x1c) from 
[<802470e8>] (sdio_irq_thread+0x104/0x23c)
[  524.208611] [<802470e8>] (sdio_irq_thread+0x104/0x23c) from 
[<8005c19c>] (kthread+0x78/0x80)
[  524.217065] [<8005c19c>] (kthread+0x78/0x80) from [<800239e0>] 
(kernel_thread_exit+0x0/0x8)
[  524.225435] ---[ end trace 7577e74177ef57d5 ]---

Also tried compat-wireless-2012-01-23

[  431.658564] WARNING: at 
/home/jbagg/Projects/NMB/compat-wireless-2012-01-23/drivers/net/wireless/ath/ath6kl/sdio.c:474 
sdio_irq_thread+0x104/0x23c()
[  431.671885] Modules linked in: ath6kl cfg80211 compat
[  431.677024] [<80027508>] (unwind_backtrace+0x0/0xf0) from 
[<80046368>] (warn_slowpath_common+0x4c/0x64)
[  431.686445] [<80046368>] (warn_slowpath_common+0x4c/0x64) from 
[<80046398>] (warn_slowpath_null+0x18/0x1c)
[  431.696168] [<80046398>] (warn_slowpath_null+0x18/0x1c) from 
[<802470e8>] (sdio_irq_thread+0x104/0x23c)
[  431.705596] [<802470e8>] (sdio_irq_thread+0x104/0x23c) from 
[<8005c19c>] (kthread+0x78/0x80)
[  431.714062] [<8005c19c>] (kthread+0x78/0x80) from [<800239e0>] 
(kernel_thread_exit+0x0/0x8)
[  431.722431] ---[ end trace 8612e47b83214f55 ]---

Jon

