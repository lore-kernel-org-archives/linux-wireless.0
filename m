Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbYBAVcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 16:32:43 -0500
Subject: Re: wireless mini-summit agenda proposals?
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240802011321r79297484m6381527457fdb919@mail.gmail.com>
References: <20080131162514.GC6413@tuxdriver.com>
	 <1201801923.3000.13.camel@localhost.localdomain>
	 <1201869751.4188.19.camel@johannes.berg>
	 <1ba2fa240802011029h7cce3f77ge61bc11564c378a6@mail.gmail.com>
	 <1201893322.20187.11.camel@localhost.localdomain>
	 <1ba2fa240802011147j4cd027e8gacf2d5a6de65443d@mail.gmail.com>
	 <1201896714.20566.8.camel@localhost.localdomain>
	 <1ba2fa240802011321r79297484m6381527457fdb919@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 16:31:58 -0500
Message-Id: <1201901519.25399.12.camel@localhost.localdomain> (sfid-20080201_213246_239274_796699AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-01 at 23:21 +0200, Tomas Winkler wrote:
> On Feb 1, 2008 10:11 PM, Dan Williams <dcbw@redhat.com> wrote:
> >
> > On Fri, 2008-02-01 at 21:47 +0200, Tomas Winkler wrote:
> > > On Feb 1, 2008 9:15 PM, Dan Williams <dcbw@redhat.com> wrote:
> > > > On Fri, 2008-02-01 at 20:29 +0200, Tomas Winkler wrote:
> > > > > On Feb 1, 2008 2:42 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > > > >
> > > > > > > cfg80211/nl80211 - overview, get Johannes to disseminate knowledge
> > > > > > > because email isn't optimal for this.  I haven't had enough time to jump
> > > > > > > into it yet, but the fact that Johannes is the vast majority of the
> > > > > > > effort here is worrisome.  Having a reference implementation (airo,
> > > > > > > atmel, maybe libertas) of a fullmac driver ported to cfg80211 would
> > > > > > > probably be very useful, even just to get a sense of how the API works.
> > > > > >
> > > > > > cfg80211/nl80211 is no further for fullmac drivers than a year ago, all
> > > > > > work it got so far is for hostapd.
> > > > > >
> > > > > > I have a fairly decent plan how to add association/... support but it
> > > > > > lacks execution because it's completely boring work that doesn't buy us
> > > > > > any new features since we still have to support wext.
> > > > > >
> > > > > Security setting is a bit  broken. There is a missing separation
> > > > > between static and dynamic./WPA wep keys.
> > > >
> > > > How do you mean?
> > >
> > > In wext there is encoding setting for static keys only for wep and
> > > extended encoding for dynamic keys including wep keys. In mac80211
> > > both setting are funneled to the same point which is incorrect since
> > > the usage is not the same. The major problem is in HW acceleration.
> > > The static wep keys are passed as belonging to the station with
> > > broadcast address and the driver cannot distinguish if the wep key is
> > > dynamic key for the bcast address or it is a static wep key that has
> > > to be used for all traffic. The problem is of course visible mostly in
> > > AP mode.
> >
> > Ah; right.  I don't think there really should be a difference in the API
> > to differentiate static vs. dynamic WEP keys.  Instead each key sent to
> > the driver (be it WEP, TKIP, or CCMP) should definitely have a BSSID to
> > which it applies which the userspace caller must set, and if the key is
> > to be used for _all_ traffic, then maybe have a flag for that or use
> > 00:00:00:00:00:00 as the BSSID.  If we use "magic" #s like 00:00... for
> > the BSSID then we've got to be sure to document that magic # which is
> > where we all fell down with WEXT.  Hence I prefer flags, but whatever.
> >
> 
> Sure this is not good to make too many interfaces, but a flag must be
> added, i prefer to not abusing BSSID address.
> One other difference is that there might be 4 keys for static wep
> while only one wep key in WPA.

Definitely; there will certainly need to be flags or a 'wep_key_idx'
field for WEP key indexes.  Should probably just have a 'u32 flags'
somewhere that goes along with each key.

Dan

