Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:42901 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZKNCG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 21:06:58 -0500
Received: by iwn8 with SMTP id 8so3103498iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 18:07:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AFDFF08.9000101@openwrt.org>
References: <4AFDFE41.9000003@openwrt.org> <4AFDFF08.9000101@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 13 Nov 2009 18:06:44 -0800
Message-ID: <43e72e890911131806v7824165vdee666198fd30d30@mail.gmail.com>
Subject: Re: [RFC 2/2] ath9k: get rid of tx_info_priv
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 13, 2009 at 4:51 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> This patch removes the need for separately allocated private tx info
> data in ath9k and brings the driver one small step closer to using the
> mac80211 rate control API properly.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks for doing this! Comments below.

> @@ -1301,23 +1298,30 @@ static void ath_tx_status(void *priv, st

< ... >

>        hdr = (struct ieee80211_hdr *)skb->data;
>        fc = hdr->frame_control;
> -       tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
> -       final_ts_idx = tx_info_priv->tx.ts_rateindex;
> +       for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
> +               struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
> +               if (!rate->count)
> +                       break;
> +
> +               final_ts_idx = i;
> +               long_retry = rate->count - 1;
> +       }
>

This seems to be the only trade off, doing a loop on tx complete but I
think I'm willing to trade that for the kmalloc()/kfree() removal.

Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
