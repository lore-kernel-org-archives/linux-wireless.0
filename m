Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:21193 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0ECR2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 13:28:30 -0400
Received: by fg-out-1718.google.com with SMTP id 19so971107fgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 10:28:26 -0700 (PDT)
Message-ID: <4BDF07B2.5080504@gmail.com>
Date: Mon, 03 May 2010 19:28:18 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, linville@tuxdriver.com
Subject: Re: [PATCH] wireless: rt2x00: delete duplicates ids in rt73usb 	rt2500usb
References: <1270574791-14006-1-git-send-email-xose.vazquez@gmail.com>	 <201004062328.40656.IvDoorn@gmail.com> <j2z14add3d11004061506q8b45b003ucbb3537cda763b58@mail.gmail.com>
In-Reply-To: <j2z14add3d11004061506q8b45b003ucbb3537cda763b58@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2010 12:06 AM, Gertjan van Wingerde wrote:
> On Tue, Apr 6, 2010 at 11:28 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>> On Tuesday 06 April 2010, Xose Vazquez Perez wrote:
>>> Follow the precepts of the ralink drivers.
>>>
>>> (0x050d, 0x7050) is only found in:
>>>
>>> RT25USB-SRC-V2.0.8.0/rt2570sw.h:#define RTVID8                  0x050D //ralink
>>> RT25USB-SRC-V2.0.8.0/rt2570sw.h:#define RTPID8                  0x7050
>>> RT25USB-SRC-V2.0.8.0/rt2570sw.h: {USB_DEVICE(RTVID8,RTPID8)},
>>>
>>> and (0x050d, 0x705a) (0x1371, 0x9022) (0x148f, 0x2573) are only in:
>>>
>>> 2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x050d,0x705a)}, /* Belkin */
>>> 2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x1371,0x9022)}, /* CNet */
>>> 2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x148f,0x2573)}, /* Ralink */
>>>
>>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>>
>> I have my doubts about this one.
>> Gertjan, do you consider it wise to remove these ID's?
>>
> 
> Yes, I have my doubts here as well. We know about overlap in USB IDs
> between rt2500 and rt73 devices,
> and these could very well be these devices.
> 
> However, if Ralink doesn't have this overlap in their devices, then
> why should we care.
> 
> Xose, can you verify with the Windows drivers whether the situation on
> the USB IDs is the same as for the
> Ralink Linux drivers?

OK, here it goes:

W = Windows:ralink_driver
L = Linux:ralink_driver


USB_IDs         W_73  W_2500  L_73  L_2500
=============   ====  ======  ====  ======
0x050d,0x7050   -     -       -     YES
0x050d,0x705a   -     -       YES   - 
0x1371,0x9022   -     YES     YES   - 
0x148f,0x2573   YES   -       YES   - 


-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
