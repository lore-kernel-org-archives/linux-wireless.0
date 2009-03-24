Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:34839 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444AbZCXUKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:10:39 -0400
Received: by qw-out-2122.google.com with SMTP id 8so2370502qwh.37
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 13:10:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com>
References: <200903241938.47155.chunkeey@web.de> <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com>
	<20090324184100.GA29268@tesla> <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com>
Date: Tue, 24 Mar 2009 13:10:21 -0700
Message-ID: <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com> (sfid-20090324_211042_909907_2DF74DC6)
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 1:03 PM, Bob Copeland <me@bobcopeland.com> wrot=
e:
> On Tue, Mar 24, 2009 at 2:41 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> Do any of you guys have time to pick it up?
>
> Well my patch #2 is pretty similar to what Christian has, and I'd lik=
e to
> upstream the first few patches soon (especially the ath.ko creation, =
it is a
> beast to rebase as you saw). =C2=A0That would bring up the first cont=
entious
> point of the merge: is "ath/ath.ko" ok with everyone?

Yes.

> ath5k/9k specific
> bits can eventually go in ath/{5k,9k} subdirs... not sure where 9170
> lives then :)

Wherever Christian wants it. If he finds re-usable bits then great.

> I probably can't get to it until the weekend, but if you have more ti=
me,
> Christian, feel free to adopt whatever you want from mine. =C2=A0Othe=
rwise I'll
> pick up where Luis left off on the weekend.
>
> I didn't push it yet because ath5k was having problems once I turned =
it
> on for ath5k,

So this is why I recommend to trim the channel list down of ath5k. The
other reason is you won't have users spending what may be 3/4 of their
time scanning on channels that they won't ever find APs in. What can
be done here is add  flag or command as we had reviewed a while back
to allow the user to enable these channels if he knows what he is
doing so that way we know we don't mind bothering scanning on the
gazillion channels. But that is just my advice. My concern first is to
get users working happily and quickly associated to an AP and I think
that parallels those goals and puts as secondary the bells and
whistles of adding every single possible channel.

> and I have no other hardware to test with so wanted to
> figure out what was broken first.
> Channel list is a good hint, maybe
> it's time to fix iw/nl80211 to send back all the channels :)

So that is the other option. I tried looking at that yesterday but
wasn't able to find a way to do this. I went through the netlink
documenation and even tried modifying the skb on the kernel side as
its a dump. Not sure what to do here to fix this.

So yes, both are possible options. Just keep in mind that without
being able to see the channel list with 'iw list' debugging regulatory
is a real royal pain in the ass. So I'd try to fix that first either
through channel reduction (you get another bonus enhancement for
scanning time for users) or through fixing this through iw/nl80211.

Johannes probably can advise best on the second path.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
