Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3660F488757
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786636381; cv=none; b=tTB+xHg8H801N1nWC83ME40IFFgOZZ4I7tXRWbfmvJxt4hdVOY4zXwdFUrsKhN3haqwoE5H0aCfVq8aNIKVzHxRAMPB6Ue912vcE7llCT+V73kWbUyzsa8LOmha97mkFUBI1xRcLsniUjhyQywVmtWIISgLCtnKg3ntEeViP7yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786636381; c=relaxed/simple;
	bh=Lf0/l9SjmdszMnvIlBnumgO1zpkWzhYliVln6iJoC7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbYgOxJtG63hfd0cBXCGmE8ooYaOmxCG47B3IQDQrHtPblcewctXPFbCGdLeLZ1imr4JJStZSM5RnUIM6+cqo0ujgX3I9dmpjXGlMbcSW4L9l68OttRUHwGIXFILAiHkf9v6o1V1bjcLeG5OTYS+t+HsIsaSXv65Rtlkr8xT0w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i/9MPtXl; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/9MPtXl"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49802c418b5so707745e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 08:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786636374; x=1787241174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lf0/l9SjmdszMnvIlBnumgO1zpkWzhYliVln6iJoC7I=;
        b=i/9MPtXl1Za+VJ9YAMM1FwLSrKjH9W5MqJffhXfZr+Fvhwt6x0/umXciO+GtE58h2p
         +27kICEwEpEhce/RA8aYdNjzKMxFi2lx6EFuRPfFltMcM2unz2jiCNuEZdc/gPk4QGXH
         Bls/hCx8aFk/0ki0jMDEzZ3mM8wzmcAl9x5QNKoud3FXSCPglYlsv/jVRKqgnSUBUqim
         LKGiadpiixtABHWhv6w3tp5ZqLxrDEyw7Gq4AE3Chwze0fKkvxAtCf5FzO0Cp2lELmQ1
         P4nAC+xTPv5YqdXYWPY6mgiYJj+8bbag7eSUszwcURlsXt4L4N70pK78f2aoLZ+ZyYMk
         1uVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786636374; x=1787241174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lf0/l9SjmdszMnvIlBnumgO1zpkWzhYliVln6iJoC7I=;
        b=HxbIL1TrDegl/yMxwn35TOvfN2V2qVPaG2BJL6SPRQ7dLqHue2YA6wdJjRaij9vfdq
         TAVPQastYECMDFE+X8M1vtUcvqDjkGhs/VafFq45qnSfdY62RodksHmDaSUXU1TjMzbS
         WPIIIZLqx5/sv1ds0Ov8Fm+Z1X8MQXwC1/QHdg1yP0Yg9RkESsoClj1LdVt2QNqeXNPG
         Yn/2FrPjgJRK3AEl14Jn5hAxZ3T/JI/RbfPUMCByAgslSeRpZ2HuHooBwuilrizlKEfL
         esg+C1RvuSiEY5JLe6tDSjd285DkrIhmE4ZTG93XXInujRIZuncUbA80KvdYqt8ADiq0
         ep4w==
X-Forwarded-Encrypted: i=1; AHgh+RpvZEYX8FwxS5DfRy4fhPFPGbwcUVjkSZ0rMJJr5TptAuvfBw7ZvMCMkJ3pGORFDZxLV6DSV5ShvTOlSg5Eiw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Qyx5/pAb7FhwUTe1a2BVpDGJf44AHYChC7NIfkWmiyNWjvnG
	L30hr011d0EbWyNt/TlpYggLrayVCVfeP1stgJ5GB0JB4nyWcnOGyMNK
