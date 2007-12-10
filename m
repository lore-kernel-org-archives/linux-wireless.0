Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:38285 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511AbXLJIPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 03:15:21 -0500
Date: Mon, 10 Dec 2007 09:08:53 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
 learning algorithm
Message-ID: <20071210090853.79ea4645@morte> (sfid-20071210_081535_203162_DF78C4E5)
In-Reply-To: <1197239150.7543.13.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209211931.26ff42fa@morte>
	<1197239150.7543.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 09 Dec 2007 23:25:50 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> >  static void *rate_control_pid_alloc(struct ieee80211_local *local)
> >  {
> >  	struct rc_pid_info *pinfo;
> > +	struct rc_pid_rateinfo *rinfo;
> > +	struct ieee80211_hw_mode *mode;
> > +	int i, j, tmp;
> > +	bool s;
> >  
> >  	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
> > +	if (!pinfo)
> > +		return NULL;
> > +
> > +	mode = local->oper_hw_mode;
> > +	rinfo = kmalloc(sizeof(*rinfo) * mode->num_rates, GFP_ATOMIC);
> > +	if (!rinfo) {
> > +		kfree(pinfo);
> > +		return NULL;
> > +	}
> 
> What if the mode is changed? Have you checked the rate control algorithm
> gets reinitialized? If not, we're scheduling a crash here, when
> mode->num_rates changes.

After a discussion on IRC with Michael (Wu), we came to the conclusion that
it doesn't make sense for mode->num_rates to change, because:
1) if the AP drops supported rates, it'll drop the association as well,
then everything here will be destroyed and created again;
2) that can be changed in userspace, but we couldn't figure out a scenario
where it would make any sense. Johannes, any comments? Wouldn't it make
sense to just forbid to change this in userspace?


--
Ciao
Stefano
