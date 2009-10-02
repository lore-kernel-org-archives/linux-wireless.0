Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50442 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751746AbZJBWZq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 18:25:46 -0400
Message-ID: <4AC67DEB.80900@gmx.de>
Date: Sat, 03 Oct 2009 00:25:47 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Malte Gell <malte.gell@gmx.de>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
References: <200910011654.10963.chunkeey@googlemail.com> <200910020852.36427.malte.gell@gmx.de> <200910021246.34699.chunkeey@googlemail.com> <200910021345.55567.malte.gell@gmx.de>
In-Reply-To: <200910021345.55567.malte.gell@gmx.de>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/02/2009 01:45 PM, Malte Gell wrote:
> Christian Lamparter <chunkeey@googlemail.com> wrote
> 
>>> The Netgear (WN?) 111 even only has one blue LED as far as I know.
>> the question is if it's the only device with this deficit, or not?
> 
> Is it feasable to write to the well known stick makers (Netgear, AVM, 
> Belkin,Asus...) and just ask them? 

After looking into staging/otus/80211core/ledmgr.c, which has functions
zfLedCtrlType1,2,3 for:
- "Traditional single-LED state"
- "Netgear Dual-LED state"
- "Netgear Single-LED state"

(althrough they are not used there, as noone initializes wd->ledStruct.LEDCtrlType correctly)

I guess there is a way to determine the number of LED in a device from the EEPROM.
I really doubt that Netgear would built different drivers/firmwares (if they built any instead of getting them from Atheros)
for both WNDA3100 and WN111v2.

hal/hpmain.c, line 2322:
#define ZM_SEEPROM_HARDWARE_TYPE_OFFSET   (0x1374)

the value from the above address is retrieved in rsp[5] and processed in
 
hal/hprw.c, lines 601f.
        wd->ledStruct.ledMode[0] = (u16_t)(rsp[5]&0xffff);
        wd->ledStruct.ledMode[1] = (u16_t)(rsp[5]>>16);

If the bits of ledMode[] are explained in 80211/ledmgr.c, lines 34ff., Atheros provided a generic way for vendors to
program LED behaviour via the EEPROM and Netgear got some extra handling in the driver (if otus is close the windows driver).

Regards,
Joerg.
