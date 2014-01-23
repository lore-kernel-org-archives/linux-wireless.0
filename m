Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52639 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaAWGfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 01:35:13 -0500
Received: by mail-bk0-f46.google.com with SMTP id r7so198917bkg.5
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 22:35:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390394166.4189.28.camel@porter.coelho.fi>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	<1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	<1390316761.6199.27.camel@jlt4.sipsolutions.net>
	<CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	<1390380726.4334.4.camel@jlt4.sipsolutions.net>
	<CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	<1390382020.4334.17.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	<1390385995.4334.27.camel@jlt4.sipsolutions.net>
	<1390394166.4189.28.camel@porter.coelho.fi>
Date: Thu, 23 Jan 2014 07:35:11 +0100
Message-ID: <CA+BoTQ=vACFk2_9xgUVdZKjrcfhNBswULG-5v7HC=Bsa3kLpVQ@mail.gmail.com> (sfid-20140123_073517_595503_843F1305)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2014 13:36, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2014-01-22 at 11:19 +0100, Johannes Berg wrote:
>> On Wed, 2014-01-22 at 11:13 +0100, Michal Kazior wrote:

[...]

>> > What about cfg80211 intf combinations? If GO sends a channel switch it
>> > will fail on num_available_channels unless you implicitly consider the
>> > userspace event you mentioned or export CSA state down to cfg80211.
>>
>> Yeah, that's a good point, need to consider that.
>
> Very good point.  I hadn't thought about it.  When mac80211 decides to
> change channel to an existing context, it needs to know whether the
> combination will be valid or not.
>
>
>> > At one point I was wondering if channel contexts should be actually
>> > exposed in cfg80211. It would probably make it easier to coordinate
>> > some CSA scenarios like this in a sane way, don't you think? But then
>> > again that's quite big of a change.
>>
>> Yeah that'd be a bit of a change, but maybe it's worth it? Not sure.
>
> That's probably going to be necessary.  How would mac80211 be able to
> know if the future combination would be possible or not? I thought about
> asking cfg80211 if the combination would be okay when reserving a
> context, but that wouldn't work if we have >= 2 reservations.  cfg80211
> needs to know about the reservations as well. :(

You could probably get away without exposing channel contexts to
cfg80211 as long as you at least provide some level of channel
switching state back to cfg80211.

You could have a 'channel switch state' which says a channel X will
become channel Y for A,B,C.. interfaces "soon". mac80211 (or any
cfg80211-based driver for that matter) could tell cfg80211 "the switch
is complete" (and possibly a status code to indicate failure). This
way cfg80211 would be the one to stop/disconnect interfaces that were
on channel X but weren't included in a given channel switch to channel
Y. I think this should work with >= 2 reservations including error
handling (i.e. failing in the middle).

What bothers me here is locking. You can't just use wdev->mtx -- you
need a more global lock for protecting this sort of thing. Since the
reservation would be accessible from userspace (even implicitly via
some existing nl80211 commands) and from cfg80211-based (i.e.
mac80211) it might be tricky? But I suppose having channel contexts in
cfg80211 would involve this predicament as well.

Also currently cfg80211 is oblivious to HT40+/HT40- and It doesn't
consider HT40+ @ chan6 and HT40- @ chan6 as different channels, right?


Micha³
