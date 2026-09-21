Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB68194C96
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 02:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789959364; cv=none; b=ar+aKexkML1NrrXJQzQpiD5wZq3/kkq+esurfVaZOKZgQJxARcgHePCp7JPwTrcL4RoHmp3qhENCElQy5qOePZZQJujsVndMm47yczjReVCiETmUUHKjamKTtREYs+0B4nJsLN/AyCWM+og22kKacZnvoVyqLpfyuGykEKT/0kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789959364; c=relaxed/simple;
	bh=nDRFwFkn7iEBW1jjaMBnVtTcgV8S1UCxv6HoCVwurGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsU9hjgVzXp2fiCvbLsOh8qlcQk9dZriV3/I1CqWsznWWqrfIhWQj8zFtg0wMWOMl8AVuHTV2yl5mAUIKOhv2KigFJANtZTCMjfJh/JWPFFoV8YXYfdPyzGRjWrEgn7nDak1DVITkquv2k/6sOtLoSUGs0VSBOwVu9hTHvpJBVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WT88AiD6; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WT88AiD6"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ed1368so30132825ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 19:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789959362; x=1790564162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nDRFwFkn7iEBW1jjaMBnVtTcgV8S1UCxv6HoCVwurGA=;
        b=WT88AiD608FWBPgSryafjktdAeAQhe+mi3JCQ18N0EUySJhfIaBKns8oBcKh/M87Hs
         Pne78Hz4g7zN6HNe2854PpGcXt5jwdVrmWh5uqFOwC8vD3yESkpnAG/r5OC41hOVJzy2
         XnZLv/v8ButQsgUbp3j+0jz+9sqaeBBu2pg70tRuM2nK+p9Tl2JFdk6PLum/JilhQaXD
         5iNiDgrOzPhJ0VRzsIRAb6Eq7siLwjVBsXOt9nvcIWzH98snqkZtjgt43lW9evnFXEzD
         G+fupsG8nrfpwmVb1DlNiTjcW4mA4biFUlcUHIm9S6eVR74A5QE0jpSQRKrnB7Y5ROyD
         tacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789959362; x=1790564162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nDRFwFkn7iEBW1jjaMBnVtTcgV8S1UCxv6HoCVwurGA=;
        b=wKI0VNkOgFzwUMrqYDThtWC0KTkcaPdshGv6JyN/6h9H/D7bQ/ramQdg3NKyhLQ+UR
         6+c5uSrRQ5jj0KfF1j3AS0aAosFxwFRbBW22zIGIimJvk6LSd3LVLMGcOgagYskN9svH
         dblJGpX//hd7Kf1bKbhbmlvU3r4IxkordHYhcS52aE9KsmLERvRXGi+Rt9YGZwT+fzes
         XPyohtIRVf+psd+2GrtWtgMyTIublPXvhz5zptXbG9gY/hO3EESpK/C4qUjM6l/S5cVe
         T8BTSk3gvo2/URAnVG+SbYi9Is8ikPBedNY4YQgEDnlpxWoknrp84ote2P9fF7TCFakf
         /txg==
X-Gm-Message-State: AFuF++lt9HNg0wo0UNPjtVyxVppa9D7YZIZv0cyTwYwlOY0PKse1IoeA
	GQUBeLKbVh1Q4sO4H6UiMA+/WGnnQjptKCb3lejD1SBYBt2kWd1s5vmupg6OgXGGmzLdyCRy
X-Gm-Gg: AYBFou3uq6pi+En0BJhenvkfPbzsWtQhcA4yYq9QVVcpFaeOEWQaQ1f8EyYwVLwU9Rm
	IUy28cYJ3AeEFY/UrXN+y+YjL9+1hYQ+WZFwgUFVAUOiXa02TNZEAePYziGTbjQDZqNEOO2C8Uq
	uyvcdFmUASJgUnX65xozpvdCLIcKKSogRkcel6r9ZGzdEj9PtlyhnnEn6D9oSPyu/4WuVKM36nj
	OE69uWVc93bsCOEktweITaX7tiUMT7tAgFsrAGb0eI7SHkeQcuReEFo7Zdz1jfwlt6ozk2JETGx
	XKzuMo6pG2TUMxP7abodGv9/0OnSIw+YKAzQj5kTbVCmZDUzjBsZ4IL7oqOnJhxwq/+gr+VgHaK
	u9xtvBXDTCBSGesvL1UF6SXSNqQnkIes+K8UFOM4XsOTDllOugDquf2ZdGJFheXAaq08KHPL64m
	Vu172vJaLQVWN2bzdPB5nidvvuSR2S8fCHK8DxZI7iy09sbXuytaKw3GtgUrbgFj7jQ3/RGm97n
	VKGbK1uhGJyyqyu78FlgRH+PVwtqoDFvUk6J2PWOw9kosFuDnYGzs4fN/36k8sxeM/t1Sbno5I+
X-Received: by 2002:a17:903:3803:b0:2dd:c100:b2d2 with SMTP id d9443c01a7336-2ddc100b3b1mr93860715ad.61.1789959362101;
        Sun, 20 Sep 2026 19:56:02 -0700 (PDT)
Received: from lenovo-thinkbook.lenovo.com (awork078078.netvigator.com. [203.198.250.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc17d8727sm25415805ad.65.2026.09.20.19.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 19:56:01 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Vega <vega@nebusec.ai>,
	Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: Re: [PATCH v4 0/1] wifi: mac80211: validate TX status rate metadata
Date: Mon, 21 Sep 2026 10:55:55 +0800
Message-ID: <20260921025555.87782-1-xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789958876.git.xuyuqiabc@gmail.com>
References: <cover.1789958876.git.xuyuqiabc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The v4 changelog lists the v2 and v1 links but was missing the v3 one.
For completeness:

 - v3 Link: https://lore.kernel.org/all/cover.1789801378.git.xuyuqiabc@gmail.com/

Sorry for the omission.

Thanks,
Yuqi
