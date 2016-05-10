Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:33797 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbcEJJkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 05:40:18 -0400
Received: by mail-qg0-f45.google.com with SMTP id 90so3108594qgz.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2016 02:40:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGm1_ksxoKXRO0gk5JEbTB2FVmpZeo6rTiB1rcqWc1QD3eYpBw@mail.gmail.com>
References: <5500469A22567C4BAF673A6E86AFA3A4022D20C81874@IR-CENTRAL.corp.innerrange.com>
 <5500469A22567C4BAF673A6E86AFA3A4022D20D2522C@IR-CENTRAL.corp.innerrange.com>
 <CAGm1_kubZOc_ddjg6i-PkZ_TuhFjt6foFOs4kZqJ5KjEu1iw6w@mail.gmail.com>
 <5500469A22567C4BAF673A6E86AFA3A4022D20D2524E@IR-CENTRAL.corp.innerrange.com> <CAGm1_ksxoKXRO0gk5JEbTB2FVmpZeo6rTiB1rcqWc1QD3eYpBw@mail.gmail.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Tue, 10 May 2016 11:39:57 +0200
Message-ID: <CAGm1_kvR0nkJeE0+dpaACc7=hY6+iWR1rK=cn84B+zvEwZ6iMg@mail.gmail.com> (sfid-20160510_114023_145273_B20953CD)
Subject: Re: rt2800 and BeagleBone Black soft lockup when unplugging from USB hub
To: Craig McQueen <craig.mcqueen@innerrange.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bin Liu <b-liu@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2016 at 9:43 AM, Yegor Yefremov
<yegorslists@googlemail.com> wrote:
> On Tue, May 10, 2016 at 9:17 AM, Craig McQueen
> <craig.mcqueen@innerrange.com> wrote:
>> Yegor Yefremov wrote:
>>> Hi Craig,
>>>
>>> On Tue, May 10, 2016 at 8:08 AM, Craig McQueen
>>> <craig.mcqueen@innerrange.com> wrote:
>>> > I previously wrote:
>>> >> I previously wrote:
>>> >> > I previously wrote:
>>> >> > >
>>> >> > > I have a D-Link DWA-140 USB Wi-Fi device which is rt2800 based
>>> >> > > (5392 chipset). I've been testing it on a BeagleBone Black
>>> >> > > running an Ubuntu
>>> >> > > 16.04 image (4.4.6 kernel), with a USB hub.
>>> >> > >
>>> >> > > When I unplug the Wi-Fi device from the USB hub, and it's
>>> >> > > connected to an access point, and then I unplug it, the OS appears to
>>> lock up.
>>> >> > > I get messages about a soft lockup on the serial console:
>>> >> > >
>>> >> > > [ 9736.136702] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
>>> >> > > [kworker/u2:0:1129] [ 9764.136701] NMI watchdog: BUG: soft lockup
>>> >> > > -
>>> >> > > CPU#0 stuck for 22s! [kworker/u2:0:1129] [ 9792.136701] NMI
>>> watchdog:
>>> >> > > BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u2:0:1129] [
>>> >> > > 9820.136699] NMI
>>> >> > > watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
>>> >> > > [kworker/u2:0:1129] [ 9848.136696] NMI watchdog: BUG: soft lockup
>>> >> > > -
>>> >> CPU#0 stuck for 22s!
>>> >> > > [kworker/u2:0:1129]
>>> >> > >
>>> >> > > This will repeat indefinitely, until I unplug the hub, which
>>> >> > > resolves the soft lockup and then the system seems to function
>>> normally.
>>> >> > >
>>> >> > > I've attached a dmesg log of the soft lockup stack traces. They
>>> >> > > seem to indicate a lockup in workqueue rt2x00usb_work_rxdone()
>>> >> > > (specifically in
>>> >> > > usb_hcd_submit_urb() called from rt2x00usb_kick_rx_entry() called
>>> >> > > from rt2x00usb_clear_entry()).
>>> >> > >
>>> >> > > I originally found this bug on a 3.14.x kernel built with Yocto
>>> >> > > for a BeagleBone Black-based product. So it seems this is a bug
>>> >> > > that has been around for some time.
>>> >> >
>>> >> > I should also note that on the 3.14.x Yocto-built kernel on
>>> >> > BeagleBone Black, this bug does not occur if the rt2800 device is
>>> >> > unplugged directly from the BBB's USB port. It only occurs if unplugged
>>> from a hub.
>>> >> >
>>> >> > I have tested this on an i586 based eBox-3310A mini-PC running
>>> >> > Debian 8.4, which has a 3.16.0 kernel, with the same hub and same
>>> >> > rt2800 device. But I was not able to reproduce this issue.
>>> >>
>>> >> There is a patch for the AM335x musb driver that seems to fix this:
>>> >>
>>> >> http://marc.info/?l=linux-usb&m=146173995117456&w=2
>>> >>
>>> >> So it seems that this issue's root cause is in the AM335x USB
>>> >> interrupt handling, and not the Wi-Fi rt2800 driver.
>>> >
>>> > Having applied two AM335x USB patches in the 3.14.49 kernel, that does
>>> seem to resolve the soft lock-up on the RX side. The two patches are:
>>> >
>>> > http://marc.info/?l=linux-usb&m=146173995117456&w=2
>>> > http://marc.info/?l=linux-usb&m=146222355213935&w=2
>>> >
>>> > But I am finding there is still a lock-up issue when unplugging from a hub,
>>> this time on the TX side. It is more likely if there is Wi-Fi traffic in progress
>>> when the unplug occurs. I'm attaching a log. Essentially there are a heap of
>>> lines (100 or so per second):
>>> >
>>> > [ 1866.693511] ieee80211 phy7: rt2800usb_tx_sta_fifo_read_completed:
>>> > Warning - TX status read failed -71
>>> >
>>> > Which finally stop shortly after USB disconnect is detected:
>>> >
>>> > [ 1866.985854] usb 1-1.3: USB disconnect, device number 10
>>> >
>>> > However that disconnect message is typically 30-90 seconds after the
>>> unplug happened. It seems that the USB disconnect detection is delayed due
>>> to the CPU load of the TX.
>>> >
>>> > I also sometimes see a kernel panic. That can occur whether connected to a
>>> USB hub or directly to the on-board USB port. See the attached log.
>>> >
>>> > I'm not so familiar with either the Wi-Fi or USB stacks in the Linux
>>> > kernel, so I would appreciate any advice with debugging and fixing
>>> > this. (My previous investigations indicate these issues are present in
>>> > both 3.14.x kernel and 4.4.6 kernel. I'm more familiar with working
>>> > with the 3.14.x kernel under Yocto, but I could try moving to 4.4.6
>>> > kernel for Ubuntu. I'm open to advice on which to investigate on.)
>>>
>>> Take a look at this patch: http://marc.info/?l=linux-
>>> usb&m=146222355213935&w=2
>>>
>>> If it fixes your issue please provide your "tested-by" tag here.
>>
>> Hi Yegor,
>>
>> I am using that patch, and I referred to it in my last message. But it doesn't fix this issue.
>
> Have missed that.
>
> I've made following test with am335x based device and a Ralink
> Technology, Corp. RT5370 Wireless Adapter attached vie USB hub:
>
> root@baltos:~# lsusb -t
> /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=musb-hdrc/1p, 480M
> /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=musb-hdrc/1p, 480M
>     |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/4p, 480M
>         |__ Port 1: Dev 4, If 0, Class=Vendor Specific Class,
> Driver=rt2800usb, 480M
>
> during nuttcp test session I unplug WLAN dongle and get following
> kernel messages (kernel 3.18.32 with [1])
>
> ieee80211 phy2: rt2800usb_tx_sta_fifo_read_completed: Warning - TX
> status read failed -71
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> ieee80211 phy2: rt2x00usb_vendor_request: Error - Vendor Request 0x07
> failed for offset 0x1700 with error -110
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> hub 1-1:1.0: hub_port_status failed (err = -110)
> ieee80211 phy2: rt2x00usb_vendor_request: Error - Vendor Request 0x07
> failed for offset 0x0438 with error -110
> hub 1-1:1.0: hub_port_status failed (err = -110)
>
> [1] http://marc.info/?l=linux-usb&m=146222355213935&w=2

With 4.6.0-rc7 I get

[  479.869736] ieee80211 phy1: rt2800usb_tx_sta_fifo_read_completed:
Warning - TX status read failed -71
[  480.106022] ieee80211 phy1: rt2x00usb_vendor_request: Error -
Vendor Request 0x07 failed for offset 0x1700 with error -110
[  480.216002] ieee80211 phy1: rt2x00usb_vendor_request: Error -
Vendor Request 0x07 failed for offset 0x7010 with error -110
[  480.325996] ieee80211 phy1: rt2x00usb_vendor_request: Error -
Vendor Request 0x06 failed for offset 0x7010 with error -110
[  480.436160] ieee80211 phy1: rt2x00usb_vendor_request: Error -
Vendor Request 0x06 failed for offset 0x0404 with error -110
[  480.546178] ieee80211 phy1: rt2x00usb_vendor_request: Error -
Vendor Request 0x07 failed for offset 0x0438 with error -110
[   96.726198] hub 1-1:1.0: hub_ext_port_status failed (err = -110)
