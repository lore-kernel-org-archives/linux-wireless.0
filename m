Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.226]:65477 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYBATrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 14:47:47 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1864304wxd.4
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 11:47:46 -0800 (PST)
Message-ID: <1ba2fa240802011147j4cd027e8gacf2d5a6de65443d@mail.gmail.com> (sfid-20080201_194752_242231_05F2AAD3)
Date: Fri, 1 Feb 2008 21:47:45 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: wireless mini-summit agenda proposals?
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1201893322.20187.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080131162514.GC6413@tuxdriver.com>
	 <1201801923.3000.13.camel@localhost.localdomain>
	 <1201869751.4188.19.camel@johannes.berg>
	 <1ba2fa240802011029h7cce3f77ge61bc11564c378a6@mail.gmail.com>
	 <1201893322.20187.11.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 9:15 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2008-02-01 at 20:29 +0200, Tomas Winkler wrote:
> > On Feb 1, 2008 2:42 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >
> > > > cfg80211/nl80211 - overview, get Johannes to disseminate knowledge
> > > > because email isn't optimal for this.  I haven't had enough time to jump
> > > > into it yet, but the fact that Johannes is the vast majority of the
> > > > effort here is worrisome.  Having a reference implementation (airo,
> > > > atmel, maybe libertas) of a fullmac driver ported to cfg80211 would
> > > > probably be very useful, even just to get a sense of how the API works.
> > >
> > > cfg80211/nl80211 is no further for fullmac drivers than a year ago, all
> > > work it got so far is for hostapd.
> > >
> > > I have a fairly decent plan how to add association/... support but it
> > > lacks execution because it's completely boring work that doesn't buy us
> > > any new features since we still have to support wext.
> > >
> > Security setting is a bit  broken. There is a missing separation
> > between static and dynamic./WPA wep keys.
>
> How do you mean?

In wext there is encoding setting for static keys only for wep and
extended encoding for dynamic keys including wep keys. In mac80211
both setting are funneled to the same point which is incorrect since
the usage is not the same. The major problem is in HW acceleration.
The static wep keys are passed as belonging to the station with
broadcast address and the driver cannot distinguish if the wep key is
dynamic key for the bcast address or it is a static wep key that has
to be used for all traffic. The problem is of course visible mostly in
AP mode.

Tomas

> Dan
>
>
