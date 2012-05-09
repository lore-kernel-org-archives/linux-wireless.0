Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:57356 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab2EIKQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 06:16:19 -0400
Message-ID: <4FAA43F0.6050401@tieto.com> (sfid-20120509_121623_489268_1658A785)
Date: Wed, 9 May 2012 12:16:16 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Thomas Pedersen <thomas@cozybit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [RFC] nl80211: don't require netdev UP for wdev
References: <1335479316-2933-1-git-send-email-thomas@cozybit.com>   (sfid-20120427_002914_313709_1CC9F96D) <1336554945.4323.12.camel@jlt3.sipsolutions.net>  <4FAA3BD2.9070203@tieto.com> <1336557043.4323.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336557043.4323.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>>> We should do the same for AP mode as well, since the channel really
>>> becomes relevant only upon start_ap(), before that there's no real
>>> concept of a channel since you don't use it yet anyway.
>>
>> Maybe we should do the same with monitor interface type, i.e. introduce
>> start_monitor() and have it pass the channel.
>
> No, that's the special case that doesn't work that way -- monitor mode
> interfaces are also great for debugging when they're just concurrently
> running with other interfaces and don't have their own channel setting.

We can make monitor interface to be a slave to other non-monitor 
interface by passing an extra parameter in start_monitor(). We could 
then have such a monitor interface follow channel changes of a given 
non-monitor interface (or rather it wouldn't be using a channel on it's 
own).


>> But then I'm thinking we shouldn't really be changing interface types
>> explicitly, since they would be set implicitly by start_ap() and such.
>> We could then use the NL80211_IFTYPE_UNSPECIFIED when we're not associated.
>
>  From some point of view, it should work that way, yes.
>
> Given how entrenched interface types are we definitely can't get rid of
> them though, and they're still needed to do concurrency management etc.

Well, I don't think we can get completely rid of them, too. Or do you 
mean something else?


-- 
Pozdrawiam / Best regards, Michal Kazior.
