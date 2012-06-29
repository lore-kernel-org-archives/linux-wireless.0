Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:44567 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755710Ab2F2PYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 11:24:44 -0400
Message-ID: <1340983483.6562.31.camel@joe2Laptop> (sfid-20120629_172448_598398_672DDCE8)
Subject: Re: [PATCH v2] mac80211: correct size the argument to kzalloc in
 minstrel_ht
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>, franzschrober@yahoo.de,
	julian.calaby@gmail.com, nbd@openwrt.org
Date: Fri, 29 Jun 2012 08:24:43 -0700
In-Reply-To: <1340978200.4472.2.camel@jlt3.sipsolutions.net>
References: <1340976387-80206-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1340978200.4472.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-29 at 15:56 +0200, Johannes Berg wrote:
> On Fri, 2012-06-29 at 06:26 -0700, Thomas Huehn wrote:
[]
> > diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
[]
> > @@ -809,11 +809,11 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
> >  			max_rates = sband->n_bitrates;
> >  	}
> >  
> > -	msp = kzalloc(sizeof(struct minstrel_ht_sta), gfp);
> > +	msp = kzalloc(sizeof(*msp), gfp);
> >  	if (!msp)
> >  		return NULL;
> >  
> > -	msp->ratelist = kzalloc(sizeof(struct minstrel_rate) * max_rates, gfp);
> > +	msp->ratelist = kzalloc(sizeof(*msp->ratelist) * max_rates, gfp);

trivia: this might be better as kcalloc


