Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:53568 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3IPTEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 15:04:15 -0400
Received: by mail-la0-f46.google.com with SMTP id eh20so3457822lab.5
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 12:04:14 -0700 (PDT)
Message-ID: <5237562D.4080509@cogentembedded.com> (sfid-20130916_210419_074817_D1807A46)
Date: Mon, 16 Sep 2013 23:04:13 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 5/8 V2] [PATCH 5/7: rtlwifi: Fix smatch warning in pci.c
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net> <1379357722-17687-6-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1379357722-17687-6-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/16/2013 10:55 PM, Larry Finger wrote:

> Smatch reports the following:
>    CHECK   drivers/net/wireless/rtlwifi/pci.c
> drivers/net/wireless/rtlwifi/pci.c:739 _rtl_pci_rx_interrupt() warn: assigning (-98) to unsigned variable 'stats.noise'

> This variable is not used and is removed.

    It is not a variable but a structure field initializer you're removing.

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/pci.c | 1 -
>   1 file changed, 1 deletion(-)

> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 703f839..6295ed2 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -736,7 +736,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
>
>   	struct rtl_stats stats = {
>   		.signal = 0,
> -		.noise = -98,
>   		.rate = 0,
>   	};

WBR, Sergei

