Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE80C4399C9
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 10:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801028; cv=none; b=EPCjVvbB6BLEr3hiQIQ2l1oMlEEDVqnavnfgODRZGY1IWftuiqTRKI7vXeqq+EXB+izRWpvHyulE8fln8El7YVFzMalDSZ8ZAX4Xlc0yGNMW6oeiZPp/XtS1OEboioymNqLU8NqgfUpavnx8uiDqB2yQjmkOvWLsdL98lIVFqMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801028; c=relaxed/simple;
	bh=v27qlq6O+ChLql5KYoPvR5jItr/Zg9lBtaKG2IWdk9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l6svNvo/cX342YgQkA6uD6CdbXPZIiLmJ3WOZPX2a5upEzPnysHlfx1xo9OT8wtUY6dEtd+F7zShgceu/tXUbazer/1VffYtOwmQsXXt2oZPKVha4BeE24uwLFSrXHisq+dxqmkAisnNBqRY7Cb+7fLkX6DZ3/5QLC2M7N5SCcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=bA/Qt+ok; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="bA/Qt+ok"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-ca957432c7fso341852a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 03:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1784801026; x=1785405826; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vv97HECfZlKm/dbim3KVUHBJD7UUj/8O/oWphiR2f1E=;
        b=bA/Qt+okBbLcVCyjNPg2H+snSMbYF5e0CEVqd0sb5Lai2uBJo88OxM2Qz8iJkrkpIc
         FMWBS6TuTpc1hD6mGqaJ/M6MhFnoTljBl6loSH84mIZ3wFd0rRJ8EPttaACmw74xXvtJ
         kIcNQHrMT/nzw7LtV6dnjT9fxVQJAED/iVLDIYvCfyvGRharwjZhqvR9ARiQXV1nik6S
         jdfzPtZk+CsO4uFnKKZGZaPSVQx6FEt25x9NRsZ1VVdJuKYXYB7QafUnEtRStEpxQyo1
         iSza4KTtto0xtsQtL5TzURNDAMcMjLPPXfWWwmWkD2Ia3ZnRasLIufAx5u4FhBlie4Ml
         gjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784801026; x=1785405826;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vv97HECfZlKm/dbim3KVUHBJD7UUj/8O/oWphiR2f1E=;
        b=SGYEHh3GBJl6bZuWj4TFvTOmO7MFs4HsPUwMeeje8ClWorM9aqSzoRi3mUBBHHen9f
         +d/v5O60Pq1o0r9N6JaHE64WwKOCgToUTmT1DXknbhSLvm+FSn1kvB2lxy4nwXb6HoUR
         sRKPA1J9GxzVTVIQzfBFFk4QqkB7bxccvcT12R1jOo8snbfH+9B4P9DZ7sgsTZykf9/2
         J1+rVz+X9SjmIF8SM4bpor0whoqpBmip4dVD/YLsTYtqpHi346uA0omYbJsBjkZ9zCnE
         nefJGkeXTLuvpYn4yYZR2WGu6hEtm0T7/ymjy313BjAeB+m6yIuoXIChq4Gla0/uNPBj
         rUQg==
X-Forwarded-Encrypted: i=1; AHgh+RqUD4vDIMX7oRH5RikUvhNbva1Ju41OvjUXelLNCTTPyN/z2+lsq9PXGj+x7WNA75O93+qHdE1bCbF/KWQmng==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/+ol9CvuiTJeRZRchWX4FD/Ot0dDguBE000duD3zU8DnZe4zA
	PBgaOfXYAeUMUVES1QFY35yh06CDgt4rmOmH+OFtrz91AP6MzUyNUI/sgJ/IPUqKY7EEYHmGtMm
	r6eZDQUU=
X-Gm-Gg: AR+sD128L9XiPoSe3Th5/Ae0+KHMOu8Gqp0fmmGM9Ro4r5d/M3jxGxwRlwIRKnWUPfN
	uA4RnSY+stZhBuTHl5RH75ZHCnAb+YWKdXLGPQL5Vr8mnGlhZlFsrxyPdTS+ESy8oqCphJYGoWi
	zvhsFFh1wmr0JKkTxwST4HTQH+FSr98dSeGFVr4XaI3XomCUpQsf7zUFJ+gLi2lC4w8gCKGA0RM
	IHpBe+d8nxIxzhPrHquWYR5nkBcdQb1CPyiBpMFWYUmW4+JuzOvBCR5hqdAZh25+JmXpXtQKH1D
	5jGlz+WTAf2xS+zmEVaLvf3Gp0gBbehNbN6ovugIbKWTHsOv9xxxECSeF1dlhcwbI9zggy792c+
	fYaGtNydMCTNZ9kBWUE9DtQQehTMp6+3JmnPvRwLAREXOyvNvUMKKBHpuBYjO0z2LZgrN2wNyyl
	RGn0FFQcp7/hS49dN30p3LWhUlPseiiaX22atxpNK1PDY=
X-Received: by 2002:a05:6a20:e290:b0:3b4:b340:411d with SMTP id adf61e73a8af0-3c44affe895mr2527037637.24.1784801026255;
        Thu, 23 Jul 2026 03:03:46 -0700 (PDT)
Received: from localhost ([60.227.167.223])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc6162csm18228191eec.7.2026.07.23.03.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 03:03:45 -0700 (PDT)
Date: Thu, 23 Jul 2026 20:03:42 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Linmao Li <lilinmao@kylinos.cn>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Arien Judge <arien.judge@morsemicro.com>, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mm81x: shut down timers during teardown
Message-ID: <thux34fm3gx75mapyqyc777upzgn6nrrr33r6i63n3pnoogyzj@7mdt7lxeocqs>
References: <20260723092357.2362744-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723092357.2362744-1-lilinmao@kylinos.cn>

Hi,

On Thu, Jul 23, 2026 at 05:23:57PM +0800, Linmao Li wrote:
> The three timer teardown paths call timer_delete_sync_try() and ignore
> its return value. If a callback is running on another CPU it returns -1
> without waiting, and it does not prevent a later rearm even when it does
> deactivate a pending timer. mm81x_skbq_tx_complete() can rearm the
> stale-status timer, and the rc and yaps callbacks queue work that rearms
> their timers. Teardown can therefore continue with a callback still
> running or the timer rearmed, so it fires after the associated state has
> been freed.
> 
> Use timer_shutdown_sync() for these permanent teardowns: it waits for an
> in-flight callback and prevents any future rearm. In mm81x_rc_deinit()
> shut the timer down before cancel_work_sync() so the work can no longer
> recreate the timer/work cycle.
> 
> Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>

I think the subject could be a bit more descriptive as "shut down
timers during teardown" is fairly vague. I also think you need to
resend since the patch isn't appearing on the list or patchwork ?
Patch itself seems fine and a good fix.

@Johannes: I missed updating the exclusion list below, I assume I
should add an entry so you aren't CC'd on every patch?

NETWORKING DRIVERS (WIRELESS)
M:	Johannes Berg <johannes@sipsolutions.net>
L:	linux-wireless@vger.kernel.org
S:	Maintained
W:	https://wireless.wiki.kernel.org/
Q:	https://patchwork.kernel.org/project/linux-wireless/list/
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
F:	Documentation/devicetree/bindings/net/wireless/
F:	drivers/net/wireless/
X:	drivers/net/wireless/ath/
X:	drivers/net/wireless/broadcom/
X:	drivers/net/wireless/intel/
...

lachlan
