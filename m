Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49206 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab3BLHlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 02:41:02 -0500
Received: by mail-ie0-f169.google.com with SMTP id 13so8989456iea.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 23:41:01 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 12 Feb 2013 08:41:01 +0100
Message-ID: <CADwvPCsGtzDyY4=yjMuX0qha-cdZHdZ-BTAhuwD7jb8pVXYPdw@mail.gmail.com> (sfid-20130212_084107_631620_D6113F56)
Subject: Silex SX-SDCAN (AR6003) sdio module, mmc0 timout on imx35 platform
From: Johannes Braun <jjo.braun@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

in my company we are using a Freescale imx35 based platform with a
3.7.6 Kernel. Currently I am trying to get the Silex SX-SDCAN (AR6003)
module up and running on this platform. But I have some trouble. The
module is connected via sdio.

My first try was with the ath6kl_sdio driver module of our kernel
(vanilla 3.7.6) which ends in the following error:
root@generic-armv6:~# modprobe ath6kl_sdio
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: DE
cfg80211: Regulatory domain changed to country: DE
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2400000 KHz - 2483000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2700 mBm)
ath6kl: temporary war to avoid sdio crc error
ath6kl: host only supports scatter of :1 entries, need: 16
ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.144 api 3
ath6kl: abi version mismatch: host(0x1), target(0x0)
mmc0: Timeout waiting for hardware interrupt.
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath6kl/sdio.c:487
ath6kl_sdio_irq_handler+0x78/0x84 [ath6kl_sdio]()
Modules linked in: ath6kl_sdio(+) ath6kl_core cfg80211 firmware_class ipv6
[<c0014860>] (unwind_backtrace+0x0/0xfc) from [<c03a5fa8>]
(dump_stack+0x20/0x24)
[<c03a5fa8>] (dump_stack+0x20/0x24) from [<c001ef14>]
(warn_slowpath_common+0x5c/0x74)
[<c001ef14>] (warn_slowpath_common+0x5c/0x74) from [<c001ef58>]
(warn_slowpath_null+0x2c/0x34)
[<c001ef58>] (warn_slowpath_null+0x2c/0x34) from [<bf10f56c>]
(ath6kl_sdio_irq_handler+0x78/0x84 [ath6kl_sdio])
[<bf10f56c>] (ath6kl_sdio_irq_handler+0x78/0x84 [ath6kl_sdio]) from
[<c02cbdec>] (sdio_irq_thread+0x1dc/0x288)
[<c02cbdec>] (sdio_irq_thread+0x1dc/0x288) from [<c0041824>] (kthread+0xb4/0xc0)
[<c0041824>] (kthread+0xb4/0xc0) from [<c000e5c8>] (ret_from_fork+0x14/0x20)
---[ end trace af8071666a83a3e8 ]---
mmc0: Timeout waiting for hardware interrupt.
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath6kl/sdio.c:487
ath6kl_sdio_irq_handler+0x78/0x84 [ath6kl_sdio]()
Modules linked in: ath6kl_sdio(+) ath6kl_core cfg80211 firmware_class ipv6
[<c0014860>] (unwind_backtrace+0x0/0xfc) from [<c03a5fa8>]
(dump_stack+0x20/0x24)
[<c03a5fa8>] (dump_stack+0x20/0x24) from [<c001ef14>]
(warn_slowpath_common+0x5c/0x74)
[<c001ef14>] (warn_slowpath_common+0x5c/0x74) from [<c001ef58>]
(warn_slowpath_null+0x2c/0x34)
[<c001ef58>] (warn_slowpath_null+0x2c/0x34) from [<bf10f56c>]
(ath6kl_sdio_irq_handler+0x78/0x84 [ath6kl_sdio])
[<bf10f56c>] (ath6kl_sdio_irq_handler+0x78/0x84 [ath6kl_sdio]) from
[<c02cbdec>] (sdio_irq_thread+0x1dc/0x288)
[<c02cbdec>] (sdio_irq_thread+0x1dc/0x288) from [<c0041824>] (kthread+0xb4/0xc0)
[<c0041824>] (kthread+0xb4/0xc0) from [<c000e5c8>] (ret_from_fork+0x14/0x20)
---[ end trace af8071666a83a3e9 ]---

Then I used the actual head of the github probject of ath6kl. I
checked it out and built a kernel with the sources. The result was a
3.7 kernel, the ath6kl_sdio.ko module and all the other modules. But
when I`m trying load the ath6kl module via "modprobe ath6kl_sdio" I
get the same error as before with our 3.7.6 kernel. See the log above.

Does someone have an idea what`s whats the issue?

Best regards
Johannes
