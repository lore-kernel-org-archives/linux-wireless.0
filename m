Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab1KGJGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 04:06:20 -0500
Subject: Re: [PATCH v4 1/2] wireless:  Support ht-capabilities over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320437440-6463-1-git-send-email-greearb@candelatech.com> (sfid-20111104_211056_032573_0C709B20)
References: <1320437440-6463-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111104_211056_032573_0C709B20)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 10:06:16 +0100
Message-ID: <1320656776.3993.21.camel@jlt3.sipsolutions.net> (sfid-20111107_100625_216025_23A117B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 13:10 -0700, greearb@candelatech.com wrote:

> + * @NL80211_ATTR_DISABLE_HT:  Force HT capable interfaces to disable
> + *      this feature.

I can see this, but

> + * @NL80211_ATTR_DISABLE_HT40:  Disable HT-40 even if AP and hardware
> + *      support it.
> + * @NL80211_ATTR_HT_CAPABILITY_MASK: Specify which bits of the HT_CAPs
> + *      to pay attention to.

if you have the mask why do you still need the HT40? Isn't HT40 a flag
in the mask? Or do you want this to affect TX/RX separately? You should
spell that out more explicitly then.

> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -704,6 +704,9 @@ void wiphy_unregister(struct wiphy *wiphy)
>  	flush_work(&rdev->scan_done_wk);
>  	cancel_work_sync(&rdev->conn_work);
>  	flush_work(&rdev->event_work);
> +
> +	kfree(rdev->wiphy.ht_capa_mod_mask);
> +	rdev->wiphy.ht_capa_mod_mask = NULL;

That doesn't seem right -- drivers should typically assign a static
const variable to this pointer that can't be freed.

> @@ -537,6 +539,12 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
>  	memcpy(&req.crypto, crypt, sizeof(req.crypto));
>  	req.use_mfp = use_mfp;
>  	req.prev_bssid = prev_bssid;
> +	req.flags = assoc_flags;
> +	if (ht_capa)
> +		memcpy(&req.ht_capa, ht_capa, sizeof(req.ht_capa));
> +	if (ht_capa_mask)
> +		memcpy(&req.ht_capa_mask, ht_capa_mask,
> +		       sizeof(req.ht_capa_mask));

I think somewhere here you should mask this mask with the
ht_capa_mod_mask. That way, you force drivers to advertise a correct
ht_capa_mod_mask, if you don't do that we will certainly see drivers use
more of ht_capa than contained in ht_capa_mod_mask. Probably should be a
helper function since I think you might need it in more places.

johannes

