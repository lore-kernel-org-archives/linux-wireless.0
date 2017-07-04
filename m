Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35778 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752249AbdGDMVc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 08:21:32 -0400
Received: by mail-ua0-f195.google.com with SMTP id j53so15117546uaa.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jul 2017 05:21:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170628075711.GA8101@symbol-HP-ZBook-15>
References: <20170628075711.GA8101@symbol-HP-ZBook-15>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Tue, 4 Jul 2017 17:51:31 +0530
Message-ID: <CAFqt6zZVs4A0w35-keKQ-wDhj=sNZKbJdt=pqOeRtX4UVQjEdg@mail.gmail.com> (sfid-20170704_142141_030352_BA06FFBA)
Subject: Re: [PATCH] rtlwifi: remove dummy function call
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Wed, Jun 28, 2017 at 1:27 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> _rtl92cu_init_usb_aggregation() can be removed as it is dummy one
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> index 107c34e..ef8bd71 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> @@ -777,10 +777,6 @@ static void _rtl92cu_init_queue_priority(struct ieee80211_hw *hw,
>                                                    queue_sel);
>  }
>
> -static void _rtl92cu_init_usb_aggregation(struct ieee80211_hw *hw)
> -{
> -}
> -
>  static void _rtl92cu_init_wmac_setting(struct ieee80211_hw *hw)
>  {
>         u16 value16;
> @@ -863,7 +859,6 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
>         rtl92c_init_edca(hw);
>         rtl92c_init_rate_fallback(hw);
>         rtl92c_init_retry_function(hw);
> -       _rtl92cu_init_usb_aggregation(hw);
>         rtlpriv->cfg->ops->set_bw_mode(hw, NL80211_CHAN_HT20);
>         rtl92c_set_min_space(hw, IS_92C_SERIAL(rtlhal->version));
>         _rtl92cu_init_beacon_parameters(hw);
> --
> 1.9.1

Any comment for this patch ?
>

-Souptick
