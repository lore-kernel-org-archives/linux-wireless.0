Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f172.google.com ([209.85.161.172]:49448 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3DKUAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 16:00:38 -0400
Received: by mail-gg0-f172.google.com with SMTP id f4so305863ggn.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 13:00:38 -0700 (PDT)
Message-ID: <51671663.3070707@lwfinger.net> (sfid-20130411_220046_607663_1A9CDE10)
Date: Thu, 11 Apr 2013 15:00:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Han Shen <shenhan@google.com>, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Subject: Re: [PATCH] Fix uninitialized-variable warnings.
References: <1365703360-19982-1-git-send-email-shenhan@google.com> <1365705330.1929.30.camel@joe-AO722>
In-Reply-To: <1365705330.1929.30.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2013 01:35 PM, Joe Perches wrote:
> On Thu, 2013-04-11 at 11:02 -0700, Han Shen wrote:
>> GCC 4.8 is spitting out uninitialized-varaible warnings against "drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c".
>> This trivial patch just adds initialization to the variable.
>
> Not sure this is correct.
> I think the logic should be inspected instead.
>
> ofdm_index_old[1] _is_ used uninitialized.
>
> It appears there might be a missing
>
> 	ofdm_index_old[1] = (u8) i;
>
> as that's the same style test done in the
> section above.
>
> Maybe this:
> ---
>   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> index b793a65..56b2b2f 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> @@ -717,6 +717,7 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
>   			for (i = 0; i < OFDM_TABLE_LENGTH; i++) {
>   				if (ele_d == (ofdmswing_table[i] &
>   				    MASKOFDM_D)) {
> +					ofdm_index_old[1] = (u8) i;
>
>   					RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
>   						 DBG_LOUD,

My earlier E-mail was too hasty. Joe's patch is correct. It should be marked for 
stable (2.6.39+).

Larry



