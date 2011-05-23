Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64657 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1EWT5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 15:57:55 -0400
Received: by vxi39 with SMTP id 39so4380202vxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 12:57:54 -0700 (PDT)
Message-ID: <4DDABC3F.2070900@lwfinger.net> (sfid-20110523_215758_635949_C63D672E)
Date: Mon, 23 May 2011 14:57:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/8] rtlwifi: Fix logic in rx_interrupt
References: <4DDA673B.6070600@ring3k.org>
In-Reply-To: <4DDA673B.6070600@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 08:55 AM, Mike McCormack wrote:
> Should pass along packet if there's no CRC and no hardware error.
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>
> ---
>   drivers/net/wireless/rtlwifi/pci.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 4fe405a..215abfa 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -691,7 +691,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
>   			hdr = rtl_get_hdr(skb);
>   			fc = rtl_get_fc(skb);
>
> -			if (!stats.crc || !stats.hwerror) {
> +			if (!stats.crc&&  !stats.hwerror) {
>   				memcpy(IEEE80211_SKB_RXCB(skb),&rx_status,
>   				       sizeof(rx_status));
>

Good catch.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Larry

