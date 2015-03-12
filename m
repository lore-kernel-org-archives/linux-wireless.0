Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44520 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbbCLUnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 16:43:01 -0400
Received: by wghl18 with SMTP id l18so18966138wgh.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 13:43:00 -0700 (PDT)
Date: Thu, 12 Mar 2015 22:42:55 +0200
From: Huseyin Olgac <revanthedarth@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Jonas Gorski <jogo@openwrt.org>, Pat Erley <pat-lkml@erley.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: Developing a new Driver
Message-ID: <20150312204255.GA4192@rev-desktop> (sfid-20150312_214306_458138_0C395E97)
References: <8BC2636B-D1F0-431C-90F4-1290A4158DC2@gmail.com>
 <54FF7970.10402@erley.org>
 <CAOiHx=kRLW6Bvrnht=pn7=9zT6Vg2QAcE2JMXrZstOixsL0CmA@mail.gmail.com>
 <CACna6rzcQ30VCvbqK_A5h4R8toUgAruygVcDoGHQsriN7BdGFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzcQ30VCvbqK_A5h4R8toUgAruygVcDoGHQsriN7BdGFg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06:55 Wed 11 Mar , Rafał Miłecki wrote:
> On 11 March 2015 at 00:15, Jonas Gorski <jogo@openwrt.org> wrote:
> > On Wed, Mar 11, 2015 at 12:08 AM, Pat Erley <pat-lkml@erley.org> wrote:
> >> On 03/10/2015 04:42 PM, Huseyin wrote:
> >>> I want to develop a driver for my usb wireless adapter. The device name is
> >>> AirTies Air 2410, codes are 0x1eda 0x2410. The company’s other usb wireless
> >>> adapters (for example, AirTies Air 2310, 0x1eda 0x2310) were using ralink
> >>> rt2800 driver, but this one doesn’t work with it.
> >>>
> >>> I opened up the device’s case, I could only find out that the board was
> >>> plotech e169497, 6 94v-0. I googled but these seem to be too vague and I
> >>> cannot go any further with it. I couldn’t find any other text on the board.
> >>
> >> Based on their driver, it's a broadcom chip in there:
> >>
> >>
> >>   inflating:
> >> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmh43xx.cat
> >>   inflating:
> >> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmihvsrv.dll
> >>   inflating:
> >> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmihvui.dll
> >>   inflating:
> >> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmwlcoi.dll
> >>   inflating:
> >> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmwlhigh6.inf
> >>   inflating:
> >> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmwlhigh6.sys
> >>   inflating:
> >> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/WdfCoInstaller01005.dll
> >>
> >> I don't know what the status of broadcom and usb drivers is though.
> >
> > According to wikidevi[1], it uses BCM4323, which is SSB based, quite
> > old, and will never be supported by brcmfmac, and probably never by
> > b43 (one would need to reverse engineer the usb protocol used by
> > broadcom).
> >
> >
> > Jonas
> >
> > [1] https://wikidevi.com/wiki/AirTies_Air_2410
> 
> This is for sure some kind of FullMAC device, it's just not clear if:
> 1) It's a standard nice FullMAC device
> 2) Device using another architecture requiring much more code on host
> 
> I guess it's the second case, you can see info about it on wiki page:
> https://wireless.wiki.kernel.org/en/users/drivers/brcm80211#unsupported_chips
> 
> If you think it's fun, you may use my tiny libusb app to read hardware info:
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/117924
> (if you do, let us know what you got, please)
> 
> -- 
> Rafał


Hi,

Here's what I got using your app:

[id]      chip: 4322
[id]   chiprev: 0001

Huseyin Olgac
