Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:43525 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbeCTD6Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 23:58:25 -0400
Received: by mail-oi0-f65.google.com with SMTP id y27-v6so211033oix.10
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 20:58:25 -0700 (PDT)
Subject: Re: [PATCH v2 06/15] rtlwifi: btcoex: Add rate table for the use of
 btcoex
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180306012554.3108-1-pkshih@realtek.com>
 <20180306012554.3108-7-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4e84eeed-c7bc-9d6b-4d49-a3a1cb930e8c@lwfinger.net> (sfid-20180320_045829_409080_CB7A8B1E)
Date: Mon, 19 Mar 2018 22:58:23 -0500
MIME-Version: 1.0
In-Reply-To: <20180306012554.3108-7-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2018 07:25 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The btcoex use the rate to rsolve IOT issue that some APs reduce TX
> rate quickly, so it uses the RX rate as a clue to decide TDMA.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger#lwfinger.net>


> ---
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       | 94 ++++++++++++++++++++++
>   1 file changed, 94 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index fe793b787716..bc2388f3f953 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -437,6 +437,100 @@ enum btc_notify_type_stack_operation {
>   	BTC_STACK_OP_MAX
>   };
>   
> +enum {
> +	BTC_CCK_1,
> +	BTC_CCK_2,
> +	BTC_CCK_5_5,
> +	BTC_CCK_11,
> +	BTC_OFDM_6,
> +	BTC_OFDM_9,
> +	BTC_OFDM_12,
> +	BTC_OFDM_18,
> +	BTC_OFDM_24,
> +	BTC_OFDM_36,
> +	BTC_OFDM_48,
> +	BTC_OFDM_54,
> +	BTC_MCS_0,
> +	BTC_MCS_1,
> +	BTC_MCS_2,
> +	BTC_MCS_3,
> +	BTC_MCS_4,
> +	BTC_MCS_5,
> +	BTC_MCS_6,
> +	BTC_MCS_7,
> +	BTC_MCS_8,
> +	BTC_MCS_9,
> +	BTC_MCS_10,
> +	BTC_MCS_11,
> +	BTC_MCS_12,
> +	BTC_MCS_13,
> +	BTC_MCS_14,
> +	BTC_MCS_15,
> +	BTC_MCS_16,
> +	BTC_MCS_17,
> +	BTC_MCS_18,
> +	BTC_MCS_19,
> +	BTC_MCS_20,
> +	BTC_MCS_21,
> +	BTC_MCS_22,
> +	BTC_MCS_23,
> +	BTC_MCS_24,
> +	BTC_MCS_25,
> +	BTC_MCS_26,
> +	BTC_MCS_27,
> +	BTC_MCS_28,
> +	BTC_MCS_29,
> +	BTC_MCS_30,
> +	BTC_MCS_31,
> +	BTC_VHT_1SS_MCS_0,
> +	BTC_VHT_1SS_MCS_1,
> +	BTC_VHT_1SS_MCS_2,
> +	BTC_VHT_1SS_MCS_3,
> +	BTC_VHT_1SS_MCS_4,
> +	BTC_VHT_1SS_MCS_5,
> +	BTC_VHT_1SS_MCS_6,
> +	BTC_VHT_1SS_MCS_7,
> +	BTC_VHT_1SS_MCS_8,
> +	BTC_VHT_1SS_MCS_9,
> +	BTC_VHT_2SS_MCS_0,
> +	BTC_VHT_2SS_MCS_1,
> +	BTC_VHT_2SS_MCS_2,
> +	BTC_VHT_2SS_MCS_3,
> +	BTC_VHT_2SS_MCS_4,
> +	BTC_VHT_2SS_MCS_5,
> +	BTC_VHT_2SS_MCS_6,
> +	BTC_VHT_2SS_MCS_7,
> +	BTC_VHT_2SS_MCS_8,
> +	BTC_VHT_2SS_MCS_9,
> +	BTC_VHT_3SS_MCS_0,
> +	BTC_VHT_3SS_MCS_1,
> +	BTC_VHT_3SS_MCS_2,
> +	BTC_VHT_3SS_MCS_3,
> +	BTC_VHT_3SS_MCS_4,
> +	BTC_VHT_3SS_MCS_5,
> +	BTC_VHT_3SS_MCS_6,
> +	BTC_VHT_3SS_MCS_7,
> +	BTC_VHT_3SS_MCS_8,
> +	BTC_VHT_3SS_MCS_9,
> +	BTC_VHT_4SS_MCS_0,
> +	BTC_VHT_4SS_MCS_1,
> +	BTC_VHT_4SS_MCS_2,
> +	BTC_VHT_4SS_MCS_3,
> +	BTC_VHT_4SS_MCS_4,
> +	BTC_VHT_4SS_MCS_5,
> +	BTC_VHT_4SS_MCS_6,
> +	BTC_VHT_4SS_MCS_7,
> +	BTC_VHT_4SS_MCS_8,
> +	BTC_VHT_4SS_MCS_9,
> +	BTC_MCS_32,
> +	BTC_UNKNOWN,
> +	BTC_PKT_MGNT,
> +	BTC_PKT_CTRL,
> +	BTC_PKT_UNKNOWN,
> +	BTC_PKT_NOT_FOR_ME,
> +	BTC_RATE_MAX
> +};
> +
>   enum {
>   	BTC_MULTIPORT_SCC,
>   	BTC_MULTIPORT_MCC_2CHANNEL,
> 
