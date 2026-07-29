Received: from mail-qv1-f100.google.com (mail-qv1-f100.google.com [209.85.219.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF08442B0F
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318510; cv=none; b=MhmT1srF1TKsN9eOmkF/2hUlV+HOp/95JvN7jXS/qwGNg46r4bL4xfXHvdWwndP9Tit2lduLJmK53Cv/6o00FPTUboJ0ICL1olDkUIklMlDk6+qtIg9PNsutD1cIdY3xd1+lVCLrdQLkLB6bPhl+QHE40E+43J5CKV5F9bh93ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318510; c=relaxed/simple;
	bh=H1cxms0cuojPr7jUeGLLOn3L/QZApPoeQCFr1rIY4pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VQQnMpP3mVJ1QGzYJ9Kv/SDFCPd7+PVlLZBq1ogNjwSqdbWt5gmgsKbEIZWUkgAWxOUD3B8479gGGiscaXoVwqvfYvBwBOhAuj0S8Tdw4A5WIaQRVWVKTF5SEIlRFOAjOu1zixryLUsUPz/k46/+NcXQ9BS6l5MMjqzNEvSfGj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UU+i96vK; arc=none smtp.client-ip=209.85.219.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UU+i96vK"
Received: by mail-qv1-f100.google.com with SMTP id 6a1803df08f44-8f256eaedf8so6443616d6.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785318507; x=1785923307;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=q+GPA/rLhc1S1DZlerpKKjvy5ROXqBkGhbeqa7Tzmk0=;
        b=HUbvuHmhB3kf9/OlMyht5nWrFhneXtvZjFJZV5Jcdbk6eIMAp0Ya+ZwRHolODQ5teF
         e4DZrf5x87VNLcXLjHx26TN1o3Tft8TGDxYWo0e+dmCDxJNLe2k3eWy3TWcdmljH2AhA
         UUfrBPnGn2eduFus2trTtFWvN++pTBedH1NlU+XOiH0JqRAkYkXD140kd6BZgj3ueMPv
         CoqE+wisql7poggDpTHi8/+xjOZHCK22c05EfTaTpmRfacVM4jD11EvMUmytPqoPwNw6
         4IGC3FxpIf6k5uVhUaGsnIIGJJxWtNl7BrJqH3sABm+eGE3/37MY1+/Z0G7cjm2KbP1g
         Yzcg==
X-Gm-Message-State: AOJu0YytZ2mva/CRwBsq6hrsBgOo+EUDh4jj+uE4ywnmo+QyDGa4vQOd
	LP31uJ6FaPqkoqAQh43PzzochqyACjhgrRLqEyAaajXvNnEUXqiABtDe+gZ2nEQAY6Gmd26ptSj
	Ku/emzrXAKeA3FB/K0l9J0sEKyC/k/R++baTsay3oBxE6JXT7t3moEdahXT5R4qpoiJIojkQV9B
	2qqFoEhzBdq9CvbfSJzMxGbJiLptiAQHTdvI7ThtgCdg6KVibbjIAFKg4ZM3mN510V6sMOSnbVt
	/rJb3aHJAMLpZR4bwOs676at/Iz
X-Gm-Gg: AR+sD138luy3siaswsahaX6vn5Og1VuO3hNyoiSrM3kV5ZZRrDvEFM/3DJbjn5d+6rp
	atkrpB5puEZUdCOm8uNaDCwNP8Pbn5jnlDU7qY4DNDI7bS21BthzrWjkJXcqDrMKmMS2Yl4tVBy
	aF9UXaCxvfV0WkTucwkVwMLmn78utGBsbchYOOuK9CDzauhMIcKHnt3gNOrbqXNgiTziqXKUbLP
	W6D1tjAQ245VIEKbp6+dPcodrJof/NVatEVKdagqC0J6ftZBvYJNAgKqv59V2FANuVOln2sNqjJ
	rB814j87khTO68FyD89c8tda5inVXSl3/eL/P70C4fJQza7sF7naFltatFJTLukAMaEG8Vxw5JM
	VhPkGRp+BG7jTvUGOiyIyx2HmEw0u2Pdy8PNy7fyL9kjToOHcZIxFC94rqasc1snIVCCwq23+RQ
	ioazIPWPJrbDeody6WFqMED6oVPdu5IChJ2J7yKNk=
X-Received: by 2002:a05:6214:2a45:b0:907:bde4:981a with SMTP id 6a1803df08f44-9081730d630mr58441186d6.42.1785318507286;
        Wed, 29 Jul 2026 02:48:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-9081dcfa345sm1679876d6.17.2026.07.29.02.48.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2026 02:48:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8eec6acbe21so17231536d6.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785318505; x=1785923305; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q+GPA/rLhc1S1DZlerpKKjvy5ROXqBkGhbeqa7Tzmk0=;
        b=UU+i96vKZD9wYydpxnhkptIh5W39Y/icdympbmwFX23fQOQPTVMfmfmiuCd5hSNAvN
         KX+VJMRmd+Kl7yuHPWcfvMkIKD2zi9ESXmgj3ggi4vMnhYDWQFZ+i/VxoHQMboGgDKg9
         vuRu3CD3QFGs06QGqJH5ybOuPOI8rcd6SXZf0=
X-Received: by 2002:a05:6214:29eb:b0:8fd:6e32:2bfb with SMTP id 6a1803df08f44-90817376d39mr59183306d6.60.1785318505542;
        Wed, 29 Jul 2026 02:48:25 -0700 (PDT)
X-Received: by 2002:a05:6214:29eb:b0:8fd:6e32:2bfb with SMTP id 6a1803df08f44-90817376d39mr59183186d6.60.1785318505096;
        Wed, 29 Jul 2026 02:48:25 -0700 (PDT)
Received: from [10.176.3.215] ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dc496f7sm20496196d6.3.2026.07.29.02.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 02:48:24 -0700 (PDT)
Message-ID: <5cf57b2d-2bcc-481c-87bf-3a034d5f99be@broadcom.com>
Date: Wed, 29 Jul 2026 11:48:22 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external SAE
 AP
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 29/07/2026 07:34, Bogdan Nicolae wrote:
> When bringing up a WPA3-SAE SoftAP with external (user space) SAE, the
> driver never told the firmware which SAE Password Element (PWE) method to
> accept. The firmware was observed to corrupt its heap over time due to
> this omission, leading to firmware trap (data abort in heap allocator).
> 
> Parse the beacon IEs on start_ap() and set the extsae_pwe iovar
> accordingly: 2 when the RSNX IE advertises H2E, 1 when an H2E-only
> membership selector is present, 0 otherwise. This matches the behaviour
> of the upstream/vendor driver and only applies to SAE-capable APs when
> external SAE is supported.

This makes sense, but may I ask what device do you have? Suspect it is a 
Cypress/Infineon chip. I could not find the iovar in our (Broadcom bca) 
code base so I suspect it is vendor specific.

Regards,
Arend
