Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:34260 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbZKQWvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 17:51:03 -0500
MIME-Version: 1.0
In-Reply-To: <1258498005.30511.3.camel@johannes.local>
References: <1258465585.3682.7.camel@johannes.local> <1258490898.21197.42.camel@johannes.local>
	<646765f40911171442m467efbc8ped7abc9d529ed095@mail.gmail.com>
	<1258498005.30511.3.camel@johannes.local>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 Nov 2009 09:50:49 +1100
Message-ID: <646765f40911171450q421cc4bv4a9a8aec0b278486@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: disallow bridging managed/adhoc interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 09:46, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2009-11-18 at 09:42 +1100, Julian Calaby wrote:
>> On Wed, Nov 18, 2009 at 07:48, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > --- wireless-testing.orig/net/mac80211/iface.c  2009-11-17 14:20:19.000000000 +0100
>> > +++ wireless-testing/net/mac80211/iface.c       2009-11-17 17:56:08.000000000 +0100
>> > @@ -745,6 +745,11 @@ int ieee80211_if_change_type(struct ieee
>> >        if (type == sdata->vif.type)
>> >                return 0;
>> >
>> > +       /* if it's part of a bridge, reject changing type to station/ibss */
>> > +       if (sdata->dev->br_port && (type == NL80211_IFTYPE_ADHOC ||
>> > +                                   type == NL80211_IFTYPE_STATION))
>> > +               return -EBUSY;
>>
>> Busy doesn't seem like the right error here ... maybe use -EOPNOTSUPP
>> like the next test?
>
> Not sure, it's a temporary error and you can fix it by removing it from
> the bridge, so it's "busy" in the sense that it is fixed to the current
> mode or any other bridging mode by being in the bridge ... it's not that
> it doesn't support the mode.

Arguably the test following this (ensuring that we don't set ad-hoc
mode on a non-ad-hoc channel) is equally temporary - i.e. both actions
require the user to do something before they'll work again.

But then, the test after that - for whether the interface is running -
returns -EBUSY - and is just as easy to remedy, so........

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
