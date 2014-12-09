Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:51973 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaLIRVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 12:21:03 -0500
Received: by mail-ob0-f172.google.com with SMTP id va8so794322obc.17
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2014 09:21:01 -0800 (PST)
Message-ID: <54872F7C.5080405@lwfinger.net> (sfid-20141209_182129_876273_02AAB4C6)
Date: Tue, 09 Dec 2014 11:21:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: weiyj_lk@163.com, Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Ben Hutchings <ben@decadent.org.uk>,
	Peter Wu <lekensteyn@gmail.com>,
	Karsten Wiese <fzuuzf@googlemail.com>,
	Andy Spencer <andy753421@ucla.edu>
CC: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] rtlwifi: rtl8192cu: Fix sparse non static symbol
 warning
References: <1418131123-3606-1-git-send-email-weiyj_lk@163.com>
In-Reply-To: <1418131123-3606-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2014 07:18 AM, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fixes the following sparse warnings:

There is only one warning.

>
> drivers/net/wireless/rtlwifi/rtl8192cu/hw.c:1595:6: warning:
>   symbol 'usb_cmd_send_packet' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Changing usb_cmd_send_packet() to be static is correct.

@john: If you want to deal with fixing the commit message, then please add 
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 873363ac..5513217 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1592,7 +1592,7 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   	}
>   }
>
> -bool usb_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
> +static bool usb_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
>   {
>     /* Currently nothing happens here.
>      * Traffic stops after some seconds in WPA2 802.11n mode.
>
>

