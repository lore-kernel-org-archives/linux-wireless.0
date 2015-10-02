Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8402 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbbJBIC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 04:02:29 -0400
Message-ID: <560E3A11.2040200@broadcom.com> (sfid-20151002_100333_789256_69DF3950)
Date: Fri, 2 Oct 2015 10:02:25 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Chaehyun Lim <chaehyun.lim@gmail.com>, <gregkh@linuxfoundation.org>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<chris.park@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <linux-wireless@vger.kernel.org>,
	<devel@driverdev.osuosl.org>
Subject: Re: [PATCH V2 08/12] staging: wilc1000: use int instead of int8_t
References: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com> <1443771681-15540-8-git-send-email-chaehyun.lim@gmail.com>
In-Reply-To: <1443771681-15540-8-git-send-email-chaehyun.lim@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/02/2015 09:41 AM, Chaehyun Lim wrote:
> This patch replaces int8_t with int.
> The int8_t should be int. It's used as an index into an array
> or -1 for not found.

Please consider using bool instead. See my previous emails.

Regards,
Arend

> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
> V2: replaces s8 with int suggested by dan.
>
>   drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index d781003..3c8c2e1 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -263,9 +263,9 @@ static void clear_duringIP(unsigned long arg)
>   	g_obtainingIP = false;
>   }
>
> -int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
> +int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
>   {
> -	int8_t state = -1;
> +	int state = -1;
>   	int i;
>
>   	if (u32LastScannedNtwrksCountShadow == 0) {
> @@ -288,7 +288,7 @@ int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
>
>   void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
>   {
> -	int8_t ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
> +	int ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
>   	u32 ap_index = 0;
>   	u8 rssi_index = 0;
>
>

