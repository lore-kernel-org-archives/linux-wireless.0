Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12937 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbcINOh6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 10:37:58 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 19/21] ath10k: Enable adhoc mode for CT firmware.
Date: Wed, 14 Sep 2016 14:37:42 +0000
Message-ID: <877faeeedm.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_163802_000843_2D6F2FF2)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-20-git-send-email-greearb@candelatech.com>
In-Reply-To: <1462986153-16318-20-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Wed, 11 May 2016 10:02:31        -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> CT firmware can support IBSS mode, so allow users to configure this.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index f1bfb3a..3fc9006 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -7482,6 +7482,10 @@ static const struct ieee80211_iface_limit ath10k_1=
0x_ct_if_limits[] =3D {
>  	.max	=3D 7,
>  	.types	=3D BIT(NL80211_IFTYPE_AP)
>  	},
> +	{
> +	.max	=3D 1,
> +	.types	=3D BIT(NL80211_IFTYPE_ADHOC)
> +	},
>  };
> =20
>  static const struct ieee80211_iface_combination ath10k_if_comb[] =3D {
> @@ -7862,6 +7866,7 @@ int ath10k_mac_register(struct ath10k *ar)
>  			ar->hw->wiphy->iface_combinations =3D ath10k_10x_ct_if_comb;
>  			ar->hw->wiphy->n_iface_combinations =3D
>  				ARRAY_SIZE(ath10k_10x_ct_if_comb);
> +			ar->hw->wiphy->interface_modes |=3D BIT(NL80211_IFTYPE_ADHOC);
>  		} else {
>  			ar->hw->wiphy->iface_combinations =3D ath10k_10x_if_comb;
>  			ar->hw->wiphy->n_iface_combinations =3D

There should a feature flag ATH10K_FW_FEATURE_SUPPORTS_ADHOC and we use
that flag as an indication to enable the mode. I wish we had done that
from the beginning, using wmi_op_version to guess that just creates
problems :(

--=20
Kalle Valo=
