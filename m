Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:58019 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936781AbZDIVxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 17:53:36 -0400
Received: by bwz17 with SMTP id 17so791132bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2009 14:53:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>
References: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>
Date: Thu, 9 Apr 2009 22:53:33 +0100
Message-ID: <3ace41890904091453o158f5c00ldad58da3d002180e@mail.gmail.com> (sfid-20090409_235345_062632_89F2B0D1)
Subject: Re: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 9, 2009 at 5:23 AM, Larry Finger <Larry.Finger@lwfinger.net=
> wrote:
> The following patch implements some control over the LED on RTL8187B =
and
> RTL8187L devices. Triggers are registered for TX and RX. Whenever the
> trigger event occurs, the LED is turned off for 1/20 second, then tur=
ned
> back on.

On the LED functionality - the LED on my laptop actually works rather
differently under windows vs under linux.
On windows it is tied to the hardware switch, and the windows driver
depends on the state of the hardware switch.
The linux driver's behavior has no relationship with the LED what so
ever. (I suppose it might blink under windows but I don't know for
sure).

> Please test and comment.

I'll have a little go at it later, but a few comments below.

> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c

> + * Based on the r8187 driver, which is:
> + * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.

> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

> + * Based on the r8187 driver, which is:
> + * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.

I found these two comments a bit odd, so I went back to the vendor
driver code to have a look.
The LED code is AFAIK a rather new addition to the vendor driver,
within the 2008, I think. It is in
0708.2008 but not in 0822.2007, and does not seem to be in 0125.2008
driver either.

The two new LED related files in 0708.2008 have these headers:
-----------------------------------------------------------------------=
---------------------------
/*++
Copyright (c) Realtek Semiconductor Corp. All rights reserved.

Module Name:
 	r8187_led.c
=09
Abstract:
 	RTL8187 LED control functions
 =09
Major Change History:
	When        Who      What
	----------    ---------------   -------------------------------
	2006-09-07    Xiong		Created

Notes:=09
 =09
--*/
/*++

Copyright (c) Microsoft Corporation. All rights reserved.

Module Name:
    r8187_led.h

Abstract:
    definitions and stuctures for rtl8187 led control.

Major Change History:
      When        Who	What
    ----------	------	----------------------------------------------
    2006-09-07	Xiong	Created

Notes:

--*/
-----------------------------------------------------------------------=
--------------------------

I am slightly worried about the microsoft copyright in the latter :-),
but presumably it is a visual studio or dev tool artefact :-).


> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rtl822=
5.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
> @@ -18,6 +18,7 @@
>
> =A0#include <linux/init.h>
> =A0#include <linux/usb.h>
> +#include <linux/eeprom_93cx6.h>
> =A0#include <net/mac80211.h>
>
> =A0#include "rtl8187.h"

This trunk seems to be redundant - why would a new include be needed
for no code addition?
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
