Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36825 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2IXXZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 19:25:15 -0400
Received: by lbbgj3 with SMTP id gj3so7548972lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 16:25:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348483695.10257.8.camel@jlt4.sipsolutions.net>
References: <504DBBAC.7040300@posedge.com> <CAB=NE6UfQdM6HrVGw3Dn-NBxQupwA3kJD27kv3c9DjLY8DVm1Q@mail.gmail.com>
 <5052E852.8030804@posedge.com> <1347896071.4975.14.camel@jlt4.sipsolutions.net>
 <CAB=NE6VMOvftuxi1zu3=4q-BJgM9rJHY86W-6+MAHmtY=V=6xA@mail.gmail.com> <1348483695.10257.8.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 24 Sep 2012 16:24:53 -0700
Message-ID: <CAB=NE6Wemx5NCTz-Q-vY4ogTUxbF+RjWdzeTt=qVrgGVhm_y+w@mail.gmail.com> (sfid-20120925_012558_912354_7FE45378)
Subject: Re: [RFC v3] cfg80211: VHT regulatory
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mahesh Palivela <maheshp@posedge.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 24, 2012 at 3:48 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-09-17 at 11:56 -0700, Luis R. Rodriguez wrote:
>
>> > I'm not convinced :-)
>> >
>> > Today, we have people who want to use wifi on other parts of the
>> > spectrum, like somewhere in the 800 MHz range for example. If that gets
>> > properly integrated into drivers (rather than pretending it's actually
>> > 2.4 GHz) then you may want to do something different here, and those
>> > channels would never actually have IEEE defined 80 MHz rules.
>>
>> So we'd have HT20 and HT40 only for 800 MHz?
>
> Why would we want to restrict bandwidth use to the band we're operating
> in at all? Fundamentally, the question, in terms of regulatory, is:
>
>  "Can I use a XY MHz around XYZ MHz?"
>
> It isn't really "Can I use VHT 80 on channel 6".

True, but we won't enable HT on non-HT cards, and so on. As much as we
can assume code is non IEEE specific cfg80211 builds on IEEE framework
and adding support to HT-foo or HT-bar to any band would require some
changes today.

>> > Also, those definitions are arbitrary for interoperability and don't
>> > reflect regulatory rules.
>>
>> It seems easier to implement supporting checking for a static set of
>> VHT arrangements rather than figuring out all theoretically possible
>> arrangements given that most other arrangements would be unused /
>> unimplemented / not-supported.
>
> I think it's only superficially easier since we define regulatory rules
> in terms of spectrum usage, and not in terms of IEEE channels.

I disagree here. Superficially it would indeed make things easier for
IEEE usage but in practice also it would make run time checks faster.
With a dynamic run time checker you are looking at a higher complex
operation at channel change time. That is what I am concerned about
ultimately.

>> > Yes, it may be easier today to just pretend
>> > that regulatory rules only matter for IEEE defined operation, but I'm
>> > not convinced that we really should have definitions here in the
>> > regulatory database that really only cover specific IEEE 802.11
>> > channels.
>>
>> Agreed, but what I am proposing doesn't necessarily push us to push
>> anything IEEE specific into the wireless regulatory database, but it
>> does however push us to implement IEEE specific use cases on cfg80211.
>
> Well, since the regulatory framework is now part of cfg80211 the line is
> a bit blurred here,

Well I consider regulatory code as code not on the Linux kernel and
cfg80211 regulatory code as IEEE 802.11 regulatory code. The regdb can
surely still be used on other subsystems, and surely can be shared
between them, but today the only user is IEEE 802.11

> but I don't see why a regulatory check should be
> restricted to 802.11 channels either, even if it uses the 802.11 defines
> to do the check?

cfg80211 deals with 802.11 ?

> On the contrary, I think that if we frame the question
> above in terms of 802.11 when asking the regulatory framework, then
> we'll most likely end up with a regulatory framework that is 802.11
> specific.

Agreed but I think cfg80211 regulatory code already is 802.11
specific, but not the userspace stuff. If we have a reason to make and
separate the cfg80211 regulatory code to be non-802.11 specific I'm
fine by that, but what's the use case so far and for what gain?

  Luis
