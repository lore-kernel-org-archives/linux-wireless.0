Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:45475 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZBTEHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 23:07:05 -0500
Received: by gxk22 with SMTP id 22so2071609gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 20:07:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87fxibhr5q.fsf@litku.valot.fi>
References: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com>
	 <8763j7qyfx.fsf@litku.valot.fi> <1235014330.6344.18.camel@rainbow>
	 <87fxibhr5q.fsf@litku.valot.fi>
Date: Thu, 19 Feb 2009 23:07:03 -0500
Message-ID: <c4d76b3b0902192007s347ea4e3hcfa3fae1a1e3060b@mail.gmail.com> (sfid-20090220_050712_391060_01136A5A)
Subject: Re: [PATCH] at76c50x-usb: support cfg80211 scanning
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 19, 2009 at 1:33 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Jason Andryuk <jandryuk@gmail.com> writes:
>> I am having issues with my Linksys WUSB11 adapter.  It has the intersil
>> 3861 and the scan command is reporting Command Status of 0x03 - Invalid
>> parameter.  For right now, scanning does not work for me.
>
> Oh, that's bad. And the device is working fine with the old at76_usb
> driver? Can you send some debug logs, please? Especially I'm
> interested about hardware differences between your Linksys and the
> Belkin I have.

I thought before I was not getting any scan results.  I may have been
wrong.  However right now with the driver from wireless-testing
2009-02-18, 4 APs show up in NetworkManager.  Unfortunately, my AP is
not one of them.  No signal strength is reported for any of them.
Curiously, there are distinct results for each of at76c50x-usb, a
semi-operational iwl3945 and the functional rtl8187.

CMD_SCAN is receiving a lot of status 0x03 CMD_STATUS_INVALID_PARAMETER

With debug=0xf022c001 I get the output below.  I was wondering if
status=0x03 was being received because CMD_SET_MIB was called before
CMD_SCAN's status was checked.  Hopefully you can make some sense out
of the below logs.

"calling ieee80211_rx_irqsafe(): 123/0" and "at76_dwork_hw_scan:
CMD_SCAN status 0x03" seem to continue indefinitely.

Jason

