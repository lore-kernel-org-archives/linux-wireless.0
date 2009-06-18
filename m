Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:44555 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZFRXjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 19:39:11 -0400
Received: by gxk10 with SMTP id 10so2296899gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 16:39:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245363695-8289-3-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
	<1245363695-8289-3-git-send-email-kilroyd@googlemail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 19 Jun 2009 09:38:53 +1000
Message-ID: <646765f40906181638j39d8e8eex8ead9d856b5f2548@mail.gmail.com>
Subject: Re: [PATCH 02/23] cfg80211: Advertise ciphers via WE according to
	driver capability
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 08:21, David Kilroy<kilroyd@googlemail.com> wrote:
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/wireless/wext-compat.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
> index 9e56f35..7dbe6c6 100644
> --- a/net/wireless/wext-compat.c
> +++ b/net/wireless/wext-compat.c
> @@ -204,8 +204,19 @@ int cfg80211_wext_giwrange(struct net_device *dev,
>        range->avg_qual.noise = range->max_qual.noise / 2;
>        range->avg_qual.updated = range->max_qual.updated;
>
> -       range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
> -                         IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
> +       range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2;

Should this should go into the for loop too, like how patch 5 works?

> +       for (c = 0; c < wdev->wiphy->n_cipher_suites; c++) {
> +               switch (wdev->wiphy->cipher_suites[c]) {
> +               case WLAN_CIPHER_SUITE_TKIP:
> +                       range->enc_capa |= IW_ENC_CAPA_CIPHER_TKIP;
> +                       break;
> +
> +               case WLAN_CIPHER_SUITE_CCMP:
> +                       range->enc_capa |= IW_ENC_CAPA_CIPHER_CCMP;
> +                       break;
> +               }
> +       }
>
>        for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
>                int i;

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
