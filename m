Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:34682 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYERKhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2008 06:37:24 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1265788waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 18 May 2008 03:37:23 -0700 (PDT)
Message-ID: <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com> (sfid-20080518_123737_265651_206263C2)
Date: Sun, 18 May 2008 13:37:23 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Helmut Schaa" <hschaa@suse.de>
Subject: Re: [PATCHv2] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "John Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080517203531.vus3gj5ce8ksskkc@imap.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080517203531.vus3gj5ce8ksskkc@imap.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 17, 2008 at 9:35 PM, Helmut Schaa <hschaa@suse.de> wrote:
> Fix a possible NULL pointer dereference in ieee80211_compatible_rates
> introduced in the patch "mac80211: fix association with some APs".
>
> Signed-off-by: Helmut Schaa <hschaa@suse.de>
> ---
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 76ad4ed..2642551 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -664,15 +664,22 @@ static int ieee80211_compatible_rates(struct
> ieee80211_sta_bss *bss,
>        int i, j, count;
>        *rates = 0;
>        count = 0;
> -       for (i = 0; i < bss->supp_rates_len; i++) {
> -               int rate = (bss->supp_rates[i] & 0x7F) * 5;
>
> -               for (j = 0; j < sband->n_bitrates; j++)
> -                       if (sband->bitrates[j].bitrate == rate) {
> -                               *rates |= BIT(j);
> -                               count++;
> -                               break;
> -                       }
> +       if (bss) {
> +               for (i = 0; i < bss->supp_rates_len; i++) {
> +                       int rate = (bss->supp_rates[i] & 0x7F) * 5;
> +
> +                       for (j = 0; j < sband->n_bitrates; j++)
> +                               if (sband->bitrates[j].bitrate == rate) {
> +                                       *rates |= BIT(j);
> +                                       count++;
> +                                       break;
> +                               }
> +               }
> +       } else {
> +               for (i = 0; i < sband->n_bitrates; i++)
> +                       *rates |= BIT(i);
> +               count = sband->n_bitrates;
>        }
>
>        return count;
>

Again, mac should rather solve the problem that we do not connect to
AP's that are not in the BSS list
Personally I would NACK this as it's just hiding  the real problem

The other issue is that we call ieee80211_rx_bss_put(dev, bss); before
this call in ieee80211_send_assoc.

Tomas
