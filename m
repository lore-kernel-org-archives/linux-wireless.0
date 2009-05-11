Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:48406 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346AbZEKSfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 14:35:12 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2261322rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 11:35:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242036115.3284.15.camel@johannes.local>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
	<1242033904-25694-4-git-send-email-lrodriguez@atheros.com>
	<1242036115.3284.15.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 11 May 2009 11:34:53 -0700
Message-ID: <43e72e890905111134u61f1600fie1950b6e12681e13@mail.gmail.com>
Subject: Re: [RFC 3/5] mac80211: fix idle trigger upon resume
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 3:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-05-11 at 05:25 -0400, Luis R. Rodriguez wrote:
>> When we suspend we stop the queues, then upon resume
>> the new idle checks will immediately pick up we're
>> idle and ask call our driver's config callback. At
>> this point its pointless to to call this callback
>> as we haven't yet come back from suspend. We avoid
>> then making assumptions about being idle until we know
>> we've come back from suspend. We do this by checking
>> the reason stop on all our queues.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>> =C2=A0net/mac80211/ieee80211_i.h | =C2=A0 =C2=A02 ++
>> =C2=A0net/mac80211/iface.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A05 +++=
++
>> =C2=A0net/mac80211/util.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 39 +++=
++++++++++++++++++++++++++++++++++++
>> =C2=A03 files changed, 46 insertions(+), 0 deletions(-)
>
>> +EXPORT_SYMBOL(ieee80211_any_queues_stopped_by_reason);
>
> You certainly should not export this symbol.
>
> Also, __ieee80211_queues_stopped_by_reason is misnamed since it check=
s
> only a single queue. I also think that we can do this much better by
> keeping track of the suspend state in a new variable rather than look=
ing
> at all the queues; even just checking queue 0 would be sufficient, bu=
t I
> think a new variable is warranted.

A global variable for going to suspend? Hm, do we have a system wide
thing for this instead?

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
