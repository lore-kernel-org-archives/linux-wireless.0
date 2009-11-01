Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37332 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752943AbZKAULo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 15:11:44 -0500
Message-ID: <4AEDEB85.5080105@gmx.net>
Date: Sun, 01 Nov 2009 21:11:49 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Josua Dietze <digidietze@draisberghof.de>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de>
In-Reply-To: <4AEDD380.40408@draisberghof.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Josua Dietze schrieb:
> Frank Schaefer schrieb:
>
>> I really think the mode-switching should be done in the kernel and not
>> in user-space for reasons of usability.
>
> What is wrong with an udev rule entry? By the way, did the "eject"
> command line tool work as well?
It returns an error but the device is ejected.
But do you really want the users to open a terminal window and call
"eject" each time they plug their device in ;) ?
>> It also doesn't "pollute" the driver with much code (adds a single
>> usb_bulk_msg()).
>
> That may be true for a single device but there are around 30+ others
> which are switched outside the kernel, some inside usb-storage, and
> this would add even more places where mode switching happened.
Of course I like the idea of having all mode-switches at the same place,
but we learnt from discussions in the past that there will likely never
be a unified solution for all devices.
Devices are to different. Some disconnect and change their IDs and
others only change their interface-setup.
In addition to that it depends on the purpose/type of the two devices.
In this case, the only purpose of the storage device is to provide
windows-drivers for installation. When the driver is installed, the
storage-device should not appear any more.
>> Another benfit is that it binds the mode-switching to the driver. If the
>> driver is blacklisted/not used, there will be no mode-switching.
>
> But how would you access the storage part of the device then?
>
> Josua
Never, that's the compromise we have to make. But we can really make it,
simply because we will never need it.
Please let me know if there is a possibility to "keep" the
usb-mass-storage-driver as "fallback-driver".

Frank
