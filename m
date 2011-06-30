Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51325 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1F3Meb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 08:34:31 -0400
Received: by iwn6 with SMTP id 6so1856667iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 05:34:30 -0700 (PDT)
Message-ID: <4E0C6D52.7010207@lwfinger.net> (sfid-20110630_143434_659740_66A0336D)
Date: Thu, 30 Jun 2011 07:34:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Beggy <chrisb@kippona.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	'Chaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: rtl8192se from recent git pull
References: <20110630.015016.392442825.chrisb@kippona.net>
In-Reply-To: <20110630.015016.392442825.chrisb@kippona.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 12:50 AM, Chris Beggy wrote:
>
> Larry Finger,
>
> I am testing the rtl8192se wireless driver in my eeepc 1001XPD.
> The firmware is not recognized.  Here are outputs from dmesg and
> lspci:
>
>
> [    6.157167] rtl8192se 0000:02:00.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
> [    6.157184] rtl8192se 0000:02:00.0: setting latency timer to 64
> [    6.170010] rtl8192se: Driver for Realtek RTL8192SE/RTL8191SE
> [    6.170015]            Loading firmware rtlwifi/rtl8192sefw.bin
> [    6.331352] rtl8192se:rtl92s_init_sw_vars():<0-0>  Failed to request firmware!
> [    6.331364] rtlwifi:rtl_pci_probe():<0-0>  Can't init_sw_vars.
> [    6.331418] rtl8192se 0000:02:00.0: PCI INT A disabled
>
> 02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvA Wireless LAN Controller (rev 1
> 0)
> 	Subsystem: AzureWave Device 1107
> 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- D
> isINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR-
>   INTx-
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: I/O ports at e800 [size=256]
> 	Region 1: Memory at fbffc000 (32-bit, non-prefetchable) [size=16K]
> 	Capabilities:<access denied>
>
> Kernel is:
>
> Linux netbook 3.0.0-rc3netbook1-00256-gde505e7 #2 SMP Tue Jun 21
> 09:49:40 EDT 2011 i686 GNU/Linux

I added the linux-wireless mailing list and the other module author (Chaoming 
Li) to this reply.

The first place to check is that /lib/firmware/rtlwifi/rtl8192sefw.bin exists on 
your system. The message you got indicates that the file is not present. If that 
is the case, you can likely get it from your distro, or from the linux-firmware 
git repository.

If the firmware file does exist on your system, then check the md5sum for that 
file. It should be bccf9bf2276621770f101a60736b4004.

Finally, what is the PCI ID for your card as shown by the 'lspci -nn' command? 
That info is missing from your posting.

Larry


