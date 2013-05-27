Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21910 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3E0POl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 11:14:41 -0400
Date: Mon, 27 May 2013 18:14:36 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Allow TDLS peer AID to be configured for VHT
Message-ID: <20130527151436.GB12369@jouni.qca.qualcomm.com> (sfid-20130527_171447_166080_743251CE)
References: <20130516171108.GA27497@jouni.qca.qualcomm.com>
 <1369427943.13623.8.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1369427943.13623.8.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 24, 2013 at 10:39:03PM +0200, Johannes Berg wrote:
> On Thu, 2013-05-16 at 20:11 +0300, Jouni Malinen wrote:
> 
> > -	if (!info->attrs[NL80211_ATTR_STA_AID])
> > +	if (!info->attrs[NL80211_ATTR_STA_AID] &&
> > +	    !info->attrs[NL80211_ATTR_PEER_AID])
> >  		return -EINVAL;
> 
> Technically here I think you could check that this attribute isn't used
> with non-TDLS stations, since in new_station you know what it's going to
> be, right?

Well, in this function yes, but not this early.. I'll add validation for
this within the iftype switch.

> > @@ -3985,7 +3989,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
> > -	params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
> > +	if (info->attrs[NL80211_ATTR_STA_AID])
> > +		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
> > +	else
> > +		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_PEER_AID]);
> 
> This is a bit strange? Wouldn't you want to prefer the new attribute, so
> you can put some possibly invalid value into the old attribute for old
> kernels? Otherwise what's the reason for even reading the new attribute
> in this code at all, if new userspace code must set the old attribute
> for old kernels anyway?

This was something to allow the new attribute to be taken into use if we
ever get rid of the extra dummy STA for TDLS. I'd assume this ends up
having to get a new capability flag, so wpa_supplicant could figure out
which attribute to use. Anyway, I agree it makes more sense to reverse
the order here to prefer _PEER_AID.

-- 
Jouni Malinen                                            PGP id EFC895FA
