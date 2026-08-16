Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3E13909A4
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 09:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786873432; cv=none; b=c8Cn6j42sA7gVh52Z1u3byvbKwyq+i2w/mbNB+yBEUyPMH9zBxJBaeCDbXR2pBa4pol1Bs6yhFPlKSy3yztwSSSxY7ZIn9TbktyIl38YLEQfo71D177eS+4bJXnRwKWPlxZ8dIiCqBH9Y1XdzBlXs//qmK5qCXmSPyuiAzO8E8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786873432; c=relaxed/simple;
	bh=G3V/6NnfckIOBq82ny3RmYXsBGcXvQhSxd8L66KrD90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p6xspeHQWAPQZn9phHayM2x3NPVvTBbWWooramhMkkHY8B+bUNwaBzadxKQrIaqsNW9E4F6yzsv13575BrEbIHhGz6GBiY1/DadBgbOQ4/ewRE2nT8KbOzFrY71DGb37jd/tnaw1MjRV8udWqrKkLg0D59u0oSEV4PZzk3902NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JT3cshUR; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JT3cshUR"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so3483523a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 02:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786873430; x=1787478230;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=JSVI9EmcUArZjAZ/au+br5pNZJa0DmSYRx0foLnLp38=;
        b=eazrF84/FLIKZbyTYwB07HdwsGauG7aqpa8+0f2Y9fSfWEcKfFgehyoy0z8tXlPgi4
         Z8KdweNJhnnHZWtMMmM1+Rf05TKJvB+oUS5+YxmnDwmS7uOz4WPwRTRVpxcIj2Hbm1Hj
         eYKPJTIHOe4D4/GF+XGAY7QFR2QW4BWIzk+T5gx9xANIK5Ao3hcBwgGP0iBCirCsJYcG
         ZNlBiTEFgT0x7RA0ELHLS+3mRl+ccErI6G8NjP6vefrUxc6Ndd+wPVjfY0Ov0qRJbfdw
         TBmn6gibqDj44Qjp7Rk9fYFS87CwTY5H2ZnVa0bu2iaY9ui+LrWOLc5FwgCiOrBC6+ij
         IbvA==
X-Forwarded-Encrypted: i=1; AHgh+Rqfv0nkx48t1pNcyU9AMfDPfYIjhV4w83qTMAfeU6YXkePEZJFYqYwHeRo/LxWhwFl08QDAaoptQ5wDXhAfOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2OUrJXb4/Cc8ZBKbJzdVSNzMv9mBcSrk01/icHYlSL1Mgiv23
	I9x8kE4x0Z3DRQmK9U7PrD0jNjFUUQR5YN7NpebMKVRFmu7Q6++SSr24aYFCODUqdf3iBkngUSV
	s/qD49QbMjKFZLPP9R8tJtl1FWYHcmOc1xJLs+/Hnh8XQslcbSOwuink7lp2yMgLfgeACc9aZgS
	jc83Dw4v9pKXv3CqnjVSUPndSaTuynofl5sS4jvnqYCiMb6ZEGDPNK5br1WdtomR2qbn9ZyiTZR
	opPyCYrOBZOi5oSo0rfI1CB2B9F
X-Gm-Gg: AR+sD13yZZRqoSrHRe2UlwMgPglpwT8XralN5aAHBuUl4bQEnJchiuhBn63clHkr5vs
	aPFPau+xXwtJff7nf+TfrBoBsUJnt+1iSwpim8VfAHYNO3zLZjLSg4ulmGjxMU/9T0SlI3wE+83
	OZFdGa9/O2nbq3udT4wC8EHkprJPI1AzY/t3eXOMjL6zkWebWloCpYMpA/HFHuiZ51/qK4pG1Dz
	/IBptO7Iz4u0Gh9m69OsCBXgGYZuf0n34rXtFOng86ZomcCUne5Q7iBeQU/H0D+SZlECHBLqnIE
	7JwURHrnLNfcj13tEfZ5qlGL4QaL+p329AouUR3+N9IwAzQAW3uUZHTAL3r7cr7+PEf1Ja9tn4m
	IvhUQR9wF8OQcUb6O3pCxXHCL8VmxHNum6057OEw9uUYTnTL3hKxpjVQZv30miRSsLlItpgmWcF
	XUULAp0Fyj/Vfgqose2YLMPJ2DTTQhTDqpnIA6Nv0=
