Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518AbYE0NyD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 09:54:03 -0400
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: JMF <tolas_feup@hotmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com>
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
	 <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com>
	 <loom.20080527T105701-941@post.gmane.org>
	 <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 27 May 2008 09:53:43 -0400
Message-Id: <1211896423.1746.9.camel@localhost.localdomain> (sfid-20080527_155421_038091_CE55B356)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-27 at 15:41 +0300, Tomas Winkler wrote:
> On Tue, May 27, 2008 at 1:58 PM, JMF <tolas_feup@hotmail.com> wrote:
> > Tomas Winkler <tomasw@...> writes:
> >
> >> WEP key is of fixed size 13 or  5 bytes, this setting should be
> >> refused somewhere in the mac wext handler.
> >> NACK.
> >> Tomas
> >  What about 256-bit WEP key (232-bit key I think), it won't be supported?
> >
> Not supported by iwlwifi HW, have to be done by SW, We need to check
> then probably in driver whether we support it or not and return error
> value in this case, in other cases I'm not sure how defensive the code
> should be....
> By the way isn't this a waste of bits. AES seams to be  secure enough.
> Who is implementing this at all?

IIRC D-Link is one manufacturer who implemented 152-bit and higher WEP
keys when people started to get scared about WEP, but before 802.11i/WPA
actually came out.

I'm pretty sure that not too many sites use greater than 104/128-bit
WEP, and the cards that support it in hardware (most cards were fullmac
at the time) we can probably count on one hand.  For softmac cards, we'd
have to weigh the maintenance cost of keeping the codepaths around that
most people wouldn't use and for hardware that nobody developing the
stack currently has to test against against the benefit of enabling
these users to work with legacy APs.

I've gotten maybe 1 or 2 requests for > 104/128-bit WEP key support for
NM in 3 years.  Nice to have, but I'm not sure it's worth the extra code
and maintenance burden?  Would be good to have somebody tell us what
hardware (APs and cards) support this though.

Dan

