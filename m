Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57081 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311Ab2K0KK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 05:10:58 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so4764770eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 02:10:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353986913-3087-1-git-send-email-bzhao@marvell.com>
References: <1353986913-3087-1-git-send-email-bzhao@marvell.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 27 Nov 2012 11:10:36 +0100
Message-ID: <CA+XFjipSqoh4Sj3Dup3cw-YMF1vs6NN-Eb3aV_m_Xs2kY6T_ig@mail.gmail.com> (sfid-20121127_111106_521273_56A4EC9A)
Subject: Re: [PATCH] mwifiex: advertise GreenField, 40MHz intolerance support
 to cfg80211
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2012 at 4:28 AM, Bing Zhao <bzhao@marvell.com> wrote:
> From: Avinash Patil <patila@marvell.com>
>
> This patch adds support for advertising GreenField, 40MHz intolerance
> or LDPC coding support to cfg80211.
>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/cfg80211.c |   15 +++++++++++++++
>  drivers/net/wireless/mwifiex/fw.h       |    2 ++
>  2 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index 3b1c277..13333e4 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -1948,6 +1948,21 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
>         else
>                 ht_info->cap &= ~IEEE80211_HT_CAP_TX_STBC;
>
> +       if (ISSUPP_GREENFIELD(adapter->hw_dot_11n_dev_cap))
> +               ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
> +       else
> +               ht_info->cap &= ~IEEE80211_HT_CAP_GRN_FLD;
> +
> +       if (ISENABLED_40MHZ_INTOLARENT(adapter->hw_dot_11n_dev_cap))
> +               ht_info->cap |= IEEE80211_HT_CAP_40MHZ_INTOLERANT;
> +       else
> +               ht_info->cap &= ~IEEE80211_HT_CAP_40MHZ_INTOLERANT;
> +
> +       if (ISSUPP_RXLDPC(adapter->hw_dot_11n_dev_cap))
> +               ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
> +       else
> +               ht_info->cap &= ~IEEE80211_HT_CAP_LDPC_CODING;
> +
>         ht_info->cap &= ~IEEE80211_HT_CAP_MAX_AMSDU;
>         ht_info->cap |= IEEE80211_HT_CAP_SM_PS;
>
> diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
> index dda588b..b125b7a 100644
> --- a/drivers/net/wireless/mwifiex/fw.h
> +++ b/drivers/net/wireless/mwifiex/fw.h
> @@ -194,6 +194,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
>  #define ISSUPP_TXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(25))
>  #define ISSUPP_RXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(26))
>  #define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
> +#define ISENABLED_40MHZ_INTOLARENT(Dot11nDevCap) (Dot11nDevCap & BIT(8))

Typo?

> +#define ISSUPP_RXLDPC(Dot11nDevCap) (Dot11nDevCap & BIT(22))
>
>  /* httxcfg bitmap
>   * 0           reserved
> --
> 1.7.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
