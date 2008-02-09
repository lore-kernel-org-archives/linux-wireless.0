Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:55824 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668AbYBICQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 21:16:56 -0500
Received: by py-out-1112.google.com with SMTP id u52so5766183pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 18:16:55 -0800 (PST)
Subject: Re: [PATCH 07/13] o11s: support for mesh interfaces in mac80211
	data path
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202345620.9965.80.camel@johannes.berg>
References: <47a78281.03b48c0a.7362.5d39@mx.google.com>
	 (sfid-20080204_212421_865811_21908028)  <1202345620.9965.80.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 18:18:01 -0800
Message-Id: <1202523481.7025.76.camel@localhost> (sfid-20080209_021707_805635_50D9A27C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2008-02-07 at 01:53 +0100, Johannes Berg wrote:
> > +	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
> > +		if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) {
> > +			if (!((rx->fc & IEEE80211_FCTL_FROMDS) &&
> > +					(rx->fc & IEEE80211_FCTL_TODS)))
> 
> It'd be shorter to write
> 
> 	if (rx->fc ^ (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS))
> 
> but I'm not sure that's easier to understand ;)

Would that work? For data frames rx->fc is 0xYY08 (with YY being the
flags, including fromDS/toDS), so they would always evaluate to true in
that if, regardless of the flags.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


