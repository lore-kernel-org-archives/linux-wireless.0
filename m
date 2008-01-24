Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22158 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYAXIwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 03:52:32 -0500
To: bruno randolf <bruno@thinktube.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, mcgrof@gmail.com,
	jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
References: <20080118125252.6455.41047.stgit@one>
	<1201099729.3454.17.camel@johannes.berg>
	<200801241443.40067.bruno@thinktube.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 24 Jan 2008 10:51:05 +0200
In-Reply-To: <200801241443.40067.bruno@thinktube.com> (ext bruno randolf's message of "Thu\, 24 Jan 2008 14\:43\:39 +0900")
Message-ID: <87ir1ja9om.fsf@nokia.com> (sfid-20080124_085237_708489_D8949458)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bruno randolf <bruno@thinktube.com> writes:

>> > --- a/net/mac80211/ieee80211_sta.c
>> > +++ b/net/mac80211/ieee80211_sta.c
>> > @@ -80,6 +80,9 @@ static void ieee80211_rx_bss_put(struct net_device
>> > *dev, struct ieee80211_sta_bss *bss); static int
>> > ieee80211_sta_find_ibss(struct net_device *dev,
>> >                                    struct ieee80211_if_sta *ifsta);
>> > +static int ieee80211_sta_join_ibss(struct net_device *dev,
>> > +                                  struct ieee80211_if_sta *ifsta,
>> > +                                  struct ieee80211_sta_bss *bss);
>>
>> No way, order the code properly, this mess needs to be cleaned up not
>> added to.
>
> Do you care to explain what's so bad about function declarations?

I don't know about Johannes, but I just see them as unnecessary
burden. If I change some parameters in a function, I'll get a compiler
error and only after that I realise to change the declaration as well.

With public (ie. non-static) functions it's a different issue, because
I know that there's a declaration in the header file. But with static
functions this is not the case.

-- 
Kalle Valo
