Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47459 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756371Ab2FTOYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 10:24:39 -0400
Received: by eaak11 with SMTP id k11so2653054eaa.33
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 07:24:37 -0700 (PDT)
Message-ID: <1340202275.1631.232.camel@cumari.coelho.fi> (sfid-20120620_162443_002790_01EAFDCF)
Subject: Re: [PATCH] mac80211: use the correct capability info in
 ieee80211_set_associated()
From: Luciano Coelho <coelho@ti.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 17:24:35 +0300
In-Reply-To: <1340202204-20536-1-git-send-email-coelho@ti.com>
References: <1340202204-20536-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, I mistyped Johannes' address.  Now fixed.

On Wed, 2012-06-20 at 17:23 +0300, Luciano Coelho wrote:
> If an AP is beaconing with different capabilities than the one we get
> in the associate response, we were still using the capabilities
> received in the beacons.  One example is when the AP is beaconing with
> the short slot bit set to zero and then we try to connect to it with
> long slot.  In this case, we would keep using long slot until the next
> beacon was received.
> 
> Fix this by using the correct capability value when calling
> ieee80211_handle_bss_capability().  We were using cbss->capability,
> but we should use the bss_conf->assoc_capability instead.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  net/mac80211/mlme.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 9caecd4..ffa0b19 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1323,7 +1323,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
>  
>  	bss_info_changed |= BSS_CHANGED_BEACON_INT;
>  	bss_info_changed |= ieee80211_handle_bss_capability(sdata,
> -		cbss->capability, bss->has_erp_value, bss->erp_value);
> +		bss_conf->assoc_capability, bss->has_erp_value, bss->erp_value);
>  
>  	sdata->u.mgd.beacon_timeout = usecs_to_jiffies(ieee80211_tu_to_usec(
>  		IEEE80211_BEACON_LOSS_COUNT * bss_conf->beacon_int));


