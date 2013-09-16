Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33377 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3IPTHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 15:07:42 -0400
Received: by mail-lb0-f181.google.com with SMTP id u14so4444640lbd.26
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 12:07:41 -0700 (PDT)
Message-ID: <523756FC.1050905@cogentembedded.com> (sfid-20130916_210745_704024_0590CA41)
Date: Mon, 16 Sep 2013 23:07:40 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 6/8 V2] rtlwifi: Fix smatch warnings in usb.c
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net> <1379357722-17687-7-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1379357722-17687-7-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/16/2013 10:55 PM, Larry Finger wrote:

> Smatch displays the following:
>    CHECK   drivers/net/wireless/rtlwifi/usb.c
> drivers/net/wireless/rtlwifi/usb.c:458 _rtl_usb_rx_process_agg() warn: assigning (-98) to unsigned variable 'stats.noise'
> drivers/net/wireless/rtlwifi/usb.c:503 _rtl_usb_rx_process_noagg() warn: assigning (-98) to unsigned variable 'stats.noise'
> drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring unreachable code.
> drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring unreachable code.

> The negative number to an unsigned quantity is fixed by removing the variable
> as it is no longer used.

    You're removing only structure field initializer, not a variable.

> The unreachable code info is fixed by including the
> appropriate section inside #ifdef .. #endif constructions.

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/usb.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)

> diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
> index e56778c..60cb0b4 100644
> --- a/drivers/net/wireless/rtlwifi/usb.c
> +++ b/drivers/net/wireless/rtlwifi/usb.c
> @@ -455,7 +455,6 @@ static void _rtl_usb_rx_process_agg(struct ieee80211_hw *hw,
>   	struct ieee80211_rx_status rx_status = {0};
>   	struct rtl_stats stats = {
>   		.signal = 0,
> -		.noise = -98,
>   		.rate = 0,
>   	};
>
> @@ -498,7 +497,6 @@ static void _rtl_usb_rx_process_noagg(struct ieee80211_hw *hw,
>   	struct ieee80211_rx_status rx_status = {0};
>   	struct rtl_stats stats = {
>   		.signal = 0,
> -		.noise = -98,
>   		.rate = 0,
>   	};
>
> @@ -582,12 +580,15 @@ static void _rtl_rx_work(unsigned long param)
>   static unsigned int _rtl_rx_get_padding(struct ieee80211_hdr *hdr,
>   					unsigned int len)
>   {
> +#if NET_IP_ALIGN != 0
>   	unsigned int padding = 0;
> +#endif
>
>   	/* make function no-op when possible */
> -	if (NET_IP_ALIGN == 0 || len < sizeof(*hdr))
> +	if (NET_IP_ALIGN == 0 || len < sizeof(struct ieee80211_hdr))

    Hm, I thought you were going to remove this collateral change.

>   		return 0;

WBR, Sergei

