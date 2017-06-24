Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:39554 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751281AbdFXMBU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Jun 2017 08:01:20 -0400
Message-ID: <1498305676.24295.27.camel@perches.com> (sfid-20170624_140124_112984_ECBE46C2)
Subject: Re: [PATCH 10/10] rtlwifi: btcoex: Use seq_file to dump btcoex
 status
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Date: Sat, 24 Jun 2017 05:01:16 -0700
In-Reply-To: <20170624015309.28099-11-Larry.Finger@lwfinger.net>
References: <20170624015309.28099-1-Larry.Finger@lwfinger.net>
         <20170624015309.28099-11-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-23 at 20:53 -0500, Larry Finger wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> If we use seq_file to dump status, then we can use 'cat' to access
> debugfs.  Other related changes are
> 1. implement btc_disp_dbg_msg() to access btcoex's common status.
> 2. remove obsolete field bt_exist
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
[]
> @@ -2719,75 +2719,64 @@ void ex_btc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
>  	u8 wifi_dot11_chnl, wifi_hs_chnl;
>  	u32 fw_ver = 0, bt_patch_ver = 0;
>  
> -	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
> -		 "\r\n ============[BT Coexist info]============");
> +	seq_puts(m, "\r\n ============[BT Coexist info]============");
>  
>  	if (btcoexist->manual_control) {
> -		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
> -			 "\r\n ===========[Under Manual Control]===========");
> -		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
> -			 "\r\n ==========================================");
> -	}
> -
> -	if (!board_info->bt_exist) {
> -		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n BT not exists !!!");
> -		return;
> +		seq_puts(m, "\r\n ===========[Under Manual Control]===========");
> +		seq_puts(m, "\r\n ==========================================");

All the \r uses should probably be removed.

>  	}
>  
> -	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
> -		 "\r\n %-35s = %d/ %d ", "Ant PG number/ Ant mechanism:",
> +	seq_printf(m, "\r\n %-35s = %d/ %d ", "Ant PG number/ Ant mechanism:",
>  		   board_info->pg_ant_num, board_info->btdm_ant_num);

etc...
