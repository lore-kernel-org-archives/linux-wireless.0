Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC951C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 12:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A7F72081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 12:31:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HaQeXG1q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A7F72081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbeKBViL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 17:38:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35752 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeKBViL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 17:38:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id q12-v6so1781402wmq.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 05:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ulDZLN/GdLZrQ/9nYAaONc7tW0Qz2moph6q4FUSarxw=;
        b=HaQeXG1q22+41k/IDm5V8wSgGnB8Aq6pWQDWdDeMd5ld1O4czNPk8MUGePgtBq3Mg0
         gvUlY/xCSd5BCAw5uahPAaO5Eh1Fk/9Cc9IzfFViy13VQgwRGtGikEQnklZtSP+qynjv
         Nkk9GqAmvG4zzcXMWzDXSVRD7fGWU+ekBrxtQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ulDZLN/GdLZrQ/9nYAaONc7tW0Qz2moph6q4FUSarxw=;
        b=eoVOhkmk7FZjcueq4jSFRaSmW8ZGubJdIddqQ+2GFPUcoeoGYbt9P8qSKDKlHG4eJU
         vMlNvTBL6XP4RnW1XY2BFjm6wLMQ69lwhKB5vEqCilHR4mz2mCPw64Su3qbJ1Wrr3jIT
         Ugas2MQ2SecYZWhPssKc6Kqxll6kA2QgveCn+H8asCXu+EbN6WWJWGHOSR1FJyaZFr/J
         ubCncij47gZcbJitv06zvbIJkhbQBxu1gH8UlsJ7bjSzjYcF58Wm8nnz+VfHyNxp4z+3
         gpvB6WulR/msmIGi5il9k2vOwGV6IG01TscEQRotzDkXdhFjt1GsYHh6bVE77Wscg5XZ
         X/+Q==
X-Gm-Message-State: AGRZ1gJDJuEBmnSGD2puFYnQ56mc2JEdb6BwC3qCaFe4RBdc8s39zrJI
        1vkfYlV+nGM9HJMYtOS7y6WUcm5TN6iqBg==
X-Google-Smtp-Source: AJdET5dyA9MKPn8z8yHkZSf4ohdgSsjzYBtC16NitP1Sxe9Ogf8sJY7rHLmciVb3gCsTXcOowTZqoQ==
X-Received: by 2002:a1c:a5d6:: with SMTP id o205-v6mr549464wme.89.1541161867060;
        Fri, 02 Nov 2018 05:31:07 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id z6-v6sm12627244wrs.19.2018.11.02.05.31.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 05:31:06 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] brcmfmac: make firmware frameburst mode a module
 parameter
To:     Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20181102082403.11676-1-wright.feng@cypress.com>
 <20181102082403.11676-3-wright.feng@cypress.com>
Cc:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e280f751-6ec7-02fb-34af-92e3779d933a@broadcom.com>
Date:   Fri, 2 Nov 2018 13:31:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181102082403.11676-3-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/2/2018 9:24 AM, Wright Feng wrote:
> This patch is for adding a new module parameter "frameburst".
> With setting "frameburst=1" in module parameters, firmware frameburst mode
> will be enabled. The feature can enable per-packet framebursting in
> firmware side and get higher TX throughput in High Throughput(HT) mode.

So why not always enable it in firmware as it seems to be the default in 
recent firmware anyway.

Regards,
Arend

> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 7 +++++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c  | 5 +++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h  | 2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h    | 1 +
>  4 files changed, 15 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 230a378c26fc..4a05d3f50cff 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6638,6 +6638,13 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
>
>  	brcmf_configure_arp_nd_offload(ifp, true);
>
> +	if (ifp->drvr->settings->frameburst) {
> +		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_FAKEFRAG, 1);
> +			if (err)
> +				brcmf_info("setting frameburst mode failed\n");
> +		brcmf_dbg(INFO, "frameburst mode enabled\n");
> +	}
> +
>  	cfg->dongle_up = true;
>  default_conf_out:
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 94044a7a6021..0ad4c3196e5d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -78,6 +78,10 @@ static int brcmf_iapp_enable;
>  module_param_named(iapp, brcmf_iapp_enable, int, 0);
>  MODULE_PARM_DESC(iapp, "Enable partial support for the obsoleted Inter-Access Point Protocol");
>
> +static int brcmf_frameburst;
> +module_param_named(frameburst, brcmf_frameburst, int, 0);
> +MODULE_PARM_DESC(frameburst, "Enable firmware frameburst feature");
> +
>  #ifdef DEBUG
>  /* always succeed brcmf_bus_started() */
>  static int brcmf_ignore_probe_fail;
> @@ -419,6 +423,7 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
>  	settings->fcmode = brcmf_fcmode;
>  	settings->roamoff = !!brcmf_roamoff;
>  	settings->iapp = !!brcmf_iapp_enable;
> +	settings->frameburst = !!brcmf_frameburst;
>  #ifdef DEBUG
>  	settings->ignore_probe_fail = !!brcmf_ignore_probe_fail;
>  #endif
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> index a34642cb4d2f..b91975258a68 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> @@ -47,6 +47,7 @@ extern struct brcmf_mp_global_t brcmf_mp_global;
>   * @feature_disable: Feature_disable bitmask.
>   * @fcmode: FWS flow control.
>   * @roamoff: Firmware roaming off?
> + * @frameburst: Firmware frame burst mode.
>   * @ignore_probe_fail: Ignore probe failure.
>   * @country_codes: If available, pointer to struct for translating country codes
>   * @bus: Bus specific platform data. Only SDIO at the mmoment.
> @@ -57,6 +58,7 @@ struct brcmf_mp_device {
>  	int		fcmode;
>  	bool		roamoff;
>  	bool		iapp;
> +	bool		frameburst;
>  	bool		ignore_probe_fail;
>  	struct brcmfmac_pd_cc *country_codes;
>  	union {
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
> index 63b1287e2e6d..b6b183b18413 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
> @@ -80,6 +80,7 @@
>  #define BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON	201
>  #define BRCMF_C_SET_ASSOC_PREFER		205
>  #define BRCMF_C_GET_VALID_CHANNELS		217
> +#define BRCMF_C_SET_FAKEFRAG			219
>  #define BRCMF_C_GET_KEY_PRIMARY			235
>  #define BRCMF_C_SET_KEY_PRIMARY			236
>  #define BRCMF_C_SET_SCAN_PASSIVE_TIME		258
>

