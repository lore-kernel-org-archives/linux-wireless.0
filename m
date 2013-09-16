Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:54613 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752270Ab3IPJf2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 05:35:28 -0400
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 01258-03 for <linux-wireless@vger.kernel.org>;
 Mon, 16 Sep 2013 10:28:43 +0100 (BST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Subject: RE: [PATCH 5/7: rtlwifi: Fix smatch warning in pci.c
Date: Mon, 16 Sep 2013 10:26:28 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B733B@saturn3.aculab.com> (sfid-20130916_113531_827982_B337F32C)
In-Reply-To: <1379094304-22041-6-git-send-email-Larry.Finger@lwfinger.net>
References: <1379094304-22041-1-git-send-email-Larry.Finger@lwfinger.net> <1379094304-22041-6-git-send-email-Larry.Finger@lwfinger.net>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Larry Finger" <Larry.Finger@lwfinger.net>,
	<linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Smatch reports the following:
>   CHECK   drivers/net/wireless/rtlwifi/pci.c
> drivers/net/wireless/rtlwifi/pci.c:739 _rtl_pci_rx_interrupt() warn: assigning (-98) to unsigned
> variable 'stats.noise'
> 
> This problem is fixed by changing the value to 256 - 98.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/net/wireless/rtlwifi/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 703f839..bf498f5 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -736,7 +736,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
> 
>  	struct rtl_stats stats = {
>  		.signal = 0,
> -		.noise = -98,
> +		.noise = 158,	/* -98 dBm */
>  		.rate = 0,
>  	};
>  	int index = rtlpci->rx_ring[rx_queue_idx].idx;

That doesn't look nice at all.
Something like (unsigned int)-98 would be slightly better,
but it looks as though something is actually wrong with
the type of 'noise' itself.

	David



