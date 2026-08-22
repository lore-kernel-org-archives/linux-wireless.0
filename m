Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8645417A586
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 18:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787423821; cv=none; b=CRPeW3w+8rja3IloWe8iAxq4E8lySHeqVBDxzb+kFi3/a+vaHxJg6RwWk85k8ggn5aLmlKUnOAD7ZQylGzqhIaU6IXmATaRGvz0A1hQgHre2REoRXwozCMYCyI3CykdX0wsH2pehfq5J+EteHAN+3fPzm0Edae1WgyAwRktiOjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787423821; c=relaxed/simple;
	bh=/bLgPtanEHCqRSINFQyyFks+a32vTas2v53/QbfupqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K13n4OupW8IUPRySX+q9lPvTAkjmHZudR8TBt5j/I7eHfsoVg09tU+ajjXHjhqnDVtAw1QYV7HAlo0PCDVIyxHkT2h0aO9F6sYINWAbxG9NSS9oiFf6TKlzRkv1e+ZyLmlj30CeYWLEIIzq8Vec99vpAjdSQMXIO5aECZ+1KL0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FBATxQrN; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FBATxQrN"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-848743155bcso737744b3a.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 11:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787423820; x=1788028620;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0BrUF3YDllozzZMX6EDMXsk/rZCZ4fUUH57/usEwGdc=;
        b=PowtcvUmpVThg323U2gXytz3RlHn9TsI5jwwbSshi8KexmQoMCu18YTLxVn3VOky9m
         6GrGgM5aLZr+K8wHYGqSNS3/bS6RIReVxJKuMjHrz0NKmDc+X+FUgRRtW9jVr/+fiVKB
         OJnNfCadvLf+O3gpjZEMCO9dwlnViLZgItye9vCuE6ViUMRsgp2XtMv2pxnbF/Qlfj5Y
         FIvuj6Lf3DljQVfKlOLreAkmTm/wg2Dx8XRxiFF9S6/+HbVVmgP1/yKLr76G01+4pXaS
         HZtZwCueZ2PB1q98OgOfgdXbIhRoUtMSnsn+yZu34SnEWgPak9KacBjMWhACsyPUSAtc
         8Hag==
X-Forwarded-Encrypted: i=1; AHgh+RrwxlhinFhM8I58+UJ/GokqTvtIVEcknP7ka3hoColX+S0QjUR5SSJFROvkTK8rujr1PWSt2xOB9z78OZ3XrQ==@vger.kernel.org
X-Gm-Message-State: AFuF++ngHMkW7tCVNK2pBCWFL9tmy/A5Y27XLK7ymaM6rrwtx2ZrfruS
	wU6dS34dd0FuuSmFqRZdrTuVguR31FXmFrVfnruM8uxrg34VRvRQ5U1K8TAPOdMbPTwO4M7J8tB
	HkSEXHKFORo3e/GFDH8566rO2PKE20c2uXtjXbPmu6frv6I7VdpTRlPUeOqvUG4P8gENk/lEPwC
	mTMh942UNjuhREFkLeqf5vsaHXmusZrKw2/7R1bA/fAaZdLk2n2rLB0FNLuSyyK3eifqpgqm5cv
	8VT589L5NqGevGMGAehRUiopcyp
X-Gm-Gg: AR+sD13mhEBqdUXZmJVZF/sH12tKXPt3H+ETESSfEPFa5fQXOHZbRk9qtzf9CW7krGv
	+lz8W21b5T6UWacLzl5ZHvEUtqIs5iQVoZjQNGD7xWE0N1g8P+RS71l4NLZhqTX8zXOp2hGX6UF
	vOr9YtPgJH8FrFKiPsnQpHnFnPIK65Io2x6XBx0pQ0nfnBm4uJ3PBgr74bM0CdxN1SS5yYngmDq
	NSELEVsdF/tCZUBOpcAVc/SgUhn5jdvLtMowIdk7jWH964MT/nvahfOYj0w06shzoYgEblFY4jU
	V+0wxpzPCXVEIyLiAURK3v2CalUtuEUHcGw5jjIuyz8aLvlM+7fgDnm68pQxjsntQh3ryMr1FDh
	RnKKbAGF1+YTQsmGO562WGwDHv0UwEMXbjEKgkN8pM9PiKHKnJRscenM2dfWKJk98FKNYcJMQo/
	YmAnAvFv/+tIsnjtLqZ0MuLkrdsJ3VrnTHlw0/nOM=
X-Received: by 2002:a05:6a00:174b:b0:851:c1d2:c48d with SMTP id d2e1a72fcca58-851f9884ce7mr21920839b3a.8.1787423819806;
        Sat, 22 Aug 2026 11:36:59 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-85210950706sm1076118b3a.4.2026.08.22.11.36.59
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Aug 2026 11:36:59 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cf7dd9fd91so22318475ad.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 11:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787423818; x=1788028618; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0BrUF3YDllozzZMX6EDMXsk/rZCZ4fUUH57/usEwGdc=;
        b=FBATxQrNwQIumEodLFvPWlksPnR7+wwj8AW0cWdkekGU6Lu5ktj3P9pvmlvCfi0i9z
         SclTUbQg44hyBktxb51UoafV1Mwc5bKMB5jI9vZB1+8EC2TdDAgUIsV2LuTKS2Re+Aa1
         QlhZ2jRLA51qMSyYY/oS/MiKYj6V/pk4MXlaI=
