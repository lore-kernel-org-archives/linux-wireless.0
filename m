Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62010 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab0I3Wv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 18:51:59 -0400
MIME-Version: 1.0
In-Reply-To: <1285886955.5137.31.camel@jlt3.sipsolutions.net>
References: <20100930211013.472957770@sipsolutions.net> <20100930211131.021309930@sipsolutions.net>
 <AANLkTik9+zA4PPPx=q6CRM-sgOjjECJdtJTgkCG9pGAY@mail.gmail.com>
 <1285886690.5137.28.camel@jlt3.sipsolutions.net> <1285886821.5137.29.camel@jlt3.sipsolutions.net>
 <1285886955.5137.31.camel@jlt3.sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 1 Oct 2010 08:51:38 +1000
Message-ID: <AANLkTimVMGHNkK=o650qzZfvUp3mWRAG_=60etVbEBxh@mail.gmail.com>
Subject: Re: [RFC 1/2] genetlink: introduce pre_doit/post_doit hooks
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	tgraf@suug.ch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 1, 2010 at 08:49, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2010-10-01 at 00:47 +0200, Johannes Berg wrote:
>> On Fri, 2010-10-01 at 00:44 +0200, Johannes Berg wrote:
>> > On Fri, 2010-10-01 at 08:41 +1000, Julian Calaby wrote:
>> >
>> > > >  d) include two private pointers in each info
>> > > >    struct passed between all these operations
>> > > >    including doit(). (It's two because I'll
>> > > >    need two in nl80211 -- can be extended.)
>> > >
>> > > Stupid question:
>> > >
>> > > Why not have a priv struct rather than an arbitrary array of two pointers?
>> >
>> > It'd have to be dynamically allocated, and the "arbitrary" array of two
>> > pointers can be on the stack.
>>
>> Maybe I should elaborate -- a priv struct basically means just a single
>> pointer, and then I'd have to allocate something to hold two pointers in
>> nl80211 and assign it to that single pointer.
>
> Come to think of it -- I could get away with a single pointer, since, if
> both are assigned,
>
> user_ptr[0] == wiphy_to_rdev(((netdev *)user_ptr[1])->ieee80211_ptr->wiphy)
>
> but that's a lot of pointy things, and some functions only have the rdev
> so it gets more complex. I think allowing two private pointers is a
> decent compromise.

Come to think of it -- if someone wanted to have a massive structure
with 10 pointers and a set of random data structures, then they could
easily create their priv struct and assign it to user_ptr[0], hence
rendering my argument null and void.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
