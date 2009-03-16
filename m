Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36920 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757895AbZCPI6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 04:58:00 -0400
Date: Mon, 16 Mar 2009 10:57:41 +0200
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: don't drop null frames during software
	scan
Message-ID: <20090316085741.GA29986@jm.kir.nu> (sfid-20090316_095804_901192_38BEC3B2)
References: <20090315200738.17370.29374.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090315200738.17370.29374.stgit@tikku>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 15, 2009 at 10:07:39PM +0200, Kalle Valo wrote:
> ieee80211_tx_h_check_assoc() was dropping everything else than probe
> requests during software scan. So the null frame with the power save
> bit was dropped and AP never received it. This meant that AP never
> buffered any frames for the station during software scan.
> 
> Fix this by allowing to transmit both probe request and null frames
> during software scan. Tested with stlc45xx.

I would assume the nullfunc frames are sent only just before the scan
and just after the scan, not really "during" the scan. Or am I missing
something here?

> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -193,7 +193,14 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
>  		return TX_CONTINUE;
>  
>  	if (unlikely(tx->local->sw_scanning) &&
> -	    !ieee80211_is_probe_req(hdr->frame_control))
> +	    !ieee80211_is_probe_req(hdr->frame_control) &&
> +	    !ieee80211_is_nullfunc(hdr->frame_control))
> +		/*
> +		 * When software scanning only null frames (to notify the
> +		 * sleep state to the AP) and probe requests (for the
> +		 * active scan) are allowed, everything else should be
> +		 * dropped.
> +		 */
>  		return TX_DROP;

While this is probably the easiest way of fixing the issue you are
seeing, the more correct operation would be to allow nullfunc frames
only at the beginning and end of the scan operation, not during it,
i.e., there is no point allowing those frames to go out when we are not
on our operational channel. I would hope we do not currently send those
frames at such time, so this should not matter much, but the comment
could be made more clear about the different needs for nullfunc frames
(please also s/null frames/nullfunc frames/) and probe request frames.
The former are sent only on the operational channel in the beginning and
end of scan while the latter are sent on the channels to be scanned
during an active scan.

-- 
Jouni Malinen                                            PGP id EFC895FA