X-Forwarded-Encrypted: i=1; AHgh+RqxV4JEQimD3JuPG5EZHduX+cpCGaA/4yem66W+eyQqUPTMMfPft3MxfuqEP2tqhvdHw0vfcJf7dg84jUQ6RA==@vger.kernel.org
X-Received: by 2002:a17:903:3804:b0:2cc:777f:d67c with SMTP id d9443c01a7336-2d64b0c5704mr294200555ad.13.1787423817772;
        Sat, 22 Aug 2026 11:36:57 -0700 (PDT)
X-Received: by 2002:a17:903:3804:b0:2cc:777f:d67c with SMTP id d9443c01a7336-2d64b0c5704mr294199955ad.13.1787423817307;
        Sat, 22 Aug 2026 11:36:57 -0700 (PDT)
Received: from [10.229.42.78] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f90c0dd3sm9258201eec.7.2026.08.22.11.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2026 11:36:56 -0700 (PDT)
Message-ID: <382c3dbb-ff32-4e62-9b79-c6e4cc6273ef@broadcom.com>
Date: Sat, 22 Aug 2026 20:36:53 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] wifi: nl80211: add roam offload extended feature
To: Jason Huang <Jason.Huang2@infineon.com>, linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com, johannes@sipsolutions.net,
 hsin-hung.li@cypress.com, linux-kernel@vger.kernel.org,
 brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 wlan-kernel-dev-list@infineon.com, jeff.johnson@oss.qualcomm.com,
 Carella Chen <carella.chen@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
 <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-1-eeab4fda0f31@infineon.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-1-eeab4fda0f31@infineon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 21/08/2026 09:56, Jason Huang wrote:
> From: Carella Chen <carella.chen@infineon.com>
> 
> Drivers can offload FT or OKC roaming without necessarily
> advertising full 802.1X 4-way handshake offload. Add an extended
> feature bit for that capability and allow PMK configuration when it is
> present.
> 
> This gives userspace a way to provide PMK or PMK-R0 material needed
> by firmware roaming implementations while keeping the existing 4-way
> handshake offload capability unchanged.
> 
> Assisted-by: GitHub-Copilot-CLI:gpt-5.5
> Signed-off-by: Carella Chen <carella.chen@infineon.com>
> Signed-off-by: Jason Huang <jason.huang2@infineon.com>
> ---
>   include/uapi/linux/nl80211.h | 4 ++++
>   net/wireless/nl80211.c       | 7 +++++--
>   2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 020387d76412..9f8d9e3d5990 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -7110,6 +7110,9 @@ enum nl80211_feature_flags {
>    * @NL80211_EXT_FEATURE_PROBE_AP: Driver supports probing the associated AP
>    *	in STA mode using @NL80211_CMD_PROBE_PEER.
>    *
> + * @NL80211_EXT_FEATURE_ROAM_OFFLOAD: Driver supports Fast Transition or

Please call it NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD or simply 
_FAST_ROAMING if the name is getting too long. As long as it is
clear this is not for regular roaming scenario.

> + *	Opportunistic Key Caching roaming offload in station mode.
> + *
>    * @NUM_NL80211_EXT_FEATURES: number of extended features.
>    * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
>    */
> @@ -7192,6 +7195,7 @@ enum nl80211_ext_feature_index {
>   	NL80211_EXT_FEATURE_ROC_ADDR_FILTER,
>   	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
>   	NL80211_EXT_FEATURE_PROBE_AP,
> +	NL80211_EXT_FEATURE_ROAM_OFFLOAD,
>   
>   	/* add new features before the definition below */
>   	NUM_NL80211_EXT_FEATURES,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 44f2bad08670..15731440c57a 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -18434,6 +18434,7 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
>   static int nl80211_set_pmk(struct sk_buff *skb, struct genl_info *info)
>   {
>   	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct wiphy *wiphy = &rdev->wiphy;
>   	struct net_device *dev = info->user_ptr[1];
>   	struct wireless_dev *wdev = dev->ieee80211_ptr;
>   	struct cfg80211_pmk_conf pmk_conf = {};
> @@ -18442,8 +18443,10 @@ static int nl80211_set_pmk(struct sk_buff *skb, struct genl_info *info)
>   	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
>   		return -EOPNOTSUPP;
>   
> -	if (!wiphy_ext_feature_isset(&rdev->wiphy,
> -				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X))
> +	if (!wiphy_ext_feature_isset(wiphy,
> +				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X) &&
> +	    !wiphy_ext_feature_isset(wiphy,
> +				     NL80211_EXT_FEATURE_ROAM_OFFLOAD))

Ah. _FAST_ROAM_OFFLOAD is not longer than the other ext_feature checked 
here.

>   		return -EOPNOTSUPP;
>   
>   	if (!info->attrs[NL80211_ATTR_MAC] || !info->attrs[NL80211_ATTR_PMK])
> 
