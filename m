Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33724 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1HMP0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 11:26:06 -0400
Received: by ywf7 with SMTP id 7so2534624ywf.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 08:26:05 -0700 (PDT)
Message-ID: <4E469789.3080705@lwfinger.net> (sfid-20110813_172611_338769_4F1AE60E)
Date: Sat, 13 Aug 2011 10:26:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Assmann <sassmann@kpanic.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] rtlwifi: add module parameter to set global debug
 level
References: <1313230356-6868-1-git-send-email-sassmann@kpanic.de>
In-Reply-To: <1313230356-6868-1-git-send-email-sassmann@kpanic.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2011 05:12 AM, Stefan Assmann wrote:
> No need to recompile the module anymore to set the debug level.
>
> Signed-off-by: Stefan Assmann<sassmann@kpanic.de>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/rtlwifi/debug.c |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/debug.c b/drivers/net/wireless/rtlwifi/debug.c
> index 5fa7385..b2f897a 100644
> --- a/drivers/net/wireless/rtlwifi/debug.c
> +++ b/drivers/net/wireless/rtlwifi/debug.c
> @@ -28,12 +28,16 @@
>
>   #include "wifi.h"
>
> +static unsigned int debug = DBG_EMERG;
> +module_param(debug, uint, 0);
> +MODULE_PARM_DESC(debug, "Set global debug level for rtlwifi (0,2-5)");
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

