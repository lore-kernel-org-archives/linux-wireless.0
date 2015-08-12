Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36840 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbHLR6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 13:58:19 -0400
Received: by oiev193 with SMTP id v193so13291876oie.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 10:58:18 -0700 (PDT)
Subject: Re: Wireless driver issue
To: "Richards, Sean" <srichards@gpo.gov>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <BY1PR09MB061612E4649D00B899E62DF9B57E0@BY1PR09MB0616.namprd09.prod.outlook.com>
Cc: "ft86drifter@cox.net" <ft86drifter@cox.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55CB88DC.9070502@lwfinger.net> (sfid-20150812_195823_182939_6CB0557F)
Date: Wed, 12 Aug 2015 12:56:44 -0500
MIME-Version: 1.0
In-Reply-To: <BY1PR09MB061612E4649D00B899E62DF9B57E0@BY1PR09MB0616.namprd09.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2015 12:05 PM, Richards, Sean wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=1239050
>
> Here is some of the information I copied from bugzilla
>
>
> Product version:  Lenovo Yoga 3 Pro-1370
> Vendor: Lenovo
>
> # rfkill list
> 0: ideapad_wlan: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no
> 1: ideapad_bluetooth: Bluetooth
> 	Soft blocked: no
> 	Hard blocked: no
> 3: hci0: Bluetooth
> 	Soft blocked: no
> 	Hard blocked: no
>
> # lspci
> 01:00.0 Network controller:  Broadcom Corportion BCM4352 801.11ac Wireless Netwrok Adapter (Rev 03)
>
> #cat dmesg.log
>
> [    7.829696] intel_rapl: Found RAPL domain package
> [    7.829700] intel_rapl: Found RAPL domain core
> [    7.829703] intel_rapl: Found RAPL domain dram
> [    7.860817] b43-phy0: Broadcom 4352 WLAN found (core revision 42)
> [    7.884409] bcma: bus0: HT force timeout
> [    8.034006] bcma: bus0: PLL enable timeout
> [    8.034053] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 12, Type 11 (AC), Revision 1)
> [    8.034066] b43: probe of bcma0:1 failed with error -95
> [    8.034085] Broadcom 43xx driver loaded [ Features: PMNLS ]
> [    8.801760] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    8.801764] Bluetooth: BNEP filters: protocol multicast
> [    8.801768] Bluetooth: BNEP socket layer initialized
> [    8.972838] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
>
> # lspci -nn
> 00:00.0 Host bridge [0600]: Intel Corporation Broadwell-U Host Bridge -OPI [8086:1604] (rev 08)
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Broadwell-U Integrated Graphics [8086:161e] (rev 08)
> 00:03.0 Audio device [0403]: Intel Corporation Broadwell-U Audio Controller [8086:160c] (rev 08)
> 00:04.0 Signal processing controller [1180]: Intel Corporation Broadwell-U Camarillo Device [8086:1603] (rev 08)
> 00:14.0 USB controller [0c03]: Intel Corporation Wildcat Point-LP USB xHCI Controller [8086:9cb1] (rev 03)
> 00:16.0 Communication controller [0780]: Intel Corporation Wildcat Point-LP MEI Controller #1 [8086:9cba] (rev 03)
> 00:1b.0 Audio device [0403]: Intel Corporation Wildcat Point-LP High Definition Audio Controller [8086:9ca0] (rev 03)
> 00:1c.0 PCI bridge [0604]: Intel Corporation Wildcat Point-LP PCI Express Root Port #3 [8086:9c94] (rev e3)
> 00:1f.0 ISA bridge [0601]: Intel Corporation Wildcat Point-LP LPC Controller [8086:9cc7] (rev 03)
> 00:1f.2 SATA controller [0106]: Intel Corporation Wildcat Point-LP SATA Controller [AHCI Mode] [8086:9c83] (rev 03)
> 00:1f.3 SMBus [0c05]: Intel Corporation Wildcat Point-LP SMBus Controller [8086:9ca2] (rev 03)
> 00:1f.6 Signal processing controller [1180]: Intel Corporation Wildcat Point-LP Thermal Management Controller [8086:9ca4] (rev 03)
> 01:00.0 Network controller [0280]: Broadcom Corporation BCM4352 802.11ac Wireless Network Adapter [14e4:43b1] (rev 03)
>
>
> Sean Richards
> Accelera | GPO Contractor
> Citrix | VMware | M.S.
> Ext. 20306

I would think that "> [    8.034053] b43-phy0 ERROR: FOUND UNSUPPORTED PHY 
(Analog 12, Type 11 (AC), Revision 1)" would be self explanatory. Obviously, b43 
does not support that device, and I doubt that it ever will. Reverse engineering 
802.11g was difficult, 802.11n was much harder, and I suspect that 802.11ac 
would be impossible.

Your only option is to use the Broadcom hybrid (proprietary) driver. It will 
taint your kernel, and we do not support it here, but it is your only choice.

Larry



