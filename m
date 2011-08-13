Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42058 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1HMKxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 06:53:13 -0400
Received: by gwaa12 with SMTP id a12so2472234gwa.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 03:53:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313211498-14442-3-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1313211498-14442-3-git-send-email-rmanohar@qca.qualcomm.com>
Date: Sat, 13 Aug 2011 18:53:12 +0800
Message-ID: <CAJ-Vmo=dzs4ZsmXq2C6gCsy+vAgdKAAQ1ZjC2VSPTtfw-aexuA@mail.gmail.com> (sfid-20110813_125315_721376_EE329595)
Subject: Re: [PATCH 03/11] ath9k: Re-enable RXOEL interrupt after processing
 rx buffers
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. again, I'll just point out that because I was seeing this when the
PCU honestly had hit the end of the RX descriptor list (lots of radar
phyerr frames), I needed to kick the PCU to start again.

Are you not seeing this? if not, why are you receiving the interrupt? :-)


Adrian

On 13 August 2011 12:58, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> Once RXEOL was disabled, it never be enabled again. This patch
> re-enables rxeol at the end of rx tasklet.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 7409402..c0c66e0 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1978,5 +1978,10 @@ requeue:
>
>        spin_unlock_bh(&sc->rx.rxbuflock);
>
> +       if (!(ah->imask & ATH9K_INT_RXEOL)) {
> +               ah->imask |= (ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
> +               ath9k_hw_set_interrupts(ah, ah->imask);
> +       }
> +
>        return 0;
>  }
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
