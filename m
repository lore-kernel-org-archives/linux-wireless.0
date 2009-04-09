Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:63718 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbZDIXBi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 19:01:38 -0400
Message-ID: <49DE7E42.5020700@lwfinger.net> (sfid-20090410_010142_717851_CD365EC6)
Date: Thu, 09 Apr 2009 18:01:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
References: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net> <3ace41890904091453o158f5c00ldad58da3d002180e@mail.gmail.com>
In-Reply-To: <3ace41890904091453o158f5c00ldad58da3d002180e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> On Thu, Apr 9, 2009 at 5:23 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
> On the LED functionality - the LED on my laptop actually works rather
> differently under windows vs under linux.
> On windows it is tied to the hardware switch, and the windows driver
> depends on the state of the hardware switch.
> The linux driver's behavior has no relationship with the LED what so
> ever. (I suppose it might blink under windows but I don't know for
> sure).

I take it that your device is built in. If it works with the hardware switch,
then we need a "radio" LED and the rfkill subsystem. I won't be able to test
that configuration, but I will try to spin that code, but I'll do it separately
from the TX/RX LEDs.

>> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.h
>> ===================================================================
> 
>> + * Based on the r8187 driver, which is:
>> + * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
> 
> I found these two comments a bit odd, so I went back to the vendor
> driver code to have a look.
> The LED code is AFAIK a rather new addition to the vendor driver,
> within the 2008, I think. It is in
> 0708.2008 but not in 0822.2007, and does not seem to be in 0125.2008
> driver either.
> 
> The two new LED related files in 0708.2008 have these headers:
> --------------------------------------------------------------------------------------------------
> /*++
> Copyright (c) Realtek Semiconductor Corp. All rights reserved.
> 
> Module Name:
>  	r8187_led.c
> 	
> Abstract:
>  	RTL8187 LED control functions
>  	
> Major Change History:
> 	When        Who      What
> 	----------    ---------------   -------------------------------
> 	2006-09-07    Xiong		Created
> 
> Notes:	
>  	
> --*/
> /*++
> 
> Copyright (c) Microsoft Corporation. All rights reserved.
> 
> Module Name:
>     r8187_led.h
> 
> Abstract:
>     definitions and stuctures for rtl8187 led control.
> 
> Major Change History:
>       When        Who	What
>     ----------	------	----------------------------------------------
>     2006-09-07	Xiong	Created
> 
> Notes:
> 
> --*/
> -------------------------------------------------------------------------------------------------
> 
> I am slightly worried about the microsoft copyright in the latter :-),
> but presumably it is a visual studio or dev tool artefact :-).

I used the rtl8187 code from rtl8187_linux_26.1025.0328.2007, and the rtl8187B
code from rtl8187B_linux_24.6.1031.0125.2008. It turned out that the code was
identical, thus no need to have two distinct paths. As you have likely seen, my
implementation was a lot smaller than theirs.

I used the rtl8187_led.c file to generate my code. It only has a Realtek
copyright. The only part of the .h file that was used was the interpretation of
the EEPROM customer code. I don't think that Microsoft has a copyright on that.

>>  #include <linux/init.h>
>>  #include <linux/usb.h>
>> +#include <linux/eeprom_93cx6.h>
>>  #include <net/mac80211.h>
>>
>>  #include "rtl8187.h"
> 
> This trunk seems to be redundant - why would a new include be needed
> for no code addition?

In my implementation of the LEDs init function, I pass the EEPROM structure as
one of the arguments so that I can read the customer code, which is the reason
that that header ended up there. I'll modify my patch so that the customer code
is read in rtl8187_dev.c and pass that to the init routine. Then the EEPROM
struct will not be needed.

Thanks for your comments.

Larry
