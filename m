Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36756 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab2CIXp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 18:45:26 -0500
Received: by ghrr11 with SMTP id r11so1309295ghr.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 15:45:25 -0800 (PST)
Message-ID: <4F5A9612.8040301@lwfinger.net> (sfid-20120310_004529_507796_1B94A553)
Date: Fri, 09 Mar 2012 17:45:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5 V2] p54usb: Load firmware from work queue and not
 from probe routine
References: <1331267337-19605-1-git-send-email-Larry.Finger@lwfinger.net> <201203092245.14420.chunkeey@googlemail.com>
In-Reply-To: <201203092245.14420.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/09/2012 03:45 PM, Christian Lamparter wrote:
> On Friday, March 09, 2012 05:28:57 AM Larry Finger wrote:
>> Drivers that load firmware from their probe routine have problems with the
>> latest versions of udev as they get timeouts while waiting for user
>> space to start. The problem is fixed by loading the firmware and starting
>> mac80211 from a work queue. By using this method, most of the
>> original code is preserved.
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> ---
> Well, I thought this over and I think unless we change the Kconfig
> and make the backend modules [p54pci, p54usb and p54spi]
> module-only options, we have to go with request_firmware_nowait.
>
> You see, if the p54* modules are compiled into the very bzImage:
> The instant workqueue option wouldn't work because the device
> might be initialized before the filesystem is. A combo approach
> [delayed workqueue, when no userspacehelper is available and a
> direct call to request_firmware (when it is availabe)] would
> work too, but then we would be reimplementing
> request_firmware_nowait ...

Christian,

Your point is well taken. I will rewrite this one. John was holding it for 3.5 
anyway.

Do we still want to try for the legacy firmware if the primary is not available?

Larry

