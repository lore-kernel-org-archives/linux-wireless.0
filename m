Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1DKNjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 09:39:35 -0400
Subject: Re: [RFC] mac80211: consolidate MIC failure report handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201104091234.27305.chunkeey@googlemail.com>
References: <201104091234.27305.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 15:39:33 +0200
Message-ID: <1302529173.6487.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-04-09 at 12:34 +0200, Christian Lamparter wrote:
> Currently, mac80211 handles MIC failures differently
> depending on whenever they are detected by the stack's
> own software crypto or when are handed down from the
> driver.
> 
> This patch tries to unify both by moving the special
> "driver" branch out of mac80211 rx hotpath and into
> into the software crypto part. This has also the
> advantage that we can run a few more sanity checks
> on the data and verify of example that the key type
> was indeed TKIP.

In principle that seems fine with me.

> BTW: why does the "driver" path check for _auth frames?

I have no idea, seems pointless.

> diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
> index f1765de..a2c18b6 100644
> --- a/net/mac80211/wpa.c
> +++ b/net/mac80211/wpa.c
> @@ -87,33 +87,35 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
>  	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>  
> +	if (!ieee80211_has_protected(hdr->frame_control) ||
> +	    !ieee80211_is_data_present(hdr->frame_control)) {
> +		return RX_CONTINUE;
> +	}

No braces necessary. But is this check correct? What if the driver
_completely_ pretends that the frame wasn't encrypted? Do we strictly
require that it leaves the protected bit set?

johannes

