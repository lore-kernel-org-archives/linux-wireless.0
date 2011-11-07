Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab1KGRm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 12:42:56 -0500
Subject: Re: [PATCH v4 1/2] wireless:  Support ht-capabilities over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB81817.9060300@candelatech.com>
References: <1320437440-6463-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111104_211056_032573_0C709B20) <1320656776.3993.21.camel@jlt3.sipsolutions.net>
	 <4EB81817.9060300@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 18:42:53 +0100
Message-ID: <1320687773.3993.53.camel@jlt3.sipsolutions.net> (sfid-20111107_184300_314396_05D68574)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 09:40 -0800, Ben Greear wrote:
> On 11/07/2011 01:06 AM, Johannes Berg wrote:
> 
> >> @@ -537,6 +539,12 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
> >>   	memcpy(&req.crypto, crypt, sizeof(req.crypto));
> >>   	req.use_mfp = use_mfp;
> >>   	req.prev_bssid = prev_bssid;
> >> +	req.flags = assoc_flags;
> >> +	if (ht_capa)
> >> +		memcpy(&req.ht_capa, ht_capa, sizeof(req.ht_capa));
> >> +	if (ht_capa_mask)
> >> +		memcpy(&req.ht_capa_mask, ht_capa_mask,
> >> +		       sizeof(req.ht_capa_mask));
> >
> > I think somewhere here you should mask this mask with the
> > ht_capa_mod_mask. That way, you force drivers to advertise a correct
> > ht_capa_mod_mask, if you don't do that we will certainly see drivers use
> > more of ht_capa than contained in ht_capa_mod_mask. Probably should be a
> > helper function since I think you might need it in more places.
> 
> This goes back to how hard we want to be on user-space.  If we are lax,
> and just ignore settings that are not (yet?) supported by the kernel,
> then user-space becomes much easier to make backwards/forwards
> compat.  That is my preferred approach.

No, not really -- I'm not saying reject it, I'm just saying don't let
userspace configure more than the driver said it could configure. if you
just do essentially "configured_masked &= advertised_mask" you still
keep this property you want, but you force drivers to advertise
everything users will be able to change otherwise it just doesn't take
effect.

johannes

