Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:51451 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1AEQUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 11:20:37 -0500
Received: by pxi15 with SMTP id 15so2776531pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 08:20:36 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19748.39483.90936.674269@gargle.gargle.HOWL>
Date: Wed, 5 Jan 2011 21:50:11 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <m.sujith@gmail.com>, Jouni.Malinen@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] cfg80211: Add HT BSS attributes
In-Reply-To: <1294243338.3590.11.camel@jlt3.sipsolutions.net>
References: <19748.37551.23627.698571@gargle.gargle.HOWL>
	<1294243338.3590.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2011-01-05 at 21:17 +0530, Sujith wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > 
> > Add two new per-BSS attributes to allow configuration of
> > HT capabilites and operational parameters by hostapd.
> 
> Looks fine, but
> 
> > @@ -2597,6 +2597,12 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
> >  	if (info->attrs[NL80211_ATTR_BSS_HT_OPMODE])
> >  		params.ht_opmode =
> >  			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_OPMODE]);
> > +	if (info->attrs[NL80211_ATTR_BSS_HT_CAPAB])
> > +		params.ht_capab =
> > +			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_CAPAB]);
> > +	if (info->attrs[NL80211_ATTR_BSS_HT_PARAM])
> > +		params.ht_param =
> > +			nla_get_u8(info->attrs[NL80211_ATTR_BSS_HT_PARAM]);
> >  
> >  	if (!rdev->ops->change_bss)
> >  		return -EOPNOTSUPP;
> 
> This appears to be missing a -1 initialisation?

Will fix.

Sujith
