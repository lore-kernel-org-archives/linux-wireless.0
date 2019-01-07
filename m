Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1991BC43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 09:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB1ED20859
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 09:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RqDl7y/B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfAGJoF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 04:44:05 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41351 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfAGJoF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 04:44:05 -0500
Received: by mail-ed1-f68.google.com with SMTP id a20so218534edc.8
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 01:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C/fMIEDG6pD0SUouWNXUJzX9jfidGY+Mzw2jZChnCYE=;
        b=RqDl7y/BpuBSRZ8s0iS5oJcO5hnHd3ODOv7FAYJRVA6+qibNQ+NPvomV7qws/ht0Qn
         yTOhHGphUlOhtjMRydx1UmCiRp02fp2idp+Ye2H+99fPrSMfEgpdSu0mnl8XKIZmYoob
         22nteiYD3wsBiFZD7aI+dgAvl+V0Bq/q7sRSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C/fMIEDG6pD0SUouWNXUJzX9jfidGY+Mzw2jZChnCYE=;
        b=S9u8P70u+sj/FycoL/4o1yQXBPshq7TZddVYRP2rsXJzWABIpNQsujB4lF31+dmIHZ
         p+z+noKxGCaJOkbSeBsJrVbTvQUcsxk9xzXBuCB2yPtHh0GGC07SC+3/JuvvK8jhpKUT
         hIgySVnmvmnNl5y9knrWOC38iQMehn863NRhXPYC0aUjLXZ4s71zwR3vhhJf4wXttaLH
         M9VaXqephryv2z5CMRcvAkx7su2/BtQo1v1dl17AqeotBHReyxYS4f9Yt84mYOvJ3NmG
         YNbpj6i5nEuz3/bsyWNIKwi2hU71rg/zOQW5LGbhpE+YpI0HKM+9RmsGrwWjOp32EXCD
         G6Ww==
X-Gm-Message-State: AA+aEWasf/ySxSwAnBnUBpesFY5Zm/qk2sPD1ojk5Is1WEQ4jD6iskhJ
        +sFJxC5UtzWaIcuvYt5ubYvNgw==
X-Google-Smtp-Source: AFSGD/XepbjWxmqcPektUrewT4sBWZAg6vkMbAk9E1KTZdYWPevarL5El7nLQfenNsI98m4mEdqkSw==
X-Received: by 2002:a50:e3cb:: with SMTP id c11mr56203357edm.80.1546854243117;
        Mon, 07 Jan 2019 01:44:03 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id k26-v6sm18415818ejv.59.2019.01.07.01.44.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jan 2019 01:44:02 -0800 (PST)
Subject: Re: [PATCH 2/6] brcmfmac: send port authorized event for 802.1X 4-way
 handshake offload
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
 <1546582221-143220-2-git-send-email-chi-hsien.lin@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d89b1304-471d-f064-02f1-6a9fab0ca25d@broadcom.com>
Date:   Mon, 7 Jan 2019 10:44:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1546582221-143220-2-git-send-email-chi-hsien.lin@cypress.com>
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
> With 4-way handshake offload for 802.1X authentication, a port
> authorized event should be sent to user space after the completion of
> 4-way handshake. It is used to indicate that a connection is authorized
> and 802.1X authentication is no longer required.

It had been a while since I had looked at our offload code (basically 
since the initial implementation for the nl80211 work) so I was unsure 
why this would be needed.

So initially we added a PORT_AUTHORIZED *attribute* in the nl80211 api 
and later on the PORT_AUTHORIZED *event* was introduced and 4-way hs 
offload support in wpa_supplicant is ignoring the *attribute* and only 
handling the *event*. I think this information is important enough to 
add to this commit message with a reference to commit 503c1fb98ba3 
("cfg80211/nl80211: add a port authorized event") which "broke" the 
functionality in brcmfmac.

Some specific comments below...

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>   .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 23 +++++++++++++++-------
>   1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 35301237d435..ad0d775a1244 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5266,10 +5266,13 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif *vif,
>   	u32 event = e->event_code;
>   	u32 status = e->status;
>   
> -	if (vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_PSK &&
> -	    event == BRCMF_E_PSK_SUP &&
> -	    status == BRCMF_E_STATUS_FWSUP_COMPLETED)
> +	if (event == BRCMF_E_PSK_SUP &&
> +	    status == BRCMF_E_STATUS_FWSUP_COMPLETED) {
>   		set_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
> +		if (vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_1X)
> +			return true;
> +	}
> +

Here things get a bit tricky I think. The old behaviour was to wait for 
both PSK_SUP and SET_SSID events before calling cfg80211_connect_done(). 
If I recall correctly I did that because they can arrive in different 
order depending on the type of offload (1x or psk) but also depends on 
firmware build, so ....

>   	if (event == BRCMF_E_SET_SSID && status == BRCMF_E_STATUS_SUCCESS) {
>   		brcmf_dbg(CONN, "Processing set ssid\n");
>   		memcpy(vif->profile.bssid, e->addr, ETH_ALEN);
> @@ -5280,11 +5283,10 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif *vif,
>   	}
>   
>   	if (test_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state) &&
> -	    test_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state)) {
> -		clear_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
> -		clear_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state);
> +	    test_and_clear_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS,
> +			       &vif->sme_state))
>   		return true;
> -	}
> +
>   	return false;
>   }
>   
> @@ -5501,6 +5503,13 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
>   		brcmf_dbg(CONN, "Report connect result - connection %s\n",
>   			  completed ? "succeeded" : "failed");
>   	}
> +
> +	if (test_and_clear_bit(BRCMF_VIF_STATUS_EAP_SUCCESS,
> +			       &ifp->vif->sme_state) &&
> +	    profile->use_fwsup == BRCMF_PROFILE_FWSUP_1X) {
> +		cfg80211_port_authorized(ndev, profile->bssid, GFP_KERNEL);
> +		brcmf_dbg(CONN, "Report port authorized\n");
> +	}

I would leave the code in brcmf_is_linkup() as before and only check 
profile->use_fwsup here to determine whether cfg80211_port_authorized() 
should be called here.

>   	brcmf_dbg(TRACE, "Exit\n");
>   	return 0;
>   }
> 
