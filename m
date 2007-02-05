Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:61378 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbXBEI22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 03:28:28 -0500
Received: by wr-out-0506.google.com with SMTP id 68so1125343wri
        for <linux-wireless@vger.kernel.org>; Mon, 05 Feb 2007 00:28:28 -0800 (PST)
Message-ID: <43e72e890702050028s33645f3exf8b1f97a783925e@mail.gmail.com>
Date: Mon, 5 Feb 2007 03:28:27 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: SoftMAC vs FullMAC
Cc: "Michael Buesch" <mb@bu3sch.de>, "Pavel Roskin" <proski@gnu.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <9e4733910702041246s750fc8ach73e29a8c17727145@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
	 <200702042007.29357.mb@bu3sch.de>
	 <9e4733910702041144n277facd1g6af9c4659afc6d39@mail.gmail.com>
	 <200702042111.17005.mb@bu3sch.de>
	 <9e4733910702041246s750fc8ach73e29a8c17727145@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/4/07, Jon Smirl <jonsmirl@gmail.com> wrote:
> On 2/4/07, Michael Buesch <mb@bu3sch.de> wrote:
> > I don't really see your point.
> > We can't change hardware. We have to implement the software around existing
> > hardware. And that's currently softmac _and_ fullmac devices.
> > So we have to create hooks and so on in our software to support
> > the fullmac devices.
>
> What happened at Microsoft in the Ethernet case is that MS stopped
> supporting FullMAC and told the vendors to come up with SoftMAC type
> drivers. For some cards the vendors wrote the software drivers and for
> others MS did. Not all of the vendors agreed to this and most of those
> companies are no longer around.
>
> The point is that Linux could simply design out the FullMAC hardware
> that didn't also make a basic SoftMAC interface available. The primary
> wireless implementation for Linux would be a fully software based
> implementation that all hardware would be required to minimally work
> with. The main kernel wireless developers would then focus their
> attention on the software stack implementation instead of dealing with
> all of the various firmware messes and uncooperative vendors.
>
> This model is pretty close to happening with the Dscape stack. Once
> Dscape goes in, notice could be given that the other implementations
> will be removed in a year.
>
> Of course Linux doesn't have the same kind of power over the vendors
> like MS does. But it doesn't mean that this model wouldn't work for
> Linux. The concept of a single top to bottom software based reference
> implementation with hooks for hardware acceleration is a sound design.

Current wireless cognitive radio research is ambitiously trying to to
come up with a framework where certain functions can exist in either
hardware and/or software; but it is very important to note that,
mainly due to timing differences, it is by no means trivial to come up
with proper encapsulation of hardware implemented blocks so that they
are easily blended in a full software framework. Additionally, since
FullMAC solutions may currently provide the best solutions for certain
situations (power requirements for embedded devices being the most
common I've heard) and since we do want to take part in projects which
make use of these solutions (OLPC being one) we cannot, and I think
should not, try to mandate vendors to adopt SoftMAC solutions only
just because it makes our lives easier. MS may have done what they did
to help with their development efforts but it doesn't mean it was
necessarily good for technology. We want to work with vendors to
support their devices regardless of how stupid their design is --
ultimately our job is to support hardware for our users and not take
on political quests to dictate the path of technology.

  Luis
