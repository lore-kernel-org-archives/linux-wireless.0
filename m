Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A88E439F99
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791788267; cv=none; b=fob6cSaikq3nYHFqX/XnTaEviAOOnSHJIq0mDYtT2amhZICimEwS2cBAjHj9SSUjz6iMN+iZYsUUdD+ttTgaZB0LPchUTQFcr4sgc9vX6szPznH3ljnxKG0r64BsGssaGFlLXmSwJolNXFpZB/1aNBL0qnv8xOpoEZdvZUdlDWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791788267; c=relaxed/simple;
	bh=bvgUSkY/ZkHuBwSfrmAs0SVNeagbkaaEQadDhf6Ehx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSp72uNAXgRQ5psvsPF2SATPMBrJxXjAOe6Tsd8598fTTiz9GGlZVTQlvCv9WR0RUYLCQQptFAaYMqrmlgeWbzbcb7HNTzIz0LEBUMK3YWxN3lkHUIDEwZwDEWxKWDbVfJf2L48AGe4WOyozX5P47m7hnycA8TkPcu++CfzDmvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lzsqWwd+; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lzsqWwd+"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b0584ad71so738293f8f.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 23:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791788263; x=1792393063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bvgUSkY/ZkHuBwSfrmAs0SVNeagbkaaEQadDhf6Ehx8=;
        b=lzsqWwd+KFRCvZeH7z1xLX4+9qhGLTGdrfzIqua4n4C1PmpgyX9DQfM+OPAy1BLyVf
         zdwT5pCv4ZiMiA2z4DkCwuz2um7N5ZRtcOtBofCvZvEyYVmalYmBqsQ4qGAwup5TOs27
         3+sO7zSGomtaIIqXH7E0pKaNuHVSQ9J5MN5k78k7xG2R0vVZazkc/+SgUHW/Az5S/b2I
         eZ22cTxrpzH3UQNze19tpJNz+weEo33f6HfJsykcB88JEMeh3157JMbVHJGy7gJ9J1gs
         j07ZmAEmZOX8Wvnly8u28GUdwWI52bmvv9rMpXTMoAqsg9WGCeJRolKQdPDGgfMPjPfM
         VhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791788263; x=1792393063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bvgUSkY/ZkHuBwSfrmAs0SVNeagbkaaEQadDhf6Ehx8=;
        b=jZw8fnACDjHw0lArof83gH+UfMBVLFxuGD9Eg6PjU4cJ13x2zbDK/ZLyYnKBqAdsqA
         I+TWNm5uxaS6IiR5/RDXwmomWUb2N9IR2mWtiYPYaffADb93uNiQzzDufM1dQVXLm+Uh
         ekv9aP0LNOI/NzGWJ2Ypa7R9LXuA9pUkWVQyff8bxUNcbllmYi8wmEOypAyORehX9sMa
         upQA8hL/roxiG5+qflyORtDRHE0N7ebls1GXtPpLC1MohfC9WowxqDY/dcf2wg1qHXCX
         6EM10h3xg05iUla78HdwW5XYiK+CJcYY7FlnYWL9Nc+gY51ZGqQsFLMkypK4yoUVdZyI
         z3jg==
X-Forwarded-Encrypted: i=1; AKwUvBz2QX/nDvWkKJh4brWs2e+UqXrr8CCdRDkhCOLI5g6n9S4nuCDXEy+8UnDkHRoQy6pK/gvrg7myRZ2YNj2pbg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJoNwoRBFMUS0yKOPL9jk6RWqef1oUNXq3sLtREfULtB0sJAnQZ
	p2NaHd6jHt13J0A7nu/Qnu/zw8xtJzPPxyGAJAcJ2VKF4YURehAKbQsD
X-Gm-Gg: AYBFou0EAroe9qKOKU2sAcyrKqQKDaGchtIfzfySBSG2cVskGR1YFHuZfGs6B+l1RRy
	6qiHk232eGBYBVp5syjtvD9HAJDAL8+Dfhb7e8KQFE2/uac/R6bv3G4smZYeDVDEe96cQhAolzj
	Xw2N6qufnOv8Djq1v18F5cM1OcMXXx9P6Q2Gg3rQkmAyP/5c4kIs3rm+WX4gsXdOp0ZI0s4Z8Jw
	B3CuJrKEhQzy+6+byDLZ8zJt89Dc+k0cMuY6IfH4FyjKzx2RmoYIQrfCYGwYGyNjvbc1ZEMqQTo
	FYWME/YZmvWriXWbty6GMnqe0wHtLkPsKuYzn3NXmma6RYN/MC3dPMIOKHL9VVvo/gQU+IPUOrf
	C4ioA6JREhGiZivUA8p327FbCkSBGDsDfIf6xWSFpqmk06LNclWFfhVJ5jgCVOWDTgDMGoNzciX
	0iCpvXk3ahWks2JJ4oL1PJydxB9+XSv7ZefnbiVrSIdWiqMx4kE4iLL9H2wSXYdmhieF59w9Kic
	zeT
X-Received: by 2002:a05:600d:8644:20b0:4a1:9eb2:b2a8 with SMTP id 5b1f17b1804b1-4a19eb2b2dfmr25139195e9.29.1791788263224;
        Sun, 11 Oct 2026 23:57:43 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9ae1c4fsm17553553f8f.58.2026.10.11.23.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 23:57:42 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next v5 2/3] wifi: rtw88: update the beacon from a wiphy work
Date: Mon, 12 Oct 2026 08:57:41 +0200
Message-ID: <20261012065741.17636-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <97931e8606134d8390762041a638e556@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-10-12 Ping-Ke Shih wrote:
> What "mac80211 state" did you mean? Without wiphy_work, it can't state
> it?

bss_conf.csa_active: patch 3 gates the TIM download of this work on it,
and mac80211 writes it under the wiphy lock. That was the only reason
for the wiphy work; the work needs nothing else from mac80211.

> rtw88 doesn't use wiphy work/lock yet. and you are the first one to use
> wiphy_work. Mixing to use wiphy work/lock and ieee80211_work with driver
> lock looks not good. Should we just use ieee80211_work to avoid confusing?
>
> Or we should migrate to wiphy work/lock?
>
> For me, I prefer you use ieee80211_work with driver lock for now, because
> I guess I don't have time to verify the migration...

Agreed, v6 does that and this patch goes away: update_beacon_work stays
as it is, cancelled in rtw_core_stop(). The countdown work of patch 3
becomes an ieee80211 delayed work under the driver mutex as well, and
the gate in the TIM download reads the driver's own csa_vif under the
mutex instead of mac80211's csa_active, so no wiphy lock is needed
anywhere in rtw88. The countdown work still reads csa_active once per
beacon interval as its exit condition, a plain read like mt76 does in
its beacon path.

> Or you should add wiphy lock on IPS path, and cancel the work.

Not needed once both works are regular ones: rtw_core_stop() cancels
them, and the IPS path and the firmware recovery both go through it.

Mehmet
