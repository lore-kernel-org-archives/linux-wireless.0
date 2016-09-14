Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38131 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754281AbcINOIG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 10:08:06 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 04/21] ath10k: rate-limit packet tx errors
Date: Wed, 14 Sep 2016 14:07:55 +0000
Message-ID: <87wpieefr9.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_160810_648044_661622AD)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-5-git-send-email-greearb@candelatech.com>
In-Reply-To: <1462986153-16318-5-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Wed, 11 May 2016 10:02:16        -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> When firmware crashes, stack can continue to send packets
> for a bit, and existing code was spamming logs.
>
> So, rate-limit the error message for tx failures.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index cd3016d..42cac32 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3432,8 +3432,9 @@ static int ath10k_mac_tx_submit(struct ath10k *ar,
>  	}
> =20
>  	if (ret) {
> -		ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
> -			    ret);
> +		if (net_ratelimit())
> +			ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
> +				    ret);
>  		ieee80211_free_txskb(ar->hw, skb);
>  	}

ath10k_warn() is already rate limited. If there's something wrong then
that function should be fixed, not the callers.

void ath10k_warn(struct ath10k *ar, const char *fmt, ...)
{
	struct va_format vaf =3D {
		.fmt =3D fmt,
	};
	va_list args;

	va_start(args, fmt);
	vaf.va =3D &args;
	dev_warn_ratelimited(ar->dev, "%pV", &vaf);
	trace_ath10k_log_warn(ar, &vaf);

	va_end(args);
}

--=20
Kalle Valo=
