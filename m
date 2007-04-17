Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3959 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030684AbXDQPpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 11:45:43 -0400
Date: Tue, 17 Apr 2007 11:21:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, Andreas Schwab <schwab@suse.de>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] ieee80211-crypt: Make some TKIP and CCMP error logging conditional on IEEE80211_DEBUG_DROP
Message-ID: <20070417152103.GC8633@tuxdriver.com>
References: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net> <jeirbwfb55.fsf@sykes.suse.de> <4623C561.4030201@lwfinger.net> <200704162237.01280.mb@bu3sch.de> <462413AE.9020200@lwfinger.net> <20070417131222.GA8633@tuxdriver.com> <1176819909.26202.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1176819909.26202.33.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 17, 2007 at 10:25:08AM -0400, Dan Williams wrote:
> On Tue, 2007-04-17 at 09:12 -0400, John W. Linville wrote:
> > On Mon, Apr 16, 2007 at 07:24:14PM -0500, Larry Finger wrote:
> > > Michael Buesch wrote:
> > > > On Monday 16 April 2007 20:50, Larry Finger wrote:
> > 
> > > >> @@ -229,6 +229,7 @@ void free_ieee80211(struct net_device *d
> > > >>
> > > >>   static int debug = 0;
> > > >>   u32 ieee80211_debug_level = 0;
> > > >> +EXPORT_SYMBOL_GPL(ieee80211_debug_level);
> > > > 
> > > > We don't use the _GPL suffix in mac80211.
> > > 
> > > Upon inspection, neither does most of ieee80211. It is now changed.
> > 
> > You are strongly encouraged to use the _GPL version for new symbol
> > exports, especially those which are fundamentally internal to
> > in-kernel subsystems and/or have no reasonable usage by drivers.
> > FWIW, this symbol would seem to fulfill both of those criteria.
> > 
> > If you do not object, I would prefer the _GPL version of the patch.
> 
> What's the rationale for mac80211 _not_ using _GPL exports? I thought
> most new exports were pretty much required to be _GPL (otherwise
> somebody would NAK it) unless it was really, really necessary that they
> weren't.

An argument against _GPL exports for mac80211 might be leaving the
exports alone as a token of gratitude or respect towards Devicescape
for having seeded the development of mac80211 with a big chunk of code.
While I do thank Devicescape for their support, I'm not sure that
this argument would be truly compelling.

A more presuasive argument in favor of this pragmatism is that
it would be counter-productive to discourage driver availability.
At this point regulatory issues are still enough of a spectre that
some vendors will want the option of offering non-GPL drivers.
Such drivers would clearly not be redistributable, but there are
arguments that allow for such drivers (i.e. "the user installed
the driver -- not us", etc like Nvidia video drivers).  Of course,
no one likes enabling this kind of "bad behaviour".

Probably the best reason in favor of leaving them as-is is that they
were written that way by their original author(s).

Should I ask for opinionated discussion on the matter? :-)

John
-- 
John W. Linville
linville@tuxdriver.com
