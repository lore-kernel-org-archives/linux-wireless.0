Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12548 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab3CHHUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 02:20:05 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Braun <jjo.braun@gmail.com>
Subject: Re: Silex SX-SDCAN (AR6003) sdio module, mmc0 timout on imx35 platform
References: <CADwvPCsGtzDyY4=yjMuX0qha-cdZHdZ-BTAhuwD7jb8pVXYPdw@mail.gmail.com>
Date: Fri, 8 Mar 2013 09:19:59 +0200
In-Reply-To: <CADwvPCsGtzDyY4=yjMuX0qha-cdZHdZ-BTAhuwD7jb8pVXYPdw@mail.gmail.com>
	(Johannes Braun's message of "Tue, 12 Feb 2013 08:41:01 +0100")
Message-ID: <87txoms6hs.fsf@kamboji.qca.qualcomm.com> (sfid-20130308_082011_584826_692606EA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Johannes Braun <jjo.braun@gmail.com> writes:

> in my company we are using a Freescale imx35 based platform with a
> 3.7.6 Kernel. Currently I am trying to get the Silex SX-SDCAN (AR6003)
> module up and running on this platform. But I have some trouble. The
> module is connected via sdio.

Is your platform big endian or little endian? I haven't tested ath6kl on
a big endian platform so there might be issues.

> My first try was with the ath6kl_sdio driver module of our kernel
> (vanilla 3.7.6) which ends in the following error:
> root@generic-armv6:~# modprobe ath6kl_sdio
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: World regulatory domain updated:
> cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> cfg80211: Calling CRDA for country: DE
> cfg80211: Regulatory domain changed to country: DE
> cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> cfg80211:   (2400000 KHz - 2483000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2700 mBm)
> ath6kl: temporary war to avoid sdio crc error
> ath6kl: host only supports scatter of :1 entries, need: 16
> ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.144 api 3
> ath6kl: abi version mismatch: host(0x1), target(0x0)
> mmc0: Timeout waiting for hardware interrupt.

The last two messages make me suspect a hardware problem, but it's
difficult to know really.

Can you please enable debug messages and send them? Especially these
levels are important:

	ATH6KL_DBG_SDIO		= BIT(16),
	ATH6KL_DBG_SDIO_DUMP	= BIT(17),
	ATH6KL_DBG_BOOT		= BIT(18),    /* driver init and fw boot */

Or you could just enable everything with debug_mask=0xffffffff. More
info here:

http://wireless.kernel.org/en/users/Drivers/ath6kl/Debug

Also try various quirks in the SDIO controller, if it supports those.
For example in some platforms using sdhci people have had to disable DMA
etc to get SDIO bus reliable.

-- 
Kalle Valo
