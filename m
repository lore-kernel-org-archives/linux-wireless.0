Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:21111 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585AbYCEQCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 11:02:48 -0500
Received: by ti-out-0910.google.com with SMTP id 28so1970563tif.23
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 08:02:46 -0800 (PST)
Message-ID: <40f31dec0803050802y702bd648ub53a1f8e5453f661@mail.gmail.com> (sfid-20080305_160328_326649_570A5278)
Date: Wed, 5 Mar 2008 18:02:44 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jerry Quinn" <jlquinn@optonline.net>
Subject: Re: [Fwd: ath5k not working on 5212 mini-pci card]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47CE89B1.3050405@optonline.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47CE89B1.3050405@optonline.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/3/5, Jerry Quinn <jlquinn@optonline.net>:
> Hi.  I just downloaded the wireless compat package (2008-03-04) to try
>  out ath5k on my thinkpad T60p.  I'm running Debian testing with the
>  Debian 2.6.22 kernel with uname
>     Linux naga 2.6.22-3-686 #1 SMP Mon Nov 12 08:32:57 UTC 2007 i686
>  GNU/Linux
>
>  When I try to load ath5k, I get the following kernel output:
>
>  Mar  5 00:03:42 naga kernel: PCI: Enabling device 0000:03:00.0 (0000 ->
>  0002)
>  Mar  5 00:03:42 naga kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI
>  17 (level, low) -> IRQ 21
>  Mar  5 00:03:42 naga kernel: PCI: Setting latency timer of device
>  0000:03:00.0 to 64
>  Mar  5 00:03:42 naga kernel: ath5k_pci 0000:03:00.0: registered as 'phy1'
>  Mar  5 00:03:43 naga kernel: ath5k phy1: failed to wakeup the MAC Chip
>  Mar  5 00:03:43 naga kernel: ACPI: PCI interrupt for device 0000:03:00.0
>  disabled
>  Mar  5 00:03:43 naga kernel: ath5k_pci: probe of 0000:03:00.0 failed
>  with error -5
>
>
>  lspci -vnn gives this for the wireless device:
>
>  03:00.0 Ethernet controller [0200]: Atheros Communications, Inc. AR5212
>  802.11abg NIC [168c:1014] (rev 01)
>     Subsystem: IBM ThinkPad 11a/b/g Wireless LAN Mini Express Adapter
>  (AR5BXB6) [1014:058a]
>     Flags: fast devsel, IRQ 21
>     Memory at edf00000 (64-bit, non-prefetchable) [size=64K]
>     Capabilities: [40] Power Management version 2
>     Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
>  Queue=0/0 Enable-
>     Capabilities: [60] Express Legacy Endpoint, MSI 00
>     Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
>     Capabilities: [100] Advanced Error Reporting <?>
>     Capabilities: [140] Virtual Channel <?>
>     Kernel modules: ath5k
>
>  I know the driver is still under development, but thought it might work
>  since 168c:0014 is listed as likely working.
>
>
>  Thanks,
>  Jerry Quinn
>
>  </div>
>

Yup, it's a known problem with pci-e cards (at least we think it's for
all pci-e cards for now, we are sure it affects 2424/5424 and 2425).
It's being fixed so expect a patch on wireless-testing soon. Have in
mind that your card is not a 5212 (else your card should work), newer
thinkpads have a 5424 card but for some reason IBM uses the same pci
id.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