Feb 19 22:26:48 rainbow kernel: [ 1040.215351] at76c50x-usb:
downloading firmware atmel_at76c503-i3861.bin
Feb 19 22:26:48 rainbow kernel: [ 1040.215354] usb 3-2: firmware:
requesting atmel_at76c503-i3861.bin
Feb 19 22:26:48 rainbow kernel: [ 1040.227033] at76c50x-usb: got it.
Feb 19 22:26:48 rainbow kernel: [ 1040.227036] usb 3-2: using firmware
atmel_at76c503-i3861.bin (version 0.90.0-44)
Feb 19 22:26:48 rainbow kernel: [ 1040.227039] at76c50x-usb: board 1,
int 104:22228, ext 22332:5832
Feb 19 22:26:48 rainbow kernel: [ 1040.227040] at76c50x-usb: firmware
id 0.90.0-44 Intersil 3861 Copyright (c) 1999-2000 by Atmel
Corporation
Feb 19 22:26:48 rainbow kernel: [ 1040.228351] at76c50x-usb: opmode 1
Feb 19 22:26:48 rainbow kernel: [ 1040.229513] at76c50x-usb: USB
interface: 2 endpoints
Feb 19 22:26:48 rainbow kernel: [ 1040.229515] at76c50x-usb:
at76_alloc_urbs: ENTER
Feb 19 22:26:48 rainbow kernel: [ 1040.229516] at76c50x-usb:
at76_alloc_urbs: NumEndpoints 2
Feb 19 22:26:48 rainbow kernel: [ 1040.229518] at76c50x-usb:
at76_alloc_urbs: 0. endpoint: addr 0x85 attr 0x2
Feb 19 22:26:48 rainbow kernel: [ 1040.229520] at76c50x-usb:
at76_alloc_urbs: 1. endpoint: addr 0x2 attr 0x2
Feb 19 22:26:48 rainbow kernel: [ 1040.229521] at76c50x-usb:
at76_alloc_urbs: EXIT
Feb 19 22:26:48 rainbow kernel: [ 1040.230845] phy3: Selected rate
control algorithm 'minstrel'
Feb 19 22:26:48 rainbow kernel: [ 1040.231471] phy3: USB 3-2:1.0, MAC
00:06:25:00:6a:7a, firmware 0.90.0-2
Feb 19 22:26:48 rainbow kernel: [ 1040.231473] phy3: regulatory domain
0x10: FCC (USA)
Feb 19 22:26:48 rainbow kernel: [ 1040.231492] usbcore: registered new
interface driver at76c50x-usb
Feb 19 22:26:48 rainbow kernel: [ 1040.247748] udev: renamed network
interface wlan0 to wlan3
Feb 19 22:26:52 rainbow kernel: [ 1044.259085] at76c50x-usb:
at76_mac80211_start()
Feb 19 22:26:52 rainbow kernel: [ 1044.259112] at76c50x-usb: issuing
command CMD_STARTUP (0x0b)
Feb 19 22:26:52 rainbow kernel: [ 1044.259120] 00000000: 0b 00 68 00
00 00 08 00 00 06 00 06 82 84 0b 16  ..h.............
Feb 19 22:26:52 rainbow kernel: [ 1044.259126] 00000010: 01 0a 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.259131] 00000020: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.259136] 00000030: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.259140] 00000040: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.259145] 00000050: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.259150] 00000060: 00 00 00 00
00 00 00 00 00 00 64 00              ..........d.
Feb 19 22:26:52 rainbow kernel: [ 1044.262385] at76c50x-usb: phy3:
Waiting on cmd 11, status = 1 (CMD_STATUS_COMPLETE)
Feb 19 22:26:52 rainbow kernel: [ 1044.262394] at76c50x-usb: issuing
command CMD_RADIO_ON (0x06)
Feb 19 22:26:52 rainbow kernel: [ 1044.262401] 00000000: 06 00 00 00
                                   ....
Feb 19 22:26:52 rainbow kernel: [ 1044.265387] at76c50x-usb: phy3:
Waiting on cmd 6, status = 2 (CMD_STATUS_UNKNOWN)
Feb 19 22:26:52 rainbow kernel: [ 1044.265394] at76c50x-usb: issuing
command CMD_SET_MIB (0x01)
Feb 19 22:26:52 rainbow kernel: [ 1044.265400] 00000000: 01 00 05 00
01 01 09 00 00                       .........
Feb 19 22:26:52 rainbow kernel: [ 1044.268385] at76c50x-usb: phy3:
Waiting on cmd 1, status = 1 (CMD_STATUS_COMPLETE)
Feb 19 22:26:52 rainbow kernel: [ 1044.268391] at76c50x-usb: issuing
command CMD_SET_MIB (0x01)
Feb 19 22:26:52 rainbow kernel: [ 1044.268396] 00000000: 01 00 06 00
03 02 08 00 00 06                    ..........
Feb 19 22:26:52 rainbow kernel: [ 1044.271397] at76c50x-usb: phy3:
Waiting on cmd 1, status = 1 (CMD_STATUS_COMPLETE)
Feb 19 22:26:52 rainbow kernel: [ 1044.271403] at76c50x-usb: issuing
command CMD_SET_MIB (0x01)
Feb 19 22:26:52 rainbow kernel: [ 1044.271408] 00000000: 01 00 06 00
03 02 0a 00 00 06                    ..........
Feb 19 22:26:52 rainbow kernel: [ 1044.274383] at76c50x-usb: phy3:
Waiting on cmd 1, status = 1 (CMD_STATUS_COMPLETE)
Feb 19 22:26:52 rainbow kernel: [ 1044.274389] at76c50x-usb: issuing
command CMD_SET_MIB (0x01)
Feb 19 22:26:52 rainbow kernel: [ 1044.274394] 00000000: 01 00 05 00
01 01 03 00 01                       .........
Feb 19 22:26:52 rainbow kernel: [ 1044.277398] at76c50x-usb: phy3:
Waiting on cmd 1, status = 1 (CMD_STATUS_COMPLETE)
Feb 19 22:26:52 rainbow kernel: [ 1044.277404] at76c50x-usb: issuing
command CMD_SET_MIB (0x01)
Feb 19 22:26:52 rainbow kernel: [ 1044.277410] 00000000: 01 00 05 00
05 01 35 00 01                       ......5..
Feb 19 22:26:52 rainbow kernel: [ 1044.280669] at76c50x-usb: phy3:
Waiting on cmd 1, status = 1 (CMD_STATUS_COMPLETE)
Feb 19 22:26:52 rainbow kernel: [ 1044.280674] at76c50x-usb: issuing
command CMD_SCAN (0x03)
Feb 19 22:26:52 rainbow kernel: [ 1044.280679] 00000000: 03 00 30 00
ff ff ff ff ff ff 00 00 00 00 00 00  ..0.............
Feb 19 22:26:52 rainbow kernel: [ 1044.280685] 00000010: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.280690] 00000020: 00 00 00 00
00 00 00 00 00 00 01 0a 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.280695] 00000030: 00 00 00 00
                                   ....
