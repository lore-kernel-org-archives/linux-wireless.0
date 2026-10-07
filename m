Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5364AA416
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 12:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377663; cv=none; b=B35nFSE5LJlX/SqXZd1abpkGMMd9BIFpa4Fkrx2ZUmzstaeaRFWI8MQYX8GKeuZOn1ahR+wA/UvWziwb69lmXnJNBqD2EHjTbf+9B0cW4xxaz/jdUyAQcDY4p0J/y8q8QcSaDCPETJZQ62Hw+RdxEQaH+SJqWCTh7Y40gbqXbkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377663; c=relaxed/simple;
	bh=vQ5ti0IRpJKxnO/ajOgsAv5J3ZdzP6Vf+7alXOHlJ2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7K7wk4sRa0FDY3Ou2vjb8BBt1gcLBbcWNm5r+/aUS5NQRLvuEYUVOIvNmXzTPHlYOcD7zJc3obNZe0eABaPBFCdIGKRaXL6GcROyRvWPWlUxLCgM3+C3N3sWckApL0iGNorhmLmZ1ZWOrh5RhnL7KneH0MYl/+lWM1osohAXF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=RRPuu6+l; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RRPuu6+l"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3a865731ee4so1553753a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 05:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791377654; x=1791982454;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=WRr2bOzV+ACM051eiPZmuzY0jHiw8RpNfmmijxyyZ5s=;
        b=mz0xFa5/P3dFwff0m/idbAHjXaA/nlVHd84sYhe3YpLNVHfohQTgqXlcmxJFEulf6X
         3O5NplEFn2ZHN4nfeIX1k5FJxAZmMMAIThT9Cj8FK3o3FuC9rWlKQGKv8oLSkHzR1MXB
         bYjC56qxdNlALBUWLWzrMe8YGhDdQLdTI604a4ZGuAy/4eMeyWWdC3SE6HRcgS/I2j2W
         CY2DkJnkqP1cWydeZE9f/xsB7T9SKR1vF5Wy/ArUpE0FIRDyfvjgdIDtxgb2LRnaAixC
         eFS3OtUWtYMabmnUYoKrfPogbxzR7J1lQlB2a/vweFNyceHCzBLMwxqGmYoce8M23XeJ
         0+Ag==
X-Gm-Message-State: AFq9FYLzjBVNrpAoglj5BTZ1eTDVZcdvY1RoXDA2RlqzYDGfNEIynqWF
	vJrDr3NxGAxIGF4eBxFZZiJvPzzBfWOt3W8Q7oaGLSNiw4kmZjoz9tjkiip4RdJ4kgUJfrW+LhO
	dD1uiUeqgQo410in4gQ2L2nD91TGWOPz9SrHqarovpg90bb7u+mV5my/r1QmhM+21bhTCFlcCLN
	nuIRdoO4Y2KihWvbu5aR7erBBBb3F+O/ENVASUpQNqqkO4xGjJI+aMffuEFQhJBt7njxibuJDJj
	y0WPRVXZ3KVxq+ucxfWd8KSPd9R
X-Gm-Gg: AYBFou1roEFgig/97dvjXbsL/qgsKYQ+InuowXjqfw7kGNX/wyqoY1IWigcG+cE+On7
	DdA4Svaa4sSTmIxW/FedKaDLEFjEULnVqqclAc36C5WSOdJT7PyCEJBadeIbSnYi2KhdRhcfFqW
	g5a9hmHgbksM/px7R3uaV0tL0BlWVfr2yqR1Hb5WVeSeRpSp8q8qwPkH8oeFKIMb09As3XIJDEm
	5qJWNK0/DCuNRPxrPTYDJ1lb/MQVUjmzZQXtQcuP2iKBmamDLWtWdP+kd8F11adZ6cEMwtly7PX
	tBBSmcPnFyESBITKsdxg+CqCJHiQnvGk4nQwQmYgnFeW2tV81rkKYoUpKemKsa0tdUGor1uXXNu
	OdRnCprCRv+WxRyUqFUMhj8/fUvd5zacC/4VxPBbghw560Wj+4+ImNhD4VNW1DzyshZaHVgktvA
	dwmZ2TwjL0tRFyniYybabt8clq+v4pPDVgryNx+ac9Vg==
X-Received: by 2002:a17:90a:38e2:b0:3a8:bb56:f1ed with SMTP id 98e67ed59e1d1-3a8bb570c8fmr581262a91.50.1791377653965;
        Wed, 07 Oct 2026 05:54:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-124.dlp.protect.broadcom.com. [144.49.247.124])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a89dc2d599sm368897a91.1.2026.10.07.05.54.13
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2026 05:54:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-88c4da716f4so5331033b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 05:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791377652; x=1791982452; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WRr2bOzV+ACM051eiPZmuzY0jHiw8RpNfmmijxyyZ5s=;
        b=RRPuu6+lLm6I2x6sXOOrNvh1BLc+q5EIBLLmmXx+lD/h9iH79fNTnhWy6F1udM7B4Y
         vLGo6TBGs/902r8fPhs883WYm/II5uXZ3yHbWv+89GDFCMfqkSCGc+TAPvli9EocJPLb
         VR5PnBWs1eANLE7zz+/0g/lVQzf+8ywkIx8us=
X-Received: by 2002:a05:6a21:3990:b0:3dd:85aa:452c with SMTP id adf61e73a8af0-3e134044716mr1756571637.30.1791377651959;
        Wed, 07 Oct 2026 05:54:11 -0700 (PDT)
X-Received: by 2002:a05:6a21:3990:b0:3dd:85aa:452c with SMTP id adf61e73a8af0-3e134044716mr1756535637.30.1791377651379;
        Wed, 07 Oct 2026 05:54:11 -0700 (PDT)
Received: from [10.176.2.78] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd0a92d5b51sm1411697a12.14.2026.10.07.05.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 05:54:10 -0700 (PDT)
Message-ID: <d28a1cfd-1bcc-4319-bbbf-7189a1ff8dc3@broadcom.com>
Date: Wed, 7 Oct 2026 14:54:04 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] wifi: brcmfmac: Add BCM4388 support
To: michael.reeves077@gmail.com, Pieter-Paul Giesberts
 <pieterpg@broadcom.com>, "Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
 Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, asahi@lists.linux.dev,
 Hector Martin <marcan@marcan.st>, Daniel Berlin <dberlin@dberlin.org>,
 Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org,
 Hante Meuleman <meuleman@broadcom.com>, linux-hardening@vger.kernel.org
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 25/09/2026 15:43, Michael Reeves via B4 Relay wrote:
> The Broadcom BCM4388 chipset requires new PCIe initialization and
> firmware interfaces. Add support for these interfaces to brcmfmac to
> enable basic station operation.
> 
> This series adds:
> - Signed firmware loading and mailbox transport
> - Fixes for chip identification and firmware capability matching
> - Versioned scan and join requests, and extended PMK payloads
> - Updated event mask handling

Thanks for this series. It is taking me longer to review the full 
series, but wanted to let you know I am looking at it.

Regards,
Arend
