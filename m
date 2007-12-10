Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33952 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751669AbXLJUvM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 15:51:12 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20071210090853.79ea4645@morte>
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost>  <20071210090853.79ea4645@morte>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 21:51:07 +0100
Message-Id: <1197319867.7493.4.camel@localhost> (sfid-20071210_205115_249319_727D7F72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-10 at 09:08 +0100, Stefano Brivio wrote:
> On Sun, 09 Dec 2007 23:25:50 +0100
> Mattias Nissler <mattias.nissler@gmx.de> wrote:
> 
> > >  static void *rate_control_pid_alloc(struct ieee80211_local *local)
> > >  {
> > >  	struct rc_pid_info *pinfo;
> > > +	struct rc_pid_rateinfo *rinfo;
> > > +	struct ieee80211_hw_mode *mode;
> > > +	int i, j, tmp;
> > > +	bool s;
> > >  
> > >  	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
> > > +	if (!pinfo)
> > > +		return NULL;
> > > +
> > > +	mode = local->oper_hw_mode;
> > > +	rinfo = kmalloc(sizeof(*rinfo) * mode->num_rates, GFP_ATOMIC);
> > > +	if (!rinfo) {
> > > +		kfree(pinfo);
> > > +		return NULL;
> > > +	}
> > 
> > What if the mode is changed? Have you checked the rate control algorithm
> > gets reinitialized? If not, we're scheduling a crash here, when
> > mode->num_rates changes.
> 
> After a discussion on IRC with Michael (Wu), we came to the conclusion that
> it doesn't make sense for mode->num_rates to change, because:
> 1) if the AP drops supported rates, it'll drop the association as well,
> then everything here will be destroyed and created again;
> 2) that can be changed in userspace, but we couldn't figure out a scenario
> where it would make any sense. Johannes, any comments? Wouldn't it make
> sense to just forbid to change this in userspace?

I don't agree. For example, what if you have some broken 802.11b only
hardware that you desperately need to get going, but it freaks out on
802.11g encoded frames. Now if your AP is hostapd on a Linux machine,
you'll want to change the mode. Hence, also the number of available
rates change.

Moreover, I think we can do better than just disallowing changes to the
rate set, don't you think?

Mattias

