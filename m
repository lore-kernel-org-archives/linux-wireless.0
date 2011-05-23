Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58985 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab1EWTze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 15:55:34 -0400
Received: by vxi39 with SMTP id 39so4378317vxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 12:55:33 -0700 (PDT)
Message-ID: <4DDABBB2.4060504@lwfinger.net> (sfid-20110523_215537_334861_EDE5A08C)
Date: Mon, 23 May 2011 14:55:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7/8] rtlwifi: Use write barrier when assigning ownership
References: <4DDA6730.7090600@ring3k.org>
In-Reply-To: <4DDA6730.7090600@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 08:54 AM, Mike McCormack wrote:
> Make sure all updates to a descriptor are flushed to memory
> before assigning ownship to hardware.
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> index 54b2bd5..06d9ddb 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
> @@ -932,6 +932,7 @@ void rtl92ce_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
>   	if (istx == true) {
>   		switch (desc_name) {
>   		case HW_DESC_OWN:
> +			wmb();
>   			SET_TX_DESC_OWN(pdesc, 1);
>   			break;
>   		case HW_DESC_TX_NEXTDESC_ADDR:
> @@ -945,6 +946,7 @@ void rtl92ce_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
>   	} else {
>   		switch (desc_name) {
>   		case HW_DESC_RXOWN:
> +			wmb();
>   			SET_RX_DESC_OWN(pdesc, 1);
>   			break;
>   		case HW_DESC_RXBUFF_ADDR:

A similar change needs to be applied to rtl8192se. I'll take care of it.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Larry

