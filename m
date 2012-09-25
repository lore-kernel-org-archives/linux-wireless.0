Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65304 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2IYTG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 15:06:58 -0400
Received: by lbon3 with SMTP id n3so608933lbo.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2012 12:06:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348557403.10041.10.camel@jlt4.sipsolutions.net>
References: <504DBBAC.7040300@posedge.com> <CAB=NE6UfQdM6HrVGw3Dn-NBxQupwA3kJD27kv3c9DjLY8DVm1Q@mail.gmail.com>
 <5052E852.8030804@posedge.com> <1347896071.4975.14.camel@jlt4.sipsolutions.net>
 <CAB=NE6VMOvftuxi1zu3=4q-BJgM9rJHY86W-6+MAHmtY=V=6xA@mail.gmail.com>
 <1348483695.10257.8.camel@jlt4.sipsolutions.net> <CAB=NE6Wemx5NCTz-Q-vY4ogTUxbF+RjWdzeTt=qVrgGVhm_y+w@mail.gmail.com>
 <1348557403.10041.10.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 25 Sep 2012 12:06:36 -0700
Message-ID: <CAB=NE6URYEr4d6ti0W7Go37x1fRM_9XD09cQXx4EJ6afhpPuXA@mail.gmail.com> (sfid-20120925_210702_811983_1B05684C)
Subject: Re: [RFC v3] cfg80211: VHT regulatory
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mahesh Palivela <maheshp@posedge.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 25, 2012 at 12:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-09-24 at 16:24 -0700, Luis R. Rodriguez wrote:
>
>> > Why would we want to restrict bandwidth use to the band we're operating
>> > in at all? Fundamentally, the question, in terms of regulatory, is:
>> >
>> >  "Can I use a XY MHz around XYZ MHz?"
>> >
>> > It isn't really "Can I use VHT 80 on channel 6".
>>
>> True, but we won't enable HT on non-HT cards, and so on. As much as we
>> can assume code is non IEEE specific cfg80211 builds on IEEE framework
>> and adding support to HT-foo or HT-bar to any band would require some
>> changes today.
>
> Not really, most cards also don't even assume that you only do 40 MHz on
> a channel that it's permitted on. The hardware will (mostly) be happy to
> do HT40- on channel 44, even if the 802.11 spec says that you should do
> HT40+ only on that channel.

Heh yeah...

>> > I think it's only superficially easier since we define regulatory rules
>> > in terms of spectrum usage, and not in terms of IEEE channels.
>>
>> I disagree here. Superficially it would indeed make things easier for
>> IEEE usage but in practice also it would make run time checks faster.
>> With a dynamic run time checker you are looking at a higher complex
>> operation at channel change time. That is what I am concerned about
>> ultimately.
>
> You've got to be kidding? Runtime cost of this is negligible, we only
> execute the test when we switch channels which happens very
> infrequently.

Well considering P2P technologies slowly blooming I would disagree
that channel changes are going to be infrequent. Then we also have
scanning which can happen any time you move away from your AP and at a
specific interval. Are we going to remove the capability to use each
channel as cached value and always ask cfg80211 it we can move on?

>> > Well, since the regulatory framework is now part of cfg80211 the line is
>> > a bit blurred here,
>>
>> Well I consider regulatory code as code not on the Linux kernel and
>> cfg80211 regulatory code as IEEE 802.11 regulatory code. The regdb can
>> surely still be used on other subsystems, and surely can be shared
>> between them, but today the only user is IEEE 802.11
>
> That's not really true though since the entire regdb handling is also
> part of cfg80211, so I think we should at least pretend to think about
> other spectrum use (or admit we don't care about other technologies,
> which is probably closer to the truth).

No you're right, the handling is purely technology agnostic and I've
always tried to keep it that way. Its just that as time went on it
started seeming like other technologies didn't want to use it or have
a way to use it. They certainly can and I'm willing to commit to
centralizing it and making a fine line but I just have't found use
cases for other technologies yet. I do suspect they will come hungry
one day looking for a solution though.

> Regardless though, if userspace
> gives us the right information for use of very wide channels, then the
> internal checks must fall to checking the spectrum permissions anyway,
> instead of iterating the list of possible 802.11 channels.

This is subjective and I prefer what you suggest, I do -- its just the
overhead I'm concerned over dynamic checks at run time channel change.
If you really feel its not going to be an issue then by all means,
lets do go for dynamic checks.

>> > On the contrary, I think that if we frame the question
>> > above in terms of 802.11 when asking the regulatory framework, then
>> > we'll most likely end up with a regulatory framework that is 802.11
>> > specific.
>>
>> Agreed but I think cfg80211 regulatory code already is 802.11
>> specific, but not the userspace stuff. If we have a reason to make and
>> separate the cfg80211 regulatory code to be non-802.11 specific I'm
>> fine by that, but what's the use case so far and for what gain?
>
> Ok so basically you do want to say that this in-kernel code doesn't care
> about other technologies, and if you want to use the regulatory database
> for other things you have to separate out the current code into "db
> handling" and "permission checking". I'm fine with that.

Yup. I've just been waiting for technologies to catch up looking for
what we have. They seem to be slow though.

> Still though, I fail to see how it helps? If you start from a database
> that has just frequency ranges & information about those ranges, you
> have to make a determination based on this information, for the channels
> you want to use.

True and in fact there are other technologies we have considered
integrating to help with efficient spectrum use and using the kernel
as a broker / helper with this, consider the frequency broker:

http://wireless.kernel.org/en/developers/FrequencyBroker

This was proposed in 2007 and at that time at least we envisioned
possibly sharing with BT channel use maps, and at times BT devices
could be informed through a firmware API that *is* required by the BT
spec to tell the device to avoid using certain channels (in our case
802.11 channels). This would in turn have allowed Linux, for example,
to deal with an OS level and device agnostic level of bluetooth
coexistance through channel skipping, one of the bt coex mechanisms:

http://wireless.kernel.org/en/users/Documentation/Bluetooth-coexistence

However obviously no one cared enough to implement this. But its
there... and yes I do foresee us requiring it, eventually.

> I'm proposing that we make that determination when we want to use a
> channel, and don't really worry about the 802.11 rules, we can enforce
> those in wpa_supplicant/hostapd as well, for example, like we actually
> do today.

That's fine, if we can ensure we won't incur a huge penalty at channel change :D

> What you're proposing (as far as I understand) is that we iterate the
> list of possible channels according to the 802.11 rules, and then make
> *the same* determination up-front.

Well consider it a cache of understood rules through a state machine.
We would clear the state machine regulatory cache upon a regulatory
change, but future checks if the state machine does not change would
enable you to very quickly move around spectrum with an O(1) check.
But -- similar ideas were spawned in networking, consider the routing
cache which is now nuked -- so maybe the cache benefits are just
theoretical and only provides a warm mental fuzzy feeling, in practice
it may be negligible and actually making things more complex.

> I fail to see the big difference that would make the latter easier,
> since it falls back to the same decision algorithm.

OK lets go with dynamic poo checks.

  Luis
