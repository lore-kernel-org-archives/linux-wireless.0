Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1K3Sbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 13:31:31 -0500
Subject: Re: [PATCH] mac80211: fill rate filter for internal scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	stable@vger.kernel.org
In-Reply-To: <1322668590-18801-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1322668590-18801-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 19:31:23 +0100
Message-ID: <1322677883.3970.0.camel@jlt3.sipsolutions.net> (sfid-20111130_193134_214506_88A07798)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-30 at 16:56 +0100, Simon Wunderlich wrote:
> The rates bitmap for internal scan requests shoud be filled,
> otherwise there will be probe requests with zero rates supported.
> 
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

Cc: stable@vger.kernel.org
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/main.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index dddedfa..3e15f75 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -779,6 +779,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  	if (!local->int_scan_req)
>  		return -ENOMEM;
>  
> +	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> +		if (!local->hw.wiphy->bands[band])
> +			continue;
> +		local->int_scan_req->rates[band] = (u32) -1;
> +	}
> +
>  	/* if low-level driver supports AP, we also support VLAN */
>  	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
>  		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);


