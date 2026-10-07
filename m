Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70323F482C
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 06:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354114; cv=none; b=sqfZ2jqHo4q5moXQGXxlcw0+KMVXcml6PYl/crud41jpHoXgoQzwDVUXzWh1Pa4r9dtChGq7ywTIyfuEWTVF/6BFCUWe4/NfKbCLScq6WNBeU3jzo6fuFcPTwzaRvj6haUOxUtRlpWJQ9A2K8P1ZCxfkg+/yffGA31Vyf5gky2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354114; c=relaxed/simple;
	bh=1IpiDcXZO6cmR758XcfRBABk089RXsqbT8ncmzLrEmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PR7/8UwclV43mydG5DhghARyqE7MssVcc9QS79n/KWc+xAIlQ1yasqN35vamKWXU0RcTekYUcg/1F5Sc9wnr4/oYxA6DAPpqND3zzzMsIYK8ceXlKFgUeppCZpgJfkE4Tpsx8lV8GlBw2Ly98Pk+jTMKStb5whelH0DJLswWnVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BEu4/1z/; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEu4/1z/"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so23771955e9.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 23:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791354111; x=1791958911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1IpiDcXZO6cmR758XcfRBABk089RXsqbT8ncmzLrEmk=;
        b=BEu4/1z/NCGqgGz0z1Zaca0lOyYHOQsGsBeu9SAh4exFmlQGGo0hJ1O+ZdgREqh8Zr
         6P0Df1Or5DsopF7X7WehU8lhGwvEDgnFA9ZdTrPgPf3zHLvo/+7YcCbI/MX8b6Oc6XAq
         ax22oG7MrQjwfu1OARv9M4B+6rR3cGNHA+GPwbletEZZPZCTsSLyuJeO0ysR57M1No3g
         CERiayGJH1Z5U+D6UMJR0fuHNPHyGvzI7of0g/PylYEtTwjduhxP0F90Lvd4Ms9uA6KF
         rheX0ziOY7vMohEMrTPj1x3OXG1IT2NywPex0701UYEENfo+CL0MG1S3Of959an6+AOp
         LjGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791354111; x=1791958911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1IpiDcXZO6cmR758XcfRBABk089RXsqbT8ncmzLrEmk=;
        b=chai1YEirikI0I+1esOGvfGpW2gGEwg2i/AjP96RoLR0AVThySQHthRQeyhqPmm7WO
         Trb2ikPvrqaj2oMB0U+Miedb+zAj8zgMJWT8n+xEp0Xin9YMqwIL1tc58RhoA8N2ZZFF
         bg8m6V0io8nuAyxZPoxOx4qW6Hk/IeiBEfFjxvkpYESmFwOON54XeleH1xqUYbp2WYNs
         P2FrxpWz6P5Sa+3Spq4P9DI/kBhtTei41LrLphu1oDoT8ppgoiYMCvsfWOy1YbLOmOxs
         PCOJLLMd4PdZuBipeBVO/IDB1F15LMUIVUx92VpjZrKWlFe+q3NtsIx8WCGCdN5/hmxX
         Pbtg==
X-Forwarded-Encrypted: i=1; AKwUvBzhEU4mtsSyBlXI/FRfDC/qjv73XrZmgrsNquLCiy+MjMvAmbGogCMT7Qpa8GtlD/SAMq3IN+UxU9GctJpgPQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lLF4ylWKKHFoLEqFYAgKNE5OvWghdTl6XjEzfyjT2hximaCTFb
	ws8rssWJNcSshLCU3ichrA7G4b9sSRptc8t1JePyEr3evVDHP1HE+JoB
X-Gm-Gg: AYBFou3pn6yUec9Id1l/7F25Gu1ItMIM1A+wqcZE9BrDqg+MpKZAKA/ntbpSh16uTw9
	vVd6XZEMw8AS/++3Wy9ayDEIjC+w2hWbogcq2g1WJdvTO9pAyxFad7KQ68+kj9QQ2GzZ7ixhLbo
	oOBIZzk+tdqkQgXK1L6q2SvwDYDz64MHWyOgGum/xfiP1+/iBRE3EMZg32sU88fUo/6ND5qQf1d
	gHkZwlzU9YzTDZS2Vu1918R4RQ10M+3BL3V3MiWIA7pF/MwNHISIjEOWOmZ4hK0LKnjG0Bn+RQq
	ThrrwvMdP6s8yk7FpuYxnNr8+fVgprLrUX46rxYc5GzsSD4mJVbNbtT9K36CaXhHJE64bOQfwwF
	foSZ8cZNnFG2ugyAyMNImeCA1SF9Z8FRLIolmUQcgVYsOWH7CV4F7lrWkJ9pnYbB8eKSAITg+3z
	4ef4dfLTTKrhtBwg3U3sCIC7RyEwFAGqaE4DDbYr5NlaUTSCeAJARmrD16d440nL/gyJajb76o2
	CQR6sUh9xvEe7Q=
X-Received: by 2002:a05:600c:530e:b0:49f:ffd0:4039 with SMTP id 5b1f17b1804b1-4a1806504fdmr14110665e9.32.1791354110998;
        Tue, 06 Oct 2026 23:21:50 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f795f29sm37438205e9.11.2026.10.06.23.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 23:21:50 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org,
	Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: Please apply 13221be72034 ("wifi: rtw88: Handle C2H_ADAPTIVITY in rtw_fw_c2h_cmd_handle()") to 6.6.y and 6.12.y
Date: Wed,  7 Oct 2026 08:21:49 +0200
Message-ID: <20261007062149.2086871-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <2026-10-06-1-daily-reply-0002-rtw88-c2h-adaptivity@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Sasha,

On 2026-10-06 Sasha Levin wrote:
> Could you send the full trace, and say whether your kernel carries that
> conversion or other local rtw88 changes? We will take the patch if it
> reproduces on unmodified stable.

You are right, and sorry for the noise: our 6.12 tree carries a backport
of 3e3aa566dd18 ("wifi: rtw88: usb: Preallocate and reuse the RX skbs"),
so the RX work runs on a BH workqueue there. The splat is the missing
follow-up to our own backport, not a problem of stock 6.12.y or 6.6.y.
Please drop the request.

Thanks,
Mehmet
