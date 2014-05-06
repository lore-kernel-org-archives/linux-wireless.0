Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:37013 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaEFOSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 10:18:23 -0400
Received: by mail-ob0-f170.google.com with SMTP id uy5so4490532obc.29
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2014 07:18:23 -0700 (PDT)
Message-ID: <5368EF2C.3060000@lwfinger.net> (sfid-20140506_161827_773514_A8C1733F)
Date: Tue, 06 May 2014 09:18:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andy Spencer <andy753421@ucla.edu>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] RTL8192CU: Increase max APFM_ONMAC polling count
References: <20140502064813.GA30179@pileus.org>
In-Reply-To: <20140502064813.GA30179@pileus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2014 01:48 AM, Andy Spencer wrote:
> With certain hardware combinations the poll interval is exceeded before
> initialization completes.
>
> Tested on a MacBookPro10,1 using a Sabrent USB-A11N USB adapter.
>
> Signed-off-by: Andy Spencer <andy753421@ucla.edu>
> ---
> I was unable to reproduce this issue using other hardware combinations.
> I thought it might be a USB3 issue but another laptop with USB3 worked
> without the patch.
>
> With my hardware the polling count reaches around 230 before
> initialization completes.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

If the adapter initializes quickly, this change causes no problem. I have not 
seen this kind of problem, but some hardware is obviously different.

Larry

>
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -511,7 +511,7 @@ static int _rtl92cu_init_power_on(struct ieee80211_hw *hw)
>   			pr_info("MAC auto ON okay!\n");
>   			break;
>   		}
> -		if (pollingCount++ > 100) {
> +		if (pollingCount++ > 1000) {
>   			RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
>   				 "Failed to polling REG_APS_FSMCO[APFM_ONMAC] done!\n");
>   			return -ENODEV;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

