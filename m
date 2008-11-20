Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rent-a-mailserver.de ([217.69.77.126]:58447 "EHLO
	smtp.rent-a-mailserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYKTRiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 12:38:46 -0500
Message-ID: <49259F12.7040403@schulte.it> (sfid-20081120_183851_179114_F47AE1A2)
Date: Thu, 20 Nov 2008 18:32:02 +0100
From: Christian Schulte <cs@schulte.it>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/mac80211/rx.c:388	__ieee80211_rx_handle_packet+0x1fe/0x627
 [mac80211]()
References: <4922D9D5.2020507@schulte.it>	 <20081119165329.15e5a6d4.akpm@linux-foundation.org>	 (sfid-20081120_015353_985468_5559E0F5) <1227163698.17336.12.camel@johannes.berg>
In-Reply-To: <1227163698.17336.12.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2008-11-19 at 16:53 -0800, Andrew Morton wrote:
>> (cc linux-wireless)
>>
>> On Tue, 18 Nov 2008 16:05:57 +0100
>> Christian Schulte <cs@schulte.it> wrote:
>>
>>> this is with the 2.6.27.6 iwl3945 module. Is it some misconfiguration on
>>> my side ?
> 
> Yes.
> 
> config MAC80211_DEBUG_PACKET_ALIGNMENT
>         bool "Enable packet alignment debugging"   
>         depends on MAC80211_DEBUG_MENU 
>         ---help---
>           This option is recommended for driver authors and strongly
>           discouraged for everybody else, it will trigger a warning
>           when a driver hands mac80211 a buffer that is aligned in
>           a way that will cause problems with the IP stack on some
>           architectures.
> 
>           Say N unless you're writing a mac80211 based driver.
> 

There is a reason I enabled debugging, of course. I thought the
following messages could be related to the wireless card when trying to
reproduce things. This happens sporadically and there is no way to
reproduce it. Maybe the hardware is going bad.

Nov 16 21:50:44 r60 kernel: Uhhuh. NMI received for unknown reason a0 on
CPU 0.
Nov 16 21:50:44 r60 kernel: You have some hardware problem, likely on
the PCI bus.
Nov 16 21:50:44 r60 kernel: Dazed and confused, but trying to continue

> 
> Intel doesn't care to make their drivers work on platforms that don't
> like unaligned loads, so in the foreseeable future this warning will
> show once if you enable that option above that specifically tells you to
> turn it off.....
> 

Also seeing lots of

Nov 19 19:54:02 r60 kernel: wlan0_rename (WE) : Wireless Event too big (320)

messages. This is a lenovo r60.

r60:~# lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
945GT Express Memory Controller Hub (rev 03)
00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
945GT Express PCI Express Root Port (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family)
Serial ATA Storage Controller AHCI (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
(rev 02)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility
X1400
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5751M
Gigabit Ethernet PCI Express (rev 21)
03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
Network Connection (rev 02)
15:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
15:00.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
IEEE 1394 Host Controller

Will turn of all debugging then.

Thanks!

-- 
Christian

