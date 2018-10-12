Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD5BC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36A9E2075B
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:02:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="etKCrt/P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36A9E2075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbeJLQdx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:33:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40857 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbeJLQdw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:33:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id r1-v6so10811481edd.7
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 02:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Y6m1KYvHfT5WN2f8THOIRZt3mMfO+iaZVsawt68rTC4=;
        b=etKCrt/PFyF3dG52DiO9iOGSOaGMwj0yTP6hUAZbOs0GwrFFnoI7tfPrTf0i7Egwad
         2sIuaLQ69taSp2lUR1oGiOJ6SwB6v4JNGRevT1OCDicZZJR+UziiAWGl7FhSx7KkDTGI
         IBACndhJORnvtQRIpp3io5atjBdehYDj2mySM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=Y6m1KYvHfT5WN2f8THOIRZt3mMfO+iaZVsawt68rTC4=;
        b=mmGm+GOlYiATugfsODjNOLrwfbQpFJERuV4XZhUhZKE0foKdDXQgNwq8G5fA6pcUk5
         Fsm/0zeZR5kWoU3Ig60Qb1a6jjByQDkL5QGy45OPO1MZEyPA94FGqUVd9hrug0Y7o3Tv
         bhUzs3Zx3AZIntAjWN4m8tLXSvPk9iTOs+Eij6XdskAeex/mlG444So/u//i3Ds0+mEn
         O+7jVYgiHdvpYyeU93RegUL86yn25DahnuwkKNZ/Rwyfn19YNB3LfyDoUQdQ4sef8Fc8
         EZ32YmTWNOQ5eGfCLzOAZBiL+h6Cd+LItRzfNYi2UV8bfRhwg0bB38GWds1xbDTBOaoo
         YD+w==
X-Gm-Message-State: ABuFfojw5SmvaP35Nnj86WGmeZFBlU4dMBFjj4QVcrKszLSSRf4FBwKP
        na9JFBbjkNBW7P6g0/3pRuuslg6BHOq6GA==
X-Google-Smtp-Source: ACcGV61a2Ne4DRcAjEFhtySNaS4VIYKl1arqSzN2LcF2Kky5qfzJ+6m5eYSosRDig4c4H+/osxVSSQ==
X-Received: by 2002:a50:d78b:: with SMTP id w11-v6mr8027181edi.19.1539334945027;
        Fri, 12 Oct 2018 02:02:25 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id i1-v6sm423492edg.3.2018.10.12.02.02.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 02:02:23 -0700 (PDT)
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
Message-ID: <cf6f8b8a-2638-7d32-d3b1-0fc21f74a0df@broadcom.com>
Date:   Fri, 12 Oct 2018 11:02:22 +0200
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

Hi Dan,

I don't have a real problem with adding this v7 stuff, but it looks 
different from what I have here which has additional fields. For what 
new firmwares and more importantly what devices do you need this. I only 
know it is used for 43684, which we do not support with brcmfmac (yet).

Regards,
Arend

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
> +			__le32 tx_rspec;	/* Rate of last successful tx frame */
> +			__le32 rx_rspec;	/* Rate of last successful rx frame */
> +			__le32 wnm_cap;		/* wnm capabilities */
> +		} v7;
> +	};
>  };
>
>  struct brcmf_chanspec_list {
>

