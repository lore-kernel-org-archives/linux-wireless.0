Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B54235AC2F
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 09:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788081258; cv=none; b=Y+IgJXoSIf3JmEqiBB/oTZ7C3lKbnNJG6wk7WXqxUwFsqM8nZ7a3HQXcaOEjpDXRcU8Gjo3aMrAoma8r9rZNGTUHSWQxzRvTy7822k/9LqLLI2pEHCImk9KiYj48lxxUvNF8Jh3B0PJEazTYQXnX5Jj9rBUoVhv8ZX0mnHTz3/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788081258; c=relaxed/simple;
	bh=AqudLIf/iTthiXu19RutYAR2E41lgzFux0xXyzaNkSQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JawHgMGn/No796v3hW+jvy3LwGG5c8wQaNfiII7vdjy0llO6cn3cEzkix41xZ4y6fIcJUZwtltfPIn9bFNLw4l3Wxdcb2SKuL1Ru7FH92WXLlQ0Odq1MpdARtIJQuGIt2n4/PONW/C8SkN02dmB/jR0BRmEE7x7odJvp7enubUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KPT5ojkM; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KPT5ojkM"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc147d86bebso2763160a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 02:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788081256; x=1788686056;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=31p2j+a2MROOfrBQh9qdpbaoRZRWKQkLx8FBZclkpJw=;
        b=KFLl7smvUoEZLgetZVyfmgGpwrEbDGHFww1FfrVw0lNhyQu+YhaVpS0P9eqpN71go9
         yERl0MuyhMvv4b4MD8ISNihG5neU7u2ozrhb7p35PFlrLXhaxH+6OYUJ0J9U1y+hcKJo
         ANA7BHzzeKkultXFvgGfe1BNJN1vuVk02DI8jhNw8F1r/yuwNYnpEiprYhNUXDdXds4q
         yrUc7GJ8SGjZhe3WRhwdBmNBDSp0q/A67HDrBt+PNE0ViEgBXDaEl/bUQgQxiqTFEQrb
         8wXXwxJ2DNk9dPLihnIgZ8MjrzP6IqPOBEcviigPK5MH7bV1CJHXwCuzxtqkAuQeDvvz
         gx4Q==
X-Forwarded-Encrypted: i=1; AHgh+RrYGo4pCfYW11CEP3RLNY7JsPlRFqaWNxSFJeJxb3DBGaIP1/D514q+ZoRAIQg/KRbgDDdeiQ6HeLUncnSETw==@vger.kernel.org
X-Gm-Message-State: AFuF++llKO7cjJGqus/yc5WpZ1evkESehjLqtVEIEHCp3wzE/1i69I4Z
	6xfr4kHqigh9BmJSBM9cTnrwy+OkABrhqFafjD8QHcR/maIm6JBhCqQWeZx6PYYJqGvIiR5XW5G
	E0Ygm/7SirA2Ubh09szpwxxkp/ANPKQqvSwdtOQ9TDqTEoj/lIksjeQ+UBh7EazZZNJaU8poe7G
	GD1Mi4xb7+yxrGHMPiT3vwB4xf5nmqZQJxlkvEu/pLtKK4XsfxMmnWpMIiQBcc0GFqpoX3V8hFz
	/T4mVlaj9ykG03YtzqduZRX0kxVhV8=
X-Gm-Gg: AR+sD13GpYzoAQcOdVWo4M7CO1LKmgCevol8vg5VM/IdhmInq7ofoAQ7giesudtZ3eS
	HyS5o3bjzlPBURjWT+F1klK28nKQWpG8ABRetQQeBfSA++slPSTg+8rdg20mXHUXCgFO3fC6p24
	tiRjbT2POSKcSyw+1GI+6ualvbENjhrRrzE3+nsynu7MlaS4t/PfL7KiTubcA7Rwg+d5uDHjkcl
	Qc/hcQF6PYAwSUa8P2pYbS4qiOshFWMl4NGwVySuxEox03bakvRxFkGwcAjI0vcavRb74RceMmm
	jTqqV4GVf5yFg8/8GROd77mZU88gd7/Q+D4XWb524hiIu+Wzul7vF4aHyN26nQoZ8OEF7gdb2rx
	6D9x3fVmwm/J3rRLYug2W3zQVuVGPPeVvlwmsiiASYgSGBihpjBqOFNdDPDanTyCjnNyGv85VwQ
	3+0qK3j/zpDUeHadUqn0r3L7ivmHz/lYR3Xqx/
