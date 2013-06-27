Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:57860 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3F0IJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 04:09:14 -0400
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Felix Fietkau'" <nbd@openwrt.org>
Cc: <linux-wireless@vger.kernel.org>
References: <1372267723-25072-1-git-send-email-jp.tosoni@acksys.fr> <51CB33D9.1070104@openwrt.org>
In-Reply-To: <51CB33D9.1070104@openwrt.org>
Subject: RE: [RFC] mac80211: Use libnl-configurable values for retry counts
Date: Thu, 27 Jun 2013 10:09:09 +0200
Message-ID: <003001ce730d$9a32e980$ce98bc80$@acksys.fr> (sfid-20130627_100923_688815_3F415100)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, thanks for your prompt reply and for pointing out my mistakes.

> > Use wiphy->retry_short for management frames.
> > Use wiphy->retry_long for other frames.
> That seems a bit arbitrary.

Indeed.
Should I use the following?
  retry_long for data frames subject to RTS
  retry_short for all other frames.
That looks closer to the descriptions in 802.11-2012.
 
> > +	mp->max_retry = hw->conf.long_frame_max_tx_count;
> minstrel_alloc is called at rate control init time. You're not making
> max_retry configurable here, it'll pick the default value of
> hw->conf.long_frame_max_tx_count and never update it again.

Is it OK if I replace max_retry with the config values in minstrel_rate_init
and minstrel_update_rates instead?
Then we can get rid of max_retry completely?

(Sorry, I got mixed in the never-ending sequence of callbacks :)

> > diff --git a/net/mac80211/rc80211_minstrel.c
> b/net/mac80211/rc80211_minstrel.c
> > index ac7ef54..502d0c9 100644
> > --- a/net/mac80211/rc80211_minstrel.c
> > +++ b/net/mac80211/rc80211_minstrel.c
> > @@ -592,11 +592,7 @@ minstrel_alloc(
> >	/* maximum time that the hw is allowed to stay in one MRR  segment
*/
> >  	mp->segment_size = 6000;
> >
> > -	if (hw->max_rate_tries > 0)
> > -		mp->max_retry = hw->max_rate_tries;
> > -	else
> > -		/* safe default, does not necessarily have to match hw
properties */
> > -		mp->max_retry = 7;
> > +	mp->max_retry = hw->conf.long_frame_max_tx_count;> 
> - Felix

Jean-Pierre

