Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5B9C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B93D20854
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BQOzPyZl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfCRK4V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 06:56:21 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43141 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbfCRK4V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 06:56:21 -0400
Received: by mail-ed1-f68.google.com with SMTP id m35so13080542ede.10
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2019 03:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fg9XGFx+cMW1j23PuggYf46UOdL/83iJlE6ambkU7+o=;
        b=BQOzPyZl5vXCU4enKhhZkYTC84GTD93d76wq4oQTnsS172Nf6i2S4osr6zjG5D2aXi
         T4LpGO2UZRkBICZ56lloPdlI45SgiokLPD/7QhImUAVn0hcHveqbszQH+PD1pSY7PcwI
         YrNlEid4kj0iAjKMPqkSFIdBM5BuFVeBGazIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fg9XGFx+cMW1j23PuggYf46UOdL/83iJlE6ambkU7+o=;
        b=rrmgIIAwKh1cg71ItGUiHE8Kg/9uJDYUBLRZ1KW0G0EvECN5Pd7rW4iogxSrXS8WNr
         b8SjeqkFqVvn76rdcHJgNiCtTjx6NfQdPW/VFMlRKfxG8l1vOFMnfRTHxZbr7Fo0FsbB
         lU4tWNMGXr9A0O/SBXfGcal2ZIZBLmUURpsXMI+t35lS06rNc4F0DqIUdfU4j85eLgEi
         GWvO80TzkAv1UMQiaLBiWoz8T01Jko7vACUW7LZ/vdZk65a4RZUZlNcFx2HkD1DXnf1A
         kdl43JxeMXlXgluhzCeq0HMH4/nXvMt9Dihdr6LkIR1RECNwcbePfH814KndP/fJI4L3
         G0xw==
X-Gm-Message-State: APjAAAXkXColQcBvELftU9I8+I7sB52ogYAQVegO/FQZ7CTsgQrMTna1
        KjoTynL8iqu3m91pFwWIoF8gSg==
X-Google-Smtp-Source: APXvYqxInYcZUOkCQB1SU1/suYMyBicxg3Wu2Jxh84Deg4EaUfUARNbpw7qC2VNNhaRh4JQTs2avzg==
X-Received: by 2002:a17:906:54b:: with SMTP id k11mr10771913eja.131.1552906579212;
        Mon, 18 Mar 2019 03:56:19 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j14sm946107ede.46.2019.03.18.03.56.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Mar 2019 03:56:18 -0700 (PDT)
Subject: Re: [PATCH 05/11] mac80211_hwsim: set p2p device interface support
 indication
To:     Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <20190315153907.16192-1-luca@coelho.fi>
 <20190315153907.16192-6-luca@coelho.fi>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0131c436-2077-ddff-63be-678f8d6a623a@broadcom.com>
Date:   Mon, 18 Mar 2019 11:56:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190315153907.16192-6-luca@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/15/2019 4:39 PM, Luca Coelho wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> P2P device interface type was not indicated in the supported
> interface types even when hwsim was configured with p2p device
> support. Fix it.

Just wondering. Doesn't this affect the hwsim-based tests in wpa_supp? 
Or is that the intent behind this patch.

Regards,
Arend

> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>   drivers/net/wireless/mac80211_hwsim.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 0838af04d681..d79f3ee2a741 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -3894,6 +3894,8 @@ static int __init init_mac80211_hwsim(void)
>   		param.p2p_device = support_p2p_device;
>   		param.use_chanctx = channels > 1;
>   		param.iftypes = HWSIM_IFTYPE_SUPPORT_MASK;
> +		if (param.p2p_device)
> +			param.iftypes |= BIT(NL80211_IFTYPE_P2P_DEVICE);
>   
>   		err = mac80211_hwsim_new_radio(NULL, &param);
>   		if (err < 0)
> 
