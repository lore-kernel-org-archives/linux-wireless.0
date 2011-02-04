Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab1BDKbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 05:31:35 -0500
Subject: Re: [PATCH 2/2] mac80211: Fix a race on enabling power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1296800640-6381-2-git-send-email-vnatarajan@atheros.com>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
	 <1296800640-6381-2-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 11:31:30 +0100
Message-ID: <1296815490.3671.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-04 at 11:54 +0530, Vivek Natarajan wrote:

> @@ -1648,6 +1649,11 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
>  				return;
>  			}
>  
> +	ifmgd = &sdata->u.mgd;
> +	if (!(ieee80211_is_nullfunc(hdr->frame_control)) &&
> +	    (ifmgd->flags & IEEE80211_STA_PS_PENDING))
> +		ifmgd->flags &= ~IEEE80211_STA_PS_PENDING;
> +

Without even trying to understand the logic of the patch, this is
clearly broken since it assumes that all interfaces are of managed type.

johannes

