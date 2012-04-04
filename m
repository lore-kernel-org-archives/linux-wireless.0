Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45768 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2DDOrc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 10:47:32 -0400
Received: by vcqp1 with SMTP id p1so188350vcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2012 07:47:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333550545.18879.5.camel@jlt3.sipsolutions.net>
References: <1333539887.18879.1.camel@jlt3.sipsolutions.net>
	<CAD2nsn0eueZ+bB8sZqAcz9NnsEc9N2yo5MxRh1F7Sc0+epDDJg@mail.gmail.com>
	<1333550545.18879.5.camel@jlt3.sipsolutions.net>
Date: Wed, 4 Apr 2012 20:17:31 +0530
Message-ID: <CAD2nsn1mkYA7+N+uo791hrvO9X==x-JUd0mUe0LZS4SpiPfWMA@mail.gmail.com> (sfid-20120404_164735_883985_C3F39A8D)
Subject: Re: [PATCH] cfg80211/mac80211: enable proper device_set_wakeup_enable handling
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 4, 2012 at 8:12 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2012-04-04 at 20:08 +0530, Mohammed Shafi wrote:
>> Hi Johannes,
>>
>> On Wed, Apr 4, 2012 at 5:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > In WoWLAN, we only get the triggers when we actually get
>> > to suspend. As a consequence, drivers currently don't
>> > know that the device should enable wakeup. However, the
>> > device_set_wakeup_enable() API is intended to be called
>> > when the wakeup is enabled, not later when needed.
>> >
>> > Add a new set_wakeup() call to cfg80211 and mac80211 to
>> > allow drivers to properly call device_set_wakeup_enable.
>>
>> should we take care of anything else apart from
>> device_set_wakeup_enable in this driver
>> callback. we are working in ath9k WoW and i had seen the drivers use
>> device_set_wakeup_enable
>> API in the suspend/resume path. thank you.
>
> Yeah, I also did it in the suspend/resume path but Rafael told me that
> was wrong. As the PM maintainer, he should know :-)

oh ok, thanks for the reply and the letting me know the reason!

>
> I don't think you need to do anything else in this callback.
>
> johannes
>



-- 
thanks,
shafi
