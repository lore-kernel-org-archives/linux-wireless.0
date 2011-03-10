Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38059 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077Ab1CJVNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 16:13:48 -0500
Received: by mail-bw0-f44.google.com with SMTP id 13so2842976bwz.17
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 13:13:44 -0800 (PST)
Subject: Re: [PATCH 05/15] wl12xx: 1281/1283 support - Loading FW & NVS
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299421940-26292-6-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
	 <1299421940-26292-6-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 23:13:48 +0200
Message-ID: <1299791628.1816.125.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
> index 69fe870..7984631 100644
> --- a/drivers/net/wireless/wl12xx/boot.c
> +++ b/drivers/net/wireless/wl12xx/boot.c
> @@ -240,36 +240,62 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
>  	u32 dest_addr, val;
>  	u8 *nvs_ptr, *nvs_aligned;
>  
> -	if (wl->nvs == NULL)
> -		return -ENODEV;
> +	if (wl->chip.id == CHIP_ID_1283_PG20) {
> +		struct wl128x_nvs_file *nvs = (struct wl128x_nvs_file *)wl->nvs;
> +
> +		if (nvs == NULL)
> +			return -ENODEV;
> +
> +		if (wl->nvs_len == sizeof(struct wl128x_nvs_file)) {
> +			if (nvs->general_params.dual_mode_select)
> +				wl->enable_11a = true;
> +		} else {
> +			wl1271_error("nvs size is not as expected: %zu != %zu",
> +				     wl->nvs_len,
> +				     sizeof(struct wl128x_nvs_file));
> +			kfree(nvs);
> +			nvs = NULL;

This is wrong.  You're just setting the local nvs variable to NULL.
It's wl->nvs that should be set to NULL instead.


> +			wl->nvs_len = 0;
> +			return -EILSEQ;
> +		}
>  
> -	/*
> -	 * FIXME: the LEGACY NVS image support (NVS's missing the 5GHz band
> -	 * configurations) can be removed when those NVS files stop floating
> -	 * around.
> -	 */
> -	if (wl->nvs_len == sizeof(struct wl1271_nvs_file) ||
> -	    wl->nvs_len == WL1271_INI_LEGACY_NVS_FILE_SIZE) {
> -		/* for now 11a is unsupported in AP mode */
> -		if (wl->bss_type != BSS_TYPE_AP_BSS &&
> -		    wl->nvs->general_params.dual_mode_select)
> -			wl->enable_11a = true;
> -	}
> +		/* only the first part of the NVS needs to be uploaded */
> +		nvs_len = sizeof(nvs->nvs);
> +		nvs_ptr = (u8 *)nvs->nvs;
>  
> -	if (wl->nvs_len != sizeof(struct wl1271_nvs_file) &&
> -	    (wl->nvs_len != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
> -	     wl->enable_11a)) {
> -		wl1271_error("nvs size is not as expected: %zu != %zu",
> -			     wl->nvs_len, sizeof(struct wl1271_nvs_file));
> -		kfree(wl->nvs);
> -		wl->nvs = NULL;

Same thing here.  I have fixed these.

This was causing very bad behaviour when the NVS was with the wrong
size, because we were not setting wl->nvs to NULL, but were setting
wl->nvs_len to 0.


-- 
Cheers,
Luca.

