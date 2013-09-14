Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39671 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab3INTot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Sep 2013 15:44:49 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so3041029lbh.23
        for <linux-wireless@vger.kernel.org>; Sat, 14 Sep 2013 12:44:47 -0700 (PDT)
Message-ID: <5234BCB6.6050508@cogentembedded.com> (sfid-20130914_214511_150792_1A0DF702)
Date: Sat, 14 Sep 2013 23:44:54 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 6/7] rtlwifi: Fix smatch warnings in usb.c
References: <1379094304-22041-1-git-send-email-Larry.Finger@lwfinger.net> <1379094304-22041-7-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1379094304-22041-7-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 09/13/2013 09:45 PM, Larry Finger wrote:

> Smatch displays the following:
>    CHECK   drivers/net/wireless/rtlwifi/usb.c
> drivers/net/wireless/rtlwifi/usb.c:458 _rtl_usb_rx_process_agg() warn: assigning (-98) to unsigned variable 'stats.noise'
> drivers/net/wireless/rtlwifi/usb.c:503 _rtl_usb_rx_process_noagg() warn: assigning (-98) to unsigned variable 'stats.noise'
> drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring unreachable code.
> drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring unreachable code.

> The negative number to an unsigned quantity is fixed by adding 256 to -98
> to get the equivalent negative number.

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/usb.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)

> diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
> index e56778c..9f3dcb8 100644
> --- a/drivers/net/wireless/rtlwifi/usb.c
> +++ b/drivers/net/wireless/rtlwifi/usb.c
[...]
> @@ -582,12 +582,15 @@ static void _rtl_rx_work(unsigned long param)
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

    Why this collateral and undocumented change? What does it achieve?

>   		return 0;

WBR, Sergei

