Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:32960 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZFYUhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 16:37:31 -0400
Received: by ewy6 with SMTP id 6so2694489ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2009 13:37:32 -0700 (PDT)
Message-ID: <4A43E002.2060309@gmail.com>
Date: Thu, 25 Jun 2009 21:37:22 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/11] cfg80211 connect API + wireless extension move
References: <20090624120745.239294066@sipsolutions.net> <43e72e890906241324n341f4988wc6e7325ee389e71e@mail.gmail.com>
In-Reply-To: <43e72e890906241324n341f4988wc6e7325ee389e71e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Wed, Jun 24, 2009 at 5:07 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> 
>>  Maybe we even decide to
>> not internalise it this way because orinoco wants to keep
>> some ioctls that we'll not offer in cfg80211, not sure yet.

Do we need to maintain these interfaces? I think allowing the same
functionality via other means should be acceptable (since any software
using these interfaces clearly doesn't work with any other hardware).

> Hm, which ones?

orinoco has the following private wext handlers:

reset firmware
reset card
get/set adhoc port
get/set short preamble
get/set ibss port
get rid

I've only ever had occasion to use the reset ioctls recently, when my
card started seriously misbehaving (I suspect it's about to fail).
debugfs or something?

The get/set things could be done as module parameters. Preferred values
will be model/fw specific - though I expect we have reasonable defaults
picked during initialisation.

Get RID reads settings off the card. Useful for debugging or reverse
engineering, but I hope no-one uses it for anything else. Remove completely?


Regarding patch 11 (the internalise one), would it be better to:
 * continue to export cfg80211_wext_* for now
 * set mac80211s dev->wireless_handler to &cfg80211_wext_handler in
iface.c (via a #define that's NULL if !CONFIG_WEXT)
 * specify a release when we expect all drivers, or at least those
anyone cares about, to have converted?

That removes the WE dependency from mac80211 but allows drivers to
gradually implement cfg80211 support. I originally attempted doing it in
one hit - that sucked, but may have been due to not having a clear idea
of how cfg80211 is supposed to work.

It also means orinoco can keep its wext private functions for a bit longer.


Thanks,

Dave.
