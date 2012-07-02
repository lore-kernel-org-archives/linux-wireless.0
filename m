Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2GBMCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 08:02:46 -0400
Message-ID: <1341230562.19642.1.camel@jlt3.sipsolutions.net> (sfid-20120702_140250_006253_D43D496B)
Subject: Re: [PATCH] mac80211: destroy assoc_data correctly if assoc fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Jul 2012 14:02:42 +0200
In-Reply-To: <1341229323-6551-1-git-send-email-eliad@wizery.com> (sfid-20120702_134155_561570_09338B27)
References: <1341229323-6551-1-git-send-email-eliad@wizery.com>
	 (sfid-20120702_134155_561570_09338B27)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-02 at 14:42 +0300, Eliad Peller wrote:
> If association failed due to internal error (e.g. no
> supported rates IE), we call ieee80211_destroy_assoc_data()
> with assoc=true, while we actually reject the association.
> 
> This results in the BSSID not being zeroed out.
> 
> After passing assoc=false, we no longer have to call
> sta_info_destroy_addr() explicitly. While on it, move
> the "associated" message after the assoc_success check.
> 
> Cc: stable@vger.kernel.org [3.4+]
> Signed-off-by: Eliad Peller <eliad@wizery.com>

Yes, good catch

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

John, can you pick this up for 3.5?

Thanks!

johannes

> ---
>  net/mac80211/mlme.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index a91c888..a2c48ff 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2174,15 +2174,13 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
>  			   mgmt->sa, status_code);
>  		ieee80211_destroy_assoc_data(sdata, false);
>  	} else {
> -		sdata_info(sdata, "associated\n");
> -
>  		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
>  			/* oops -- internal error -- send timeout for now */
> -			ieee80211_destroy_assoc_data(sdata, true);
> -			sta_info_destroy_addr(sdata, mgmt->bssid);
> +			ieee80211_destroy_assoc_data(sdata, false);
>  			cfg80211_put_bss(*bss);
>  			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
>  		}
> +		sdata_info(sdata, "associated\n");
>  
>  		/*
>  		 * destroy assoc_data afterwards, as otherwise an idle


