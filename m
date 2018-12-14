Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5210C67839
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 10:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2F7B2086D
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 10:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hMefluRT";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Fp4TaxzO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2F7B2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbeLNKJT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 05:09:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeLNKJT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 05:09:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9C4776071A; Fri, 14 Dec 2018 10:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544782157;
        bh=B5c9Wt8BAkdsF6juOWvpy2xtH/Fpekw3LrQ5W0skp+A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hMefluRTdNGjbpt54QRDAoFD3svJJq/7EugPaX+brIUoIiERFCSPItRQj+lQLozNl
         eR4KklZWf9gxwcXInmfO577rKZuIYnrOxT0Jlf0aMpcK/ep+u19oboo0aY0qxQQi9f
         WZT/zBYF3W++DcRVY6YCDvwenaICejzp8ft0rG98=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C312B600E2;
        Fri, 14 Dec 2018 10:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544782156;
        bh=B5c9Wt8BAkdsF6juOWvpy2xtH/Fpekw3LrQ5W0skp+A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Fp4TaxzOBQV6zxeYaedCb3QBnMW7XU3xFYRcBk0FlAdhf0q36vOVGaR7resRC6Tsk
         +iXHxpPBvgj+32SlIik9Wxy614sc5VNo7zK9HYH7a9T3JHARDUX5CEwXp6MhGxC+ko
         AG0F9U41um7EDNPprmoo/tWdnljCeB/pj9RETAtE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C312B600E2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, Rakesh Pillai <pillair@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Skip sending quiet mode cmd for WCN3990
References: <20181211053853.3557-1-govinds@codeaurora.org>
Date:   Fri, 14 Dec 2018 12:09:13 +0200
In-Reply-To: <20181211053853.3557-1-govinds@codeaurora.org> (Govind Singh's
        message of "Tue, 11 Dec 2018 11:08:53 +0530")
Message-ID: <87k1kcxvw6.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> writes:

> From: Rakesh Pillai <pillair@codeaurora.org>
>
> HL2.0 firmware does not support setting quiet mode.
> If the host driver sends the quiet mode setting
> command to the HL2.0 firmware, it crashes with the
> below signature.
>
> fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN RT:207a:PC=b001b4f0
>
> The quiet mode command support is exposed by the firmware
> via thermal throttle wmi service. Enable ath10k thermal
> support if thermal throttle wmi service bit is set.
> 10X firmware version supports this feature by default, hence
> set this service bit by default.
>
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

So this would also need testing with QCA988X or QCA9884 family of
devices, I don't think this patch would have worked as is.

> Co-developed-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>

I had few comments below which I fixed myself. I'll send v2 soon.

> @@ -2621,6 +2621,10 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
>  		goto err_hif_stop;
>  	}
>  
> +	if (test_bit(ATH10K_FW_FEATURE_WMI_10X,
> +		     ar->normal_mode_fw.fw_file.fw_features)) {
> +		set_bit(WMI_SERVICE_THERM_THROT, ar->wmi.svc_map);
> +	}

I don't think testing for ATH10K_FW_FEATURE_WMI_10X works, that's a
really old and deprecated flag. wmi_op_version should be more reliable.

Also I refactored this to it's own function.

>  	/* Some firmware revisions do not properly set up hardware rx filter
>  	 * registers.
>  	 *
> @@ -2919,11 +2923,13 @@ static void ath10k_core_register_work(struct work_struct *work)
>  		goto err_debug_destroy;
>  	}
>  
> -	status = ath10k_thermal_register(ar);
> -	if (status) {
> -		ath10k_err(ar, "could not register thermal device: %d\n",
> -			   status);
> -		goto err_spectral_destroy;
> +	if (test_bit(WMI_SERVICE_THERM_THROT, ar->wmi.svc_map)) {
> +		status = ath10k_thermal_register(ar);
> +		if (status) {
> +			ath10k_err(ar, "could not register thermal device: %d\n",
> +				   status);
> +			goto err_spectral_destroy;
> +		}
>  	}

The code becomes cleaner if the test is in thermal.c so I moved it
there.

> @@ -2964,7 +2970,8 @@ void ath10k_core_unregister(struct ath10k *ar)
>  	if (!test_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags))
>  		return;
>  
> -	ath10k_thermal_unregister(ar);
> +	if (test_bit(WMI_SERVICE_THERM_THROT, ar->wmi.svc_map))
> +		ath10k_thermal_unregister(ar);

Same here.

> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4800,7 +4800,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
>  	ath10k_regd_update(ar);
>  
>  	ath10k_spectral_start(ar);
> -	ath10k_thermal_set_throttling(ar);
> +	if (test_bit(WMI_SERVICE_THERM_THROT, ar->wmi.svc_map))
> +		ath10k_thermal_set_throttling(ar);

And here.

-- 
Kalle Valo
