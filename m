Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51490 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdG0J7e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 05:59:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v4 02/10] rtlwifi: Add BT_MP_INFO to c2h handler.
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
        <20170702181239.17911-3-Larry.Finger@lwfinger.net>
Date: Thu, 27 Jul 2017 12:59:30 +0300
In-Reply-To: <20170702181239.17911-3-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sun, 2 Jul 2017 13:12:31 -0500")
Message-ID: <87zibqw67x.fsf@purkki.adurom.net> (sfid-20170727_115938_983907_317EEC85)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> We use H2C to ask BT's status, and C2H will return the status.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

[...]

> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -327,7 +327,22 @@ static void halbtc_aggregation_check(struct btc_coexist *btcoexist)
>  
>  static u32 halbtc_get_bt_patch_version(struct btc_coexist *btcoexist)
>  {
> -	return 0;
> +	struct rtl_priv *rtlpriv = btcoexist->adapter;
> +	u8 cmd_buffer[4] = {0};
> +	u8 oper_ver = 0;
> +	u8 req_num = 0x0E;
> +
> +	if (btcoexist->bt_info.bt_real_fw_ver)
> +		goto label_done;
> +
> +	cmd_buffer[0] |= (oper_ver & 0x0f);	/* Set OperVer */
> +	cmd_buffer[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
> +	cmd_buffer[1] = 0; /* BT_OP_GET_BT_VERSION = 0 */
> +	rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, 4,
> +					&cmd_buffer[0]);
> +
> +label_done:
> +	return btcoexist->bt_info.bt_real_fw_ver;
>  }

I don't remember if I have mentioned before but there's way too much
magic numbers. There should an enum for all req_num values and
cmd_buffer should be a struct so that is serves as documentation at the
same time. No need to resend because of this but take this into account
in the future.

As an example rsi driver is having similar problems and Prameela is
fixing those:

https://patchwork.kernel.org/patch/9832895/

-- 
Kalle Valo
