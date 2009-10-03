Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:51617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbZJCAFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 20:05:33 -0400
Received: by fg-out-1718.google.com with SMTP id 22so45726fge.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2009 17:05:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Sat, 3 Oct 2009 02:05:28 +0200
Cc: Malte Gell <malte.gell@gmx.de>, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	"Hin-Tak Leung" <hintak.leung@gmail.com>
References: <200910011654.10963.chunkeey@googlemail.com> <200910021345.55567.malte.gell@gmx.de> <4AC67DEB.80900@gmx.de>
In-Reply-To: <4AC67DEB.80900@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910030205.29381.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 03 October 2009 00:25:47 Joerg Albert wrote:
> On 10/02/2009 01:45 PM, Malte Gell wrote:
> > Christian Lamparter <chunkeey@googlemail.com> wrote
> > 
> >>> The Netgear (WN?) 111 even only has one blue LED as far as I know.
> >> the question is if it's the only device with this deficit, or not?
> > 
> > Is it feasable to write to the well known stick makers (Netgear, AVM, 
> > Belkin,Asus...) and just ask them? 
> 
> After looking into staging/otus/80211core/ledmgr.c, which has functions
> zfLedCtrlType1,2,3 for:
> - "Traditional single-LED state"
> - "Netgear Dual-LED state"
> - "Netgear Single-LED state"
> 
> (althrough they are not used there, as noone initializes wd->ledStruct.LEDCtrlType correctly)
On Windows platforms this setting is initialized by the Driver .inf file:

(ref: http://ftp.dlink.ru/pub/Wireless/DWA-160/Drivers/Rev.A-DWA-160_S0009/Drivers/Vista32/arusb_lh.inf )

[NTGR9010.reg]
HKR, Ndi,								Service,    0, "WNDA3100"

HKR, Ndi\Interfaces,					UpperRange, 0, "ndis5"
HKR, Ndi\Interfaces,					LowerRange, 0, "wlan,ethernet"

[...]

HKR,,					DfsChDisable,				0, 1
HKR,,					LEDCtrlType,				0, 2

vs.

[NTGR9001.reg]
HKR, Ndi,								Service,	0, "WN111v2"

HKR, Ndi\Interfaces,					UpperRange, 0, "ndis5"
HKR, Ndi\Interfaces,					LowerRange, 0, "wlan,ethernet"

[...]

HKR,,					DfsChDisable,				0, 1
HKR,,					LEDCtrlType,				0, 3


the situation is different for AVM:
there is not any reference of LEDCtrlType in any of AVM's inf files,
but the LEDCtrlType string does turn up in the driver file.

> I guess there is a way to determine the number of LED in a device from the EEPROM.
> I really doubt that Netgear would built different drivers/firmwares
> (if they built any instead of getting them from Atheros)
> for both WNDA3100 and WN111v2.
> 
> hal/hpmain.c, line 2322:
> #define ZM_SEEPROM_HARDWARE_TYPE_OFFSET   (0x1374)
> 
> the value from the above address is retrieved in rsp[5] and processed in
>  
> hal/hprw.c, lines 601f.
>         wd->ledStruct.ledMode[0] = (u16_t)(rsp[5]&0xffff);
>         wd->ledStruct.ledMode[1] = (u16_t)(rsp[5]>>16);
> 
> If the bits of ledMode[] are explained in 80211/ledmgr.c, lines 34ff.,
> Atheros provided a generic way for vendors to program LED behaviour
> via the EEPROM and Netgear got some extra handling in the driver
> (if otus is close the windows driver).
nice catch!

On Saturday 03 October 2009 01:03:28 Joerg Albert wrote:
> Hi,
> 
> could anyone with a WN111v2 (or any other device with one LED only)
> apply the patch below and look into syslog for the value of "hwtype"?
> 
> I get 22212221 for an AVM stick (057c:8401) and 22211111 for a Netgear WNDA3100 (0846:9010).
> 
> Thanks,
> Joerg.
> 
> 
Netgear WNDA3100:

LedMode[0] = 0x1111 => (blue LED)
 Bit 0 = 1		=> Power-on state: On
 Bit 6 = 0		=> Connect state
   Bit 4 = 1	=> always on (~ assoc/link LED?)
 Ton   = 1
 Toff  = 1

LedMode[1] = 0x2221 => (orange LED)
 Bit 0 = 1		=> Power-on state: On
 Bit 6 = 0		=> Connect state
   Bit 5 = 1	=> Idle off, acitve on (~ traffic/tx LED?)
 Ton   = 2
 Toff  = 2

this looks promising. The setting here does indeed match
the current driver behavior! 

AVM:
LedMode[0] = 0x2221 => (red LED?)
 Bit 0 = 1		=> Power-on state: On
 Bit 6 = 0		=> Connect state
   Bit 5 = 1	=> Idle off, acitve on (~ traffic/tx LED?)
 Ton   = 2
 Toff  = 2

LedMode[1] = 0x2221 => (green LED?)
 Bit 0 = 1		=> Power-on state: On
 Bit 6 = 0		=> Connect state
   Bit 5 = 1	=> Idle off, acitve on (~ traffic/tx LED?)
 Ton   = 2
 Toff  = 2

hmm, by this definition both LEDs are assigned as "traffic indicators".
This can not be right?! I did expect (based on Malte's description of
the Windows driver) something more like: 0x11112221.

Regards,
	Chr
