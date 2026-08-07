Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3038E2F3C0E
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 06:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786085232; cv=none; b=qHb/6StErVWfWI3YQMhiDJiYfAcbus/Nwy9f47FJ7lgs9CLRDEPl+9bk/5QkNeC6JYebrn+z5h3MgPrF2KKPPeeaY7Kfy3dzChpqjKcffHBVcZOAT7l8mcbXIPR65sFJ+v10jkkJu9//vPRIyto2hmNgO0Nee05jNH3/oAMjaHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786085232; c=relaxed/simple;
	bh=9Y5CiBh9ejoquK6ooJ8B7lLV6zQMZFZZqfxbS+uFVnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ujyXf3ulQvjuZJJWZMQjohANZWRgSy3e+REUj6yYsAPxE75bEN1GQifl8+hkrHkMxv4fIXMF8fMBlyurey0+zV4r9xBATu2ed5poG1TtB+3rc5qDAyP3Ey7LKDwTNsXhSlzUjJarJNZurzdj79MKHQfLIufABl3KkbUj8802jBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OSYcUBQ6; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OSYcUBQ6"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38e08baf860so2857981a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 23:47:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786085230; x=1786690030;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=k1nQYGrcGXQu2s20fusPuZGr3riqxpJDJFHLZrZqcfQ=;
        b=eunBr6NW4tzkp21sORrWWmytvsyYDuWNeIKziiDtBS9LzYr/fGAYrztaM0KEsfqcnA
         DRcfqzZ2vQBwTWfZv6/u74MxW6mc2Wkk1RoePBSLNGASNN4JQlNnzYI3WKEXy5v0cT+G
         0Oanc1/AHmT8pUkZ4p+MZvadnnHUPIonTQA4umRiTPLxg98vzfK31/EqCLGTiFMgwYMY
         GHJpWjLQUg/oRBTYxMCWhc1K4zW5Kx+siRc6roBC/3jM/VY0KYA0i3pm3hn9uSbkFDVV
         ugBHBG8TrthaUPvcTUBcJBkgTKYzSU+64Ky4HD//83PwcwBJmCr0HjHmyaXagOcET4Vg
         6dxA==
X-Gm-Message-State: AOJu0YyF7mWIVKDHn+nyzTs8EkWEyvwF+lb7R7d7MhESM6hM7k3uHxJi
	EmM2f2/+24McKqogzwvMcwfaGDW1VPL1OVS+MmJPWi9mRuIz9gWj6xGEVkBeCaNzvM2N5tUzFOK
	7kVnonTfPD0oJayhBV7Ee3WWSP4+u8w2YbFj9tk0DrFpVNYGBh1SThXB/xHHPzvnvGRIWznPzuC
	oJ5AC7k5xqHl7UPMPhlKu0C5+e850SOzTO2HehBOUsZY0aYTateFoknlavAc3/iWO2RPaEdNS5C
	DPRaiHMzVScQL87uJftt34iKHcg
X-Gm-Gg: AR+sD13uA2rcqySFvlDCSjhV+LP5i3IXqWqlCISBpDBtwvYa56ebcpUAIckR3utYfJx
	b5l+h0gL4Z/SnpFKaCccQIIrtZrDwViYmQSFyYLyv7G55uA+x3q8pVF0HVTXexdlhnDbv7M8BKD
	0nq/CP2Ty35ImLfFB3L3QbYtdK0rNvl7SLbPfWruyGVfwAWnPum8G2UkcXLxRXgyaP6axxEmYoW
	+MwJ0RJ8OcqnZFpMMm7a6kbBq3Bf0S2Sasmcl7GqYESQ/TAW+Rg8cCwR91RqZlz0KG5e8M2X0oD
	NOo6ZlutHuDma9MYw8w7FLAKbKOXWXJm+y8Eqd2eMJiXWydMBuElUJxzVYBcHuQUFI2slPEdj+3
	VhN3Qlxm00RCdBma6rjLCxOrkpBypaCffW2hbXcb3O3N+5QgRcZZdAEkrl4NnM6wN8B7e89tCym
	kKXmyaO0Iwg+oK3LSgLoibHG/aKr45Mz2u1sCFJZM=
