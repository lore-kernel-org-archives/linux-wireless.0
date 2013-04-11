Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:60159 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3DKTvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 15:51:25 -0400
Received: by mail-qe0-f48.google.com with SMTP id 2so1115564qea.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 12:51:25 -0700 (PDT)
Message-ID: <5167143A.70503@lwfinger.net> (sfid-20130411_215129_847487_F8B3FDF2)
Date: Thu, 11 Apr 2013 14:51:22 -0500
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
>
>
> --

Joe's patch would work, but as the elements of ofdm_index_old[] are just filled 
with the contents of i, just eliominate the middle man as in:

Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -669,7 +669,7 @@ static void rtl92c_dm_txpower_tracking_c
         u8 thermalvalue, delta, delta_lck, delta_iqk;
         long ele_a, ele_d, temp_cck, val_x, value32;
         long val_y, ele_c = 0;
-       u8 ofdm_index[2], ofdm_index_old[2], cck_index_old = 0;
+       u8 ofdm_index[2], cck_index_old = 0;
         s8 cck_index = 0;
         int i;
         bool is2t = IS_92C_SERIAL(rtlhal->version);
@@ -700,12 +700,10 @@ static void rtl92c_dm_txpower_tracking_c

                 for (i = 0; i < OFDM_TABLE_LENGTH; i++) {
                         if (ele_d == (ofdmswing_table[i] & MASKOFDM_D)) {
-                               ofdm_index_old[0] = (u8) i;
-
                                 RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
                                          "Initial pathA ele_d reg0x%x = 0x%lx, 
ofdm_index=0x%x\n",
                                          ROFDM0_XATXIQIMBALANCE,
-                                        ele_d, ofdm_index_old[0]);
+                                        ele_d, i);
                                 break;
                         }
                 }
@@ -722,7 +720,7 @@ static void rtl92c_dm_txpower_tracking_c
                                                  DBG_LOUD,
                                                  "Initial pathB ele_d reg0x%x = 
0x%lx, ofdm_index=0x%x\n",
                                                  ROFDM0_XBTXIQIMBALANCE, ele_d,
-                                                ofdm_index_old[1]);
+                                                i);
                                         break;
                                 }
                         }

I will submit this as a proper patch later. Fortunately, the driver is seldom 
run with the debug level as high as DBG_LOUD, then the RT_TRACE statements 
rarely result in any output.

Larry


Larry


