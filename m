Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:44215 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXKVXiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 18:38:55 -0500
Received: by an-out-0708.google.com with SMTP id d31so622340and
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 15:38:54 -0800 (PST)
Message-ID: <40f31dec0711221538i503119b7hdeffbbde50629a6c@mail.gmail.com> (sfid-20071122_233858_921384_6F283C3F)
Date: Fri, 23 Nov 2007 01:38:54 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: Majo <virec@inmail.sk>
Subject: Re: AR5006X on Fijitsu-Siemens Lifebook E8410 - not work
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200711222310.01165.virec@inmail.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200711222310.01165.virec@inmail.sk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/23, Majo <virec@inmail.sk>:
> Hi,
>
> ath5sudo k don't work with my Notebook Wifi Card
>
> sudo lspci -v
>
> 14:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG 802.11 b/g
> Wireless PCI Express Adapter (rev 01)

This is a 2424 pci-express card, we don't support this chip yet ;-(

(damn i thought that was only the pci express version of 5414 that we
just fixed, seems there's more to do)

>   Subsystem: Atheros Communications, Inc. Unknown device 3067
>   Flags: fast devsel, IRQ 19
>   Memory at fe200000 (64-bit, non-prefetchable) [size=64K]
>   Capabilities: [40] Power Management version 2
>   Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0
> Enable-
>   Capabilities: [60] Express Legacy Endpoint IRQ 0
>   Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
>
> - in Windows XP is detected as AR5006X
>
> dmesg
>
> [ 1276.969782] ACPI: PCI Interrupt 0000:14:00.0[A] -> GSI 19 (level, low) ->
> IRQ
> 19
> [ 1276.969811] PCI: Setting latency timer of device 0000:14:00.0 to 64
> [ 1277.982089] ath5k_hw_nic_wakeup: failed to resume the MAC Chip

Hmm it seems that 5424/2424 and later chips have a different reset
sequence we are not aware of. We 'll need traces to make it work, if
you have some time plz take a look here ->
http://madwifi.org/wiki/DevDocs/MadwifiTrace (the testbed stuff would
really help)


Thanx for the feedback ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
