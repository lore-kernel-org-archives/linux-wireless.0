Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:65432 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYLCAOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 19:14:32 -0500
Received: by rn-out-0910.google.com with SMTP id k40so2718723rnd.17
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 16:14:30 -0800 (PST)
Message-ID: <43e72e890812021614i103235few3a19721c6ca1d0cc@mail.gmail.com> (sfid-20081203_011445_943399_795D4F1C)
Date: Tue, 2 Dec 2008 16:14:30 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH] ath9k: Use GFP_ATOMIC when allocating private area
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com
In-Reply-To: <18741.12999.753996.233483@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18741.12999.753996.233483@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2008 at 5:06 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:

> --- a/drivers/net/wireless/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath9k/xmit.c
> @@ -1787,7 +1793,12 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
>                return -1;
>        }
>
> -       ath_tx_setup_buffer(sc, bf, skb, txctl);
> +       ret = ath_tx_setup_buffer(sc, bf, skb, txctl);
> +       if (ret) {
> +               DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
> +               return ret;

Hm, this doesn't add the bf back to the txq, so we'd run out of bf's
completely when on low memory, eventually leaving the list always
empty. I'll resend with that added and a few more changes.

  Luis
