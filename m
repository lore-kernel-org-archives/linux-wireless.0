Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52325 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbdHLWC5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 Aug 2017 18:02:57 -0400
Subject: NACK: [PATCH] rtlwifi: btcoex: make function btc8723b2ant_dac_swing
 static
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20170812220017.6505-1-colin.king@canonical.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <2cd21542-1129-d93d-480b-752afbf11b8d@canonical.com> (sfid-20170813_000313_542283_FBF90E67)
Date: Sat, 12 Aug 2017 23:02:54 +0100
MIME-Version: 1.0
In-Reply-To: <20170812220017.6505-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/17 23:00, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The function btc8723b2ant_dac_swing  is local to the source and
> does not need to be in global scope, so make it static.
> 
> Cleans up sparse warning:
> symbol 'btc8723b2ant_dac_swing' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> index 31965f0ef69d..9d2ecfbc7b33 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> @@ -833,9 +833,9 @@ static void btc8723b2ant_set_sw_fulltime_dac_swing(struct btc_coexist *btcoex,
>  		btc8723b2ant_set_dac_swing_reg(btcoex, 0x18);
>  }
>  
> -void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
> -			    bool force_exec, bool dac_swing_on,
> -			    u32 dac_swing_lvl)
> +static void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
> +				   bool force_exec, bool dac_swing_on,
> +				   u32 dac_swing_lvl)
>  {
>  	struct rtl_priv *rtlpriv = btcoexist->adapter;
>  
> 
Sent out wrong patch. Please ignore.
