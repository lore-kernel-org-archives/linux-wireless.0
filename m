Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22669 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756102AbdGSSl3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 14:41:29 -0400
From: Ryan Hsu <ryanhsu@qti.qualcomm.com>
To: Gabriel Craciunescu <nix.or.die@gmail.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        "joe@perches.com" <joe@perches.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] ath10k_htt_rx_amsdu_allowed(): use ath10k_dbg()
Date: Wed, 19 Jul 2017 18:41:27 +0000
Message-ID: <e41a39fd-87a1-7fc7-158d-cb298e46a754@qca.qualcomm.com> (sfid-20170719_204210_832230_652C3A0A)
References: <1500481605.25934.40.camel@perches.com>
 <20170719182454.11267-1-crazy@frugalware.org>
In-Reply-To: <20170719182454.11267-1-crazy@frugalware.org>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2017 11:24 AM, Gabriel Craciunescu wrote:

To make it consistent, maybe rename the patch title starting with ath10k:

> From: Gabriel Craciunescu <nix.or.die@gmail.com>
>
> 	Each time we get disconencted from AP we get flooded with messages like:
>
> 	...
> 	ath10k_pci 0000:03:00.0: no channel configured; ignoring frame(s)!
> 	<until ratelimit kicks in>
> 	ath10k_warn: 155 callbacks suppressed
> 	...
>
> 	Use ath10k_dbg() here too.

You don't need an indentation on every line of the commit.

> Signed-off-by: Gabriel Craciunescu <nix.or.die@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wirel=
ess/ath/ath10k/htt_rx.c
> index 398dda978d6e..75d9b59b7e63 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -1514,7 +1514,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath1=
0k *ar,
>  	 */
> =20
>  	if (!rx_status->freq) {
> -		ath10k_warn(ar, "no channel configured; ignoring frame(s)!\n");
> +		ath10k_dbg(ar, ATH10K_DBG_HTT, "no channel configured; ignoring frame(=
s)!\n");
>  		return false;
>  	}
> =20

--=20
Ryan Hsu
