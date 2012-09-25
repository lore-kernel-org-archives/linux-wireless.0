Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43022 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2IYNZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 09:25:13 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so13805250iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2012 06:25:13 -0700 (PDT)
Message-ID: <5061B0B5.3040103@lwfinger.net> (sfid-20120925_152518_032258_2F8A93E9)
Date: Tue, 25 Sep 2012 08:25:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: kerolasa@gmail.com
CC: Sami Kerola <kerolasa@iki.fi>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce, system freeze and bios reset
References: <CAG27Bk3tuw+P34btGic9pKwof3xsDw=dBpm-VEgv-RxN-BgVaQ@mail.gmail.com>
In-Reply-To: <CAG27Bk3tuw+P34btGic9pKwof3xsDw=dBpm-VEgv-RxN-BgVaQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2012 02:49 PM, Sami Kerola wrote:
> FYI rtl8192ce maintainers (and maillist archive readers),
>
> I recently bought Toshiba Satellite C850D-107 version PSC9SE-00T00DEN
> which comes with Realtek hardware[1].
>
> Initially I had a bit of problems with Arch Linux kernel 3.5.4-1-ARCH
> which froze after running wpa_supplicant.  Once the command had been
> entered it took about 5 to 10 seconds before real trouble, by which I
> mean terminal did not echo keystrokes nor feel any way responsive.  I did
> not try Magic SysRq's.
>
> Strange enough that problem persisted over boot, and went away only if I
> went to BIOS and set factory defaults.  Once factory defaults where set I
> could use console again, as long I did not try to do anything with
> wpa_supplicant command.  After wondering for while I found
> instructions[2] how to go around; disable power saving, e.g., the set the
> lines below.
>
> $ cat /etc/modprobe.d/rtl8192ce.conf
> options rtl8192ce ips=0 fwlps=0
>
> That worked I became curious if the latest kernel would have the same
> issue.  Now I am running 3.6.0-rc6-ARCH-00193-ge5e77cf from Linus's git
> with new firmware[3], and power save enabled.  At least after an hour all
> seems to work fine.
>
> Did you anticipate firmware change to fix this these sort of problem?
>
>
> [1] The hardware:
> 06:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
> 802.11b/g/n WiFi Adapter (rev 01)
> 	Subsystem: Realtek Semiconductor Co., Ltd. Device 8212
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: I/O ports at 3000 [size=256]
> 	Region 2: Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: rtl8192ce
>
> [2] https://bbs.archlinux.org/viewtopic.php?id=132931
>
> [3] md5sum /usr/lib/firmware/rtlwifi/rtl8192cfwU_B.bin
> dd371739aa401ea1d615436b24598bc4 /usr/lib/firmware/rtlwifi/rtl8192cfwU_B.bin

As I do not have a Toshiba laptop, I have no idea what the change in BIOS 
setting might have done.

I doubt that adding the rtl8192cfwU_B.bin firmware to your system made any 
difference. The device that needs that firmware is a B-cut RTL8188CE, and the 
code to drive it has been submitted to wireless-testing, but not yet merged. I 
expect that it will be in kernel 3.7. Kernel 3.6-rc7 from mainline contains code 
that detects the B-cut device and logs a warning, but there are no other changes.

The output of the dmesg command will say what firmware has been loaded.

Larry

