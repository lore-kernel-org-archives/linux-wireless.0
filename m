Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0072AC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C506B21B24
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:40:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p4uHCVB6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfBKNke (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 08:40:34 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:55694 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbfBKNkd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 08:40:33 -0500
Received: by mail-it1-f194.google.com with SMTP id f18so15259516itb.5;
        Mon, 11 Feb 2019 05:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q1uKVdY+cO0rOE73T/6bXXPdmXo2uSurICeVpjRQCt0=;
        b=p4uHCVB619mYSO0YS3TUuH+WqdvCiknzowNTOgnMaWzJnzmQTZiAFoHuHsdBBCRllF
         rF6emCj/sBKoRwn//fRk5eMmcUHTuE2LnH8a1mwun42M5yKR72GyHOcVO8Xwsk4q73iN
         lzHcStlVn56HnyPu8p6/WWHCX5UU/3wphHNskT55anWo5w70UAQ4XNt4wWAvtxDWhlSA
         1/MoC0I4fcEFaQRVV4rl97E3rDa0q9Y174lVZsA/vld1cnSBNzzQygUcFNgDYw0cf1lQ
         P6x358s8Cz4cGwUQSyqscN5m4E7gY/5xDMu3b9+I3V8jgJ5AWwpcwFbrvZL279w+l2AV
         bBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q1uKVdY+cO0rOE73T/6bXXPdmXo2uSurICeVpjRQCt0=;
        b=XhBoTxqf+Ch92sRQUF5VrVpOJNqKMpMvAV9ANAHvtaG2wJEioQ7DV8vyeN39xoPSjr
         GVb9QBRFDR8l/eQfK2h2m9g+tTzEfUkp/4rTTmascOxDVHwaP295raVSzAEgFdO1Ebhs
         7RkLaXkIEHFa4bfQVMqetydTbwJttOZyvpHTQycxpHUfaVh1p2jmCT8kuF4jfDH03s95
         jxrnhbXzn8eG6e6+PI4Krc/TcmrZMQWcianNlYCFqroS/rAdB5RBIHHwTVVhL9JJLUgf
         rwYWuiJbloj6uLaxq8NCiGPR9v+PAax473uQncE40HoWOkvxMNGhhsb2qjvBuKw2NGbZ
         hHug==
X-Gm-Message-State: AHQUAuYqgiQOyq/HuXfNozrQaRirtyka1gzr3SlDZfkGbQTNH85LAVov
        bZAHHM6KOuUwF0KzWfvf1xpqpnSeSSPaGt9Pw4w=
X-Google-Smtp-Source: AHgI3IaSgYPwWoVqaMshGskb6Bq0xW8dhwWF6z/7jFT1BRG117UguhMfVjlG0VLzXm5mPK+GUWV0nWG+5xEjSYeSgc8=
X-Received: by 2002:a5d:8545:: with SMTP id b5mr10352899ios.288.1549892432394;
 Mon, 11 Feb 2019 05:40:32 -0800 (PST)
MIME-Version: 1.0
References: <20190210194822.18539-1-lkundrak@v3.sk>
In-Reply-To: <20190210194822.18539-1-lkundrak@v3.sk>
From:   Steve deRosier <derosier@gmail.com>
Date:   Mon, 11 Feb 2019 05:39:55 -0800
Message-ID: <CALLGbRJCH5-ASTi19SdjMP3a2AO1wDmf1z=kGDeLRR0_NRxfQg@mail.gmail.com>
Subject: Re: [PATCH] libertas_tf: fix signal reporting
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Feb 10, 2019 at 11:48 AM Lubomir Rintel <lkundrak@v3.sk> wrote:
>
> Instead of exposing the signal-to-noise ration, calculate the actual signal
> level taking the noise floor into account.
>
> Also, flip the SIGNAL_DBM bit on, so that mac80211 exposes the signal
> level along with the station info in scan results. This fills
> NetworkManager's "nmcli d wifi output" output with colors, bars and joy.
>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/net/wireless/marvell/libertas_tf/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
> index c71ad87cdc44..f93b400db949 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/main.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/main.c
> @@ -562,7 +562,7 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
>                 stats.flag |= RX_FLAG_FAILED_FCS_CRC;
>         stats.freq = priv->cur_freq;
>         stats.band = NL80211_BAND_2GHZ;
> -       stats.signal = prxpd->snr;
> +       stats.signal = prxpd->snr - prxpd->nf;
>         priv->noise = prxpd->nf;
>         /* Marvell rate index has a hole at value 4 */
>         if (prxpd->rx_rate > 4)
> @@ -626,6 +626,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
>
>         hw->queues = 1;
>         ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
> +       ieee80211_hw_set(hw, SIGNAL_DBM);
>         hw->extra_tx_headroom = sizeof(struct txpd);
>         memcpy(priv->channels, lbtf_channels, sizeof(lbtf_channels));
>         memcpy(priv->rates, lbtf_rates, sizeof(lbtf_rates));
> --
> 2.20.1
>

Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
