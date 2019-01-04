Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42319C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 11:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12A8A205F4
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 11:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eO0DYF85"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfADLKG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 06:10:06 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:32839 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbfADLKG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 06:10:06 -0500
Received: by mail-yb1-f194.google.com with SMTP id o73so6682891ybc.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2019 03:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YMEy76GUCv9HIEhJwkX8JxBwhY49ol7GLY41KBkxnFY=;
        b=eO0DYF85mi8SJnDh0+5WpOq7c1bZh+kX8p7a5lH1FNG+c+mDp0FvWv4Q35rMEy5/Pi
         FlfqSL89ZtWPIJmZQM2sBc3VsL5q0z+rSH79TS9mRYxRB9H+ZA5jmVxrdZoqu0JSLQVI
         qaQCLL0AWBdzlkLQk9k0XmQ8NbyXt5S0jfNNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YMEy76GUCv9HIEhJwkX8JxBwhY49ol7GLY41KBkxnFY=;
        b=RquiFd7gmC9u2GH2VZRTLxabqrZQPte9Gk2Hyxz9ehs2u0xyPEQRzRCHxQ1PMhf5//
         VL5w0ZAwwdCqIINOYUPD4RRJ5YiuI6HpG23BVPnwnk2I/a5aAIaY3K42G6MLty9NsNxg
         /UCw1/TAOQhrl6diw1DGJv9Ub9KkZB1pbZ82yuIlhXSe5020U5umSWe+XdtCCOywWDx7
         VBxDWq9kguC+hVZ++V8Nj6UIr91FdGRJiy9r+JC1UuLglBuKNS+FrMS2BrcpVkddrfqI
         k06ztknLElPhCaWgop1lD5ezSMOw/oX4TXEly/2nAhpYrbwCaS1rgk7jmjpYgealqeRe
         /7fw==
X-Gm-Message-State: AJcUukfFlha104HfCzGVv5ShIgWQuwqSUbJ/BOHnwLsNGFBhsw57WHXe
        fMGe+vkd8zlBbNX39Y08ioipig==
X-Google-Smtp-Source: ALg8bN5nccMrfSUU9fdaS/Jl/cdetODN5+mj61jjShEMem6YMNx2cCAwAUNKopKMD0XfezN01yDpng==
X-Received: by 2002:a25:ca08:: with SMTP id a8mr51585767ybg.127.1546600204689;
        Fri, 04 Jan 2019 03:10:04 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id x133sm4220970ywg.57.2019.01.04.03.10.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jan 2019 03:10:04 -0800 (PST)
Subject: Re: [PATCH 5/6] cfg80211: add support for SAE authentication offload
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanley Hsu <Stanley.Hsu@cypress.com>
References: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
 <1546582221-143220-5-git-send-email-chi-hsien.lin@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6c17fb65-d070-51d5-17cf-4d6788e8cbcb@broadcom.com>
Date:   Fri, 4 Jan 2019 12:10:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <1546582221-143220-5-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/4/2019 7:11 AM, Chi-Hsien Lin wrote:
> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> Let drivers advertise support for station-mode SAE authentication
> offload with a new NL80211_EXT_FEATURE_SAE_OFFLOAD flag.

When touching nl80211 api I prefer 'nl80211:' prefix instead of 'cfg80211:'.

> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>   include/linux/ieee80211.h    |  1 +
>   include/net/cfg80211.h       |  5 +++++
>   include/uapi/linux/nl80211.h | 16 ++++++++++++++++
>   net/wireless/nl80211.c       | 14 ++++++++++++++
>   4 files changed, 36 insertions(+)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 3b04e72315e1..37d3e655e547 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -2596,6 +2596,7 @@ enum ieee80211_key_len {
>   #define FILS_ERP_MAX_RRK_LEN		64
>   
>   #define PMK_MAX_LEN			64
> +#define SAE_PASSWORD_MAX_LEN		128
>   
>   /* Public action codes (IEEE Std 802.11-2016, 9.6.8.1, Table 9-307) */
>   enum ieee80211_pub_actioncode {
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index e0c41eb1c860..5809dac97b33 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -740,6 +740,9 @@ struct survey_info {
>    *	CFG80211_MAX_WEP_KEYS WEP keys
>    * @wep_tx_key: key index (0..3) of the default TX static WEP key
>    * @psk: PSK (for devices supporting 4-way-handshake offload)
> + * @sae_pwd: password for SAE authentication (for devices supporting SAE
> + *	offload)
> + * @sae_pwd_len: length of SAE password (for devices supporting SAE offload)
>    */
>   struct cfg80211_crypto_settings {
>   	u32 wpa_versions;
> @@ -755,6 +758,8 @@ struct cfg80211_crypto_settings {
>   	struct key_params *wep_keys;
>   	int wep_tx_key;
>   	const u8 *psk;
> +	const u8 *sae_pwd;
> +	u16 sae_pwd_len;

Not really need u16 as max length is defined earlier as 128.

>   };
>   
>   /**
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 12762afb3a07..4840aaed39ba 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -235,6 +235,15 @@
>    */
>   
>   /**
> + * DOC: SAE authentication offload
> + *
> + * By setting @NL80211_EXT_FEATURE_SAE_OFFLOAD flag drivers can indicate they
> + * support offloading SAE authentication for WPA3-Personal networks. In
> + * %NL80211_CMD_CONNECT the password for SAE should be specified using
> + * %NL80211_ATTR_SAE_PASSWORD.
> + */
> +
> +/**
>    * enum nl80211_commands - supported nl80211 commands
>    *
>    * @NL80211_CMD_UNSPEC: unspecified command to catch errors
> @@ -2288,6 +2297,9 @@ enum nl80211_commands {
>    *
>    * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
>    *	statistics, see &enum nl80211_ftm_responder_stats.
> + * @NL80211_ATTR_SAE_PASSWORD: attribute for passing SAE password material. It
> + *	is used with %NL80211_CMD_CONNECT to provide password for offloading
> + *	SAE authentication for WPA3-Personal networks.
>    *
>    * @NL80211_ATTR_TIMEOUT: Timeout for the given operation in milliseconds (u32),
>    *	if the attribute is not given no timeout is requested. Note that 0 is an
> @@ -2743,6 +2755,7 @@ enum nl80211_attrs {
>   	NL80211_ATTR_FTM_RESPONDER,
>   
>   	NL80211_ATTR_FTM_RESPONDER_STATS,
> +	NL80211_ATTR_SAE_PASSWORD,

Marcel already commented on this. These enumerations are ABI. You should 
also change the nl80211_policy to assure the max length 
SAE_PASSWORD_MAX_LEN is not exceeded.

Gr. AvS
