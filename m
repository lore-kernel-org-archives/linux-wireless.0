Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:43990 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab3DVSj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 14:39:57 -0400
Received: by mail-oa0-f50.google.com with SMTP id j6so1724375oag.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 11:39:56 -0700 (PDT)
Message-ID: <517583FA.5020802@lwfinger.net> (sfid-20130422_204000_730582_88F6BA34)
Date: Mon, 22 Apr 2013 13:39:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Han Shen <shenhan@google.com>
CC: linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
	joe@perches.com, zajec5@gmail.com
Subject: Re: [PATCH] rtl8192c:dm: Properly initialize local array.
References: <1366654089-31387-1-git-send-email-shenhan@google.com>
In-Reply-To: <1366654089-31387-1-git-send-email-shenhan@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/22/2013 01:08 PM, Han Shen wrote:
> GCC 4.8 is spitting out uninitialized-varaible warnings against "drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c".
> This trivial patch just adds initialization to the variable.
>
> Signed-off-by: Han Shen  (shenhan@google.com)
>
> ---

NACK. The patch also sets one element of the array; a statement that was 
missing. The commit message should say that as well. You also need to limit the 
lengths of lines in the commit message to less than 80 characters.

There is also a typo in the commit message. You should fix that as well.

Larry

>   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
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

