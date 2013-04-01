Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49285 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3DAQZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 12:25:45 -0400
Received: by mail-wi0-f182.google.com with SMTP id hi18so1687976wib.9
        for <linux-wireless@vger.kernel.org>; Mon, 01 Apr 2013 09:25:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMgrJ3b0EUUae8k1Z2RR92eLbFyPGpqA5px1J_gALDTJ+rmAnA@mail.gmail.com>
References: <CAMgrJ3b0EUUae8k1Z2RR92eLbFyPGpqA5px1J_gALDTJ+rmAnA@mail.gmail.com>
Date: Mon, 1 Apr 2013 09:25:43 -0700
Message-ID: <CAJ-Vmo=TBiJjs-DF-BfV95Mz8-Ro_aDa-dxcSOVC20rk9T5bqA@mail.gmail.com> (sfid-20130401_182549_340807_C371A24C)
Subject: Re: [PATCH] ath9k: Re-enable interrupts after a channel change failure
From: Adrian Chadd <adrian@freebsd.org>
To: Robert Shade <robert.shade@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You filed a bug against this, right? Can you mention the bug report in there?

(What's the "blessed" way to mention a bugzilla.kernel.org bug in a
linux git commit?)



adrian


On 1 April 2013 07:22, Robert Shade <robert.shade@gmail.com> wrote:
> Re-enable interrupts after a channel change failure, since
> ath_complete_reset will not be called.  Also schedule a reset as a
> best effort method to recover the chip from whatever state caused the
> channel change failure.
>
> Signed-off-by: Robert Shade <robert.shade@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c
> b/drivers/net/wireless/ath/ath9k/main.c
> index 24650fd..0567ac9 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -280,6 +280,12 @@ static int ath_reset_internal(struct ath_softc
> *sc, struct ath9k_channel *hchan)
>   if (r) {
>   ath_err(common,
>   "Unable to reset channel, reset status %d\n", r);
> +
> + ath9k_hw_set_interrupts(ah);
> + ath9k_hw_enable_interrupts(ah);
> +
> + ath9k_queue_reset(sc, RESET_TYPE_BB_HANG);
> +
>   goto out;
>   }
>
> --
> 1.7.1
