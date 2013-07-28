Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62295 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3G1Lio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jul 2013 07:38:44 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so2415463eek.10
        for <linux-wireless@vger.kernel.org>; Sun, 28 Jul 2013 04:38:43 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: FUSB200 xhci issue
Date: Sun, 28 Jul 2013 13:38:38 +0200
Cc: linux-wireless@vger.kernel.org
References: <51ED4E12.8030006@rempel-privat.de> <5176750.ryksn4nuMW@blech> <51F4B128.3010901@rempel-privat.de>
In-Reply-To: <51F4B128.3010901@rempel-privat.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201307281338.39157.chunkeey@googlemail.com> (sfid-20130728_133905_416993_894FB1F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 July 2013 07:50:32 Oleksij Rempel wrote:
> Am 27.07.2013 23:59, schrieb Christian Lamparter:
> > On Wednesday, July 24, 2013 12:37:55 PM Oleksij Rempel wrote:
> >> Am 23.07.2013 20:26, schrieb Christian Lamparter:
> >>> On Tuesday, July 23, 2013 06:59:46 AM Oleksij Rempel wrote:
> >>>> Am 22.07.2013 23:23, schrieb Christian Lamparter:
> >>>>> On Monday, July 22, 2013 10:47:41 PM Oleksij Rempel wrote:
> >>>>>> Am 22.07.2013 21:54, schrieb Christian Lamparter:
> >>>>>>> Hello!
> >>>>>>>
> >>>>>>> On Monday, July 22, 2013 05:21:54 PM Oleksij Rempel wrote:
> >>>>>>>> i'm one of ath9k_htc devs. Currently i'm working on usb_suspend issue of
> >>>>>>>> this adapters. Looks like ar9271 and ar7010 have FUSB200, and i
> >>>>>>>> accidentally discovered that 9170 have it too. Are there any issue with
> >>>>>>>> usb-suspend + xhci controllers by you? Did you some how specially
> >>>>>>>> handled it?
> >>>>>>>
> >>>>>>> No, I haven't heard any complains about xhci + suspend. In fact,
> >>>>>>> it's working fine with the NEC xhci I have. I also have a AR9271
> >>>>>>> and AR7010, so if you want I could try if they survive a suspend
> >>>>>>> +resume cycle when attached.
> >>>>>>>
> >>>>>>> But, I do have a bug-report from someone else who has/had? problems
> >>>>>>> with carl9170 and xhci. If you want, you can get the details from:
> >>>>>>> "carl9170 A-MPDU transmit problem":
> >>>>>>> <http://comments.gmane.org/gmane.linux.kernel.wireless.general/104597>
> >>>>>>>
> >>>>>>> The likely cause is related to Intel's xhci silicon (Ivy Bridge is
> >>>>>>> affected, but I don't know about Haswell):
> >>>>>>> <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/104602>
> >>>>>>
> >>>>>> Same situation is here - i have problem on Ivy Bridge.
> >>>>> (Note: I don't have any Ivy Bridge system. Just Sandy Bridge
> >>>>> and AMD's new A6-1450 Temash and both xhci work. So I can't
> >>>>> do any proper comparisons like you.)
> >>>>>
> >>>>>> Steps to reproduce:
> >>>>>> - plug adapter. Module and firmware will be loaded
> >>>>>> - make sure usb autosupend is enabled. By default it is not! Use
> >>>>>> powertop or directly sysfs to enable autosuspend for this device
> >>>>>> - rmmod .... and wait some seconds until adapter is suspended and then
> >>>>>> modprobe ath9k_htc
> >>>>
> >>>>>> first packet which is bigger as 64Byte will kill EP4 FIFO. Size register
> >>>>>> will report wrong size.. bigger as FIFO can handle. And only first ~40
> >>>>>> readet bytes will be actually OK.. all the rest of packet will be trashed.
> >>>>>
> >>>>> This is what happens with a WN721 (ar9271):
> >>>>>
> >>>>> [17619.597905] usbcore: deregistering interface driver ath9k_htc
> >>>>> [17619.679549] usb 2-2: ath9k_htc: USB layer deinitialized
> >>>>> [17619.679602] ath9k_htc: Driver unloaded
> >>>>> <suspend>
> >>>>>
> >>>>> <resume>
> >>>>> [17667.543024] usb 2-2: reset high-speed USB device number 3 using xhci_hcd <----
> >>>>> [17667.572168] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77600
> >>>>> [17667.572174] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77640
> >>>>> [17667.572177] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77680
> >>>>> [17667.572180] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa776c0
> >>>>> [17667.572183] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77700
> >>>>> [17667.572185] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77740
> >>>>> [17667.573826] usb 2-2: ath9k_htc: Firmware htc_9271.fw requested
> >>>>> [17667.573873] usbcore: registered new interface driver ath9k_htc
> >>>>> [17668.038200] usb 2-2: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
> >>>>> [17668.273249] ath9k_htc 2-2:1.0: ath9k_htc: HTC initialized with 33 credits
> >>>>>
> >>>>> The driver loads, but there's no "wlanX" interface, no phyX interface
> >>>>> and the driver can't be unloaded due to "Error: Module ath9k_htc is in use".
> >>>>
> >>>> So, it is exactly this bug.
> >>>> After firmware was loaded ath9k trying to set some registers. Since
> >>>> command buffer is trashed it will write some nonsense to registers and
> >>>> some times in wrong to wrong addresses. I have some patches to do crc
> >>>> check of commands, to easy detect corrupted ones.
> >>>>
> >>>> You reproduced it on NEC xhci? Is it possible to reproduce it in
> >>>> carl9170?
> >>>
> >>> Ok: That's dmesg of your scenario:
> >>>
> >>> [  809.995966] usbcore: deregistering interface driver carl9170
> >>> <suspend>
> >>>
> >>> <resume>
> >>> [  826.365596] usb 2-2: reset high-speed USB device number 2 using xhci_hcd
> >>> [  826.431154] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88045af2b900
> >>> [  826.431159] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88045af2b940
> >>> [  826.431162] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88045af2b980
> >>> [  826.431164] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88045af2b9c0
> >>> [  826.432257] usbcore: registered new interface driver carl9170
> >>> [  826.433717] usb 2-2: driver   API: 1.9.8 2013-03-23 [1-1]
> >>> ...
> >>> [  826.816110] usb 2-2: Atheros AR9170 is registered as 'phy3'
> >>>
> >>> carl9170 is able to recover and the stick is working after autosuspend cycle.
> >>
> >> Thank you for your tests. USB configuration and handlers look similar on
> >> this two firmwares. May be problem is not in FUSB200 and it is clock
> >> related issue so carl9170 do not need reset. - I don't know :(
> >>
> >> Can you please test this branch:
> >> https://github.com/olerem/open-ath9k-htc-firmware/commits/next
> >> There is a workaround to reset adapter, right after this bug is
> >> detected. It is really dirty hack, but currently i do not know how to
> >> fix this bug on xhci or on ath9k-htc side.
> >>
> > Is it still Saturday?
> >
> > Anyway, I tried the -next branch.
> >
> > commit dbbb809d592dde0b3c9ecb97b3b387ff8e40e799
> > Author: Oleksij Rempel <linux@rempel-privat.de>
> > Date:   Wed Jul 24 10:26:18 2013 +0200
> >
> >      k2_fw_usb_api: workaround for EP4 bug.
> >
> > but still, the device won't show up after autosuspend.
> 
> Hm... firmware probably didn't rebooted before suspend. Did interface 
> was up, before autosuspend? If no, you need latest wireles-testing - 
> there are patches to handle this issue. Or just make "ifconfig wlan1 up" 
>   before  rmmod.
Oh, I it was on the latest wireless-testing. (And the "ath9k_htc" module
had the patch "ath9k_htc: reboot firmwware if it was loaded").

Furthermore, I did the same test with one of the ehci-only ports
and it worked. Both, devices (one had a AR7015, the other a AR9271)
came back after autosuspend there.

> then i would need last log messages from firmware.. If  there is
> some way to attach to uart pins on it.
Sorry, I can't really help you there as I don't have the
necessary tools. But I would be happy to test patches.

Regards,
	Chr