X-Gm-Gg: AR+sD11zPtMe9yGD+hTonBHVNfSq0ohem3xCtUpvpTssBPs8nz6lne8aFY0PyYU7Ks8
	jL0kT7LowQv+JRtelyTmQRXdBYN8qpU8aHpdnDoGl/45CI5IyPVT6fKuolIXoyD0WrKyL/S+OZ5
	8+GLtM2mMZ9q9F9yj3alDDs2X/2eskpTzZZOJ1C43Pz/TGBexEyqtNSb8fabtGYbqcy9s8F15/k
	vf/zBxh74mAba1DE5STVbFJFP8/B1F+h3qE/JzBFnJBKo5qNNmUatQzLuRzHkrsqUbXdYCfqy8G
	d+NO+EHHPNnB+9nf9a6OKSs67yceKM4ntZgnObx725Gk6fVkqpatH+WGtl/lVWykFFhu1F+08ob
	QtBU4Ndys1Ruol9OqTQKuY5t6MZITt1SdBKvZL6cFt2HEjSDWXglD8FizES+fA5tqRgVionsoR9
	PTZmgDStyk5raTfrprfYygGiNWlu4kMk2hq6QfkbPQWtXmLylcFGayWP2q1R3gQL3TGQ==
X-Received: by 2002:a05:600c:3b2a:b0:499:78b3:7b36 with SMTP id 5b1f17b1804b1-499821c9a1emr75650485e9.11.1786636373908;
        Thu, 13 Aug 2026 08:52:53 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f21a24esm326560f8f.11.2026.08.13.08.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 08:52:53 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via the AC queues
Date: Thu, 13 Aug 2026 17:52:52 +0200
Message-ID: <20260813155252.2265589-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <4bb13bf2-8588-4235-a1ec-b82e6668c982@gmail.com>
References: <4bb13bf2-8588-4235-a1ec-b82e6668c982@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

Hello Bitterblue,

> I wonder if you can reproduce this problem with kernel 6.5? It looks
> like commit 076f786a0ae1 ("wifi: rtw88: Fix AP mode incorrect DTIM
> behavior") from 6.5 was supposed to fix the exact same problem.
> This is also the commit which introduced the code you are now removing.

Thanks, I was not aware of that commit, and you are right that my patch
reverts exactly the usb.c hunk of it; the MORE_DATA and HGQMD parts
stay. I will say that in the commit message in a v2.

I did not run 6.5 and cannot easily on this hardware, the board support
we run starts at 6.12. I do not think it would add information though:
the code from 076f786a0ae1 is unchanged between 6.5 and the 6.12.103 I
tested, and it was demonstrably engaged while the AP was wedged. In a
register snapshot taken in that state REG_TCR reads 0x00303030, so
BIT_TCR_UPDATE_HGQMD was set. Still, the high queue drained at about 14
frames a second, roughly 3 frames per DTIM at beacon interval 100 and
dtim_period 2, measured over minutes from the URB submit/complete
counters, while several hundred frames sat queued. So at least on
RTL8822BU the burst fetch does not happen even with that fix active.
RTL8821CU behaves the same, measured today on the same bench with only
the dongle swapped: stock fails the reconnect test 0/3 with the "error
beacon valid" messages appearing, and passes 5/5 with none once the bmc
routing is reverted. RTL8822BU is 0/5 stock and 10/10 with the revert.

I also think the two problems are different. 076f786a0ae1 addresses the
hardware fetching one buffered packet per DTIM instead of the whole
burst. What we hit is sustained inflow above any DTIM-paced outflow: on
USB the high queue shares the single bulk-out endpoint and the page
pool with the beacon and H2C queues, so once the pool is exhausted
(measured: 14 of 1803 pages left) the beacon reserved-page download
fails ("error beacon valid"), the TIM stops updating, and the firmware
never releases the burst, which closes the loop and no station can
associate again.

If you would rather keep the after-DTIM delivery for stations in power
save, I am happy to test an alternative, for example routing bmc to the
high queue only while a station is actually in PS, or a depth cap on
the high queue. On this hardware the plain AC-queue routing is what I
could verify.

Thanks,
Mehmet
