Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6373264DA
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 09:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786872454; cv=none; b=u1pWterYugI56Bg3R5ZE12YFRWyffB+vSgsf39/zm1djAhxNiFwaxMatfR8/8KDwFneWFMoBRQFLxTGeQ9IUSkwxni4wVw03kqkXFmyJi3pxXZ/8Hnim6wJXYetSWu4ZzNpSI9pSTGy/0Y1/pgY4WQTNB4busLbEjxAm8CQszyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786872454; c=relaxed/simple;
	bh=gHaxS2CMGM6ltvdh+vUAj+mhVVXmU1FfTCkmGfYFns0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tx5JrFMmendqZxXhjz02sTyfwfyBO6J1K8P/XBYi1RsHfo1Ob71/jMsOZcDMsdyiaOuyttpZeymmnTN2BRu7KUFAkp2388AE6ccR+vk3BhitAr1w7v89f2iAXXK0k1tlWtKSNMZNlsnEfriPBsVMUJT2xlLBBhqtFCgTTjWn0Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JAD68Yo1; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JAD68Yo1"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso2522452a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 02:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786872452; x=1787477252;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6J7Zj/2iLPXHmJLANMYAlHCnCm6alEEBJz8C1vVMkgk=;
        b=YC1ief9fH9fvKVsRieIkDKLdGr/WODhGA01uvV1OmZxhTavNlpApCT9+lt+PvSrDk7
         K95l0h97ghSpYqU+NvQ3xNjW3eRqwcIRH96dEdd1UD7uUrZhFuhgPitY42oS1EkkAUhS
         bxON7O2MMt1fWuF+8rxeau+6UVrFDXM9aSN8bEC3ROzkEJ1KMOfrUZLwhuhy8tlKUocy
         2HpZUlNnRH89EE73lcs58beTM80e/hCGQrBpEMnKRq13kWhEW2MPuq1k1xMHP57vVgng
         RG4VrmiE/odPsgL1Pr63AXtD9/ZympzASJTtioIW/Vx8xsorLpttSsJQA6aUuwf0U3S+
         TgkQ==
X-Forwarded-Encrypted: i=1; AHgh+RpLrtZ8Y/U6+c3KUAsov99hBJ0hRstFtGHU7hff51FqCvbO/cjn5/1Ru2Qb3Fe9WqTcGwEYRHDmjPcbzlYPsA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzM8sAT1Pw5I/T5UaJViI2QRhmCjpyWkx8DH/ghNpH1Px43XbgS
	FazkQ+XWutqKmlcxpMU802fIi8dGc2OL6Xe/maD8Ha0lq2Gj7LNKRpsUtZY8BmzeTgm4iKZDOCK
	8OFA9Jg+e2okuVpCMwEkgvRnmzEP4gdY1vx8U725NCIb06ENWd6E2Z81MCwuWcsRDvNEu7pQmrg
	BjIW32wbJT0pmXXdNWbS8sFNnUa9ud2WFVOyKKXZ6oxRWMdcKR/pA31T2YjGwgpQR0EfgMhSPqN
	x0XMwybQ+0WyKglS2e/lH2kodaN
X-Gm-Gg: AR+sD11VWkvPPuB/O24VLHaItdB9YmA5EYAyRgB6uWo9eiMdFIu4rcMu3P8WeOtwMNk
	ysElnxuhDIXRD7T0l7xCkhdS0kZLk4ACDRLrWEORJkEc38Xzox5YPX7YsbT4DRXVjS3V3XJVR+H
	WhO0WvQpe3fyRWuG566GoE3Zfl/9G2TFKoPiorH65nWZRLW5YwfUt0zs0lN30e0WyMB3lUvrSiO
	9+7A00uXHKiO43HDrJaE4+dIeS+fZvBUNl4/XSzVvRTw8kII8E5qM+JqCoG6jiQK99KWZbVr3rX
	wY/W81M+kFyc5qPNWH92d8VAG2r5129i+8Hy0NZHFgsCgggyoeSYE29CtfhMyNVugPtcvkbLHZg
	X4Z1BYSl0pTy7OgBCaJscQKrz6057PTXEHqUeJdm0lTUNSZd1odV28WNdtAlR9Q7bw/zh5rZBl/
	DFapBUV3NeXw3JFUcp6xL1CvPqyE7x+Air2Q+83dU=
X-Received: by 2002:a17:90a:e7cd:b0:380:fead:448d with SMTP id 98e67ed59e1d1-3933b87224cmr17632912a91.13.1786872452079;
        Sun, 16 Aug 2026 02:27:32 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39531c3b13bsm567508a91.0.2026.08.16.02.27.31
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Aug 2026 02:27:32 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc12e8e22b7so1026664a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 02:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786872450; x=1787477250; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6J7Zj/2iLPXHmJLANMYAlHCnCm6alEEBJz8C1vVMkgk=;
        b=JAD68Yo11J1YEEdaQzy7E/IWaBUTGu5gjM3tGSi2rpZztg6lMg+cm2n/CKJrBXGe2K
         4cLUKAilSB/oVdjRFbYya+srVJ8kWIc5wSVIuq5rEClwHyYtCZxP/EkII3NavnN67cXM
         Rwr1hdJmEzh1NYzw87E2rRjVCFbvIQ//limp0=
X-Forwarded-Encrypted: i=1; AHgh+RrYYK/3vAI8bARxASfJNwx0FewpSZIasVAvUlZaR6Ce0qD6s+kr5StB/elroRzieVBSOZhqN9fI6W479mEdAw==@vger.kernel.org
X-Received: by 2002:a05:6a21:3384:b0:3b2:8685:1473 with SMTP id adf61e73a8af0-3cc719c7356mr23248611637.7.1786872450059;
        Sun, 16 Aug 2026 02:27:30 -0700 (PDT)
X-Received: by 2002:a05:6a21:3384:b0:3b2:8685:1473 with SMTP id adf61e73a8af0-3cc719c7356mr23248589637.7.1786872449629;
        Sun, 16 Aug 2026 02:27:29 -0700 (PDT)
Received: from [10.229.42.78] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141387e49d3sm29196000c88.7.2026.08.16.02.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 02:27:29 -0700 (PDT)
Message-ID: <999f6e0e-8706-479e-a861-be83fb022a62@broadcom.com>
Date: Sun, 16 Aug 2026 11:27:23 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: brcmfmac: allow opting into PM_MAX
 power management
To: Alexander Fischer <alexander@fischermail.me>,
 linux-wireless@vger.kernel.org
Cc: brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 linux-kernel@vger.kernel.org, Andre Eikmeyer <dev@deq.rocks>
References: <20260810150552.25375-1-alexander@fischermail.me>
 <20260814205115.799977-1-alexander@fischermail.me>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260814205115.799977-1-alexander@fischermail.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 14/08/2026 22:51, Alexander Fischer wrote:
> Hello,
> 
> I would like to withdraw this patch.
> 
> Further testing on BCM4364 showed intermittent latency spikes of about
> 50-250 ms with PM_MAX. The connection can work normally for extended
> periods, but the issue is reproducible and disappears after switching
> back to PM_FAST. This invalidates my earlier statement that I had
> observed no latency regression.

At least thanks for testing.
> Given this trade-off, I no longer think exposing PM_MAX through this new
> module parameter is worthwhile, and I do not plan to send a v2. Please
> drop the patch.

Agree.

> pw-bot: changes-requested
> 
> Sorry for the noise, and thanks for your time.
No problem. Had only glanced at the patch so far. I did have my doubts 
about your latency statement, but not fired up my setup with it.

Regards,
Arend
