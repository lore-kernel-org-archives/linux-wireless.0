Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58039 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBEOhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 09:37:05 -0500
Received: by mail-bk0-f52.google.com with SMTP id e11so237768bkh.39
        for <linux-wireless@vger.kernel.org>; Wed, 05 Feb 2014 06:37:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391602306.16723.57.camel@porter.coelho.fi>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	<1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	<1391434913.4488.24.camel@jlt4.sipsolutions.net>
	<1391508433.26522.61.camel@porter.coelho.fi>
	<CA+BoTQngW4Ycuv0H=ba5KWs2qDcqPQtKJWp-9XEwdqQv+Xu6CA@mail.gmail.com>
	<1391585999.16723.7.camel@porter.coelho.fi>
	<CA+BoTQkXjAYR0H4nHxagYz3Kn5atWJ048UUY1=gPrW77Gvqp+Q@mail.gmail.com>
	<1391602306.16723.57.camel@porter.coelho.fi>
Date: Wed, 5 Feb 2014 15:37:02 +0100
Message-ID: <CA+BoTQ=5v7OvUrBBRrArPnd7n5jKkUHMuDhU0tRL5caF-J+BiA@mail.gmail.com> (sfid-20140205_153711_550872_D556A963)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 February 2014 13:11, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2014-02-05 at 11:29 +0100, Michal Kazior wrote:
>> On 5 February 2014 08:39, Luca Coelho <luca@coelho.fi> wrote:
>> > I don't see how involving the userspace in the STA CSA decision would
>> > make any difference.  Doesn't it actually make it worse, because the STA
>> > CSA *itself* may fail because userspace doesn't have the time to react?
>>
>> If you have STA CSA started inside mac80211 userspace may not have
>> enough time to react and request GO to switch in the GO-follows-STA.
>
> It's the same if the STA CSA would be "started" in the userspace.  If
> the remote AP sets a too short count, the userspace won't have the
> chance to react.  In either case, we would have to send a notification
> to the userspace and it would have to tell us what to do.  If we wait
> for the userspace to react on our STA CSA, we will be too late on both
> interfaces.  If mac80211 does the STA CSA directly, at least the STA CSA
> will be done on time and the GO can move a bit later (or get
> disconnected if we were short on chanctx's).
>
> Now, if you are thinking about my "delay the STA CSA even if it will be
> late" idea, then I think you have a point.  The side-effect would be
> that if you have only a STA and get a CSA with short count, we will
> probably get delayed too.

Correct. Having STA CSA in userspace makes it a little more timing
tolerant but it makes it a bit "laggy".


[...]
>> The purpose of ch_switch_finalize() is to perform the final switch
>> atomically and make sure non-complying interfaces are disconnected
>> before channel is actually switched (this could include Ilan's GO case
>> in a clean way).
>
> I was thinking about eventual drivers that offload the whole channel
> switch process to the firmware.  The driver just sends the count, the
> new channel and everything and the firmware takes care of it all.  It
> will beacon for count TBTTs and perform the actual channel switch at the
> right time.  In this case, all the decision making about what needs to
> be disconnected or switched must be made at the beginning.
>
> But I'll let Johannes comment more. ;)

If the decision must be made at the beginning and you want mac80211 to
start STA CSA then GO-follow-STA is impossible.

What could work here is single-command-multi-interface channel switch
IF you make STA CSA a userspace thing.

If you want to keep STA CSA not a userspace thing you cannot make any
decision at the start in cfg80211 and you must move the decision to
the driver itself (or firmware, actually). In that case cfg80211
remains highly reactive and you cannot guarantee interface combination
state consistency at all times because driver may be incapable of
notifying cfg80211 in a sane way about interface state changes (e.g.
due to firmware design/ HW limitation/ cfg80211 locking issues/
synchronization).


Michał
