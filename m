Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:40338 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762033AbZLQKz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2009 05:55:57 -0500
Message-ID: <4B2A0AE5.2080006@reactivated.net>
Date: Thu, 17 Dec 2009 10:41:41 +0000
From: Daniel Drake <dan@reactivated.net>
MIME-Version: 1.0
To: Josua Dietze <digidietze@draisberghof.de>
CC: Stefan Seyfried <stefan.seyfried@googlemail.com>,
	usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stefan Seyfried <seife@sphairon.com>
Subject: Re: [usb-storage] [PATCH] move eject code from zd1211rw to  usb-storage
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <4B278191.1010009@draisberghof.de>
In-Reply-To: <4B278191.1010009@draisberghof.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 15/12/09 12:31, Josua Dietze escribió:
> Stefan Seyfried schrieb:
>
>> The USB ID claimed by zd1211rw for the fake storage device is
>> also in use by other, non-zd1211rw devices (Sphairon Homelink
>> 1202). Move the eject of these devices to where it belongs and
>> where all the needed infrastructure already exists: usb-storage.
>
>
> We can do the eject (as other mode switches) in userspace. Previous
> discussions pointed into that direction.

When I originally wrote this code this wasn't as easy as you might think 
- the virtual CD device seems to be very quirky, and utterly confused 
Linux to the point where it didn't even create a device node. Maybe 
linux is more flexible these days though.

Daniel
