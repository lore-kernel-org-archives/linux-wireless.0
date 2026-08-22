Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174E42F39C2
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787423220; cv=none; b=XYckwIrMrj+Tjth/yc/IEqo/DwPXg/FxknR6JU5lcs8jjgbGuP3jibx3m4cT1SEUpcJWbKtcPdx/KzL+zot+OpzRbxeNat6tPOscECiA3I5qRyxMxDv8xdFnvM/ZudIlFSdQ+xg3xl7PXkdJdpdeVpoEeJtrT60R0NY9gkMvWbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787423220; c=relaxed/simple;
	bh=uq3A1sNVYEdKpA7gxbETBfyN1KpDSfAsdal7tIBTVjE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=BFy5pAims3O4uYHIryxPCELr993L2B7BOXiQENT3j6eCaCwyxxPUHRPg2VciGTkukzP7NyRatFFPZ1wugII3gQzvhG4QtWet4WWCp4WawfbdyrGK6zObK0qblwqcuCH6VtsV5zRv2j/btBwajjOWm8jRYhrQtt1yraPlYX51FBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=X2dm6yDQ; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X2dm6yDQ"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2ceb096e675so24946685ad.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 11:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787423218; x=1788028018;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ayvjUqnkGC3HPVARpVFh4ZXeLs68IbUz5B1oV86llgY=;
        b=BfhyY3QH2Xk7UchVoKzRgGIxYvR+L01qXjfkMF4pSBsgsPE4ty5gMhOk/3zgm+T14h
         0bpuDoM/v3Dtsy1wK8eQhrBoxsBMBnqkjVBCTBsDYV1ChMDmoNH2Zg6ddFdw95xN+5j2
         uswke4WM2g3dPh4654lywEQCcgfACwZM1ldwI5LIfGfcl59VcRI00EmKelyRkOU8Mb7q
         b/Nl7SGi05Yz3DveWcZvk8Uacy0EHboUIC8oyuCiwL7HfMo0345tRQdImEzPmKxBK52B
         KkyY9DrmG7kDqgTUpVfbP8p8aV7JJWVjil3aGaidIg/WKCR5HxwqRNM1R8vkL3R8hfX0
         tbQw==
X-Forwarded-Encrypted: i=1; AHgh+Rr7FzBnJTWIdJslVkmAn6traWX67zCg9D9g8e8Z7o8842B5BNopGHmE8ENv8HyK/+ggbU+ktlpVrd9K64nntg==@vger.kernel.org
X-Gm-Message-State: AFuF++mybz9pWCCetTKiKrxs1I7ViKl1KlJ9Vg4oi+g7h23bZ7PXYz1Q
	v5uh5ELkFYEiK6RiPHQxG/y1N/9Nn3TC8BHIrg6fsKx578f1YaTxm8BXbg03qJNwTb+cQIT+FTI
	gmFQ6s24dI5IbdzZQAzsv/YecN6bPnRU35ZkfRUEpd3OMY9m9Ko8DLfuJS2gq9agH9vkTwJO4ud
	8G+kmyH4Te1VpZeoTs9FnaOBucGtfqzq0KcjAvgPrRaU+uwPztPzR0dXNuuIwWHAK1kN+1w9BQE
	IYgCto8m+VFX6ERtbFfnw1O+nui
X-Gm-Gg: AR+sD10JQpz6QwT7SURsapHTJsa5+5/7BZNehyAuwTMI9IB+T3IrSllqQTIU8DtuNR/
	3lFM9aH9xisIOGblmG4NKtB9fE7HrHPlxIMPXkyi7O0veJhkHSg/ADoBTR3PqPyhFroehXB+MmP
	/HmOX3RIXviZhEvsTrdMpzSzLQwtsl+reoWXq3i5HSJAI2BXVwlIcvcqncRpKn3RVEGrdvaT9nr
	lEcgUanWmVqdOyI9CVOHwZ7ukQY188jC/15ET1M8QqaUEUHf//gAPaqt5RG3tHheQeOhSCWO/AV
	d52TadTA0KkIn3gWrIc8DdP8uGRUK2KNn7f2EUObZTc6CWTGUH/vk7Jc6EC9bzWfTwDHyO4mbRm
	8Q36OCRMLEmYKxBn2bi+z5fLQyrC+xZIQGwnWnRxQAonxmsuFOHCzcMwiux906vhDsNkZ4/cO1/
	faK/5PxLcmQuyWHeDEh1i63sb+alHg2GgPziHMBzk=
