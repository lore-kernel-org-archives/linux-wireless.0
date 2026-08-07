Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7769337C11C
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121532; cv=none; b=obS+BIz3CtMEHi12S0kOJKYvSgDNnX4nV7xiyl4xBIoAB/sdAjm3nzFOCozi9GgUw5jyx7VD3Z1fhL8Y7w2eGI/JnQpQ53fUeMB3Jb0mJ5nfV1XaLERPJe0Getx+ULFhyhlID7vtOZ9KvZDQ6akgnqHIcDumsbcocmQMEF1ZKmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121532; c=relaxed/simple;
	bh=O58BTvrNM2aC7RLe/NA9M4KfX96TgIfxhat39lMlpy0=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=mLFh9UIcXX9PZLg8VuJWc/cvUVPneV2Ssbn36RRm9fEJ2nux3+k/tDHKimfyyeTotCK8fLhoUc4s5a7BGtFUXJjNFXxCHi++TVzHlaOSY0GUCUo37k2LoIGrocS6bdQCYU2ESaYZn2So6uQ5liKUJMZR+xiq0Z6o86ARZXKZpI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=e4hUl3Fe; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="e4hUl3Fe"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-38f0f132f56so1820179a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 09:52:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121531; x=1786726331;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sK4XYhySCSAmfEvjmTkEI+hN3CX6qZ07+OcZw718arQ=;
        b=bpAQdz0r3EKu7X8tllrjqY5DK32trVhYySvN30IjzXAgTG6uyLaCuq0hR8IuG87Cg2
         u+TXvVeeOU9CDMDcoKgZN7dG3FUC4M2N3tQgseHnogtnsLIWgJrrowhofCNWcBxPNtaU
         z20wt1TSyQXA/0ekw2EcSxXHeAVWWYSeulqhiOOvgXSmjlwYySghJmA8PZlT1IQXG9iM
         rjc0331RIohWNT5hP0WH4glnbdrfaJ3+ucY4TbwQ4TlC3KcT7tWdQsoOd/3A1GPKu2jm
         Z081upyZpNri4PrM8ktl5lJA7K0dEb55G62/qJFFyX+F1EHUNcCP+K/QRBJSrhZNS0/m
         xLVg==
X-Gm-Message-State: AOJu0YwfCERIOQWiQmLNpQhwrKhdZsQcEnVLVWEPobz+HTSBN5+olh6+
	3XTC7jP8GEzItnO5ou0Dv8C8OUfuzDv757OBTOuAZvmMToBESz30jeLmOyRUuQv+1JBOOEgKJud
	O9TAdodxQGxANND+j+FPdEr17caNSS4P40cELMoZ11MHbNNEdnSqYq2dM8yCqX/pQEIoeTIEjFh
	sJe3mHtweRasCCslqL4vpneQqzPu+HyaHG4VFgh6nR4TQFyN7WVxKOYuUiDb25QnNbBqbh7bRxz
	Qu6/Dv7E88bcuhgKByHyXKEne4f
X-Gm-Gg: AR+sD13QDb6T7NkMEAUZL1WhqJkYd00zerOtwbHn4IyJLKgyaNoeAubioFBC1bZUu2a
	7kcyKfIc52TMJo5LXkUC5zcl4UgxOQlzmnMZrOgvWpQJmtoAv3x7xXpWv04Y6lbEYfERpqL36Z7
	/H260OmOJnhyvcZqdTLWcGdoUrBt7acBrsaERiZiqNLfNCsXbwKSLWZW3MARH4r5O0mqsoOpckR
	Nps59TXc78f1MCeSpRVPvut7cjQdvXs9gB/O9I+qF9k5GS7M8UCtmCLxIKSQXDcLmMJsus4k1Re
	KGalLI9M7//9RnAgB/1lGFeMVhpq7/ZeQgXXHTPvDSMIo7cgKKEvl3kacDs6fW6Gmw//eWgMQRt
	Y/JRYw0IjbBWI9qo6yYgetnximqsH1EoFytwCYOheL1yCLipAHgjTNENn3J2vPlqf/Z2Myo/BiP
	sebPw06F9NZsvp1D0VRtKXqGvj0u/OI2ZXOD8a
X-Received: by 2002:a17:90b:3948:b0:36b:b903:994 with SMTP id 98e67ed59e1d1-392845f90a5mr18315a91.4.1786121530630;
        Fri, 07 Aug 2026 09:52:10 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-392825d6b3fsm150284a91.12.2026.08.07.09.52.10
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Aug 2026 09:52:10 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cce14a21faso32858265ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 09:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786121528; x=1786726328; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sK4XYhySCSAmfEvjmTkEI+hN3CX6qZ07+OcZw718arQ=;
        b=e4hUl3FejJZoFo0SiVH25+eT/u0KfMe4x9RBNhPQc078ZfBxgf60PXCGQku5zhmH7c
         8vSUiezD4MKui6jx8D9M6LIKNLGCrjQ8rz9CRXhbQ/rThUnUNyES8DP8VsVSMn//iT9a
         htNC9K8z1SF/UeAEmE7VyRAozGq2K0LT5XYVs=
X-Received: by 2002:a17:903:2289:b0:2d2:72b6:556b with SMTP id d9443c01a7336-2d2b2e9258fmr175755ad.13.1786121528519;
        Fri, 07 Aug 2026 09:52:08 -0700 (PDT)
X-Received: by 2002:a17:903:2289:b0:2d2:72b6:556b with SMTP id d9443c01a7336-2d2b2e9258fmr175115ad.13.1786121528066;
        Fri, 07 Aug 2026 09:52:08 -0700 (PDT)
Received: from [10.229.40.14] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec2ec20sm10580276eec.28.2026.08.07.09.52.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 09:52:07 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Fri, 07 Aug 2026 18:52:03 +0200
Message-ID: <19fdd238f38.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <20260807163418.487508-1-bogdan.nicolae@gmail.com>
References: <20260807163418.487508-1-bogdan.nicolae@gmail.com>
User-Agent: AquaMail/2.6.0 (build: 200600043)
Subject: Re: [PATCH v6] wifi: brcmfmac: cyw: pass PMKID to firmware if present
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 7 augustus 2026 18:37:48 schreef Bogdan Nicolae <bogdan.nicolae@gmail.com>:

> Zero out auth_status on initialization. Otherwise, garbage will
> leak from the stack to the firmware (when ssid is less than 32 bytes
> and/or when params->pmkid is set). Then, pass the params->pmkid to the
> firmware (without it, the firmware caches a garbage PMKID on successful
> authentication and denies a subsequent association request that includes
> the PMKID).
>
> Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE 
> authentication in station mode")
> Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Hi Bogdan,

Looks good so my Acked-by: still stands. Thanks for going with the flow.

Regards,
Arend

> ---
> v6: Fixed diff line number
> v5: Fixed line length > 80 chars
> v4: Fixed indentation
> v3: Added Fixes, Cc: stable, and Acked-by tags
> v2: Split into a separate patch
>
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)



