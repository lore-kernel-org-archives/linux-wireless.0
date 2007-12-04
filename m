Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbXLDQCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:02:11 -0500
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <200712041647.46523.hs4233@mail.mn-solutions.de>
References: <200712041140.07516.hs4233@mail.mn-solutions.de>
	 <1196780650.26155.26.camel@localhost.localdomain>
	 <200712041647.46523.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 10:56:47 -0500
Message-Id: <1196783807.26155.58.camel@localhost.localdomain> (sfid-20071204_160214_232074_AF3A3C7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-12-04 at 16:47 +0100, Holger Schurig wrote:
> >> > 3. MAX_NETWORK_COUNT
> > Again, the point of using already defined stuff was to take
> > code out of libertas.  If this is in a header, it's pointless
> > to move it back into libertas.
> 
> I haven't found something similar in linux/ieee80211.h, but I 
> don't know if something with this meaning is in some other 
> header file which I don't know. I just doubt it.

We should  move something like this to lib80211 in the end anyway, but
for now make it local to libertas.

> > I assume that the reason you 
> > want to remove the dep on ieee80211 is to remove the
> > requirement to load that module, which moving this define back
> > to libertas wouldn't accomplish.
> 
> And the reason that some people want to remove the old ieee80211 
> code from the kernel source "really soon now" :-)

Yeah; I assume this means folding the ieee80211 stack back to being
private to the ipw* drivers too...

> > If you'd like to propose moving this define to some other
> > shared header that would be better (linux/ieee80211.h?). 
> > Libertas is not the only driver that uses this define (ipw*,
> > airo, libertas).
> 
> Okay, if other's don't object I can do that.

Another lib80211 candidate; but if you really want you can move it back
to libertas and we'll extract it for lib80211 later.

> 
> > > 4. DEFAULT_MAX_SCAN_AGE
> > No, but it does age the scan results after 15 seconds or
> > something.  Or at least it should.  It shouldn't be throwing
> > any AP in the scan list away until it's 15 seconds old.  This
> > define was picked because it was pointless to create yet
> > another define when there was already a usable and established
> > one.
> 
> If I understand you correctly, then this constant should end up 
> in linux/ieee80211.h as well?

When we do lib80211 it should really be private to lib80211 because that
would handle all the scan aging; but if this define isn't appropriate
for other drivers that use ieee80211.h then maybe we keep it private for
now and move it to lib80211 later.

> 
> > > 7. RADIOTAP
> > >
> > > Libertas contains lot's of code for it's monitoring mode,
> > > which uses radiotap. It used "struct net_device
> > > *rtap_net_dev" and "struct ieee80211_device *ieee". It
> > > contains code like
> > >
> > >    priv->rtap_net_dev = alloc_ieee80211(0);
> > >    priv->ieee = netdev_priv(priv->rtap_net_dev);
> > >
> > > and I don't have any knowledge about radiotap and how to
> > > substitue the alloc_ieee80211(). All I could currently to is
> > > to put those sections into #ifdef CONFIG_IEEE80211.
> >
> > Javier might have more comments on this.
> 
> I actually have a WIP patch that removes the ieee80211 
> dependency, it just clashes with my WIP 
> patch "new-scan.patch" :-)
> 
> The patch applies, compiles sparse-clean and is checkpatch clean, 
> so all is well ---- except that it completely disables monitor 
> mode via radiotap. Maybe I add the bunches you said and the ask 
> Javier to take things over, if he wants & has time. Or I split 
> the patch into things that can be committed today and only 
> remove ieee80211-dependency halfway.

That's probably best for the _moment_, need to investigate more what
exact functionality from ieee80211 Javier used for radiotap.

> But then again, ieee80211 is still in the kernel, so there's no 
> haste in making libertas ready for the post-ieee80211 time. So I 
> think I'll wait until David's patches settled.

Yeah, sounds like a plan.

Dan

