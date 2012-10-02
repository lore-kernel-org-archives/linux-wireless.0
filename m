Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw-out1.cc.tut.fi ([130.230.160.32]:52442 "EHLO
	mail-gw-out1.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2JBSfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 14:35:11 -0400
Message-ID: <506B3052.4000206@iki.fi> (sfid-20121002_203516_766641_34D6BE30)
Date: Tue, 02 Oct 2012 21:20:02 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: David Smith <sidicas2@gmail.com>
CC: platform-driver-x86@vger.kernel.org,
	linux-wireless@vger.kernel.org, 684352@bugs.debian.org
Subject: Re: phy0/hp-wifi problems after kernel update from 2.6 to 3.2
References: <CA+7qwUkZiysOF-ocV+wyTGfnFyiGH6G=TiEB+ts89Pb=NvgpxA@mail.gmail.com>
In-Reply-To: <CA+7qwUkZiysOF-ocV+wyTGfnFyiGH6G=TiEB+ts89Pb=NvgpxA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

02.10.2012 17:28, David Smith kirjoitti:
> 
> Hello, I'm having a problem with my Intel 2200 wireless on my Compaq
> Presario V4000T (made by HP) that has started happening after I upgraded
> my kernel from 2.6 to 3.2.
> 
> Problem: phy0 wireless state is incorrect.
> 
> Steps to reproduce problem:
> 1. Upgrade kernel from 2.6 to 3.2
> 2. rfkill now reports that I have two wireless devices but I only have
> the Intel 2200 wireless:
> 
>  Miho:/home/david# rfkill list all
>  0: hp-wifi: Wireless LAN
>          Soft blocked: yes
>          Hard blocked: no
>  1: phy0: Wireless LAN
>          Soft blocked: yes
>          Hard blocked: yes
> 
> 3.  The wireless simply doesn't work anymore because all software
> believes the wireless is blocked with a hardware switch, which is not
> the case.
> 
> After many many hours of searching, I discovered that running "rfkill
> unblock all" is able to remove the "Hard Block" from phy0 and put the
> wireless into this state:

Sounds like the "hp-wifi" soft block status affects "phy0" hard block
status. So if some management program softblocks "hp-wifi", the "phy0"
will become hardblocked and the program doesn't understand that it needs
to unblock "hp-wifi" again to undo what it just did.

I have no idea what is the proper course of action here, though, but
hopefully someone else on the lists has an idea.



> 
> Miho:/home/david# rfkill unblock all
> Miho:/home/david# rfkill list all
> 0: hp-wifi: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> Miho:/home/david#
> 
> 
> However, I find that I have to keep dropping to a console and running
> "sudo rfkill unblock all" because the hardware keeps going back into the
> first state where phy0 is reporting that it is hard blocked, when it
> really isn't.
> 
> 
> 
> Workaround #1: Set "ACPI=off" on 3.2 kernel. After which, the wireless
> appears to be correctly reported:
> Miho:/home/david# rfkill list all
> 0: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 
> This causes phy0 to accurately reflect the state of the hardware.
> 
> Workaround #2: Add hp-wmi to modprobe blacklist.  Again, this causes
> only phy0 wireless to be reported and phy0 always accurately reflects
> the state of the hardware (both soft and hard blocked).
> 
> Expected Results;
> Both phy0 and hp-wifi refer to the same hardware device so they should
> accurately report the correct state of that hardware device.
> 
> Actual Results:
> Phy0 reports it is hard blocked when there is no hard block on the
> wireless.  Further, phy0 keeps going into this "hard blocked" state from
> regular usage of the wireless with networkmanager, while the hp-wmi does
> not.  If I remove the hp-wmi then the phy0 works properly.  When I have
> hp-wmi, then phy0's state is often incorrect.  It seems there may be
> some conflict here between phy0 and hp-wmi.
> 
> 
>   
> Kernel versions tested:
> linux-image-3.2.0-3-686-pae: Wireless regularly gets into this "bad
> state" of reporting it's hard blocked when it isn't. Unable to recover
> from it without using "sudo rfkill unblock all".
> 
> linux-image-2.6.32-5-686: No problem at all
>  
> 
>  PCI registers from the only wireless device I have in this PC:
>  
>  Miho:/home/david# lspci -vv -s06:05.0
> 06:05.0 Network controller: Intel Corporation PRO/Wireless 2200BG
> [Calexico2] Network Connection (rev 05)
>         Subsystem: Hewlett-Packard Company Device 12f5
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 128 (750ns min, 6000ns max), Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 20
>         Region 0: Memory at c8206000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [dc] Power Management version 2
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
>         Kernel driver in use: ipw2200
> 
> Miho:/home/david#
> 
> 
> Somehow network manager is putting phy0 into a "hard blocked" state, but
> the hardware is not really hardblocked. After going into this hard
> blocked state, the wireless cannot be used anymore unless dropping to a
> console and running sudo rfkill unblock all which removes the "hard
> block" from phy0. Networkmanager alone is not able to bring the wireless
> back up.
> 
> Also, sometimes when I turn on the PC, or resume from hibernate the
> rfkill reports phy0 as hard blocked, when it isn't. Which again, forces
> me to drop to console and run a "sudo rfkill unblock all"
> 
> I am currently using Workaround #2 and am very happy with it. The
> wireless no longer goes into "hard blocked" through normal usage of the
> hardware with network manager.
> 
> Thank you for your time.

-- 
Anssi Hannula