X-Received: by 2002:a05:6372:a70c:b0:3d3:aed2:6f26 with SMTP id adf61e73a8af0-3d5da1aa7cbmr687376637.26.1788081255791;
        Sun, 30 Aug 2026 02:14:15 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-1.dlp.protect.broadcom.com. [144.49.247.1])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc1f32dfcf5sm1410703a12.3.2026.08.30.02.14.15
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Aug 2026 02:14:15 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3968dfff779so1932513a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 02:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788081254; x=1788686054; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=31p2j+a2MROOfrBQh9qdpbaoRZRWKQkLx8FBZclkpJw=;
        b=KPT5ojkM8C5H4eoT8xeyI3sG53c0Fn5+wEAWMzWOEZgCVTmYw7/WNakgVunVgZtz/9
         h1u/jorHHK8HIrw8uWA03nZaZAEC89ogN77KZ2kIkg1Ru5hXzl4OVCpo1DHEb5HvUklS
         SMJp0YjFTToXHZBikL65XuF5NH9yZN/M5jBSE=
X-Forwarded-Encrypted: i=1; AKwUvByOgsu613RDH3M1KFGjaPKuexgs7OoEtd9iKjFeDBs1t4ABqMogA5IxIpGm+ul8NGX9XxkbKxC4zmsjOq8rVg==@vger.kernel.org
X-Received: by 2002:a17:90b:1a87:b0:398:c6e1:dceb with SMTP id 98e67ed59e1d1-398da61d56dmr1054575a91.9.1788081253892;
        Sun, 30 Aug 2026 02:14:13 -0700 (PDT)
X-Received: by 2002:a17:90b:1a87:b0:398:c6e1:dceb with SMTP id 98e67ed59e1d1-398da61d56dmr1054548a91.9.1788081253416;
        Sun, 30 Aug 2026 02:14:13 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0d2e465sm29855331c88.4.2026.08.30.02.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2026 02:14:12 -0700 (PDT)
Message-ID: <8a866e2b-8802-4a8e-8421-2732da5f5c8f@broadcom.com>
Date: Sun, 30 Aug 2026 11:14:09 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] wifi: nl80211: add roam offload extended feature
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Huang <Jason.Huang2@infineon.com>, linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com, johannes@sipsolutions.net,
 hsin-hung.li@cypress.com, linux-kernel@vger.kernel.org,
 brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 wlan-kernel-dev-list@infineon.com, jeff.johnson@oss.qualcomm.com,
 Carella Chen <carella.chen@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
 <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-1-eeab4fda0f31@infineon.com>
 <382c3dbb-ff32-4e62-9b79-c6e4cc6273ef@broadcom.com>
Content-Language: en-US
In-Reply-To: <382c3dbb-ff32-4e62-9b79-c6e4cc6273ef@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 22/08/2026 20:36, Arend van Spriel wrote:
> On 21/08/2026 09:56, Jason Huang wrote:
>> From: Carella Chen <carella.chen@infineon.com>
>>
>> Drivers can offload FT or OKC roaming without necessarily
>> advertising full 802.1X 4-way handshake offload. Add an extended
>> feature bit for that capability and allow PMK configuration when it is
>> present.
>>
>> This gives userspace a way to provide PMK or PMK-R0 material needed
>> by firmware roaming implementations while keeping the existing 4-way
>> handshake offload capability unchanged.
>>
>> Assisted-by: GitHub-Copilot-CLI:gpt-5.5
>> Signed-off-by: Carella Chen <carella.chen@infineon.com>
>> Signed-off-by: Jason Huang <jason.huang2@infineon.com>
>> ---
>>   include/uapi/linux/nl80211.h | 4 ++++
>>   net/wireless/nl80211.c       | 7 +++++--
>>   2 files changed, 9 insertions(+), 2 deletions(-)
>>

[...]

>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 44f2bad08670..15731440c57a 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -18434,6 +18434,7 @@ static int 
>> nl80211_set_multicast_to_unicast(struct sk_buff *skb,
>>   static int nl80211_set_pmk(struct sk_buff *skb, struct genl_info *info)
>>   {
>>       struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +    struct wiphy *wiphy = &rdev->wiphy;
>>       struct net_device *dev = info->user_ptr[1];
>>       struct wireless_dev *wdev = dev->ieee80211_ptr;
>>       struct cfg80211_pmk_conf pmk_conf = {};
>> @@ -18442,8 +18443,10 @@ static int nl80211_set_pmk(struct sk_buff 
>> *skb, struct genl_info *info)
>>           wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
>>           return -EOPNOTSUPP;
>> -    if (!wiphy_ext_feature_isset(&rdev->wiphy,
>> -                     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X))
>> +    if (!wiphy_ext_feature_isset(wiphy,
>> +                     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X) &&
>> +        !wiphy_ext_feature_isset(wiphy,
>> +                     NL80211_EXT_FEATURE_ROAM_OFFLOAD))
> 
> Ah. _FAST_ROAM_OFFLOAD is not longer than the other ext_feature checked 
> here.

Actually there is a checkpatch warning that line with the STA_1X check 
is 82 characters. So my suggestion please make it FAST_ROAMING instead 
of ROAM_OFFLOAD and swap the two checks to fix the checkpatch warning.

Regards,
Arend
