Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55470 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbdIJUmY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Sep 2017 16:42:24 -0400
From: Sven Joachim <svenjoac@gmx.de>
To: <gregkh@linuxfoundation.org>
Cc: Larry.Finger@lwfinger.net, birming@realtek.com,
        kvalo@codeaurora.org, pkshih@realtek.com, shaofu@realtek.com,
        steventing@realtek.com, yhchuang@realtek.com,
        <stable@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: Patch "rtlwifi: btcoexist: Fix antenna selection code" has been added to the 4.13-stable tree
References: <1505043448199217@kroah.com>
Date: Sun, 10 Sep 2017 22:42:01 +0200
In-Reply-To: <1505043448199217@kroah.com> (gregkh's message of "Sun, 10 Sep
        2017 13:37:28 +0200")
Message-ID: <87bmmib812.fsf@turtle.gmx.de> (sfid-20170910_224227_554641_72804360)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-09-10 13:37 +0200, gregkh@linuxfoundation.org wrote:

> This is a note to let you know that I've just added the patch titled
>
>     rtlwifi: btcoexist: Fix antenna selection code
>
> to the 4.13-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      rtlwifi-btcoexist-fix-antenna-selection-code.patch
> and it can be found in the queue-4.13 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
>
> From 6d622692836950b3c943776f84c4557ff6c02f3b Mon Sep 17 00:00:00 2001
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Mon, 4 Sep 2017 12:51:34 -0500
> Subject: rtlwifi: btcoexist: Fix antenna selection code
>
> From: Larry Finger <Larry.Finger@lwfinger.net>
>
> commit 6d622692836950b3c943776f84c4557ff6c02f3b upstream.
>
> In commit 87d8a9f35202 ("rtlwifi: btcoex: call bind to setup btcoex"),
> the code turns on a call to exhalbtc_bind_bt_coex_withadapter(). This
> routine contains a bug that causes incorrect antenna selection for those
> HP laptops with only one antenna and an incorrectly programmed EFUSE.
> These boxes are the ones that need the ant_sel module parameter.

I am the unlucky owner of such a laptop.

> Fixes: 87d8a9f35202 ("rtlwifi: btcoex: call bind to setup btcoex")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c |   23 ++++++----
>  1 file changed, 16 insertions(+), 7 deletions(-)
>
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -173,6 +173,16 @@ static u8 halbtc_get_wifi_central_chnl(s
>  
>  u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv)
>  {
> +	struct rtl_mod_params *mod_params = rtlpriv->cfg->mod_params;
> +
> +	/* override ant_num / ant_path */
> +	if (mod_params->ant_sel) {
> +		rtlpriv->btcoexist.btc_info.ant_num =
> +			(mod_params->ant_sel == 1 ? ANT_X2 : ANT_X1);
> +
> +		rtlpriv->btcoexist.btc_info.single_ant_path =
> +			(mod_params->ant_sel == 1 ? 0 : 1);
> +	}
>  	return rtlpriv->btcoexist.btc_info.single_ant_path;
>  }
>  
> @@ -183,6 +193,7 @@ u8 rtl_get_hwpg_bt_type(struct rtl_priv
>  
>  u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
>  {
> +	struct rtl_mod_params *mod_params = rtlpriv->cfg->mod_params;
>  	u8 num;
>  
>  	if (rtlpriv->btcoexist.btc_info.ant_num == ANT_X2)
> @@ -190,6 +201,10 @@ u8 rtl_get_hwpg_ant_num(struct rtl_priv
>  	else
>  		num = 1;
>  
> +	/* override ant_num / ant_path */
> +	if (mod_params->ant_sel)
> +		num = (mod_params->ant_sel == 1 ? ANT_X2 : ANT_X1) + 1;
> +
>  	return num;
>  }
>  
> @@ -861,7 +876,7 @@ bool exhalbtc_bind_bt_coex_withadapter(v
>  {
>  	struct btc_coexist *btcoexist = &gl_bt_coexist;
>  	struct rtl_priv *rtlpriv = adapter;
> -	u8 ant_num = 2, chip_type, single_ant_path = 0;
> +	u8 ant_num = 2, chip_type;
>  
>  	if (btcoexist->binded)
>  		return false;
> @@ -896,12 +911,6 @@ bool exhalbtc_bind_bt_coex_withadapter(v
>  	ant_num = rtl_get_hwpg_ant_num(rtlpriv);
>  	exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_PG, ant_num);
>  
> -	/* set default antenna position to main  port */
> -	btcoexist->board_info.btdm_ant_pos = BTC_ANTENNA_AT_MAIN_PORT;
> -
> -	single_ant_path = rtl_get_hwpg_single_ant_path(rtlpriv);
> -	exhalbtc_set_single_ant_path(single_ant_path);
> -
>  	if (rtl_get_hwpg_package_type(rtlpriv) == 0)
>  		btcoexist->board_info.tfbga_package = false;
>  	else if (rtl_get_hwpg_package_type(rtlpriv) == 1)
>
>
> Patches currently in stable-queue which might be from Larry.Finger@lwfinger.net are
>
> queue-4.13/rtlwifi-btcoexist-fix-breakage-of-ant_sel-for-rtl8723be.patch
> queue-4.13/rtlwifi-btcoexist-fix-antenna-selection-code.patch

After applying these patches on top of 4.13.1 the WiFi on my laptop
works again (thanks, Larry!), but now rtl8723be needs the ant_sel=2
parameter which is a bit odd, because previously it had been working
(only) with ant_sel=1.  This looks like it has not been intended?

Cheers,
       Sven
