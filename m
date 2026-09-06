Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DBA3C4B8D
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 08:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788682822; cv=none; b=cZ0VlrUd3u59J3Sl/9pkDYx9LcoTnF5WhA6Y240LqzAkpoAFjUktUJFGpkcDqcLBtJgBdbuyTvpGiFsXCjPSwUNZ6riO96di0G2GvFar1fP0uFiiF8ZvpEauhIQbGJXKm6XoG51/R0jxHT2fa0U5w2Z+54p/A+GMNsYLGiONj3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788682822; c=relaxed/simple;
	bh=k/46rd7cvC0Orx2Im4cugtLKMvwQQqOCYqTZRcALraA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUXHfTNW/okobG+Ob3aqq+9PFGwaJR5NuapavVGThwKWv6yJuTf2hwRiwRYHIwo/F4ms1LHEOHUlSKnxfomhsAxJYi4PmhAxIybdBpOCFKFo2D+Hn+ix/V5BF/8MIHxqK7glk0OyLPn3Oc4RRCVNoOO3zyl9bgCGQqrq51VYPsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FwW2vMy3; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FwW2vMy3"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49ccfbe062eso21303455e9.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 01:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788682819; x=1789287619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k/46rd7cvC0Orx2Im4cugtLKMvwQQqOCYqTZRcALraA=;
        b=FwW2vMy3Y6OX6qxEXhuqufr0qz146QlrtA4T7qv1rwstpCr9rjRnQdR+U3WHGbuqMb
         f/01Ngr/ulnY9KH7DjpKw6doJoBoXBXM1v8GWC2b749Yb+9P5VQDXORsDI3sZZ3y4d3H
         MZBAzaHTCOJ+wkldxvMFpcWcX/uOW3qEj5HzahpUUxXQ1M1F79lKOs+4ajpaIxM3bvWG
         xK9tTs1X3RilTyDbPp5co7dpbU9ASkd8bWMoAz5ZRC1E+IgVevodNHR7PONfjBKLZbhA
         Wgh2IdQT/jtLp7efn25CjQw5jGq+HM+CG8m6h8mp33SX49XJp7fs9Nf+EHjQtlGghIx2
         JASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788682819; x=1789287619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k/46rd7cvC0Orx2Im4cugtLKMvwQQqOCYqTZRcALraA=;
        b=UUfZfqkK0gMrF+cz29/FPv1ucykQHclCyFEfmKckuMYyaL3Vz8TNR76jsAw5jrYPmu
         OfmGjLsWOJXDmuFUhPbPeoGdsnNbejVRqn+45FOXE33SWJKn0jvTlVnfdeLAWOl0JAXV
         4I3U9Urp+7csy/v4BkEu7VorDtRB/dOr5SYnZX6Qfv4LdzgKbsSUyWiqRnqr8ZQT+c10
         MVnE/+OT+lqbZSbyCuHo0myGu67p1TH2i559n849Erwxzit0xCNRwRO0fsyGumsB3h87
         5DbbZP4H0Ww9i7wZOS6WNUlg3UO6yTNWGhIrFuhCNlTH6cvFcM+Zra9plRbtFsYqqCHk
         m1Rg==
X-Forwarded-Encrypted: i=1; AKwUvBxMsgpi/UudEuSoq06MacVDx7kXD2P6Oj+4Md9oyAh+hmR3cB+vKdo1k7uTqogfCqzTNm9Q45QpJodsbhqzPw==@vger.kernel.org
X-Gm-Message-State: AFuF++kkw338TE2mATP/IHIx9wdbXHmKT6x0BagUYcPscN6UYRR2n01T
	RbJmFg6X0smzJf89lffBfW4dRmbLnmv6YXbCkriAIyzRnINg0hkgQYq04hfc3w==
X-Gm-Gg: AYBFou1b0av73b+JWksFLvA5yasXZil01Gi6d9/2ApxAED502BPFgwgw/lSudrggeXS
	XNRAoUN+j371nFbhBS2cY98D2lroEzKhxCb1wOownf8Q3KdIuAYWS2VpDuNoyZt/MKmt8s+wHW/
	T+PAyXOyZqxIBXUFZjUyQaokA90bJyEq8usZ+7qxMYzXg6QtQIt1dmpEZzH4eznN2126291ZCKJ
	vaEd0R61ocm0gbyVZNt6f/NnDa8iY4cfvUcd58HqVyytu3rk3HsIuy7QQkEg04ka4ZOTcFW2QN/
	IMvwNM0FBN0CU4kpH3Oc81DZ/IdQM4NuhUw6re4XI0lguULto61yZmsoqfxT/FNRICf1z13jY2k
	ZjLVzLcmMcG6WoSx8NmivovsqcqSX8+Hwv+7sIWZCx5xeEGfSJZZWmuNZ+3N5g7ZH5SZV67jTMn
	SzAtQuM40bXAv6mfWvppDD0Usy09zusCjW+Xn0z/oT276/x+BxUh1/boK3LqPKX1sVpw==
X-Received: by 2002:a05:600c:348a:b0:49c:fa20:cc03 with SMTP id 5b1f17b1804b1-49cfa20ccedmr117480115e9.26.1788682819131;
        Sun, 06 Sep 2026 01:20:19 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm123450485e9.13.2026.09.06.01.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 01:20:18 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery
Date: Sun,  6 Sep 2026 10:20:17 +0200
Message-ID: <20260906082017.909554-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <070f9724ca4a42a0b64bbf63724d8cdc@realtek.com>
References: <070f9724ca4a42a0b64bbf63724d8cdc@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

> FYI. I checked vendor driver. Normally REG_ATIMWND sets 0xa or 0xc in AP mode
> for chips.

Thanks, that matches what I measured: 0x04 already drained the storm, so
0xa leaves comfortable headroom. If you agree I will add a small third patch
to the series that programs REG_ATIMWND to 0xa when the interface goes into
AP mode, as a complement to the bound and the filter (each covers a
different failure mode: the window adds drain capacity, the bound protects
the pool if the window is not enough, the filter keeps the ordinary chatter
off the beacon-paced path altogether).

> As you saw it is for TDLS channel switching (timeslot sharing), I
> don't think it can work in AP mode...
> I will ask USB experts internally to see if there is an interrupt
> to notify driver about TBTT (or beacon early).

Understood, and thank you for asking. If such a notification exists I would
be glad to prototype IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING on top of it
as the long-term solution; the bound and filter series does not depend on it.

Mehmet
