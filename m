Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:56936 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZEOCTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 22:19:17 -0400
Received: by pxi29 with SMTP id 29so826885pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 19:19:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905141833g214753d9lbdb00bd70ee28dfe@mail.gmail.com>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
	<1242033904-25694-4-git-send-email-lrodriguez@atheros.com>
	<1242036115.3284.15.camel@johannes.local> <43e72e890905111134u61f1600fie1950b6e12681e13@mail.gmail.com>
	<1242068010.3873.46.camel@johannes.local> <20090511190922.GD18696@tesla>
	<20090515003202.GA17816@tesla> <43e72e890905141833g214753d9lbdb00bd70ee28dfe@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 14 May 2009 19:18:58 -0700
Message-ID: <43e72e890905141918v5c8aa7b9n2ab42bfabd90ca54@mail.gmail.com>
Subject: Re: [RFC 3/5] mac80211: fix idle trigger upon resume
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 6:33 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, May 14, 2009 at 5:32 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Mon, May 11, 2009 at 12:09:22PM -0700, Luis Rodriguez wrote:
>>> On Mon, May 11, 2009 at 11:53:30AM -0700, Johannes Berg wrote:
>>> > On Mon, 2009-05-11 at 11:34 -0700, Luis R. Rodriguez wrote:
>>> >
>>> > > > Also, __ieee80211_queues_stopped_by_reason is misnamed since it checks
>>> > > > only a single queue. I also think that we can do this much better by
>>> > > > keeping track of the suspend state in a new variable rather than looking
>>> > > > at all the queues; even just checking queue 0 would be sufficient, but I
>>> > > > think a new variable is warranted.
>>> > >
>>> > > A global variable for going to suspend? Hm, do we have a system wide
>>> > > thing for this instead?
>>> >
>>> > No, and even then we couldn't use it I think since you can have
>>> > per-device suspend. I was just thinking of a local->variable.
>>>
>>> OK thanks will add this.
>>
>> So I've added the WARN_ON() here as we agreed to investigate on irc. Turns out
>> we hit it several times as expected. We hit it while going to suspend
>> once, and then on resume 3 times.
>
> The trace doesn't help much except for acknowledging the issue I was
> pointing out. The workqueue is run because we flush it, twice, during
> suspend. The idle recalc is run because we call it within
> ieee80211_sta_work(). If we want we can move the check for
> local->suspended to ieee80211_sta_work() but then we'd have to set
> local->suspended early on during suspend before the first flush and
> that doesn't seem right. So I think the patch as I have it is fine
> unless I'm missing something.

Nevermind -- the last trace does show its called from disassoc -- and
we I don't think we should disassoc until we've come back from
suspend.

  Luis
