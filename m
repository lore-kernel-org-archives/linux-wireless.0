Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36815 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422686AbbENWEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 18:04:52 -0400
Received: by qgg76 with SMTP id 76so18559074qgg.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2015 15:04:52 -0700 (PDT)
Message-ID: <55551BC7.10702@gmail.com> (sfid-20150515_000456_020727_3E790E47)
Date: Thu, 14 May 2015 19:03:51 -0300
From: Gaston Gonzalez <gascoar@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	devel@driverdev.osuosl.org, arnd@arndb.de,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	joe@perches.com, navyasri.tech@gmail.com, julian.calaby@gmail.com
Subject: Re: [PATCH] staging: rtl8192u: ieee80211: Silence sparse warning
References: <1429476231-6197-1-git-send-email-gascoar@gmail.com>	 <20150420082441.GU10964@mwanda> <553C18B6.807@gmail.com>	 <20150427101242.GR14154@mwanda> <554AD76E.7060605@gmail.com>	 <20150508110328.GT14154@mwanda> <55527D6E.7090207@gmail.com>	 <20150513083615.GS14154@mwanda> <5553F48E.3050008@gmail.com>	 (sfid-20150514_030522_036209_6D0AE5EB) <1431632112.2237.5.camel@sipsolutions.net>
In-Reply-To: <1431632112.2237.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/05/15 16:35, Johannes Berg wrote:
> On Wed, 2015-05-13 at 22:04 -0300, Gaston Gonzalez wrote:
>
>>  .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      | 53
>> ++--------------------
>>  include/net/mac80211.h                             |  3 ++
>>  net/mac80211/tkip.c                                |  9 ++--
>>  3 files changed, 10 insertions(+), 55 deletions(-)
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
>
> johannes
>
Johannes,

If Dan is a newbie to this, I would be a pre-under-newbie or something
below that. That being said, understood your explication, I'll look for
another way to deal with this warning.
Thanks, and sorry for the noise.

Regards,

Gaston



