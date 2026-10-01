Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CFB3AFCEB
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 11:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855680; cv=none; b=Rq0CxuJzS8E4AJfOLo/h0EOmoKrGLPXzQ5WFU/ic5yuI2r4aoOLyDUIwr2GYMTHnz7i+7Gc5D9Eg2z0nBZtHEcypPRDrJAZgYtN2x6OKFu0/wdGAca0GYHzuY7aBk5/zyBr+sP/qBNx1QLk7tsXe7bAKDB6/nLqUXMhXFcvRSPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855680; c=relaxed/simple;
	bh=baCT4wfTg+IGi44EpWy/Yu1MX338NQxsuAkGvm/V0ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFTqEijT+LzCM3bsqM8GIhUXT3Iv3Ljmv+kWwma3qfdGI5YXty2osVjO7RffR3KMwSRDxTMU7uRlDemr8ylx8hhvPLefoYimXo14hcI5FNmBQzg6VHiGxv4vZJJWyFhI4Kz+EqmN+O7re1Qp3ir36Svo/aVFeF6dALztjGYiMGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SY4Uhoz3; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SY4Uhoz3"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a022e9cbebso3706345e9.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 04:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790855672; x=1791460472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=baCT4wfTg+IGi44EpWy/Yu1MX338NQxsuAkGvm/V0ME=;
        b=SY4Uhoz33STtlz44uQtBpzJDF2+/79IyRD3CtMi5WlFIznWUaEKF4SniZHPcdxfLbC
         DPmr/B0BA/go6eALuf1qYwF2YEptp8NEp4mlNUFkCH3zWVbnsE24xAsx3JJQmJ7g5hdK
         ggJPPKZf8cyd4+ERWKOJ65Irq+0ScwqKD7uSGhR4CFs4qXBIGlsm00Z94GGQAAILY4zb
         AECts98hCuhNBNMuAYduAWHhKpuBaB6oSGXbfPooJvXTbvxsmnqeUWZKsnjCIfVneqJ8
         UZ4bMaI+sdfCVqM4/LAEnbdohpo+OtuIoavkhfqB4+R0nnQSUANEGLuiUvtS0dtPTTwC
         cuAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790855672; x=1791460472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=baCT4wfTg+IGi44EpWy/Yu1MX338NQxsuAkGvm/V0ME=;
        b=Fb2CtNy4OshH5GJ39z2dFf8a6L50mjrMn64V6/dBX/LXzOWOwxopTV9bkRV9Tith1U
         wKz3/FmIXCClK6zj4e2usbqp4IAxmvO+0fnn97mYxyKv1lGJ2nP850NA1CKAy5L0eCAM
         HREy1l8am99XIjETAHYT0qNM33aYXJVdOvfkREx42F64C2bsnPdQRPLA5j384RyBeddK
         WkWxG1tFe7eQppqNrSKMdUWfIOODfRNZd/VgqYyFAvdRuSghDMP4RJx1JptH2bhggjmw
         ldf1rzE2JuplP24SXB+nH2gRQGybXK+hSPkMFPdT09AoToLeI+vrV9SVUu6MiSVAO3h0
         j0ZA==
X-Forwarded-Encrypted: i=1; AKwUvBx/aSZUwhGDZLKt9urVfVjv682egtcbHMU1E2Avc1PTZln7sTXX6+jAI6RN+bwnlJ71+ijwClBi+1jBW1Thog==@vger.kernel.org
X-Gm-Message-State: AFuF++lur9fMkTV8LOCmQKqib45IrqTT1NYPfhRu39Kxx2cFeAQaYAQj
	EAjUCVu2OkqlRf4V2CxrOF5498ptd74mOXrXDiCE2HpcmwP/QkXRXQxU
X-Gm-Gg: AYBFou2BibWw4JhQJMYOppaWBOwtV2IKa3dpv9rHkDOE67K6pHPQ1RjZchPG2Qy/Hzn
	fjIikNQrTq0ecNtDqhBptCnmchDlfCrJXRbitWGBejYlPMWSptNzxKHb1pzwnFyhofNTOlnZv7c
	Hb3g5cQYDY5QEyq8uokaZsTLwHe9buczte5+GWDMjLdXUDJ9kCAck7vHMDycLaNP37d7EC9anXX
	+FzAhF9MKrk2Ri1Lh+so/iz6nieUzR731BDT7OI26qr9pKygjB/gMfFPviTV5F/wzMZciJG0DlT
	apbuaKSCrZSF8/8rjA8FsmepCeO9UtbwrOmBU0Vssfy+hy3Go5tg4Ach2CIPSoxzr0VCOiea3t1
	xVCZ+BDeFK7eWurnWe3W/19u0KxzgLWAKB7038U1WmxQUx91pKaCNsbc9v43cEiS2u5mfenIHYP
	tUsR5msnE7LTGNbzK+Hm9j4ISUa8RAXn+ZjL/k0Sf9qhn3vpOoAxPut5I9PzO4CNxfZ2xlm0Hp6
	dTM
X-Received: by 2002:a05:600c:3b9f:b0:4a0:1b21:2628 with SMTP id 5b1f17b1804b1-4a01b212757mr76481705e9.23.1790855671923;
        Thu, 01 Oct 2026 04:54:31 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f938f89sm56229115e9.9.2026.10.01.04.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 04:54:31 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v2 2/2] wifi: rtw88: support channel switch in AP mode
Date: Thu,  1 Oct 2026 13:54:30 +0200
Message-ID: <20261001115430.2979761-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001071822.17746-1-luka.gejak@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

On 2026-10-01 Luka Gejak wrote:
> This work is not the only one that re-downloads the page. Every page download
> fetches a beacon, through rtw_get_rsvd_page_skb():
[...]
> A station that wakes up in power save during the countdown is enough, so one
> interval can move the count twice, for example 4 on air and then 2, and a fetch
> that lands after the counter reached 1 makes mac80211 log "beacon TX faster than
> countdown". Can the set_tim work skip the download while a switch is announced?
> rtw_fw_csa_beacon_work() rebuilds the page one interval later, so the new TIM
> still gets out and the countdown keeps one step per interval.

You are right, I had only looked at the paths the series touches. v3
makes rtw_fw_update_beacon_work() return without a download while the
vif that owns the beacon page has csa_active set; the csa work rebuilds
the page, TIM included, within the interval.

I went through the other callers of rtw_fw_download_rsvd_page() for the
same pattern. One more is reachable with an AP: set_key downloads the
page for the PG deep-sleep backup, so a station installing a key during
the countdown would add a step on a chip with that mode; v3 skips that
download the same way. BSS_CHANGED_BEACON during a countdown re-arms
the csa work timer, so that download replaces the step instead of
adding one; the hw scan is refused while a switch is announced; the
WoWLAN downloads run after suspend cancelled the work; the ASSOC
download is station mode.

I will check it with a station in power save during the countdown and
watch for mac80211's "beacon TX faster than countdown" before and after.

Best regards,
Mehmet
