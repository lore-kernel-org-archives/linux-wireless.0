Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34458 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030216AbbENUBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 16:01:45 -0400
Received: by oiko83 with SMTP id o83so64468408oik.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2015 13:01:45 -0700 (PDT)
Message-ID: <5554FF26.1040304@lwfinger.net> (sfid-20150514_220149_095730_A5678EFF)
Date: Thu, 14 May 2015 15:01:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Gaston Gonzalez <gascoar@gmail.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	devel@driverdev.osuosl.org, arnd@arndb.de,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	joe@perches.com, navyasri.tech@gmail.com, julian.calaby@gmail.com
Subject: Re: [PATCH] staging: rtl8192u: ieee80211: Silence sparse warning
References: <1429476231-6197-1-git-send-email-gascoar@gmail.com>	 <20150420082441.GU10964@mwanda> <553C18B6.807@gmail.com>	 <20150427101242.GR14154@mwanda> <554AD76E.7060605@gmail.com>	 <20150508110328.GT14154@mwanda> <55527D6E.7090207@gmail.com>	 <20150513083615.GS14154@mwanda> <5553F48E.3050008@gmail.com>	 (sfid-20150514_030522_036209_6D0AE5EB) <1431632112.2237.5.camel@sipsolutions.net>
In-Reply-To: <1431632112.2237.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2015 02:35 PM, Johannes Berg wrote:
> On Wed, 2015-05-13 at 22:04 -0300, Gaston Gonzalez wrote:
>
>>   .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      | 53
>> ++--------------------
>>   include/net/mac80211.h                             |  3 ++
>>   net/mac80211/tkip.c                                |  9 ++--
>>   3 files changed, 10 insertions(+), 55 deletions(-)
>
> That doesn't seem right to me. Clearly, that's a staging driver that
> ships its own 802.11 subsystem, and bears no existing relation to
> mac80211. Exporting a mac80211 internal function to make such a driver
> happy makes me very suspicious. That function might not be very mac80211
> specific, but exporting it from mac80211 doesn't seem right, that
> introduces a massive and mostly artificial dependency into the driver.
>
> Now arguably that driver is in staging and that doesn't matter, but then
> why even bother cleaning this up? It seems likely that a well-written
> driver for this would use mac80211, and not have to bother with this at
> all since it could then use ieee80211_get_tkip_rx_p1k() or
> ieee80211_get_tkip_p2k() or the update_tkip_key() method.
>
> So I'm not fond of this patch and without a *very very* good reason and
> explanation I'm not going to merge the mac80211 part. It certainly
> bothers me much less that a crappy staging driver has a few lines of
> duplicated code than it would to export mac80211 internals that real
> mac80211 drivers don't need.

I agree. No staging driver should ever require changes in any part of mac80211!

If you want to get credit for kernel patches, you are welcome to fuss with the 
code, but none of your changes should touch any part of the kernel other than 
the driver you are working on. That is an absolute requirement.

One other comment is that I have never seen this hardware. I wonder if anyone 
has it anymore.

Larry


