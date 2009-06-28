Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:62465 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZF1Inz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jun 2009 04:43:55 -0400
Received: by ewy6 with SMTP id 6so4700734ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 28 Jun 2009 01:43:57 -0700 (PDT)
Message-ID: <4A472D47.7020906@gmail.com>
Date: Sun, 28 Jun 2009 09:43:51 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/11] cfg80211 connect API + wireless extension move
References: <20090624120745.239294066@sipsolutions.net>	 <43e72e890906241324n341f4988wc6e7325ee389e71e@mail.gmail.com>	 <4A43E002.2060309@gmail.com> <1246050118.21314.82.camel@johannes.local>
In-Reply-To: <1246050118.21314.82.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2009-06-25 at 21:37 +0100, Dave wrote:
> 
>> That removes the WE dependency from mac80211 but allows drivers to
>> gradually implement cfg80211 support. I originally attempted doing it in
>> one hit - that sucked, but may have been due to not having a clear idea
>> of how cfg80211 is supposed to work.
> 
> Another idea I just had is that we could do everything like my
> internalise patch, but have an if (!netdev->wireless_handlers) before
> the assignment. That way, people could still have their own wireless
> handlers.

I had that same thought...

> Additionally, subject to a Kconfig symbol, we could still
> export the handlers, something like this:

<snip>

> or something like that. Then drivers that are in transition could select
> NEED_... and transition call by call even in the future after we switch
> to the central model. Is it worth it? I don't know.

Neat. I tend to prefer avoiding these indirections and keeping things
clean. I'd vote (if I had one) to take the NEED_ behaviour now, and
transition at some point.


Thanks,

Dave.
