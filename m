Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB8348CD5A
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332468; cv=pass; b=lNcYCDNdQT53AXR89BkEAF1H2MwPY3iYC4PQV1quOV+xJVd0DJOGPylFw6ZEefVUYcrJaMBrawFjN0BYUvA5aNnmisTx+7HxaAX6RwT/bO8rz1/I0Wq+/uWCAS0LmYi9DKVZarSp3OdV5nZx8PSmu+BgjiWxWFQ/pUOLJLSEYe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332468; c=relaxed/simple;
	bh=eDZPqYGArkFQdUYxP+BvMCkfknhlS8PDG9aqd8MbJOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=byZ/hLMzp2fO1dIC1x8KQ6WZAOPh0DN0b4uZN5sn7/KfarUv9BzQXiMXSAQkQVIuG1bzq9IWALhhxBEb+qp0gJvYyWuWDx6pXcyBmfMgQwIA8r/ndthKwtMXpL3/wTee5Cr3Mh3zKOtu2AFoCHEjpY1AI0Q3Y1x1PaBD4+iHBH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wt0o+iSb; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wt0o+iSb"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6acaee38a75so169448eaf.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 06:41:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785332461; cv=none;
        d=google.com; s=arc-20260327;
        b=m8btpTNm1Q7y2bxP/6JbSETdswQItbuyv+fNZ0UAOIf7OT7OK8/tfbQY6a9jxhzXI0
         Ku+Vfjj+7Jt+9ajOLcpk4oB5aEViJl+ygAoUE3rrs81CYN/4LbtkruazhWkq7sx0xwk7
         YCbVdi2qZrxJVOid833cA2NkbvFxQsKV0Y4d1o8gXVS5wg+olAfjZoO0Y1eRHbqoTXzW
         q9V7gSCtwBq7+FG3C6mX9Qp3NfwiB6BmoZqvSnQ/yGUjouTohe+vhmI1eDKKMtNAkrTS
         fsYbzbvfAt0q1Eq8DBB40d0l4ekJplRuTX5bwWH2qp+ru8gvJkvdsmvQRtc6CayXIWBJ
         /JjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hIAx79LJq6yxaX0RmXwDdX2gojdN9qwdNc0W9PAeu88=;
        fh=wyFKGA9BxXw1l4bUV2U7tEjBOaMMSsjqpxREjvbYkL4=;
        b=jaDiW4FaQGuw/hrj++XJFhzuWb6jlimynf9NoPvS3GR9XCJd4D9Hjoge30Ra/TE1A1
         IE2Y9+vuWNeAtH/eYOo82HvugoQjir3SKrogU4xtLdYL07HRmfrKq8Xqj7u/MDkYtBNp
         RTTmtj2o8rRA4lymbbYEvw/ivpwgUfWTIRFKefR/OZ01Smb4zwuIs/bmq+whUR3kpZId
         JqH2U11t1aFtCC5XuAEkvC+9m2paKrKebsh19R6g/7bMcaWM7sYc6bkqJoZyLd/CWDtu
         9hFKgRwAcphI36dD4Pq6Wq/rE9mn5BKjWaFxK3EIpEiX7cNtTmSed043B3TICkwQTsd0
         TaMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785332461; x=1785937261; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hIAx79LJq6yxaX0RmXwDdX2gojdN9qwdNc0W9PAeu88=;
        b=Wt0o+iSb3ZO3p06NkYt3dlagR5xSD+fuE+c5h+QJbdnATRumgkfuhiFsclz5YJlX1T
         Krkz2E7l1BFmXXaLgpTFngrXynPbcwWZEqAHNKBH6hTo7VmdotU5Pg7DkVdvt6dCT4nm
         qybbleFtDyWvbiBiOYsRFxZ1DvTTpzm6S1Dubbntsay0xuJ1t90ZzA/5ITk12sJX8BsW
         EhVQb1cFPFBBAVtsX+U9qC5WSo3qFl/Ca+2dgWRdUb+corE1rRJ/fyu4LnxZC5+65ViQ
         PI196gYPNH8nS8qP9qNUQlukDfseUqXgUGyXUV+rsO6OlTXx4W3jXNhUNm0MxTZevwJo
         0aBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785332461; x=1785937261;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hIAx79LJq6yxaX0RmXwDdX2gojdN9qwdNc0W9PAeu88=;
        b=Ot9xSXSLUdAVNwuygCPbsXSGn1BM6hSR78+xqTzEOc2QNwg2Eg6EgI2qEah2CFkYGy
         NxL05Lh1LWLJUlVOVOQKkKeWR4+V4dmOXylUcJcqGu/wFxqB/EfgMwNtN2GP7hPQnSwO
         dhl/hiFd3lkoFkcrfjw/uAQDqHT3gSF3mCOVtg3AKRxbfN8TvSubZwE14t4yDTWyz278
         0fMOd1hcxSCA0txOmqwEmvQUed9ZfNRJguctZvUmJ+g/lq30YC+KNy67Z2x5gE6m6Ml/
         cgfHz5lu5aXUkFGeqkpAEyBRJudqxX9UuVX78l8caPpZPbgM1KPEAsvMw9CZXUWKAyNf
         62Ng==
