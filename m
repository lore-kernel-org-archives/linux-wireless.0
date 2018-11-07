Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C068EC0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 21:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 573E820827
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 21:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Pc5xtqL4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 573E820827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbeKHGfY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 01:35:24 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:40745 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbeKHGfY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 01:35:24 -0500
Received: by mail-yw1-f66.google.com with SMTP id l66-v6so6766624ywl.7
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2018 13:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ny2lqYUacchYDk2DXAj3wCO3ajEzQYwdNCxmVLPWkZ8=;
        b=Pc5xtqL4sKYROcCzLhg/fpQJhg5vl2mnBhIHfuPDgvcNw3XRw1xjoCIumNe3S9pkvr
         a7EWLuRN1lkV+yHt6k1apWurfEgIPD4LQYPSfXKG17t6aFEing/ryUhEA3QBZ/TKyTic
         qmZXoxnaUOn0lmqoe2MdxfGB2Oa+10hMme/XU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ny2lqYUacchYDk2DXAj3wCO3ajEzQYwdNCxmVLPWkZ8=;
        b=l86oZbZ8ZFM26K3bINqZNH0hUMvq8i5DExsp28HQ41qBIbJV1OifM/7K9DxbvisR1y
         XSC7ALUXjoGByqgJmN4vb1v7U88+oNrQgiSyT+e40/jFfvpEGFSOXpKem/A4hNdKa4Qi
         Crb3DxTNXwVclNFA22ynnaVgxafGnJt6SV+J92+sZM1z2zJoG2CmfPaxaq0EAKAwdsds
         dVtm0yz/gbFXPhVVosHeLEDA9Dto4zz2q8JY9O2Cy704vIQdC9ybVB0emFsFnD/JMSMN
         SUoLlbaPXoQYJtFXFR+wJ/JLeHfgdfyF2KNQKScpMncD8xEr0craD3NkQGlxr9gG5KS0
         1w5Q==
X-Gm-Message-State: AGRZ1gJ8uUML9wIAitE1AFPa8dSDUTClg9ndrA/WT658ijkCtrGaWHFB
        LVoft0Kv0NmfaZxuqKluMgu/ig==
X-Google-Smtp-Source: AJdET5eRUM1k1XqltSOShbRLu49uYFDfH2JtnbgY9P8H/zjEjkpAvds1n7KbtoIKTJJK4sN6+C9LYQ==
X-Received: by 2002:a81:d88:: with SMTP id 130-v6mr1868046ywn.251.1541624594910;
        Wed, 07 Nov 2018 13:03:14 -0800 (PST)
Received: from [10.177.251.110] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id f68-v6sm394247ywd.85.2018.11.07.13.03.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Nov 2018 13:03:14 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: support STA info struct v7
To:     Dan Haab <riproute@gmail.com>, Kalle Valo <kvalo@codeaurora.org>
References: <1539289141-13689-1-git-send-email-dan.haab@luxul.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Dan Haab <dan.haab@luxul.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d4de8ccb-0de9-bf55-53d9-79f3d5f7df4e@broadcom.com>
Date:   Wed, 7 Nov 2018 22:03:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1539289141-13689-1-git-send-email-dan.haab@luxul.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/11/2018 10:19 PM, Dan Haab wrote:
> The newest firmwares provide STA info using v7 of the struct. As v7
> isn't backward compatible, a union is needed.
>
> Even though brcmfmac does not use any of the new info it's important to
> provide the proper struct buffer. Without this change new firmwares will
> fallback to the very limited v3 instead of something in between such as
> v4.
>
> Signed-off-by: Dan Haab <dan.haab@luxul.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 39 ++++++++++++++++++----
>  1 file changed, 32 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
> index d5bb81e..189d576 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
> @@ -176,6 +176,8 @@
>
>  #define BRCMF_VHT_CAP_MCS_MAP_NSS_MAX	8
>
> +#define BRCMF_HE_CAP_MCS_MAP_NSS_MAX	8
> +
>  /* MAX_CHUNK_LEN is the maximum length for data passing to firmware in each
>   * ioctl. It is relatively small because firmware has small maximum size input
>   * playload restriction for ioctls.
> @@ -601,13 +603,36 @@ struct brcmf_sta_info_le {
>  	__le32 rx_pkts_retried;        /* # rx with retry bit set */
>  	__le32 tx_rate_fallback;       /* lowest fallback TX rate */
>
> -	/* Fields valid for ver >= 5 */
> -	struct {
> -		__le32 count;					/* # rates in this set */
> -		u8 rates[BRCMF_MAXRATES_IN_SET];		/* rates in 500kbps units w/hi bit set if basic */
> -		u8 mcs[BRCMF_MCSSET_LEN];			/* supported mcs index bit map */
> -		__le16 vht_mcs[BRCMF_VHT_CAP_MCS_MAP_NSS_MAX];	/* supported mcs index bit map per nss */
> -	} rateset_adv;
> +	union {
> +		struct {
> +			struct {
> +				__le32 count;					/* # rates in this set */
> +				u8 rates[BRCMF_MAXRATES_IN_SET];		/* rates in 500kbps units w/hi bit set if basic */
> +				u8 mcs[BRCMF_MCSSET_LEN];			/* supported mcs index bit map */
> +				__le16 vht_mcs[BRCMF_VHT_CAP_MCS_MAP_NSS_MAX];	/* supported mcs index bit map per nss */
> +			} rateset_adv;
> +		} v5;
> +
> +		struct {
> +			__le32 rx_dur_total;	/* total user RX duration (estimated) */
> +			__le16 chanspec;	/** chanspec this sta is on */
> +			__le16 pad;

Here we add explicity padding field.

> +			struct {
> +				__le16 version;					/* version */
> +				__le16 len;					/* length */
> +				__le32 count;					/* # rates in this set */
> +				u8 rates[BRCMF_MAXRATES_IN_SET];		/* rates in 500kbps units w/hi bit set if basic */
> +				u8 mcs[BRCMF_MCSSET_LEN];			/* supported mcs index bit map */
> +				__le16 vht_mcs[BRCMF_VHT_CAP_MCS_MAP_NSS_MAX];	/* supported mcs index bit map per nss */
> +				__le16 he_mcs[BRCMF_HE_CAP_MCS_MAP_NSS_MAX];	/* supported he mcs index bit map per nss */
> +			} rateset_adv;		/* rateset along with mcs index bitmap */
> +			__le16 wpauth;		/* authentication type */
> +			u8 algo;		/* crypto algorithm */

So I prefer to have padding explicit here as well, ie. a u8 field.

> +			__le32 tx_rspec;	/* Rate of last successful tx frame */
> +			__le32 rx_rspec;	/* Rate of last successful rx frame */
> +			__le32 wnm_cap;		/* wnm capabilities */
> +		} v7;
> +	};
>  };

Regards,
Arend

