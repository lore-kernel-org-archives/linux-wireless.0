Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:54966 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaAWH5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 02:57:16 -0500
Received: by mail-bk0-f51.google.com with SMTP id w10so229475bkz.10
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 23:57:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390462306.4189.56.camel@porter.coelho.fi>
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
	<1390403432.4334.33.camel@jlt4.sipsolutions.net>
	<1390403634.4189.39.camel@porter.coelho.fi>
	<CA+BoTQ=+TGFo0f0z1SymiN5DkeLZUPC_p_YVZ59s=FFqpGV3vQ@mail.gmail.com>
	<1390458664.4189.48.camel@porter.coelho.fi>
	<CA+BoTQnyd5HQxU9n=7G8bhJTukMJqZwNmD1FgWowHm2LJ=NUsA@mail.gmail.com>
	<1390462306.4189.56.camel@porter.coelho.fi>
Date: Thu, 23 Jan 2014 08:57:14 +0100
Message-ID: <CA+BoTQn-wjQYfUVxJU+xOUoANKE=8ajmq=ytmzAqVuiqMXJj=w@mail.gmail.com> (sfid-20140123_085719_763226_62D0CCB1)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 January 2014 08:31, Luca Coelho <luca@coelho.fi> wrote:
> (adding Andrei, since he should be aware of these discussions as well ;)
>
> On Thu, 2014-01-23 at 07:41 +0100, Michal Kazior wrote:
>> On 23 January 2014 07:31, Luca Coelho <luca@coelho.fi> wrote:
>> > On Thu, 2014-01-23 at 07:22 +0100, Michal Kazior wrote:
>> >> On 22 January 2014 16:13, Luca Coelho <luca@coelho.fi> wrote:
>> >> > On Wed, 2014-01-22 at 16:10 +0100, Johannes Berg wrote:
>> >> >> On Wed, 2014-01-22 at 14:36 +0200, Luca Coelho wrote:
>> >> >>
>> >> >> > I don't think we should try to merge the channel switches.  We should
>> >> >> > just perform them separately, especially because the exact time of the
>> >> >> > switch will most likely not be the same (since the TBTTs are not in
>> >> >> > sync).
>> >> >>
>> >> >> Do you mean that we shouldn't even have all that new API to switch
>> >> >> multiple interfaces simultaneously?
>> >> >
>> >> > Right, I'm not really sure it's necessary.  PErhaps with non-chanctx we
>> >> > need something like that, but maybe it would still be better not to do
>> >> > this in the nl80211 API, but sync/merge in cfg80211/mac80211?
>> >>
>> >> I was thinking about it. This should work, mostly, as long as you're
>> >> able to submit CSA requests fast enough and you don't use count 0 or
>> >> 1, in which case it becomes racy.
>> >
>> > CSA with count 0 or 1 are really tricky in many respects.  But still I
>> > don't see why it would get racy.  The interfaces will switch
>> > independently, making their own chanctx reservations and so on...
>>
>> You can't really switch multiple interfaces independently with a
>> single-channel hardware. You'll either end up with some interfaces
>> disconnected or dragged to a different channel forcefully.
>
> Right... I think there's no way around dragging them all forcefully.
>
> What about this: when mac80211 sees that one interface is about to
> switch channel and there are other interfaces in a single-channel
> device, it automatically starts channel switch on the other interfaces
> as well (really, there's no way around it).  Obviously it needs to
> inform userspace in this case and then it's up to the userspace to
> decide what to do (drop the connection, or accept the change).

This is actually the tricky part. How do you automatically switch an
AP interface? You should be able to at least generate CSA IE - true -
but what about beacon after CSA? You need to update HT IE and VHT IE
at least.

Perhaps we could split CSA into two parts somehow and make it more
userspace coordinated. The first part of CSA - announcing it, is
trivial and can actually be done entirely within mac80211 if I'm not
mistaken. What needs userspace input is what happens after the
announcement. This would mean that there is a possible time gap
between announcement being completed and the actual channel switch &
operation resuming.

This approach would also help with case of handling CSA to a DFS
"usable" channel that needs a CAC first.


Michał