X-Received: by 2002:a17:90b:274d:b0:38e:fea2:df53 with SMTP id 98e67ed59e1d1-3903c534d46mr23608831a91.4.1786085230256;
        Thu, 06 Aug 2026 23:47:10 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3925fec93a9sm458164a91.5.2026.08.06.23.47.09
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2026 23:47:10 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15fff01a30so214697066b.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 23:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786085228; x=1786690028; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k1nQYGrcGXQu2s20fusPuZGr3riqxpJDJFHLZrZqcfQ=;
        b=OSYcUBQ6Hc2DPUXFDDKcSONEbDeO7DTmKNXnSXwXzVal4LTXrlUNzGbqycHSS2mwad
         mk6bi9UuNurebVkEPBS4c6hCopOScb3zfe7ssBslpq2pSgmzr32ojgHiNPlyt3qgv4i0
         k0L8LAqI6enKB0ZPEQ/+b4vQ1XtI85pnmtnmc=
X-Received: by 2002:a17:906:ef01:b0:c20:2b23:71cc with SMTP id a640c23a62f3a-c20731e1113mr305061866b.10.1786085227660;
        Thu, 06 Aug 2026 23:47:07 -0700 (PDT)
X-Received: by 2002:a17:906:ef01:b0:c20:2b23:71cc with SMTP id a640c23a62f3a-c20731e1113mr305058566b.10.1786085226844;
        Thu, 06 Aug 2026 23:47:06 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2080a29a4csm15686666b.1.2026.08.06.23.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 23:47:06 -0700 (PDT)
Message-ID: <ca791519-5967-4d30-919b-146158432990@broadcom.com>
Date: Fri, 7 Aug 2026 08:47:08 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] wifi: brcmfmac: cyw: pass PMKID to firmware if present
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>,
 Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260807032209.447044-1-bogdan.nicolae@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260807032209.447044-1-bogdan.nicolae@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 07/08/2026 05:22, Bogdan Nicolae wrote:
> Zero out auth_status on initialization. Otherwise, garbage will
> leak from the stack to the firmware (when ssid is less than 32 bytes
> and/or when params->pmkid is set). Then, pass the params->pmkid to the
> firmware (without it, the firmware caches a garbage PMKID on successful
> authentication and denies a subsequent association request that includes
> the PMKID).
> 
> Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")
> Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

It looks good, but in patchwork it showed the patch could not be applied 
so I tried myself:

$ patch -p1 < 
~/Downloads/v5-wifi-brcmfmac-cyw-pass-PMKID-to-firmware-if-present.diff
patching file drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
/usr/bin/patch: **** malformed patch at line 23:  		bphy_err(drvr, 
"External authentication failed: status=%d\n",

Been staring at it and not seeing the problem. Also checkpatch is not 
complaining. Look at the hexdump and the last line was missing a space 
before the tabs, but that was not the issue. The plot thickens...
> ---
> v5: Fixed line length > 80 chars
> v4: Fixed indentation
> v3: Added Fixes, Cc: stable, and Acked-by tags

Contrary to this there is no CC: stable tag in this patch.

> v2: Split into a separate patch
> 
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
> index 873754be5..2c59b5e57 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
> @@ -200,7 +200,7 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
>   {
>   	struct brcmf_if *ifp;
>   	struct brcmf_pub *drvr;
> -	struct brcmf_auth_req_status_le auth_status;
> +	struct brcmf_auth_req_status_le auth_status = {};
>   	int ret = 0;
>   
>   	brcmf_dbg(TRACE, "Enter\n");
> @@ -208,6 +208,8 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,

It looks like you hand edited the patch but now the number of line is 9 
and not 8. Not sure if Johannes wants to hand edit that, but it does 
apply once fixed.

Let's wait for Johannes to reply.

Regards,
Arend

>   	ifp = netdev_priv(dev);
>   	drvr = ifp->drvr;
>   	if (params->status == WLAN_STATUS_SUCCESS) {
> +		if (params->pmkid)
> +			memcpy(auth_status.pmkid, params->pmkid,
> +			       WLAN_PMKID_LEN);
>   		auth_status.flags = cpu_to_le16(BRCMF_EXTAUTH_SUCCESS);
>   	} else {
>   		bphy_err(drvr, "External authentication failed: status=%d\n",
> --
> 2.55.0

