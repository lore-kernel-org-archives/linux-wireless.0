Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:36426 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752219AbcLPTe7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 14:34:59 -0500
Message-ID: <1481916894.20419.3.camel@perches.com> (sfid-20161216_203502_606792_31B7C777)
Subject: Re: [PATCH 03/14 V2] rtlwifi: rtl8821ae: Remove all instances of
 DBG_EMERG
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>
Date: Fri, 16 Dec 2016 11:34:54 -0800
In-Reply-To: <20161215182310.13713-4-Larry.Finger@lwfinger.net>
References: <20161215182310.13713-1-Larry.Finger@lwfinger.net>
         <20161215182310.13713-4-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-15 at 12:22 -0600, Larry Finger wrote:
> This is a step toward eliminating the RT_TRACE macros. Those calls that
> have DBG_EMERG as the level are always logged, and they represent error
> conditions, thus they are replaced with pr_err().

OK,

> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
[]
> @@ -162,8 +161,8 @@ static int _rtl8821ae_fw_free_to_go(struct ieee80211_hw *hw)
>  		goto exit;
>  	}
>  
> -	RT_TRACE(rtlpriv, COMP_FW, DBG_EMERG,
> -		 "Checksum report OK ! REG_MCUFWDL:0x%08x .\n", value32);
> +	pr_err("Checksum report OK! REG_MCUFWDL:0x%08x\n",
> +	       value32);
>  
>  	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
>  	value32 |= MCUFWDL_RDY;
> @@ -186,9 +184,8 @@ static int _rtl8821ae_fw_free_to_go(struct ieee80211_hw *hw)
>  		udelay(FW_8821AE_POLLING_DELAY);
>  	} while (counter++ < FW_8821AE_POLLING_TIMEOUT_COUNT);
>  
> -	RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> -		 "Polling FW ready fail!! REG_MCUFWDL:0x%08x .\n",
> -		 value32);
> +	pr_err("Polling FW ready fail!! REG_MCUFWDL:0x%08x .\n",
> +	       value32);

It's odd to fix / remove " .\n" above but here and
the wrapping comment on the first patch applies too.

I didn't look at the rest and I won't comment on
other uses in any further patches in the series.

Thanks,  Joe
