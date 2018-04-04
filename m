Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:44857 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754850AbeDDCnR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 22:43:17 -0400
Received: by mail-oi0-f53.google.com with SMTP id j143-v6so17868833oih.11
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 19:43:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/9] rtlwifi: btcoex: Add 8822b1ant coex files
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180328072741.23349-1-pkshih@realtek.com>
 <20180328072741.23349-2-pkshih@realtek.com>
Message-ID: <f4d2fe50-76b0-27a8-a119-018d7d7d1286@lwfinger.net> (sfid-20180404_044321_955939_0A9A3113)
Date: Tue, 3 Apr 2018 21:43:15 -0500
MIME-Version: 1.0
In-Reply-To: <20180328072741.23349-2-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2018 02:27 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> This file supports 8822be WiFi module with two physical antenna that
> means one antenna will share with BT.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   .../realtek/rtlwifi/btcoexist/halbtc8822b1ant.c    | 5303 ++++++++++++++++++++
>   .../realtek/rtlwifi/btcoexist/halbtc8822b1ant.h    |  413 ++
>   2 files changed, 5716 insertions(+)
>   create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c
>   create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.h

--snip--

> +/*anttenna control by bb mac bt antdiv pta to write 0x4c 0xcb4,0xcbd*/
> +
> +static
> +void hallbtc882b1ant_set_ant_switch(struct btc_coexist *btcoexist,
> +				    bool force_exec, u8 ctrl_type,
> +				    u8 pos_type)
> +{
> +	struct rtl_priv *rtlpriv = btcoexist->adapter;
> +	bool switch_polatiry_inverse = false;
> +	u8 regval_0xcbd = 0, regval_0x64;
> +	u32 u32tmp1 = 0, u32tmp2 = 0, u32tmp3 = 0;
> +
> +	/* Ext switch buffer mux */
> +	btcoexist->btc_write_1byte(btcoexist, 0x974, 0xff);
> +	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x1991, 0x3, 0x0);
> +	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbe, 0x8, 0x0);
> +
> +	if (!rfe_type->ext_ant_switch_exist)
> +		return;
> +
> +	coex_dm->cur_ext_ant_switch_status = (ctrl_type << 8) + pos_type;
> +
> +	if (!force_exec) {
> +		if (coex_dm->pre_ext_ant_switch_status ==
> +		    coex_dm->cur_ext_ant_switch_status)
> +			return;
> +	}
> +
> +	coex_dm->pre_ext_ant_switch_status = coex_dm->cur_ext_ant_switch_status;
> +
> +	/* swap control polarity if use different switch control polarity*/
> +	/* Normal switch polarity for SPDT,
> +	 * 0xcbd[1:0] = 2b'01 => Ant to BTG, WLA
> +	 * 0xcbd[1:0] = 2b'10 => Ant to WLG
> +	 */
> +	switch_polatiry_inverse = (rfe_type->ext_ant_switch_ctrl_polarity == 1 ?
> +					   ~switch_polatiry_inverse :
> +					   switch_polatiry_inverse);

gcc 7.3.1 reports the following:

   CC [M]  drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.o
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c: In function 
‘hallbtc882b1ant_set_ant_switch’:
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c:2193:9: 
warning: ‘~’ on a boolean expression [-Wbool-operation]
          ~switch_polatiry_inverse :
          ^
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c:2193:9: note: 
did you mean to use logical not?
          ~switch_polatiry_inverse :
          ^

For a boolean, you should use !bool, not -bool. In addition, it would be better 
to use switch_polarity_inverse, not switch_polatiry_inverse. The same "typo" 
happens in other places in this file. I suggest

sed -i 's/polatiry_inverse/polarity_inverse/g' \
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c.

> +
> +	switch (pos_type) {

Larry
