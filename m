Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14599 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbZGOO4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 10:56:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 07:56:03 -0700
Date: Wed, 15 Jul 2009 07:56:01 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 01/21] mac80211: drop frames for sta with no valid rate
Message-ID: <20090715145601.GA5682@mosca>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
 <1247616853-11221-2-git-send-email-lrodriguez@atheros.com>
 <1247659121.2477.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1247659121.2477.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 04:58:41AM -0700, Johannes Berg wrote:
> On Tue, 2009-07-14 at 20:13 -0400, Luis R. Rodriguez wrote:
> 
> > +	if (unlikely((tx->local->sw_scanning) &&
> > +	    (sta_flags & WLAN_STA_ASSOC) &&
> > +	    !rate_usable_index_exists(sband, &tx->sta->sta))) {
> > +#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> > +		printk(KERN_DEBUG "%s: dropped data frame -- no "
> > +		       "supported rate for station %pM on %c GHz band\n",
> > +		       tx->dev->name, hdr->addr1,
> > +		       tx->channel->band ? '5' : '2');
> > +#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
> > +		WARN_ON(1);
> > +		return TX_DROP;
> 
> Can you use WARN(),

sure.

> and put it into the if() please?

It is already in the if() branch, do you mean in the #ifdef?

  Luis
