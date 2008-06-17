Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:54565 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbYFQSLm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:11:42 -0400
Date: Tue, 17 Jun 2008 21:10:50 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] 802.11w: Use BIP (AES-128-CMAC)
Message-ID: <20080617181050.GD4974@jm.kir.nu> (sfid-20080617_201146_239530_112A50A1)
References: <20080617154008.883383150@localhost> <20080617155920.329586297@localhost> <1213722347.3803.89.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213722347.3803.89.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 17, 2008 at 07:05:47PM +0200, Johannes Berg wrote:

> > @@ -603,30 +605,38 @@ static int nl80211_set_key(struct sk_buf
> > -	if (key_idx > 3)
> > +	if (key_idx > 5)
> >  		return -EINVAL;

> > -	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT])
> > +	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT] &&
> > +	    !info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT])

> I think this should probably check the key index depending on the type,
> i.e. only permit 4 and 5 for mgmt and 0-3 for data keys.

Yes, I started doing that, but did not cover all places yet. It's
somewhat unclear to me where this type of validation should live, i.e.,
what piece of code should know that key indexes 4 and 5 are used for
IGTK at this point taken into account that the index could actually be
0..65535.. Anyway, it may be safer to do it here than to trust on other
places being able to handle odd indexes for data frame TX key index.

-- 
Jouni Malinen                                            PGP id EFC895FA
