Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1KHIPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 03:15:04 -0500
Subject: Re: [PATCH v6 1/2] wireless:  Support ht-capabilities over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320707676-17255-1-git-send-email-greearb@candelatech.com> (sfid-20111108_001449_233997_95FF19FA)
References: <1320707676-17255-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_001449_233997_95FF19FA)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 09:14:59 +0100
Message-ID: <1320740099.4304.5.camel@jlt3.sipsolutions.net> (sfid-20111108_091508_632709_596EAD03)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 15:14 -0800, greearb@candelatech.com wrote:

> +++ b/net/wireless/mlme.c
> @@ -501,13 +501,32 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
>  	return err;
>  }
>  
> +/*  Do a logical ht_capa &= ht_capa_mask.  */
> +static void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
> +			const struct ieee80211_ht_cap *ht_capa_mask)
> +{
> +	int i;
> +	u8 *p1, *p2;
> +	if (!ht_capa_mask) {
> +		memset(ht_capa, 0, sizeof(*ht_capa));
> +		return;
> +	}
> +
> +	p1 = (u8*)(ht_capa);
> +	p2 = (u8*)(ht_capa_mask);
> +	for (i = 0; i<sizeof(*ht_capa); i++)
> +		p1[i] &= p2[i];
> +}

I think you also need to call this in the cfg80211_connect() path.

Also, maybe we should reject this configuration if the device didn't
support it at all, ie. ht_capa_mask was NULL? It also seems a bit odd to
allow this on a device that doesn't even support HT.

Also how would you feel about rejecting, instead of silently ignoring,
things that we do look at but don't support, e.g. a wrong A-MSDU
setting? Alternatively, cfg80211 could modify the settings in a way that
drivers don't have to worry about the "downgrade only" part.

Finally, I think we need a tad more documentation about how this is
supposed to work in case somebody wants to implement it on non-mac80211.
The way it's done right now it seems fairly error prone, with all
restrictions that the driver needs to implement like not allowing the
a-MSDU size to be increased.

johannes