X-Gm-Message-State: AOJu0YyfZxUu6G0YuyaIb0QmYU76s45ipuL9vu2ue7Z4VRQme4Qo2sHt
	TNSMTutiw1Qk3NXsbSdA4zNC7fTZIcs9lU2KfzrJDu3D2XdJBrtB6inAbTxsJfV7VYoEyH+jxOq
	QZxE2ejBdnhDG6aqDC74dj/bWHXtJXe4=
X-Gm-Gg: AR+sD104KbcQitbvDqOhaYyyvPPHjbt4QCA6oeNw4GhCfCceYxir6gbs0tPi8Zak+vR
	bFl67xAJPRQohTBMkyrlaUp4XJNx3WDcrFESae3PhVdSEH1aoGv2O0bj39XZp8FBON1vDFJcJNb
	zvILpiz3clF2eWfEg9SKXsH/IcKso9Z35wffW6EkpJNk6UQTBD8kZx5eKWN4mSpz26LlrVPYalx
	59GLigDDSTXV2yzYaO9I9gdbFkuNzzI8JsEQDuB+VvCj2lj3EyH7Xr8FLHfxwMZDIJW61craZEq
	yeFnIv190x1gvLy6tM43oJATec0MuCGqfMyymC53ZHI=
X-Received: by 2002:a05:6820:81cf:b0:69e:b8:ffe4 with SMTP id
 006d021491bc7-6ac96a9188emr3235833eaf.32.1785332461086; Wed, 29 Jul 2026
 06:41:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719215817.2468580-1-wabsie@gmail.com> <20260719215817.2468580-3-wabsie@gmail.com>
 <907535d1-1d0a-4174-9513-11ef27002f36@oss.qualcomm.com>
In-Reply-To: <907535d1-1d0a-4174-9513-11ef27002f36@oss.qualcomm.com>
From: Mark Ruvald <wabsie@gmail.com>
Date: Wed, 29 Jul 2026 15:40:47 +0200
X-Gm-Features: AUfX_mwFJRh9UFyn8vVY0g4F-did_bGoH3rJlMU2VQPVwBGttxNK5Zw1bdL-VIQ
Message-ID: <CABmnzGrncCNgsjKHyScF_PzCWdBeezBb=utBc36cYhbzL-WyQw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] wifi: ath11k: make external IRQ control idempotent
To: Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Jeff Johnson <jjohnson@kernel.org>, 
	ath11k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

> can you elaborate the scenario where the repeated lifecycle disable
> happen for better understand ?

Hey Karthikeyan, the scenario is a failed reset retry:

ath11k_core_reset()
  disable IRQ/NAPI                 depth 0 -> 1
  power-cycle
  recovery does not complete
    another reset_work is queued
      reset_count > 1
        wait_for(reset_complete) times out
          disable IRQ/NAPI again   depth 1 -> 2

later recovery succeeds
  enable IRQ/NAPI                  depth 2 -> 1

NAPI is then enabled, but the IRQ remains masked. The patch makes the second
lifecycle disable a no-op - ie idempotent.

This is an error/retry path, mainly the PCI/MHI reset path.

I haven't reproduced that exact sequence on hardware, but it was under
suspicion during testing, reloading of modules and kexec etc.
So this patch is more of a belt-and-suspenders kind of thing.
Idempotency helps me sleep at night.

regards Mark
