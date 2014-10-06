Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:41439 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbaJFNBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 09:01:49 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFT] iwlwifi: dvm: drop non VO frames when flushing
Date: Mon, 6 Oct 2014 13:01:37 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B53CC6D@hasmsx107.ger.corp.intel.com> (sfid-20141006_150152_481896_8BE837B7)
References: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
 <20141006123314.GA131459@ubuntu-hedt>
 <0BA3FCBA62E2DC44AF3030971E174FB31B53CBD4@hasmsx107.ger.corp.intel.com>
 <20141006124307.GB131459@ubuntu-hedt> <20141006124402.GC131459@ubuntu-hedt>
 <0BA3FCBA62E2DC44AF3030971E174FB31B53CC1F@hasmsx107.ger.corp.intel.com>
 <20141006125921.GE131459@ubuntu-hedt>
In-Reply-To: <20141006125921.GE131459@ubuntu-hedt>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Mon, Oct 06, 2014 at 12:47:41PM +0000, Grumbach, Emmanuel wrote:
> > >
> > > On Mon, Oct 06, 2014 at 07:43:07AM -0500, Seth Forshee wrote:
> > > > On Mon, Oct 06, 2014 at 12:35:46PM +0000, Grumbach, Emmanuel
> wrote:
> > > > > > Subject: Re: [RFT] iwlwifi: dvm: drop non VO frames when
> > > > > > flushing
> > > > > >
> > > > > > On Sun, Oct 05, 2014 at 04:57:12PM +0300, Emmanuel Grumbach
> wrote:
> > > > > > > +	if (vif)
> > > > > > > +		scd_queues &= ~BIT(vif-
> > > >hw_queue[IEEE80211_AC_VO]);
> > > > > >
> > > > > > I'm backporting this to 3.13, and this part doesn't work
> > > > > > unless 77be2c54c5bd26279abc13807398771d80cda37a is also
> > > > > > backported. Is this critical, or can it be omitted in the backport?
> > > > > >
> > > > >
> > > > > 77be2c54c5bd26279abc13807398771d80cda37a isn't really critical,
> > > > > but it is
> > > a dependency, and it is safe IMO.
> > > > > But I'd wait for a bit more testing :) The patch isn't even in
> > > > > my tree yet :)
> > > >
> > > > My backport is for testing too. Most of our bugs are against
> > > > Ubuntu 14.04, which uses 3.13. Seems better to have them test this
> > > > change in isolation rather than also testing everything which has
> > > > changed up to 3.17.
> > > >
> > > > I agree the patch is safe,
> > >
> > > Sorry, I was ambiguous here. I mean that
> > > 77be2c54c5bd26279abc13807398771d80cda37a is safe to backport.
> > >
> > > > but I'd also prefer to have it tested in the form which would
> > > > eventually get applied to the 3.13 extended stable tree. So I take
> > > > it for stable you would advocate applying both patches?
> >
> > I guess... I can rework the discussed patch (drop non VO ...) to work
> > without 77be2c54c5bd26279abc13807398771d80cda37a, but is it really
> worth it?
> > I don't see any reason not to backport
> 77be2c54c5bd26279abc13807398771d80cda37a.
> > IMHO, the easiest is to backport
> > 77be2c54c5bd26279abc13807398771d80cda37a and apply the drop non VO
> on top of it.
> >
> > What am I missing?
> 
> Nothing, except that stable kernel rules dictate that only bug fixes will be
> applied. 77be2c54c5 isn't a bug fix. If it's a necessary prerequisite then I
> suspect they'd be accomodating, but if it's not necessary then they might
> request a backport which doesn't require 77be2c54c5.
> 
> No sense it beating it to death now though. I'll backport both, and if the
> stable trees end up with something different I can ask for additional testing.
> Especially if it involves more than simply dropping those two lines.
> 

Yeah - I know the rules, but heh... You can even either:
1) a patch that is not a bug fix and then no conflicts
2) a conflict which can be tricky (bug prone) to solve

Sometimes rules need to be challenged :)
