Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36670 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdHCJ0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:26:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH] mwifiex: add module parameter to disable 40MHZ support in 2.4G band
References: <1501751215-12742-1-git-send-email-huxinming820@gmail.com>
Date: Thu, 03 Aug 2017 12:26:39 +0300
In-Reply-To: <1501751215-12742-1-git-send-email-huxinming820@gmail.com>
        (Xinming Hu's message of "Thu, 3 Aug 2017 09:06:55 +0000")
Message-ID: <874ltpovcg.fsf@kamboji.qca.qualcomm.com> (sfid-20170803_112649_224440_D8E18C30)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> This patch provide a new module parameter disable_2g4_40m, with
> which driver will not report 40M capability for 2.4GHZ to cfg80211.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index 2be7817..820475a 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -25,6 +25,10 @@
>  static char *reg_alpha2;
>  module_param(reg_alpha2, charp, 0);
>  
> +static bool disable_2g4_40m;
> +module_param(disable_2g4_40m, bool, 0000);

This is bool, good.

> +MODULE_PARM_DESC(disable_2g4_40m, "2.4G 40M support disable:1, enable:0");

This is not really a readable description for someone not familiar with
Wi-Fi, maybe this instead:

"disable 40 Mhz channels on 2.4 GHz band (disable:1, enable:0)"

> @@ -2755,7 +2759,7 @@ static void mwifiex_setup_vht_caps(struct ieee80211_sta_vht_cap *vht_info,
>   */
>  static void
>  mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
> -		      struct mwifiex_private *priv)
> +		      struct mwifiex_private *priv, int disable_40m)

But here you use int, that's a bit strange. Why not bool?

-- 
Kalle Valo