X-Received: by 2002:a17:90b:4d0e:b0:38e:659b:f366 with SMTP id 98e67ed59e1d1-395decb87edmr9738236a91.0.1787423218238;
        Sat, 22 Aug 2026 11:26:58 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-395e4b0d991sm1359787a91.8.2026.08.22.11.26.57
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Aug 2026 11:26:58 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so38007815ad.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 11:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787423216; x=1788028016; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ayvjUqnkGC3HPVARpVFh4ZXeLs68IbUz5B1oV86llgY=;
        b=X2dm6yDQvFuIHNNOC9Vm2dCsaKLhjYxdDY7mDq+uS3TPZeKmDWwAz3JfCw+rsI4zdm
         UCnyQ2SOcRptUrl0H3qLcowr5rRm50rTjiyOXq6l8s7clnfZ5lEvqyd5syrHswvNtbvf
         xc6p2AA7AK0WXdOyA+F7M0So6NseCgLGCIj3M=
X-Forwarded-Encrypted: i=1; AHgh+RrMNJq2sB4kaBIYfba7d8k4mSEIwhgpz5M4G8wydYhaeIyw5HB4NqIsBF3dNdUepPGjoyeVO9VfeZNBsDSYAA==@vger.kernel.org
X-Received: by 2002:a17:902:d552:b0:2ca:e19c:97b with SMTP id d9443c01a7336-2d670b85ea7mr143130875ad.5.1787423216476;
        Sat, 22 Aug 2026 11:26:56 -0700 (PDT)
X-Received: by 2002:a17:902:d552:b0:2ca:e19c:97b with SMTP id d9443c01a7336-2d670b85ea7mr143130315ad.5.1787423216011;
        Sat, 22 Aug 2026 11:26:56 -0700 (PDT)
Received: from [10.229.42.78] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f923490bsm14091904eec.26.2026.08.22.11.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2026 11:26:55 -0700 (PDT)
Message-ID: <cbb4b486-c7db-4687-a08c-1b1486583d32@broadcom.com>
Date: Sat, 22 Aug 2026 20:26:52 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] brcmfmac: add FT/OKC roaming offload support
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Huang <Jason.Huang2@infineon.com>, linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com, johannes@sipsolutions.net,
 hsin-hung.li@cypress.com, linux-kernel@vger.kernel.org,
 brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 wlan-kernel-dev-list@infineon.com, jeff.johnson@oss.qualcomm.com,
 Carella Chen <carella.chen@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
 <71261493-e974-4f5c-a453-b4c2e449baf5@broadcom.com>
Content-Language: en-US
In-Reply-To: <71261493-e974-4f5c-a453-b4c2e449baf5@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 22/08/2026 20:24, Arend van Spriel wrote:
> On 21/08/2026 09:56, Jason Huang wrote:
>> From: Carella Chen <carella.chen@infineon.com>
>>
>> This series adds the cfg80211/nl80211 and brcmfmac pieces needed to
>> support firmware-assisted FT/OKC roaming offload.
>>
>> Patch 1 adds an nl80211 extended feature bit so drivers can advertise
>> roaming PMK programming support without claiming full 802.1X 4-way
>> handshake offload. The brcmfmac patches then detect firmware FBT/OKC
>> capabilities, keep roaming-offload connections in a firmware-supplicant
>> profile state, program PMK material for FT/OKC roaming, report port
>> authorization after offloaded roaming, and advertise the new capability
>> when firmware support is present.
>>
>> Changes in v5:
>> - Reworked nl80211_set_pmk() to avoid the 80-column checkpatch warning
>>    on the 4-way handshake extended-feature check.
>> - Added kernel-doc for the brcmfmac OKC profile state added by the PMK
>>    programming patch.
>> - Normalized Assisted-by trailers to the checkpatch-accepted
>>    AGENT_NAME:MODEL_VERSION format.
>> - Added Johannes and the wireless/brcm80211 lists to the cover letter
>>    Cc list for the nl80211 and brcmfmac changes.
> 
> Hi Jason,
> 
> Thanks for the follow-up, but looks like it happened again. Missing 
> patch 5/5 as happened with v3 series.
I do have other comment(s) for v5 series, but feel free to send the 
missing patch so I can review that in one go.

Regards,
Arend
