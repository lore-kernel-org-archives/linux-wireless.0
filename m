Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:43074 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab0EFFrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 01:47:00 -0400
Message-ID: <4BE257CC.7030308@free.fr>
Date: Thu, 06 May 2010 07:46:52 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] cfg80211/mac80211: better channel handling
References: <1273055797.3728.14.camel@jlt3.sipsolutions.net>	 <1273061543.3728.16.camel@jlt3.sipsolutions.net>	 <1273065902.3728.17.camel@jlt3.sipsolutions.net> <4BE1DBFE.2060909@free.fr> <1273124159.3573.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1273124159.3573.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 06/05/2010 07:35, Johannes Berg a écrit :
> On Wed, 2010-05-05 at 22:58 +0200, Benoit Papillault wrote:
>
>> Real hardware are not capable of listening on multiple channels (except
>> 2 ht20 channels in ht40 mode, maybe?). So I don't understand why we
>> should have a per-interface channel.
>>
>> I think we should either have two strategies :
>>
>> - "first one is the winner" : once a channel has been set, it cannot be
>> changed. For instance, if you create an AP interface (with hostapd) and
>> latter a STA interface, the STA interface can only scan on the channel
>> the AP is.
>
> That's what you get now.
>
>> - "last one is the winner" : in this case, the last call to set the
>> channel is always successful. Of course, this will change channel on
>> existing interfaces which might change their IE accordingly, through an
>> appropriate API.
>
> That's pretty much impossible to implement with the current split
> between user and kernel space.
>
>> I might be wrong, but I don't see this multi-channel usage...
>
> Say you have two stations associated to two different APs. They can
> powersave while they are on the channel for the other AP. It'll be done,
> rather soon, trust me :)
>
> johannes

I understand now and I am impressed as well! I don't know how this could 
work in the details, but I trust you on this :-)

Regards,
Benoit
