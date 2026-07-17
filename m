Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E703EDAD8
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 11:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784288035; cv=none; b=HfAS+/OcvOl8nKRpfKPdzgp23bKs595h2GTiWQwgS0WYnozMWiZWRjLzgYXYfZHSZGSZZhUbDaF8+oOdMb0PRS1ye2d5ZAlMyvwG6JzPCoOr/A3BDXbyLq9IRyZr5E0PhxYEcj2x7r/dAVRVSefTEsLZQUMc80ZMZrwad3wWlfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784288035; c=relaxed/simple;
	bh=le2wdt8kZN6Vu3VzjjnEO98KjIPuSx7Gmdh8iHBE3IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cV6n8jCVp7Ed1H/FrPKdKDlRTI2pHrFTRPJquYXWeAO++ml3AbyilbkpeEgZIXojvAyDzjyg/qLUhlYtF2JgkCAS+hB8VL01jJytHFv2uhB4uh5iDAnH9JQDH1tQL+PR0KoXyzPROAWiBYNZjaT9BnMpkt6EU46TtO8bex6B/r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aOKVAswy; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOKVAswy"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4954afac04bso4437085e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 04:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784288028; x=1784892828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=le2wdt8kZN6Vu3VzjjnEO98KjIPuSx7Gmdh8iHBE3IM=;
        b=aOKVAswykIRXtSIbIBlwk0VM/Hh8q2SxSRzAnldaGqrJZCWAlpRJXR2az32eIk8XnK
         LwkxAkcMDeso0y0D5n4ac84myfVEi+1sLUYTE9HVEG4GkpJASupRbG82XOqLOm5z9gQr
         RTFDPoyxvaMbTbwAAJCOVvcs3a2aM5j5S2V1B7xTn56p/aja7ektzcvR2Ua1q3RIhPSP
         g2pUm1Yla/QTDZN0GHdoygXENsvQ4U4S6Z3POnWUGB4CQaJZoMqdHLOpteL9vTvjFeze
         42c9c4C86ZMMa7IA9W3R+k9xu4Mi76fQtodAkjfU8Ji6VcsSyiBTEazzhSQkh6u56q+B
         sf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784288028; x=1784892828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=le2wdt8kZN6Vu3VzjjnEO98KjIPuSx7Gmdh8iHBE3IM=;
        b=s5Lm0ev2zGBOSmLEFyn6sgHNPqR93Cq3LWEez6uNGDOReB29O0XImxaOdhPMvGIx6F
         XlO3NT9weNhpqHwF7E66XGIzzbnwK/H0Ln4djb/Eb7mgbWfMNZrWUlZm0tbhl4Ntp9MZ
         mz4c/sz06povbzgVW0QbobovzzunRwGyTpHwLXo8RRpvkJElnlfKFiAZbjwO9cIF/w06
         JRXw/dexZo91iVgkBUMD71iwen+Zg7chY0obUl5CrOEjJjeEvSDgs537C+7c0XUBs7Qz
         PlHXtjs6fXO1XGoOGdi8VgC4V8d2e9gByZDX79u4jKHTaqQRU/cO/eXNJWyfWw+EANI3
         M+Kw==
X-Gm-Message-State: AOJu0YxEEJ11Voa0cEOPfFmSXjxEqu76eqN6Z7bXj2soePZEvsi5FMqd
	eyAbhxXHsCycSVr+U+nKNteZbKO62yGUw9eNfxf7j1imLB2qGMbd2mpo
X-Gm-Gg: AfdE7ckeqRdzKODFq/k90MtQcPK+v1JYBIX49MTkRI0BhncmRxtZJ3ecvsWS2ug6BEM
	Xyt8SsZWmi3XHBufPfXj+XlbzUvNWOR4oC3nzrXc6JsbMhrqgBTWxQTfgpy04/XF1PKs/+SzS/w
	uYCgq8FWcbI3T5hR7lE2y6s0rIaq0IQSHfGTaXrDQm4Y6/Se2ZNCdGymxsMPHF2L4aw70mTmJl0
	Kvm0nKUpbZfNz7z786fenRYtQqGGWslVbgDwZMspb4dVc+xIF/xwb65Gf+ta1u0cjJuQ3jVNGe3
	gqmQ0m1UNjPbQeAVNw7nPlzrQC+S5AQJWLqi3f9wMXA7ysVwdOtb0Q9rOK0gJbU/JRuGA8E7ueV
	jlpVTfiSgHoinK7OL7EdUjOitA70EgqGWbHHUnOdRcR4DdS6STeao0hGQ36OwznaG+AObLsPfUU
	pxLwY5aK18gfNwSUXOVBBFThwV5A==
X-Received: by 2002:a05:600c:4692:b0:493:bcef:565c with SMTP id 5b1f17b1804b1-4954a3e6dd1mr24540805e9.1.1784288027365;
        Fri, 17 Jul 2026 04:33:47 -0700 (PDT)
Received: from localhost ([102.128.173.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954966a033sm35176885e9.0.2026.07.17.04.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 04:33:46 -0700 (PDT)
From: Louis Kotze <loukot@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loukot@gmail.com
Subject: Re: [PATCH 0/4] wifi: rtw89: advertise WFA-certified EHT capabilities for 8922a
Date: Fri, 17 Jul 2026 13:33:43 +0200
Message-ID: <20260717113343.1525489-1-loukot@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <b998ea41f3c8493faea09203be3275c6@realtek.com>
References: <cover.1777832019.git.loukot@gmail.com> <7e092f6cf82c4bb18b59ba5eca40dbb5@realtek.com> <20260709103138.1269594-1-loukot@gmail.com> <b998ea41f3c8493faea09203be3275c6@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ping-Ke Shih <pkshih@realtek.com> wrote:
> With this declaration, it will handshake two links in protocol point
> of view, so you can see two links in debugfs, but actually it operates
> on one of the links since driver isn't implemented to configure
> hardware and firmware.
>
> So, I'd defer this patch. Internally, we are still cooking to enable
> this feature.

Understood, and that makes sense. Advertising the capability without the
hardware and firmware configuration behind it would be misleading to the
peer, and my A/B only established that the links are set up at the
protocol level, which is exactly the part you are granting. I did not
measure per-link radio activity, so I have nothing that speaks to whether
EMLSR actually runs.

Dropping the patch, and I will not resend it.

When the EMLSR enablement is ready, I am happy to test it. I have an
RTL8922AU (USB) associated to a Wi-Fi 7 AP MLD with an A/B capture rig
already set up, so I can report on real multi-link behaviour rather than
just the association state. Please Cc me if that would be useful.

Thanks for taking the time on the series.

Louis

(Resent as plain text; the original copy was rejected by the list for
containing an HTML part. Apologies for the duplicate, Ping-Ke.)