Feb 19 22:26:52 rainbow kernel: [ 1044.283425] at76c50x-usb:
at76_add_interface()
Feb 19 22:26:52 rainbow kernel: [ 1044.291401] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 61/0
Feb 19 22:26:52 rainbow kernel: [ 1044.292072] at76c50x-usb:
at76_configure_filter(): changed_flags=0x00000000
total_flags=0x80000000 mc_count=0
Feb 19 22:26:52 rainbow kernel: [ 1044.292122] at76c50x-usb:
at76_config(): channel 1 radio 1
Feb 19 22:26:52 rainbow kernel: [ 1044.292126] at76c50x-usb: bssid:
Feb 19 22:26:52 rainbow kernel: [ 1044.292131] 00000000: 00 00 00 00
00 00                                ......
Feb 19 22:26:52 rainbow kernel: [ 1044.292136] at76c50x-usb: issuing
command CMD_SCAN (0x03)
Feb 19 22:26:52 rainbow kernel: [ 1044.292141] 00000000: 03 00 30 00
ff ff ff ff ff ff 00 00 00 00 00 00  ..0.............
Feb 19 22:26:52 rainbow kernel: [ 1044.292146] 00000010: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.292151] 00000020: 00 00 00 00
00 00 00 00 00 00 01 01 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.292156] 00000030: 00 00 00 00
                                   ....
Feb 19 22:26:52 rainbow kernel: [ 1044.295393] at76c50x-usb:
at76_configure_filter(): changed_flags=0x00000001
total_flags=0x80000000 mc_count=1
Feb 19 22:26:52 rainbow kernel: [ 1044.295420] at76c50x-usb:
at76_configure_filter(): changed_flags=0x00000001
total_flags=0x80000000 mc_count=2
Feb 19 22:26:52 rainbow kernel: [ 1044.295623] at76c50x-usb: issuing
command CMD_SET_MIB (0x01)
Feb 19 22:26:52 rainbow kernel: [ 1044.295630] 00000000: 01 00 05 00
01 01 06 00 01                       .........
Feb 19 22:26:52 rainbow kernel: [ 1044.296495] ADDRCONF(NETDEV_UP):
wlan3: link is not ready
Feb 19 22:26:52 rainbow kernel: [ 1044.296504] at76c50x-usb:
at76_configure_filter(): changed_flags=0x00000001
total_flags=0x80000000 mc_count=2
Feb 19 22:26:52 rainbow kernel: [ 1044.302400] at76c50x-usb: phy3:
Waiting on cmd 1, status = 1 (CMD_STATUS_COMPLETE)
Feb 19 22:26:52 rainbow kernel: [ 1044.302410] at76c50x-usb: at76_hw_scan():
Feb 19 22:26:52 rainbow kernel: [ 1044.302415] at76c50x-usb:
at76_hw_scan: sending CMD_SCAN
Feb 19 22:26:52 rainbow kernel: [ 1044.302420] at76c50x-usb: issuing
command CMD_SCAN (0x03)
Feb 19 22:26:52 rainbow kernel: [ 1044.302426] 00000000: 03 00 30 00
ff ff ff ff ff ff 00 00 00 00 00 00  ..0.............
Feb 19 22:26:52 rainbow kernel: [ 1044.302433] 00000010: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 19 22:26:52 rainbow kernel: [ 1044.302438] 00000020: 00 00 00 00
00 00 00 00 00 00 00 00 10 27 0a 00  .............'..
Feb 19 22:26:52 rainbow kernel: [ 1044.302444] 00000030: 78 00 00 00
                                   x...
