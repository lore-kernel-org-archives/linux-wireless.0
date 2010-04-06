Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:53262 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab0DFWGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 18:06:25 -0400
Received: by ewy20 with SMTP id 20so227588ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 15:06:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004062328.40656.IvDoorn@gmail.com>
References: <1270574791-14006-1-git-send-email-xose.vazquez@gmail.com>
	 <201004062328.40656.IvDoorn@gmail.com>
Date: Wed, 7 Apr 2010 00:06:23 +0200
Message-ID: <j2z14add3d11004061506q8b45b003ucbb3537cda763b58@mail.gmail.com>
Subject: Re: [PATCH] wireless: rt2x00: delete duplicates ids in rt73usb
	rt2500usb
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 6, 2010 at 11:28 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Tuesday 06 April 2010, Xose Vazquez Perez wrote:
>> Follow the precepts of the ralink drivers.
>>
>> (0x050d, 0x7050) is only found in:
>>
>> RT25USB-SRC-V2.0.8.0/rt2570sw.h:#define RTVID8                  0x050D //ralink
>> RT25USB-SRC-V2.0.8.0/rt2570sw.h:#define RTPID8                  0x7050
>> RT25USB-SRC-V2.0.8.0/rt2570sw.h: {USB_DEVICE(RTVID8,RTPID8)},
>>
>> and (0x050d, 0x705a) (0x1371, 0x9022) (0x148f, 0x2573) are only in:
>>
>> 2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x050d,0x705a)}, /* Belkin */
>> 2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x1371,0x9022)}, /* CNet */
>> 2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x148f,0x2573)}, /* Ralink */
>>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>
> I have my doubts about this one.
> Gertjan, do you consider it wise to remove these ID's?
>

Yes, I have my doubts here as well. We know about overlap in USB IDs
between rt2500 and rt73 devices,
and these could very well be these devices.

However, if Ralink doesn't have this overlap in their devices, then
why should we care.

Xose, can you verify with the Windows drivers whether the situation on
the USB IDs is the same as for the
Ralink Linux drivers?

---
Gertjan.
