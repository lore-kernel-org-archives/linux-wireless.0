Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43745 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761690AbYENUGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 16:06:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 5/5] b43: move the register write into radio2050_rfover_val
Date: Wed, 14 May 2008 22:06:29 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <1210791396.6191.40.camel@brick> <200805142122.21635.mb@bu3sch.de> <1210793758.6191.43.camel@brick>
In-Reply-To: <1210793758.6191.43.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805142206.29881.mb@bu3sch.de> (sfid-20080514_220706_756615_BFDF81D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 May 2008 21:35:57 Harvey Harrison wrote:
> On Wed, 2008-05-14 at 21:22 +0200, Michael Buesch wrote:
> > On Wednesday 14 May 2008 20:56:36 Harvey Harrison wrote:
> > > It is always called with the same dev, register value as the
> > > b43_phy_write that wraps around it, make it return void
> > > and move the register write into radio2050_rfover_val.
> > 
> > NACK to the whole 5 patches.
> > See the list archives for an explanation.
> 
> Any particular reference for nacking 5/5?

Well, I don't see a point.
I designed the function to return the actual value. Therefore it's
named foobar_val().
You patches shuffle a lot of code around, but there's no real gain from it.
There are only huge downsides, like the possibility of introducing a flipped
bitmask or similiar bugs. That happened in the past. And I tell you, it's
really hard to debug the PHY code. _Not_ because it's hard to read, but because
nobody does understand what it really does.
And guess what; it's _me_ who will have to debug it in case bugs appear... .
But I already explained all this earlier.

> But if you apply all 5, just look at the two files side-by-side and it
> is much easier to follow with them applied.

Nobody is actually reading or touching this code. It's Good Code (tm).
We don't know what it does and we must not modify its semantics. So I don't
really see a point in making it more pretty. You won't understand it afterwards
anyway.

_Please_ try to do something more useful, like hacking mac80211 or something like
that. There are lots of places in wireless that need work. But this certainly not
one of them, as it's good and _working_ code.

-- 
Greetings Michael.
