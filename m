Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:55608 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965133AbcIXRrf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Sep 2016 13:47:35 -0400
Message-ID: <1474739251.23838.15.camel@perches.com> (sfid-20160924_194752_408247_B3779954)
Subject: Re: [PATCH 1/2] rtlwifi: Add HAL_DEF_WOWLAN case to *_get_hw()
 routines
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Date: Sat, 24 Sep 2016 10:47:31 -0700
In-Reply-To: <1474736239-9826-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1474736239-9826-1-git-send-email-Larry.Finger@lwfinger.net>
         <1474736239-9826-2-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-09-24 at 11:57 -0500, Larry Finger wrote:
> Only rtl8821ae implements WOWLAN; however, the other drivers may receive
> a call requesting information about this mode. The other drivers need to
> ignore the request rather than logging that the default branch of the
> switch statement has been reached.

How about later rationalizing the DBG_EMERG vs DBG_LOUD differences too?

> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
[]
> @@ -355,6 +355,8 @@ void rtl88ee_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
[]
>  	default:
>  		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>  			 "switch case %#x not processed\n", variable);
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
[]
> @@ -141,6 +141,8 @@ void rtl8723e_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
[]
>  	default:
>  		RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
>  			 "switch case %#x not processed\n", variable);

etc...
