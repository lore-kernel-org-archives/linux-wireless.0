Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13BEC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644502054F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="f+ALq14V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfCLPUP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:20:15 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:59490 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfCLPUP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:20:15 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 66F877CD
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 15:20:13 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DcGHA_pXIMgB for <linux-wireless@vger.kernel.org>;
        Tue, 12 Mar 2019 10:20:13 -0500 (CDT)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 274B712B
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 10:20:13 -0500 (CDT)
Received: by mail-it1-f197.google.com with SMTP id r136so2496433ith.3
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 08:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=8gsSGvrhWQOMKFOJKLs0EMSL8Jnn2+NalFSIZty+4qI=;
        b=f+ALq14VAnEsH0FbbBKw/IGMTRa7k2uNGf6MAFjzMHTr4Ul5VP3PjRbDjhymd4Dir8
         wvb0eQ+caixT9hwTglin1YneyttUjQAkvRBYNTCOmnKrg5qk1r60TuLfq0hHKIPHBxb1
         KUqUuQZzLKQv/M8Os0yDN02lR9kwPap2Mzu2XxdnE5S2It9s7E1MQgSx1MO8tfTpIyai
         DHmF40fgJaAc3epK+QgYTy985YB7RR+U59KOHAN7kQIqvfU9GHVA1ogEUO1n3nHv9UII
         kuheS2NwqkzfVq5c0pKkdxv1bdc7WIutYqMJtDQN0yaED+kF24Wcarj0TfghxT+ADtB6
         cSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8gsSGvrhWQOMKFOJKLs0EMSL8Jnn2+NalFSIZty+4qI=;
        b=h/jtmTm1YH/9ug0c1nk5qyak5KBQlDq0v43db76xGYUHGDgqdrVV0CuKUaLUBhSnVJ
         6bp2mU1xT43ys2OhQHZE8rrdr8xFNlf/VOLStgT1RvGDROhTSe7P3lmRe8tiNKFrmK+O
         zLudswbLMe5nxpoNLm6YzjIqcdjsIe/XLql57mCRk3ygAiNLFgnySZBITSLERSHJyJQH
         jZ2bLS2OibiOWV1snxiAcp4kzjT/hDuYBEam7bNdxBmgI9Mhv5WTMLaz8AlmvFrUDS1Z
         Am6XvaE/+JZYG4HKNL4YcXKMVqNGaOhO2WMywPhv2HJlcIcLhHsD3t+T/k+1S2xZN/i5
         bv4g==
X-Gm-Message-State: APjAAAU26rGruQ4xV3Fwn8Ktt6VKF+YDD9H+fIXzUP56XWCMYn1Ami5V
        xPeOdHSSl9HcZYCTihH7RnvTlKxJtaGENqls7AcEH/DCw6mBMd8Ior/eeWioL5J7bP/9hMKcGLx
        5Ln0y2rJcYAr8i/30QSVpYTRVWgk4W/k=
X-Received: by 2002:a5e:dd43:: with SMTP id u3mr7691565iop.283.1552404012292;
        Tue, 12 Mar 2019 08:20:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxoQNYyWSCisVAgyabc+qJ4g4G4xeSgX3J/JVaPTLIf4xbWFhAW/yh1PkoxcUc6GCzbJ/hDLg==
X-Received: by 2002:a5e:dd43:: with SMTP id u3mr7691545iop.283.1552404011926;
        Tue, 12 Mar 2019 08:20:11 -0700 (PDT)
Received: from [128.101.106.63] (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id u13sm773155iog.80.2019.03.12.08.20.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 08:20:11 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: fix potential NULL pointer dereference
To:     pkshih@realtek.com, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
References: <20190312090648.30750-1-pkshih@realtek.com>
From:   Kangjie Lu <kjlu@umn.edu>
Message-ID: <a514c8f3-be50-c2c0-0712-fde98e52ffd4@umn.edu>
Date:   Tue, 12 Mar 2019 10:20:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190312090648.30750-1-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thanks for reporting the cases. There are still a few more such
cases; we will report them soon.

On 3/12/19 4:06 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
>
> In case dev_alloc_skb fails, the fix safely returns to avoid
> potential NULL pointer dereference.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c       | 2 ++
>   drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c | 2 ++
>   drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c       | 2 ++
>   drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c       | 2 ++
>   drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c       | 2 ++
>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c       | 4 ++++
>   6 files changed, 14 insertions(+)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
> index 203e7b574e84..e2e0bfbc24fe 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
> @@ -600,6 +600,8 @@ void rtl88e_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
>   		      u1rsvdpageloc, 3);
>   
>   	skb = dev_alloc_skb(totalpacketlen);
> +	if (!skb)
> +		return;
>   	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
>   
>   	rtstatus = rtl_cmd_send_packet(hw, skb);
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
> index 18c76990a089..86b1b88cc4ed 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
> @@ -623,6 +623,8 @@ void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
>   		      u1rsvdpageloc, 3);
>   
>   	skb = dev_alloc_skb(totalpacketlen);
> +	if (!skb)
> +		return;
>   	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
>   
>   	if (cmd_send_packet)
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> index 7c5b54b71a92..67305ce915ec 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> @@ -744,6 +744,8 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
>   		      u1rsvdpageloc, 3);
>   
>   	skb = dev_alloc_skb(totalpacketlen);
> +	if (!skb)
> +		return;
>   	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
>   
>   	rtstatus = rtl_cmd_send_packet(hw, skb);
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
> index be451a6f7dbe..33481232fad0 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
> @@ -448,6 +448,8 @@ void rtl8723e_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
>   		      u1rsvdpageloc, 3);
>   
>   	skb = dev_alloc_skb(totalpacketlen);
> +	if (!skb)
> +		return;
>   	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
>   
>   	rtstatus = rtl_cmd_send_packet(hw, skb);
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
> index 4d7fa27f55ca..aa56058af56e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
> @@ -562,6 +562,8 @@ void rtl8723be_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
>   		      u1rsvdpageloc, sizeof(u1rsvdpageloc));
>   
>   	skb = dev_alloc_skb(totalpacketlen);
> +	if (!skb)
> +		return;
>   	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
>   
>   	rtstatus = rtl_cmd_send_packet(hw, skb);
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
> index dc0eb692088f..fe32d397d287 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
> @@ -1623,6 +1623,8 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
>   		      &reserved_page_packet_8812[0], totalpacketlen);
>   
>   	skb = dev_alloc_skb(totalpacketlen);
> +	if (!skb)
> +		return;
>   	skb_put_data(skb, &reserved_page_packet_8812, totalpacketlen);
>   
>   	rtstatus = rtl_cmd_send_packet(hw, skb);
> @@ -1759,6 +1761,8 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
>   		      &reserved_page_packet_8821[0], totalpacketlen);
>   
>   	skb = dev_alloc_skb(totalpacketlen);
> +	if (!skb)
> +		return;
>   	skb_put_data(skb, &reserved_page_packet_8821, totalpacketlen);
>   
>   	rtstatus = rtl_cmd_send_packet(hw, skb);
