Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47120 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1HLUdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 16:33:06 -0400
Received: by yxj19 with SMTP id 19so2204881yxj.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 13:33:05 -0700 (PDT)
Message-ID: <4E458DFD.4060208@lwfinger.net> (sfid-20110812_223314_756583_0C25AC2C)
Date: Fri, 12 Aug 2011 15:33:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Assmann <sassmann@kpanic.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: add module parameter to set global debug level
References: <1313176963-17141-1-git-send-email-sassmann@kpanic.de>
In-Reply-To: <1313176963-17141-1-git-send-email-sassmann@kpanic.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 02:22 PM, Stefan Assmann wrote:
> Adding a module parameter to allow setting the global debug level.
> No need to recompile the module anymore to set the debug level.
>
> Signed-off-by: Stefan Assmann<sassmann@kpanic.de>
> ---
>   drivers/net/wireless/rtlwifi/debug.c |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/debug.c b/drivers/net/wireless/rtlwifi/debug.c
> index 5fa7385..1d82639 100644
> --- a/drivers/net/wireless/rtlwifi/debug.c
> +++ b/drivers/net/wireless/rtlwifi/debug.c
> @@ -28,12 +28,16 @@
>
>   #include "wifi.h"
>
> +static unsigned int debug = DBG_EMERG;
> +module_param(debug, uint, 0);
> +MODULE_PARM_DESC(debug, "Set global debug level for rtlwifi (uint)");

As the system puts a (uint) following the description when the modinfo command 
is used, the one above is redundant. Replace it with (0,2-5) instead. I have no 
idea why there is a hole in the debug levels, but I hesitate to close it. Also, 
send patches to John Linville with Cc to wireless.

Thanks for doing this. I'll sign off on it when you send V2.

Larry

> +
>   void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	u8 i;
>
> -	rtlpriv->dbg.global_debuglevel = DBG_EMERG;
> +	rtlpriv->dbg.global_debuglevel = debug;
>
>   	rtlpriv->dbg.global_debugcomponents =
>   	    COMP_ERR | COMP_FW | COMP_INIT | COMP_RECV | COMP_SEND |

