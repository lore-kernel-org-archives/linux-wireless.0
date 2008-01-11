Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ag-out-0708.google.com ([72.14.246.243]:58516 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759472AbYAKQ4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 11:56:25 -0500
Received: by ag-out-0708.google.com with SMTP id 23so819483agd.10
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 08:56:23 -0800 (PST)
Message-ID: <40f31dec0801110856r1d0e04f3i284afb2a3f64f8c1@mail.gmail.com> (sfid-20080111_165630_351019_7BE3D42B)
Date: Fri, 11 Jan 2008 18:56:23 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Romano Giannetti" <romanol@upcomillas.es>
Subject: Re: Testing ath5k driver
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1200049360.12702.14.camel@rukbat>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1200049360.12702.14.camel@rukbat>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/11, Romano Giannetti <romanol@upcomillas.es>:
>
> Hi all,
>
> I stumbled yesterday on the compat- package and I could not resist to
> test the new drivers on my laptop. (BTW, the link to the download page
> on http://linuxwireless.org/en/users/Drivers/ath5k is wrong).
>
> I have a toshiba U305 with a Atheros chipset, marked as AR5BXB63 or
> AR5007EG.
>
> 06:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG 802.11 b/g Wireless PCI Express Adapter (rev 01)
>         Subsystem: Askey Computer Corp. Unknown device 7128
>         Flags: fast devsel, IRQ 19
>         Memory at 88200000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: [40] Power Management version 2
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
>         Capabilities: [60] Express Legacy Endpoint IRQ 0
>         Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel
> 00: 8c 16 1c 00 42 01 10 00 01 00 00 02 10 00 00 00
> 10: 04 00 20 88 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 01 50 00 00 4f 14 28 71
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
>
> I have built the yesterday  compat-wireless-2.6.tar.bz2 and after all
> the step I have:
>
> [  312.999107] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> [  312.999141] PCI: Setting latency timer of device 0000:06:00.0 to 64
> [  312.999351] ath5k_pci 0000:06:00.0: registered as 'phy0'
> [  314.048568] ath5k phy0: failed to resume the MAC Chip
> [  314.048652] ACPI: PCI interrupt for device 0000:06:00.0 disabled
> [  314.048674] ath5k_pci: probe of 0000:06:00.0 failed with error -5
>
> So... just to give you a data point. I am available to test things. The
> wireless works ok[*] with ndiswrapper and XP drivers for AR5008.
>
> Romano
>
> [*] Well, if I do not try to load ath5k modules. After that, and after
> unload it and all of the dependent modules, trying to load ndiswrapper
> again put the laptop in brick mode. But that's another story, I know.
>

It's a known bug in nic_wakeup, i've fixed it but patch is pending due
to testing. Problem is that even with that fix RF2425 doesn't tx/rx,
we are currently working with users to fix 2413/2414 support (radio
revision 0x56) so it'll take a while (tests etc) before we make this
work.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
