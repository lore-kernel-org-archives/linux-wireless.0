Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34280 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaFHUfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2014 16:35:18 -0400
Received: by mail-ig0-f178.google.com with SMTP id hn18so816641igb.11
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2014 13:35:17 -0700 (PDT)
Date: Sun, 8 Jun 2014 13:35:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>, Peter Wu <lekensteyn@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8723be: hw.c:  Cleaning up
 if statement that always evaluates to false
In-Reply-To: <1402191743-26177-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <alpine.DEB.2.02.1406081333550.19183@chino.kir.corp.google.com> (sfid-20140608_223538_368202_D431A747)
References: <1402191743-26177-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 8 Jun 2014, Rickard Strandqvist wrote:

> I find a logical error in an if statement '(X & 0xfc) == 0x3' is always false
> 

Where is the 0xfc that your converting?

> After pointing this out, Larry Finger informed what would be the correct one.
> '(X & 0x3) == 0x3'
> 

This is already what it is, just say that you're replacing it with the 
constant.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/net/wireless/rtlwifi/rtl8723be/hw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
> index 0fdf090..b61044f 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
> @@ -1197,7 +1197,7 @@ static int _rtl8723be_set_media_status(struct ieee80211_hw *hw,
>  	}
>  	rtl_write_byte(rtlpriv, (MSR), bt_msr);
>  	rtlpriv->cfg->ops->led_control(hw, ledaction);
> -	if ((bt_msr & 0x03) == MSR_AP)
> +	if ((bt_msr & MSR_AP) == MSR_AP)
>  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>  	else
>  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
