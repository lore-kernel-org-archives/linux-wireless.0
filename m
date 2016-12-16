Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:60802 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1761232AbcLPTbZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 14:31:25 -0500
Message-ID: <1481916679.20419.1.camel@perches.com> (sfid-20161216_203129_042378_6037CAA4)
Subject: Re: [PATCH 02/14 V2] rtlwifi: Remove RT_TRACE messages that use
 DBG_EMERG
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>
Date: Fri, 16 Dec 2016 11:31:19 -0800
In-Reply-To: <20161215182310.13713-3-Larry.Finger@lwfinger.net>
References: <20161215182310.13713-1-Larry.Finger@lwfinger.net>
         <20161215182310.13713-3-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-15 at 12:22 -0600, Larry Finger wrote:
> These messages are always logged and represent error conditions, thus
> we can use pr_err().

OK and some trivialities:

> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
[]
> @@ -389,8 +388,8 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
>  			/* <4> set mac->sband to wiphy->sband */
>  			hw->wiphy->bands[NL80211_BAND_5GHZ] = sband;
>  		} else {
> -			RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Err BAND %d\n",
> -				 rtlhal->current_bandtype);
> +			pr_err("Err BAND %d\n",
> +			       rtlhal->current_bandtype);

It's nice to rewrap lines to 80 columns where possible.

> @@ -1886,8 +1883,7 @@ void rtl_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation)
>  						      (u8 *)&iotype);
>  			break;
>  		default:
> -			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> -				 "Unknown Scan Backup operation.\n");
> +			pr_err("Unknown Scan Backup operation.\n");

And it's also nice to remove unnecessary periods for
output message consistency.  Most don't use it.

> diff --git a/drivers/net/wireless/realtek/rtlwifi/cam.c b/drivers/net/wireless/realtek/rtlwifi/cam.c
[]
> @@ -285,8 +285,7 @@ u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
>  	u8 i, *addr;
>  
>  	if (NULL == sta_addr) {
> -		RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
> -			 "sta_addr is NULL.\n");
> +		pr_err("sta_addr is NULL.\n");

etc...
