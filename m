Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:42188 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3DVVoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 17:44:32 -0400
Received: by mail-oa0-f49.google.com with SMTP id j1so3964272oag.8
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 14:44:30 -0700 (PDT)
Message-ID: <5175AF3C.30804@lwfinger.net> (sfid-20130422_234437_907439_BE0C8B3F)
Date: Mon, 22 Apr 2013 16:44:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Han Shen <shenhan@google.com>
CC: linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
	joe@perches.com, zajec5@gmail.com
Subject: Re: [PATCH v2] rtl8192c:dm: Properly initialize local array and set
 value.
References: <1366662911-4143-1-git-send-email-shenhan@google.com>
In-Reply-To: <1366662911-4143-1-git-send-email-shenhan@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/22/2013 03:35 PM, Han Shen wrote:
> GCC 4.8 is spitting out uninitialized-variable warnings against
> "drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c".  This patch adds
> initialization to the variable and properly sets its value.
>
> Signed-off-by: Han Shen  (shenhan@google.com)
>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> index b793a65..34150de 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> @@ -669,7 +669,7 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
>   	u8 thermalvalue, delta, delta_lck, delta_iqk;
>   	long ele_a, ele_d, temp_cck, val_x, value32;
>   	long val_y, ele_c = 0;
> -	u8 ofdm_index[2], ofdm_index_old[2], cck_index_old = 0;
> +	u8 ofdm_index[2], ofdm_index_old[2] = {0, 0}, cck_index_old = 0;
>   	s8 cck_index = 0;
>   	int i;
>   	bool is2t = IS_92C_SERIAL(rtlhal->version);
> @@ -717,7 +717,7 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
>   			for (i = 0; i < OFDM_TABLE_LENGTH; i++) {
>   				if (ele_d == (ofdmswing_table[i] &
>   				    MASKOFDM_D)) {
> -
> +					ofdm_index_old[1] = (u8) i;
>   					RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
>   						 DBG_LOUD,
>   						 "Initial pathB ele_d reg0x%x = 0x%lx, ofdm_index=0x%x\n",
>

