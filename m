Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:57796 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3GINgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 09:36:55 -0400
Received: by mail-ob0-f173.google.com with SMTP id wc20so6871384obb.4
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 06:36:55 -0700 (PDT)
Message-ID: <51DC11F5.9080604@lwfinger.net> (sfid-20130709_153658_602520_7719E6B1)
Date: Tue, 09 Jul 2013 08:36:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dmitry Zganyaiko <dmitry.zganyaiko@gmail.com>
CC: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: New device for ar5523
References: <CC807E45-D614-4540-AD3F-160B56795851@gmail.com>
In-Reply-To: <CC807E45-D614-4540-AD3F-160B56795851@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2013 03:59 AM, Dmitry Zganyaiko wrote:
> Hi! I'm using usb wireless adaptor named
> 07d1:3a0d D-Link System DWA-120 802.11g Wireless 108G (taken from lsusb)
>
> System is Debian wheezy with 3.8 kernel taken from ubuntu reps. But after launch this adaptor doesn't work: no any new network interfaces is shown in ifconfig.
>
> As far as I understood, such vendor:product (07d1:3a0d) isn't specified in drivers/net/wireless/ath/ar5523/ar5523.c, and therefore the driver doesn't recognise my device. Firmware 'ar5523.bin' is located in /usr/local/lib/firmware.
>
> What can I do to make this adaptor work? Only add that v:p pair to ar5523.c and recompile it? Just if that can be done without compiling - it will be great.

You can test to see if it works with that kernel with the following commands (as 
root):

modprobe -v ar5523
echo 07d1 3a0d > /sys/bus/usb/drivers/ar5523/new_id

If the device would work by adding that USB ID to the device table, then the 
above commands should accomplish the same result. Note - these commands will 
need to be re-entered after every reload of ar5523.

Larry

