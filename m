Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:20727 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYBIAfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 19:35:42 -0500
Received: by wa-out-1112.google.com with SMTP id v27so734034wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 16:35:41 -0800 (PST)
Subject: Re: [PATCH 07/13] o11s: support for mesh interfaces in mac80211
	data path
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202345620.9965.80.camel@johannes.berg>
References: <47a78281.03b48c0a.7362.5d39@mx.google.com>
	 (sfid-20080204_212421_865811_21908028)  <1202345620.9965.80.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 16:36:47 -0800
Message-Id: <1202517407.7025.32.camel@localhost> (sfid-20080209_003557_235107_BEBE6BA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-07 at 01:53 +0100, Johannes Berg wrote:
> > +		if (!is_estab_plink(hdr->addr2, rx->dev)) {
> 
> This would get to be something like
> 
> 		if (sta->flags & STA_FLAG_MESH_LINK_ESTABLISHED)
> 
> right?

I probably can use just the AUTHORIZED flag.

> I suppose you should be adding sta_info structs for each mesh peer and
> set the AUTHORIZED flag on them. Is this what you were referring to in
> the patch description?

Right, and adding a pointer to a reduced mesh peer link structure with
variables only needed for mesh (it would only be allocated for mesh
interfaces).

> type == ETH_P_PAE &&
> > +	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT &&
> > +	    (!is_multicast_ether_addr(hdr.addr1) &&
> > +		      !(sta_flags & WLAN_STA_AUTHORIZED) &&
> > +		      !(ethertype == ETH_P_PAE &&
> >  		       compare_ether_addr(dev->dev_addr,
> >  					  skb->data + ETH_ALEN) == 0))) {
> 
> That's also an artifact of not adding sta info structs, right?

Indeed, will be gone in the next round.

Btw, I will also fix all the issues I'm not commenting on in this patch
and the others. Thanks for you patience with me!

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


