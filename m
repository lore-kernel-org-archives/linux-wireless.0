Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31979 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762170AbcINPBM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 11:01:12 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 12/21] ath10k: Support up to 64 vdevs.
Date: Wed, 14 Sep 2016 15:01:07 +0000
Message-ID: <87y42ucyq6.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_170116_540931_F27D051E)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-13-git-send-email-greearb@candelatech.com>
In-Reply-To: <1462986153-16318-13-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Wed, 11 May 2016 10:02:24        -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> The (1 << x) - 1 trick won't work when you
> are trying to fill up all 64 bits, so add special
> case for that.
>
> And, move the limits to the per-nic structure instead
> of per-driver to allow better dynamic use of the limits.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index 3f1786c..fa71d57 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1819,7 +1819,10 @@ int ath10k_core_start(struct ath10k *ar, enum ath1=
0k_firmware_mode mode,
>  	if (status)
>  		goto err_hif_stop;
> =20
> -	ar->free_vdev_map =3D (1LL << ar->max_num_vdevs) - 1;
> +	if (ar->max_num_vdevs >=3D 64)
> +		ar->free_vdev_map =3D 0xFFFFFFFFFFFFFFFFLL;
> +	else
> +		ar->free_vdev_map =3D (1LL << ar->max_num_vdevs) - 1;

The last sentence in the commit log doesn't match the code, I removed
that in the pending branch.

--=20
Kalle Valo=
