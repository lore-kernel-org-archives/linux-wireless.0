Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:52609 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757041Ab2IZQpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 12:45:47 -0400
Message-ID: <1348677946.15175.8.camel@joe-AO722> (sfid-20120926_184552_372990_6913937F)
Subject: Re: [PATCH] rtlwifi: use %*ph[C] to dump small buffers
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 26 Sep 2012 09:45:46 -0700
In-Reply-To: <1348667852-5957-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348667852-5957-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-26 at 16:57 +0300, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Hi Andy.

(adding Larry and Chaoming to cc's)

Please use scripts/get_maintainer.pl on your patches to
see who maintains these files so you can cc them.

One comment below, it looks like a possible endian bug.
(not in your patch)

> ---
>  drivers/net/wireless/rtlwifi/cam.c          |    7 ++-----
>  drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    6 ++----
>  drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |    6 ++----
>  3 files changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
> index 5b4b4d4..6ba9f80 100644
> --- a/drivers/net/wireless/rtlwifi/cam.c
> +++ b/drivers/net/wireless/rtlwifi/cam.c
> @@ -52,11 +52,8 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
>  	u32 target_content = 0;
>  	u8 entry_i;
>  
> -	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
> -		 "key_cont_128:\n %x:%x:%x:%x:%x:%x\n",
> -		 key_cont_128[0], key_cont_128[1],
> -		 key_cont_128[2], key_cont_128[3],
> -		 key_cont_128[4], key_cont_128[5]);
> +	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD, "key_cont_128: %*ph\n",
> +			6, key_cont_128);
>  
>  	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
>  		target_command = entry_i + CAM_CONTENT_COUNT * entry_no;
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> index 86d73b3..932780d 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> @@ -1918,10 +1918,8 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
>  				     (ratr_index << 28);
>  	rate_mask[4] = macid | (shortgi ? 0x20 : 0x00) | 0x80;
>  	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
> -		 "Rate_index:%x, ratr_val:%x, %x:%x:%x:%x:%x\n",
> -		 ratr_index, ratr_bitmap,
> -		 rate_mask[0], rate_mask[1], rate_mask[2], rate_mask[3],
> -		 rate_mask[4]);
> +		 "Rate_index:%x, ratr_val:%x, %*phC\n",
> +		 ratr_index, ratr_bitmap, 5, rate_mask);
>  	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);
>  
>  	if (macid != 0)
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 4bbb711..7554501 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -2169,10 +2169,8 @@ void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level)
>  				      ratr_index << 28);
>  	rate_mask[4] = macid | (shortgi ? 0x20 : 0x00) | 0x80;
>  	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
> -		 "Rate_index:%x, ratr_val:%x, %x:%x:%x:%x:%x\n",
> -		 ratr_index, ratr_bitmap,
> -		 rate_mask[0], rate_mask[1], rate_mask[2], rate_mask[3],
> -		 rate_mask[4]);
> +		 "Rate_index:%x, ratr_val:%x, %*phC\n",
> +		 ratr_index, ratr_bitmap, 5, rate_mask);
>  	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);
>  }
>  

rate_mask uses:

	u32 ratr_bitmap = (u32) mac->basic_rates;
...
	u8 rate_mask[5];
...
	[sets ratr_bitmap as u32]
...
	*(u32 *)&rate_mask = ((ratr_bitmap & 0x0fffffff) |
				      ratr_index << 28);
...
	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);

Looks like a possible endian misuse to me.



