Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3AC416844
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 20:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838147; cv=none; b=m4prvmR2sr/JuoVWZrE7FjvlWO2a743AyEwtpntaNRsuoc2pkel/7VB8tS/pNYDRWRGnwLGVaQMuBjWlCIhY0u1Cem8IRTT3ub/+TXUF5poyDieAekFfP51DjnTHYn/g2YDlMRgj+8glGsKZ0+u7JzXLodvP/VmUqF3FOpOm7As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838147; c=relaxed/simple;
	bh=GIkU30C9WJEnTrtP4imH33hNOAkn0FzP0QJG2+bzhKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyrspiGYbxIye1q4AZd853xPi4zdVYVX7JuIFGuWcChFsCVIPREOo02rDicaNkG+IC4tgWXjdVF+J2Q7dy4etiGDVltGbykk/aIsrtqiGVr5iZjiWGL5wWKOZ5Rhaxl/xxS+iYjg5o63monmN0OE92vB8Lz1XTzXLYbCDvGiyrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YdnICrkr; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YdnICrkr"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84861fc51f5so557581b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 13:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784838137; x=1785442937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GIkU30C9WJEnTrtP4imH33hNOAkn0FzP0QJG2+bzhKQ=;
        b=YdnICrkrU9sMuuST8IIbL6IPIwAJFdKf3BBkzWeV+PRgHmjGY8GAiYRXYWPo+rNp+c
         OVIfwbcWkzcW6Fm7qxcnsLNcIj8utqZisF9AL531uhE7pDZR6v6scV5ocl+IIfZkU/84
         ruNoZpgQ9LkfJEpl7CFdXcvdOSu5lLhUtIH4Ph35/Wo4PygtTUE36KWU741TOntVpVzL
         OPQXCirQjfHud8mg4DZApkc9p2DsqNoeTpMKc1wvCN2oMo2IrQbkPeLqeSRASddyaVja
         GrJuqDTmJlVJtc8reICARiXE43Uu6kt3By5OiUPSry2UOgIDJp35L/iHJRwK6MjU/VuU
         cG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838137; x=1785442937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GIkU30C9WJEnTrtP4imH33hNOAkn0FzP0QJG2+bzhKQ=;
        b=roog/9xs1NsgbGxotRhcAp+bsCKLn8ZOdXqAd7nD42SQnGcuFm3o8dwIlQG+S9AbM2
         WhqaG/Cnp0OvadWPDJAqemvs4TG2GBkNKSc1hOVKsPMCVG21x9xjtY/IGzOevcwragbG
         30ArblVfBvOcOzTDwcjNTwbM+A8OfACdcjnaMPCq4Vj+TLahTvGDmRiTyPElZAgZ6N2Y
         kdtR8UeO0i0QznZS54wrZRRyQ2oe38Ze9KEGoBZoCIys//Desjdt2Ulsy+qJjyDY+TfQ
         ti6/PYWQCJSenlT9OKBC1s0e8YmeUQMDmzo2qmc3xsYmexi8HQD6++FKxSBU2LZNWUsR
         rzew==
X-Gm-Message-State: AOJu0Yyh69GjelffMlyWZ/ybe1+T+wRYqDHJ4JkvefrSsQUW6GeCuiO2
	kUe5WKZL5Iakkdq/6QmY1Sl98eLNSmuOmP8ToRLQ2wr9iafRZumHXdbT
X-Gm-Gg: AR+sD13H1MEmOtKdq/udWoA7PIJMsNjT6XhG4NM/+GSQ6hUhAO6bdOR0lrzzzVTHbDk
	ltoDJkFsEJ3PoKbeYQz4VArhCFSh1phgUMWStycjEy0Y8TyzR6SZH5hIbbNJ6gruO+66UssGkP+
	Yg3VFxL5tAMA5xY7KqO3L1vYt2Ljusg54/+qUTR0fREZ6n5j/LnhsFPzdy4QENL15KT74YsJNTO
	1RRiyi/NqkYmLEaWgByQ/U++c1z5WmNbAWhgOgRHWsqE+Si1aCl63FPEOIwwyvYQ8k3UH1tUdsT
	xeA7UV0Ac59ucCjt88Gs+BeMsPNGgm3XNhkfs5vJXHmJow3e7dqgY2PbJh1VIJQLw0jv8WrVBwx
	vkkcKg7wUdlZtcP4p4kQU+tH+118DgSMAq/oezzgwmmiSh4RpOACbB/cNqrSSCiECzzp+qAKgBz
	7s+VRXc00unRB2HK79GD7NBZoABurUh9rvARNGtgzv
X-Received: by 2002:a05:6a00:94f7:b0:84c:5349:daa1 with SMTP id d2e1a72fcca58-84e2bc2ea4cmr5328562b3a.76.1784838137139;
        Thu, 23 Jul 2026 13:22:17 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([61.141.241.108])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f1a912asm3310729a12.27.2026.07.23.13.22.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jul 2026 13:22:16 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: cfg80211: publish PMSR request before starting the driver
Date: Fri, 24 Jul 2026 04:22:09 +0800
Message-ID: <20260723202209.98437-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <3552acdf7839106b152edfd13502684306ea42a3.camel@sipsolutions.net>
References: <3552acdf7839106b152edfd13502684306ea42a3.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 23 Jul 2026 at 10:18:33 +0200, Johannes Berg wrote:
> However, I don't think it makes sense to actually *document* that it's
> now possible - it's only possible from the kernel's locking POV, from
> userspace's POV it's still highly confusing at best, and it makes no
> sense semantically either.

Agreed. I'll drop the kernel-doc changes. Documenting it implies it's a
supported semantic when it's really just a locking side effect.

> That comment then should call out how it's really about preventing races
> with drivers from doing UAF (we could technically be preempted here too),
> rather than making that sound like a reasonable order - just saying "Under
> races and/or broken drivers immediate completion might free it ..." or
> something along those lines would be better I think.

Exactly. I'll reword the comment to frame it as defensive against races
and broken drivers, not as an intentional ordering.

Will send a v2.

Thanks,
Zhao
