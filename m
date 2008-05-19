Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:19706 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbYESRCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 13:02:51 -0400
Received: by rn-out-0910.google.com with SMTP id e11so477660rng.17
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2008 10:02:50 -0700 (PDT)
Message-ID: <1ba2fa240805191002mc77db60q6736104923179cef@mail.gmail.com> (sfid-20080519_190314_357814_302F9D67)
Date: Mon, 19 May 2008 20:02:49 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Helmut Schaa" <hschaa@suse.de>
Subject: Re: [PATCHv4] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "John Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200805191659.43961.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200805191659.43961.hschaa@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2008 at 5:59 PM, Helmut Schaa <hschaa@suse.de> wrote:
> Fix a possible NULL pointer dereference in ieee80211_compatible_rates
> introduced in the patch "mac80211: fix association with some APs". If no bss
> is available just use all supported rates in the association request.
>
> Signed-off-by: Helmut Schaa <hschaa@suse.de>
> ---
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 76ad4ed..7aff784 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -722,6 +722,15 @@ static void ieee80211_send_assoc(struct net_device *dev,
>                if (bss->wmm_ie)
>                        wmm = 1;
>                ieee80211_rx_bss_put(dev, bss);
> +
> +               /* get all rates supported by the device and the AP as
> +                * some APs don't like getting a superset of their rates
> +                * in the association request (e.g. D-Link DAP 1353 in
> +                * b-only mode) */
> +               rates_len = ieee80211_compatible_rates(bss, sband, &rates);

Shuldn' t this call ieee80211_rx_bss_put(dev, bss);  after calling
ieee80211_compatible_rates()


> +       } else {
> +               rates = ~0;
> +               rates_len = sband->n_bitrates;
>        }
>
>        mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
> @@ -752,10 +761,7 @@ static void ieee80211_send_assoc(struct net_device *dev,
>        *pos++ = ifsta->ssid_len;
>        memcpy(pos, ifsta->ssid, ifsta->ssid_len);
>
> -       /* all supported rates should be added here but some APs
> -        * (e.g. D-Link DAP 1353 in b-only mode) don't like that
> -        * Therefore only add rates the AP supports */
> -       rates_len = ieee80211_compatible_rates(bss, sband, &rates);
> +       /* add all rates which were marked to be used above */
>        supp_rates_len = rates_len;
>        if (supp_rates_len > 8)
>                supp_rates_len = 8;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
