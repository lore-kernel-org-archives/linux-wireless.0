Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1KPHuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 02:50:09 -0500
Subject: Re: [PATCH] mac80211: Add NoAck per WMM Queue Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <4EC36A56.70104@openwrt.org>
References: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <4EC36A56.70104@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 08:50:04 +0100
Message-ID: <1321429804.4773.4.camel@jlt3.sipsolutions.net> (sfid-20111116_085013_836160_A70CC5D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-16 at 08:46 +0100, Felix Fietkau wrote:
> On 2011-11-16 12:21 AM, Simon Wunderlich wrote:
> > This patch adds support for NoAck per WMM Queue. The Unicast QoS
> > Header is adapted accordingly for each outgoing frame.
> > The support is turned on and off through nl80211 by extending
> > the WMM TX Queue Parameters, but can be triggered separately.
> > 
> > I have tested this feature on ath9k as well as ath5k devices. There is
> > an iw patch as well to make use of this feature.
> > 
> > It should apply well on the latest wireless-testing kernel.

> > +	int	(*set_txq_noack)(struct wiphy *wiphy, struct net_device *dev,
> > +				  struct ieee80211_txq_params *params);
> > +
> >  	int	(*set_channel)(struct wiphy *wiphy, struct net_device *dev,
> >  			       struct ieee80211_channel *chan,
> >  			       enum nl80211_channel_type channel_type);
> Why add a separate cfg80211 op when you can just make use of the extra
> parameter in the existing one?

Can't actually -- that one's only allowed in AP mode :)

FWIW I think this API would also better be per connection or so.

johannes

