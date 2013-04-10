Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44293 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935720Ab3DJRhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 13:37:12 -0400
Received: by mail-bk0-f51.google.com with SMTP id y8so379669bkt.24
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 10:37:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365500246.8465.5.camel@jlt4.sipsolutions.net>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
 <1365444377-9959-3-git-send-email-thomas@cozybit.com> <1365446248.25475.17.camel@jlt4.sipsolutions.net>
 <CAG6hwVOBqfP_Mw-pirzEOFytck-7H6_LNiTtO_90gXskbEuNTg@mail.gmail.com>
 <1365449914.25475.20.camel@jlt4.sipsolutions.net> <CAG6hwVOAwtngWU3uEueG7hZX3z5dxLLc8c8-Vd7Q+e93wM-UaQ@mail.gmail.com>
 <1365500246.8465.5.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 10 Apr 2013 10:36:50 -0700
Message-ID: <CAG6hwVOamzGVJ8x3omSu_9oY48WK=8nk=3P4CWnba53TfhsqUw@mail.gmail.com> (sfid-20130410_193717_193389_CFB3174A)
Subject: Re: [PATCH 3/6] mac80211: ieee80211_queue_stopped returns reasons
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 9, 2013 at 2:37 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2013-04-08 at 12:57 -0700, Thomas Pedersen wrote:
>
>> > That seems racy? Even asking whether it's stopped is racy though, what
>> > are you even trying to accomplish?
>>
>> Yeah, that's why I'd like to get the reason the first time.
>>
>> _h_mesh_fwding() checks whether the outgoing queue is stopped, to
>> avoid piling frames on the pending queue if the outgoing medium is
>> busy. I guess the idea was to avoid queueing frames faster than the
>> hardware could unload them. Maybe this doesn't actually happen, but we
>> can be a little bit smarter about when to drop forwarded frames. Like
>> if skbs are just being added to the outgoing queue, we probably
>> shouldn't.
>
> Technically I guess that can happen if your inbound link is better than
> the outbound one? But it'll depend on the AC parameters etc. too.
>
> However it seems that ieee80211_queue_stopped() is actually kinda broken
> and should only return the 'driver-stopped' reason to start with. If you
> fix that, it's probably good enough for you. I don't think in patch 4
> you should drop frames for scanning, for example.

It looks like mac80211 already just checks local->queue_stop_reasons
for being 0 (or not), so that check would still hold. I'm not 100%
sure the driver calls to ieee80211_queue_stopped() only returning true
for REASON_DRIVER are ok? What if the queues are being flushed, or say
REASON_PS is set?

-- 
Thomas
