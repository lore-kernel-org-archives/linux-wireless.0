Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44020 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZKGOLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 09:11:43 -0500
Received: by bwz27 with SMTP id 27so2066234bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 06:11:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911021522.38842.mb@bu3sch.de>
References: <4888b8cb0911010451w3e824921ob5ee6b7aae5b728b@mail.gmail.com>
	<69e28c910911020326m67797910ub1df048d8dd3eb7e@mail.gmail.com>
	<4888b8cb0911020557m226d8bccx36da7949459369f@mail.gmail.com>
	<200911021522.38842.mb@bu3sch.de>
From: Thomas Wiecki <thomas.wiecki@googlemail.com>
Date: Sat, 7 Nov 2009 15:11:25 +0100
Message-ID: <4888b8cb0911070611j365f2fa7ldde193bfde37f6e3@mail.gmail.com>
Subject: Re: b43 with 14e4 gives DMA error
To: Michael Buesch <mb@bu3sch.de>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't know if I did it right, let me know if there is anything else
you need. Here is kern.log (I added CONFIG_B43_DEBUG to config.mk,
also, I am running compat-wireless-2009-11-07 -- I also tried most
recent wireless-testing, however, with the same result):

Nov  7 15:01:30 lateralus kernel: [  101.013386] cfg80211: Calling
CRDA to update world regulatory domain
Nov  7 15:01:30 lateralus kernel: [  101.117855] b43-pci-bridge
0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Nov  7 15:01:30 lateralus kernel: [  101.117878] b43-pci-bridge
0000:0c:00.0: setting latency timer to 64
Nov  7 15:01:30 lateralus kernel: [  101.184603] ssb: Sonics Silicon
Backplane found on PCI device 0000:0c:00.0
Nov  7 15:01:30 lateralus kernel: [  101.222674] cfg80211: World
regulatory domain updated:
Nov  7 15:01:30 lateralus kernel: [  101.222683]        (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Nov  7 15:01:30 lateralus kernel: [  101.222691]        (2402000 KHz -
2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov  7 15:01:30 lateralus kernel: [  101.222697]        (2457000 KHz -
2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Nov  7 15:01:30 lateralus kernel: [  101.222704]        (2474000 KHz -
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Nov  7 15:01:30 lateralus kernel: [  101.222710]        (5170000 KHz -
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov  7 15:01:30 lateralus kernel: [  101.222716]        (5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov  7 15:01:30 lateralus kernel: [  101.237106] b43-phy0: Broadcom
4312 WLAN found (core revision 15)
Nov  7 15:01:30 lateralus kernel: [  101.331600] phy0: Selected rate
control algorithm 'minstrel'
Nov  7 15:01:30 lateralus kernel: [  101.332296] Registered led
device: b43-phy0::tx
Nov  7 15:01:30 lateralus kernel: [  101.332309] Registered led
device: b43-phy0::rx
Nov  7 15:01:30 lateralus kernel: [  101.332322] Registered led
device: b43-phy0::radio
Nov  7 15:01:30 lateralus kernel: [  101.332368] Broadcom 43xx driver
loaded [ Features: PML, Firmware-ID: FW13 ]
Nov  7 15:01:30 lateralus kernel: [  101.424508] b43 ssb0:0: firmware:
requesting b43/ucode15.fw
Nov  7 15:01:31 lateralus kernel: [  101.657129] b43 ssb0:0: firmware:
requesting b43/lp0initvals15.fw
Nov  7 15:01:31 lateralus kernel: [  101.667660] b43 ssb0:0: firmware:
requesting b43/lp0bsinitvals15.fw
Nov  7 15:01:31 lateralus kernel: [  101.820518] b43-phy0: Loading
firmware version 478.104 (2008-07-01 00:50:23)
Nov  7 15:01:37 lateralus kernel: [  107.761441] b43-phy0 ERROR: Fatal
DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
0x00000000
Nov  7 15:01:37 lateralus kernel: [  107.761457] b43-phy0: Controller
RESET (DMA error) ...
Nov  7 15:01:37 lateralus kernel: [  107.992539] b43-phy0: Loading
firmware version 478.104 (2008-07-01 00:50:23)
Nov  7 15:01:42 lateralus kernel: [  113.617348] b43-phy0: Controller restarted

On Mon, Nov 2, 2009 at 3:22 PM, Michael Buesch <mb@bu3sch.de> wrote:
> Can we have a full kernel log with b43 debugging enabled, please? (CONFIG_B43_DEBUG)
>
> --
> Greetings, Michael.
>
