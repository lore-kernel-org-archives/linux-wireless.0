Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47923 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaIWI7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 04:59:42 -0400
Received: by mail-wi0-f169.google.com with SMTP id fb4so4175525wid.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 01:59:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411426820-4047-1-git-send-email-greearb@candelatech.com>
References: <1411426820-4047-1-git-send-email-greearb@candelatech.com>
Date: Tue, 23 Sep 2014 10:59:40 +0200
Message-ID: <CA+BoTQn9sECMNZsxQpB4i3wHPxfVL+LXq9=2GBd-opH6+9TD=A@mail.gmail.com> (sfid-20140923_105947_202904_5967CC09)
Subject: Re: [PATCH] ath10k: use configured nss instead of max nss.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 September 2014 01:00,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> When re-associating a station, the nss was set back to
> maximum value even if user had configured small number
> of tx chains.  So, pay attention to user's config in
> this case as well.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 855c71c..c5d31cc 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4086,6 +4086,10 @@ ath10k_default_bitrate_mask(struct ath10k *ar,
>         u32 legacy = 0x00ff;
>         u8 ht = 0xff, i;
>         u16 vht = 0x3ff;
> +       u16 nrf = ar->num_rf_chains;
> +
> +       if (ar->cfg_tx_chainmask)
> +               nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);

Oh, so you do update the peer nss value here.

I think it might be a good idea to convey the limitation of tx/rx
chainmask to the user: you can't change the tx/rx chainmask on the fly
easily (while connected/have associated stations). Or do you plan to
schedule peer reassoc in __ath10k_set_antenna() in a follow up
patch(es) later?


Michał
