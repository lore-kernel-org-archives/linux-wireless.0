Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab1KDQsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 12:48:54 -0400
Subject: Re: [PATCH v3] cfg80211: merge in beacon ies of hidden bss.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYhbX+zKRw823RmPzwXqVzP7c+5W8pAaR4DGsOm0qnZGpA@mail.gmail.com> (sfid-20111104_171212_230697_F4323BFB)
References: <CAMG6FYhbX+zKRw823RmPzwXqVzP7c+5W8pAaR4DGsOm0qnZGpA@mail.gmail.com>
	 (sfid-20111104_171212_230697_F4323BFB)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 17:48:50 +0100
Message-ID: <1320425330.3969.115.camel@jlt3.sipsolutions.net> (sfid-20111104_174857_877054_38C92B1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 17:12 +0100, Dmitry Tarnyagin wrote:
> The problem with PSM when a hidden SSID was used was originally
> reported by Juuso Oikarinen.
> 
>  - When generally scanning, the AP is getting a bss entry with
>    a zero SSID.

And maybe one with the probe reply too, if you do a scan with the SSID,
but anyway.

>  - When associationg, a probe-req is sent to the AP with the SSID,

associating :-)

>    and as a result a probe-responseis received with the hidden

probe-response is

>    SSID in place. As a consequence, a second bss entry is created
>    for the AP, now with the real SSID.
>  - After association, mac80211 executes ieee80211_recalc_ps(),
>    but does not switch to powersave because the beacon-ies are missing.
> 
> As result, the STA does not ever enter PSM.
> 
> The patch merges in beacon ies of hidden bss from beacon to the probe
> response, creating a consistant set of ies in place.

consistent

> Patch is depended on "cfg80211: fix cmp_ies" made by Johannes.

Thanks. This looks fine to me.

> +	/* sort by length first, then by contents */
> +	if (ie1[1] != ie2[1])
> +		return ie2[1] - ie1[1];
> +
> +	/* zeroed SSID ie is another indication of a hidden bss */
> +	for (i = 0; i < ie2[1]; i++)
> +		if (ie2[i + 2])
> +			return -1;

The "return -1" here seems to be correct, but tricky -- maybe it
warrants a comment?

(I'm also thinking that maybe hashing the SSID into the tree was a bad
idea?)


One thing just occurred to me: This patch doesn't make the problem go
away, it just makes it less likely. Consider this: you ask to connect to
an AP with hidden SSID without scanning first. The scan for this AP
happens so quickly that you don't receive a beacon at all, you only
receive a probe response because the scan falls between two beacons.

In that case, the BSS entry will never be updated to get beacon IEs, so
you will still never enter powersave, because the beacon IEs weren't
present when the BSS entry was created.

You can probably reproduce that case easily by using a large beacon
interval, say 1 second.

To fix this, we need to address the TODO item.

johannes

