Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55389 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYCFRbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 12:31:02 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: handling Qdisc issues
Date: Thu, 6 Mar 2008 18:30:31 +0100
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com> <200803061815.31398.mb@bu3sch.de> <1204824008.25502.123.camel@johannes.berg>
In-Reply-To: <1204824008.25502.123.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803061830.32316.mb@bu3sch.de> (sfid-20080306_173109_978615_7D73C2D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 March 2008 18:20:08 Johannes Berg wrote:
> 
> > >  		/* Decide by priority where to put this frame. */
> > > -		ring = priority_to_txring(dev, ctl->queue);
> > > +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> > > +		ring = priority_to_txring(dev, skb->queue_mapping);
> > > +#else
> > > +		/* XXX: b43 qos needs a lot of work */
> > > +		ring = 1;
> > > +#endif
> > >  	}
> > 
> > ehm, this won't compile.
> > And did you see the patches I recently submitted?
> 
> That's my old patch, I think Ron doesn't know anything about b43 :) And
> my patch was based before your QoS support patches.

Ah ok. You can just add this #ifdef to the already existing
dynamic condition on b43_modparam_qos in the new queue mapping function.

-- 
Greetings Michael.
