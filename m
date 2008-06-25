Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:52726 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbYFYW0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 18:26:32 -0400
Received: by py-out-1112.google.com with SMTP id p76so1839194pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 15:26:30 -0700 (PDT)
Message-ID: <1ba2fa240806251526k773e8e2bj2c198defd0d8ef@mail.gmail.com> (sfid-20080626_002637_477717_068C8946)
Date: Thu, 26 Jun 2008 01:26:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/4 V2] mac80211: add last beacon time in scan list
Cc: "Pavel Roskin" <proski@gnu.org>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1214410337.21847.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214396229-18782-1-git-send-email-tomas.winkler@intel.com>
	 <1214409527.5881.21.camel@dv>
	 <1214410337.21847.33.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 25, 2008 at 7:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-06-25 at 11:58 -0400, Pavel Roskin wrote:
>
>> > +                   unsigned long mid_range = (-1) / 2 + 1;
>>
>> What is that?  I guess that's where Riemann's zeta function has its
>> non-trivial roots :-)

>
> The Pavel hypothesis: "The Riemann hypothesis is correct when calculated
> in 32-bit integers" is obviously wrong ;)
>
Welcome to the Desert of the Real

>> > +                   time_diff = jiffies - bss->last_update > mid_range ?
>> > +                           jiffies - bss->last_update :
>> > +                           bss->last_update - jiffies;
>>
>> That's pretty hairy.  Do we really lack a function to calculate time
>> difference?

This is simplest as you can get under assumption that times are not
apart more then 1/2 of UL.
 It would be overkill to translate it to timeval or anything we have
diff function for.

> Actually, come to think of it, isn't just doing the difference as in teh
> original patch correct in 32-bit unsigned integers? It'll wrap around a
> bit but that's ok, no?

It would make a very recent beacon to be like half an hour old on
wraps, wouldn't it?
But I'm good also with the old version as well. Just ACK one

Tomas