X-Received: by 2002:a17:90b:3b43:b0:393:1cd6:643a with SMTP id 98e67ed59e1d1-3933bac941dmr18633395a91.18.1786873430344;
        Sun, 16 Aug 2026 02:43:50 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39531e138c7sm576282a91.7.2026.08.16.02.43.49
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Aug 2026 02:43:50 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-392cf18db8eso1478790a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 02:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786873428; x=1787478228; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JSVI9EmcUArZjAZ/au+br5pNZJa0DmSYRx0foLnLp38=;
        b=JT3cshURJxnF45hSmP1n3wvuY99IXfsVEoEKw4U4f9Xxb0l5WLabIVNRgeAxVTnFle
         XVSngsW0o+eoOfeoGWDLHLxAUa31NFJQ4IrnakUpee0pNJqXcT5aTdrH7b3RHgSjfXGz
         /BOLQd8vJ9GXndou62AMG+2+OaVhB7XlwSp4w=
X-Forwarded-Encrypted: i=1; AHgh+RooLefmNQ3hOlE5QSF0hGOFtNd4NxUN3LjCDgoVkDcFXr1wFHJmJswEFkJhyVRKdGIvaZL+0qxZlY7EIMQfJQ==@vger.kernel.org
X-Received: by 2002:a17:90b:4f8b:b0:38e:8021:2ea9 with SMTP id 98e67ed59e1d1-3933bcc78a9mr18359416a91.19.1786873428464;
        Sun, 16 Aug 2026 02:43:48 -0700 (PDT)
X-Received: by 2002:a17:90b:4f8b:b0:38e:8021:2ea9 with SMTP id 98e67ed59e1d1-3933bcc78a9mr18359386a91.19.1786873427926;
        Sun, 16 Aug 2026 02:43:47 -0700 (PDT)
Received: from [10.229.42.78] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320e9df2504sm24436596eec.17.2026.08.16.02.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 02:43:47 -0700 (PDT)
Message-ID: <83ef9f7b-4145-4985-b157-6fb9fbb0b3f0@broadcom.com>
Date: Sun, 16 Aug 2026 11:43:41 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] dt-bindings: net: brcm,bcm4329-fmac: add nvmem-cells
 for MAC address
To: Rosen Penev <rosenp@gmail.com>, devicetree@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, van Spriel <arend@broadcom.com>,
 "open list:NETWORKING DRIVERS (WIRELESS)" <linux-wireless@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260811192829.123410-1-rosenp@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260811192829.123410-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/08/2026 21:28, Rosen Penev wrote:
> The nvmem-cells and nvmem-cell-names properties are used to supply a
> MAC address to the brcmfmac wireless controller. Nodes such as
> bcm4709-linksys-ea9200.dts fail dtbs_check with:
> 
>      Unevaluated properties are not allowed ('nvmem-cell-names',
>      'nvmem-cells' were unexpected)
> 
> nvmem-consumer.yaml cannot be referenced from the common
> network-class.yaml because it does not constrain the number of entries
> or their names, and not all network devices use the same cell names.
> Each binding that uses nvmem must therefore define its own
> nvmem-cells/nvmem-cell-names constraints, like ethernet-controller.yaml
> and qca,ath9k.yaml already do.
> 
> Add the single-cell, mac-address-only constraints to the
> brcm,bcm4329-fmac binding.
> 
> Assisted-by: opencode:deepseek-v4-flash-free

Probably for this v2 it is better to say:

Suggested-by: Rob Herring <robh@kernel.org>

> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>   v2: don't use nvmem-consumer.yaml
>   .../bindings/net/wireless/brcm,bcm4329-fmac.yaml           | 7 +++++++
>   1 file changed, 7 insertions(+)
