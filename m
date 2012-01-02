Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59910 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2ABRtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 12:49:46 -0500
Message-ID: <4F01DC4B.50501@qca.qualcomm.com> (sfid-20120102_184948_834848_0AFDABE0)
Date: Mon, 2 Jan 2012 18:33:15 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 3/3] ath6kl: Remove few deadcode in main.c
References: <1325154939-6986-1-git-send-email-vthiagar@qca.qualcomm.com> <1325154939-6986-3-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1325154939-6986-3-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/29/2011 12:35 PM, Vasanthakumar Thiagarajan wrote:
> 1. In ath6kl_add_new_sta(), if (ielen <= ATH6KL_MAX_IE) is going to be
> always true due to ielen being u8 and is checked against 256.
> 
> 2. In ath6kl_reset_device(), since control can never reach switch..case
> when the target_type is neither TARGET_TYPE_AR6003 nor TARGET_TYPE_AR6004,
> remove the default option of switch statement.

Two separate patches, please.

> @@ -62,8 +62,7 @@ static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
>  
>  	sta = &ar->sta_list[free_slot];
>  	memcpy(sta->mac, mac, ETH_ALEN);
> -	if (ielen <= ATH6KL_MAX_IE)
> -		memcpy(sta->wpa_ie, wpaie, ielen);
> +	memcpy(sta->wpa_ie, wpaie, ielen);

And then someone changes the u8 ielen to something else and accidentally
adds a bug. I would prefer to have an explicit check for the ielen to
make it obvious what's the maximum length.

I don't really like using u8 for ielen either. IMHO size_t or similar
would be better.

Kalle
