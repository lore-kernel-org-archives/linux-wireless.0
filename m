Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f51.google.com ([209.85.216.51]:43439 "EHLO
	mail-vn0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbbDNWpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 18:45:39 -0400
Received: by vnbg7 with SMTP id g7so9212815vnb.10
        for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2015 15:45:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1428911141-6534-2-git-send-email-janusz.dziedzic@tieto.com>
References: <1428911141-6534-1-git-send-email-janusz.dziedzic@tieto.com>
	<1428911141-6534-2-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 14 Apr 2015 15:45:38 -0700
Message-ID: <CAFuUQkhQeCwP098DH7_R4mNCvrJ7WxdT7wnHi52DSOKm8c0k1Q@mail.gmail.com> (sfid-20150415_004545_624168_B64415F5)
Subject: Re: [RFC 2/2] ath10k: don't disable PS when not connected
From: YanBo <dreamfly281@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2015 at 12:45 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Don't disable PS while we are not connected.
> In other case we will get higher power consumption.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 52c5b1f..b896dd4 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -1730,7 +1730,13 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
>                 enable_ps = false;
>         }
>
> -       if (enable_ps) {
> +       if (!arvif->is_started) {
> +               /* enable power save mode while not connected,
> +                * in other case after iface up we will get
> +                * higher power consumption - firmware design
> +                */
> +               psmode = WMI_STA_PS_MODE_ENABLED;
> +       } else if (enable_ps) {
>                 psmode = WMI_STA_PS_MODE_ENABLED;
>                 param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
>
> --

What the expectation behavior after we enable the
WMI_STA_PS_MODE_ENABLED at Idle status?
Is there any effect for TX or RX chain after set it?

BR /Yanbo
