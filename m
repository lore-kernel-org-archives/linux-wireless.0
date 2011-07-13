Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52570 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab1GMNyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 09:54:43 -0400
Message-ID: <4E1DA3A0.1000606@gnu.org> (sfid-20110713_155455_200889_A3655A02)
Date: Wed, 13 Jul 2011 09:54:40 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [TODO] at76c50x: remove wext includes
References: <1310546836.3873.6.camel@jlt3.sipsolutions.net> <4E1D5CB7.7070607@adurom.com>
In-Reply-To: <4E1D5CB7.7070607@adurom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 04:52 AM, Kalle Valo wrote:
> On 07/13/2011 11:47 AM, Johannes Berg wrote:
>> Not possible right now:
>> at76c50x-usb.h:404:11: error: ‘IW_ESSID_MAX_SIZE’ undeclared here (not in a function)
>> at76c50x-usb.c: In function ‘at76_startup_device’:
>> at76c50x-usb.c:1371:263: error: ‘IW_MODE_ADHOC’ undeclared (first use in this function)
>> at76c50x-usb.c:1371:263: note: each undeclared identifier is reported only once for each function it appears in
>> at76c50x-usb.c: In function ‘at76_add_interface’:
>> at76c50x-usb.c:1863:19: error: ‘IW_MODE_INFRA’ undeclared (first use in this function)
>> at76c50x-usb.c: In function ‘at76_init_new_device’:
>> at76c50x-usb.c:2269:18: error: ‘IW_MODE_INFRA’ undeclared (first use in this function)
>>
>> but none of those constants should be used in a mac80211 driver.
>>
>> Also this driver is missing a MAINTAINERS entry.
>
> The driver has been broken due to the mac80211 changes for a long time
> and it's obvious that I can't maintain it anymore as I haven't touched
> it for a long time. I would like to just remove it altogether. Any
> objections?
>
> If someone wants to step up and fix it, now is the time to do it.

Please keep the driver for now!  I have a pile of compatible hardware, 
and I should be able to fix it.  I'm placing it onto my TODO list.

There is some really obsolete hardware that we may need to stop 
supporting, e.g. Atheros AR5210, but the reason is because it's 
supported by an actively developed driver, ath5k, and the AR5210 code 
stands in the way all the time.

However, at76c50x-usb is a separate driver and it doesn't stand in the 
way of anybody except when global changes are made.

-- 
Regards,
Pavel Roskin
