Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3GIOfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 10:35:52 -0400
Message-ID: <1373380545.8241.1.camel@jlt4.sipsolutions.net> (sfid-20130709_163554_805519_4876E42C)
Subject: Re: Replacement for local->hw.conf.channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 09 Jul 2013 16:35:45 +0200
In-Reply-To: <51DB0937.2020609@candelatech.com>
References: <51D4BB56.9070401@candelatech.com>
	   (sfid-20130704_020129_998241_BE6D0EF6) <1372922870.8235.0.camel@jlt4.sipsolutions.net>
	  <51DB0302.5050201@candelatech.com>
	 <1373308289.8312.17.camel@jlt4.sipsolutions.net>
	 <51DB0937.2020609@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > No, don't use that in any new code. It's purely for compatibility with
> > drivers that aren't converted to channel contexts (yet).
> >
> >> In 3.9, ath9k_htc was giving me a null channel in the code below:
> >>
> >> 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> >> 	if (chanctx_conf)
> >> 		channel = chanctx_conf->def.chan;
> >> 	else
> >> 		channel = NULL;
> >
> > Well that of course happens if the vif isn't bound to a channel context.
> 
> Any opinions on what to return in ethtool stats for frequency if
> there is no channel context?

Why even bother doing so? "iw dev" shows the frequency and channel width
just fine, no?

> If there is a quick way to just return whatever the hardware is
> currently using, I think that is best, but if there is not
> a reliable way to do this then, some hard coded default
> like 0 is probably best.

Well there's no such concept as "what the hardware is currently using"
in this case, the channel is completely pointless when there's no
channel context at all. There might be something like the current scan
channel, but what value would there be in returning that?

johannes

