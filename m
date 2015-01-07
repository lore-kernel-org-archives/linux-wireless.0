Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33618 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbbAGNnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:43:01 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so1212546wgh.18
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 05:43:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420637871.3407.10.camel@sipsolutions.net>
References: <1419847199-25493-1-git-send-email-arik@wizery.com>
 <1420541514.1966.16.camel@sipsolutions.net> <CA+XVXfeFWbVLCpebTQpv9FZPaDUEt1NJ6GpnyRoZ1UG91nMymw@mail.gmail.com>
 <1420637871.3407.10.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 7 Jan 2015 15:42:44 +0200
Message-ID: <CA+XVXfezPYoyEv-HVq_Xy9HHyRKeqDZMxOWDXLTQMHprkbM0ng@mail.gmail.com> (sfid-20150107_144305_595889_35DE733C)
Subject: Re: [PATCH] cfg80211: fix deadlock during reg chan check
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 7, 2015 at 3:37 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2015-01-07 at 15:34 +0200, Arik Nemtsov wrote:
>
>> > I'm not convinced this is the right thing to do. When checking for the
>> > current wdev that it can use a channel, then it seems that it's own
>> > current BSS connection (if any) shouldn't actually be taken into account
>> > - ergo the lock shouldn't have to be taken, that interface should be
>> > excluded from the "can beacon due to concurrent check" anyway.
>>
>> We have a couple of checks we want to add in the pipeline that also
>> need "this" wdev in the concurrent check, so I'd prefer to avoid this.
>
> Why would you need to check "this" wdev when doing something for "this"
> wdev? Seems odd? But I'm willing to learn :)

There's some convoluted regulatory logic where if this GO (or any
other) are operating on this GO_CONCURRENT (and not indoor-only)
channel, then it may continue in its operation even after the STA that
operated concurrently has disconnected.

>
>> > Also, the only reason this can happen anyway is when you call "can
>> > beacon" for a station interface - which seems nonsensical. Given that
>>
>> This is not true. This happens with current code for a p2p-go
>> interface during channel validity checks in reg.c.
>
> Not sure I see this? The only thing doing wdev locking is
> cfg80211_go_permissive_chan(), no? And that only for station interfaces.

cfg80211_go_permissive_chan is called from cfg80211_reg_can_beacon,
currently only for GO interfaces, but for STA also in the future
(hopefully).
The latter is called during channel validity checks for GO.

Arik
