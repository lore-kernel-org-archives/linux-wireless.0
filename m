Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 007.netroom.de ([194.0.247.207]:10574 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZKASzg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 13:55:36 -0500
Message-ID: <4AEDD380.40408@draisberghof.de>
Date: Sun, 01 Nov 2009 19:29:20 +0100
From: Josua Dietze <digidietze@draisberghof.de>
MIME-Version: 1.0
To: Frank Schaefer <schaefer.frank@gmx.net>
CC: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	johannes@sipsolutions.net, chunkeey@web.de
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net>
In-Reply-To: <4AEDCCA0.8050709@gmx.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frank Schaefer schrieb:

> I really think the mode-switching should be done in the kernel and not
> in user-space for reasons of usability.

What is wrong with an udev rule entry? By the way, did the "eject" 
command line tool work as well?

> It also doesn't "pollute" the driver with much code (adds a single
> usb_bulk_msg()).


That may be true for a single device but there are around 30+ others 
which are switched outside the kernel, some inside usb-storage, and 
this would add even more places where mode switching happened.

> Another benfit is that it binds the mode-switching to the driver. If the
> driver is blacklisted/not used, there will be no mode-switching.


But how would you access the storage part of the device then?


Josua
-- 
Man is the only creature on earth enabled to take a
warm meal while flying!                      Loriot
