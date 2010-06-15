Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:47173 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab0FOIuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 04:50:23 -0400
Subject: Re: [PATCH] iw: Configure basic rates when joining ibss network
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276586335.3648.3.camel@jlt3.sipsolutions.net>
References: <1276583053-30638-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276586335.3648.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Tue, 15 Jun 2010 11:50:05 +0300
Message-Id: <1276591805.4314.28.camel@paavo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 09:18 +0200, ext Johannes Berg wrote:
> On Tue, 2010-06-15 at 09:24 +0300, Teemu Paasikivi wrote:
> 
> > @@ -41,6 +46,31 @@ static int join_ibss(struct nl80211_state *state,
> >  		argc--;
> >  	}
> >  
> > +	/* basic rates */
> > +	if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {
> > +		argv++;
> > +		argc--;
> > +
> > +		value = strtok_r(argv[0], ",", &sptr);
> > +
> > +		while (value && n_rates < NL80211_MAX_SUPP_RATES) {
> > +			rate = atof(value);
> 
> should that use strtod() to check you didn't give "1a,2b,6c,11d"?
> 
Sure, it can be used. I think I'll change it to use that. I was just
wondering that how much the values given by the user should/could be
checked here.

> johannes
> 

Br,

Teemu


