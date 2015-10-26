Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.43]:45115 "EHLO
	gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbbJZK0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 06:26:11 -0400
Received: from ham07.websitewelcome.com (unknown [192.185.81.79])
	by gateway21.websitewelcome.com (Postfix) with ESMTP id 7B5BBE6DBFAF4
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 05:05:12 -0500 (CDT)
Received: from br538.hostgator.com.br (br538.hostgator.com.br [108.179.252.175])
	by ham07.websitewelcome.com (Postfix) with ESMTP id ED07D660003
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 05:05:11 -0500 (CDT)
Received: from [209.85.220.179] (port=33539 helo=mail-qk0-f179.google.com)
	by br538.hostgator.com.br with esmtpsa (TLSv1.2:AES128-GCM-SHA256:128)
	(Exim 4.85)
	(envelope-from <bino@bino.us>)
	id 1ZqeeN-0005tp-RA
	for linux-wireless@vger.kernel.org; Mon, 26 Oct 2015 05:05:11 -0500
Received: by qkcy65 with SMTP id y65so106468323qkc.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 03:05:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1445851330-18736-1-git-send-email-manikanta.pubbisetty@gmail.com>
References: <1445851330-18736-1-git-send-email-manikanta.pubbisetty@gmail.com>
Date: Mon, 26 Oct 2015 08:05:11 -0200
Message-ID: <CAMu38xLre1jS7Vjsc3sL80oTkVhg5YQJV-U-CXeEQo8k2Zqp-A@mail.gmail.com> (sfid-20151026_112614_680357_66E22F85)
Subject: Re: [PATCH] ath10k: update antenna configuration after setting in fw
From: Albino B Neto <bino@bino.us>
To: manikanta.pubbisetty@gmail.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-10-26 7:22 GMT-02:00  <manikanta.pubbisetty@gmail.com>:
> Signed-off-by: Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 484c1a1..8d0ce37 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3771,9 +3771,6 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
>         ath10k_check_chain_mask(ar, tx_ant, "tx");
>         ath10k_check_chain_mask(ar, rx_ant, "rx");
>
> -       ar->cfg_tx_chainmask = tx_ant;
> -       ar->cfg_rx_chainmask = rx_ant;
> -
>         if ((ar->state != ATH10K_STATE_ON) &&
>             (ar->state != ATH10K_STATE_RESTARTED))
>                 return 0;
> @@ -3794,6 +3791,9 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
>                 return ret;
>         }
>
> +       ar->cfg_tx_chainmask = tx_ant;
> +       ar->cfg_rx_chainmask = rx_ant;
> +
>         return 0;
>  }

Sorry, I see no change in the code. script checkpatch.pl ?

    Albino
