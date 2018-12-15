Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C175EC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 11:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88F44206A2
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 11:07:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hnxraO33"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbeLOLHA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 06:07:00 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36400 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729077AbeLOLHA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 06:07:00 -0500
Received: by mail-ed1-f65.google.com with SMTP id f23so7003491edb.3
        for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2018 03:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gtS4XiN1thksVMtFaVcCxCJci9vw7suP9rhNfNvpvtI=;
        b=hnxraO338oC7caQXf3uRPkQXiXJijSmfN8p2VDN8Dl60DtrjOh4Ro1nMo9k2O8GH+3
         wABdehxrjXyA4Re1nWACARf5/oDv+VbqGcPBiafmbeE3ga/bz3tJfV8QebZiihNQwa/p
         QynGvcQOFYX43WZy7FOaY2r3TpP+fjXiaOHwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gtS4XiN1thksVMtFaVcCxCJci9vw7suP9rhNfNvpvtI=;
        b=TOJhjJ8U0oKC7ZZYcWDpyvMqMYdJsOlYbnPcTec/bTTCrjxjU3glFtRNBbLzlfOM4e
         OLWooYI+LzkN9R/AUrgyzWavucC89ffqsdkUE0ZUu7D6ern2puyTMQBBg/scrzNA/qTO
         pVrGW0r5MmbN5gw1hkJKrIKlXB0K67DUMOtLmwbk0j5+chsE8DHdH5V9GOyLZ8tT4pWj
         pQzPTgo/T47AlMMxQ0+iZv2q2eqwElJk4JgmGjM4cIyHIFY4HEoPVFoX5AVHoV1Ekdgs
         AXVETEj9p0Z9loBXUUuzyNHQUPvsJKV2+PysC6XbRyMh6XZXMmm9mr4yY2uVf/wuGAp0
         mqNA==
X-Gm-Message-State: AA+aEWaKGu1hAN6OQgs+8I+zndezqGwokmZhhhk92Pb+W6I5cLXEvDQ0
        vdzh1KDIhURmDM6LS0jCScJhMA==
X-Google-Smtp-Source: AFSGD/W04dl9UxkATI1mDbHxV2XdptV1hoI0NW/F8aiSYiL4g7cCkysWXnGZ7FjJGeF47tQiARHzhg==
X-Received: by 2002:a17:906:a984:: with SMTP id jr4-v6mr4820316ejb.90.1544872018461;
        Sat, 15 Dec 2018 03:06:58 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id k31sm2266956ede.5.2018.12.15.03.06.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Dec 2018 03:06:57 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Fix access point mode
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
References: <1544642406-24272-1-git-send-email-stefan.wahren@i2se.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e0a0b249-eb3e-7284-1a99-1c4fc5683850@broadcom.com>
Date:   Sat, 15 Dec 2018 12:06:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <1544642406-24272-1-git-send-email-stefan.wahren@i2se.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 12/12/2018 8:20 PM, Stefan Wahren wrote:
> Since commit 1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")
> the Raspberry Pi 3 A+ (BCM43455) isn't able to operate in AP mode with
> hostapd (device_ap_sme=1 use_monitor=0):
> 
> brcmfmac: brcmf_cfg80211_stop_ap: setting AP mode failed -52
> 
> So add the missing mgmt_stypes for AP mode to fix this.
> 
> Fixes: 1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")
> Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks for submitting this patch.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 7f0a5ba..05bd818 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6309,6 +6309,16 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
>   		.tx = 0xffff,
>   		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
>   		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
> +	},
> +	[NL80211_IFTYPE_AP] = {
> +		.tx = 0xffff,
> +		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
> +		      BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
> +		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
> +		      BIT(IEEE80211_STYPE_DISASSOC >> 4) |
> +		      BIT(IEEE80211_STYPE_AUTH >> 4) |
> +		      BIT(IEEE80211_STYPE_DEAUTH >> 4) |
> +		      BIT(IEEE80211_STYPE_ACTION >> 4)
>   	}
>   };
>   
> 