Feb 19 22:26:52 rainbow kernel: [ 1044.353434] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:52 rainbow kernel: [ 1044.455471] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:52 rainbow kernel: [ 1044.549532] at76c50x-usb:
at76_dwork_hw_scan: CMD_SCAN status 0x03
Feb 19 22:26:52 rainbow kernel: [ 1044.558532] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:52 rainbow kernel: [ 1044.660587] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:52 rainbow kernel: [ 1044.682597] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:52 rainbow kernel: [ 1044.763601] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:53 rainbow kernel: [ 1044.797651] at76c50x-usb:
at76_dwork_hw_scan: CMD_SCAN status 0x03
Feb 19 22:26:53 rainbow kernel: [ 1044.887702] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:53 rainbow kernel: [ 1044.968742] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:53 rainbow kernel: [ 1045.045776] at76c50x-usb:
at76_dwork_hw_scan: CMD_SCAN status 0x03
Feb 19 22:26:53 rainbow kernel: [ 1045.070790] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:53 rainbow kernel: [ 1045.293899] at76c50x-usb:
at76_dwork_hw_scan: CMD_SCAN status 0x03
Feb 19 22:26:53 rainbow kernel: [ 1045.378910] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:53 rainbow kernel: [ 1045.542031] at76c50x-usb:
at76_dwork_hw_scan: CMD_SCAN status 0x03
Feb 19 22:26:53 rainbow kernel: [ 1045.583049] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:53 rainbow kernel: [ 1045.687101] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:53 rainbow kernel: [ 1045.707111] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:54 rainbow kernel: [ 1045.790152] at76c50x-usb:
at76_dwork_hw_scan: CMD_SCAN status 0x03
Feb 19 22:26:54 rainbow kernel: [ 1045.810161] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:54 rainbow kernel: [ 1045.890199] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:54 rainbow kernel: [ 1045.912207] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:54 rainbow kernel: [ 1046.014267] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:54 rainbow kernel: [ 1046.037275] at76c50x-usb:
at76_dwork_hw_scan: CMD_SCAN status 0x03
Feb 19 22:26:54 rainbow kernel: [ 1046.117316] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:54 rainbow kernel: [ 1046.219360] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:54 rainbow kernel: [ 1046.285400] at76c50x-usb:
at76_dwork_hw_scan: CMD_SCAN status 0x03
Feb 19 22:26:54 rainbow kernel: [ 1046.300403] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:54 rainbow kernel: [ 1046.402455] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 123/0
Feb 19 22:26:54 rainbow kernel: [ 1046.424471] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:54 rainbow kernel: [ 1046.526519] at76c50x-usb: calling
ieee80211_rx_irqsafe(): 110/0
Feb 19 22:26:54 rainbow kernel: [ 1046.534514] at76c50x-usb:
at76_dwork_hw_scan: CMD_SCAN status 0x03
