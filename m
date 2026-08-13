Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A609F43BDC7
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 21:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786657467; cv=none; b=J7Lo5iNTf+wa19Fz8InZKoeP+v1jTISm/sWUSqkALFeVlRnM1P+EVVcLRIYl/COVP6G9FJVfDPOTPnlqoT7md2y7rgo6NDbRQ5fxbhFEfYokQyBYjqc+1MEVOPISD68T3B2M1dgdw24nOzj4YIRuKLFe41qYO5Ju3Z7hRxbyhO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786657467; c=relaxed/simple;
	bh=ZMlmsxsJ8rHff6aryetAqpFwiTle5YtFRPBLKUeOZxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVPXInV9PZkxcLvAuppMC4bqhXwkZ8ArTpPm3qM2BxGFowYzNcRBoOGSjmQUDfKHqRteE+wRQOdtMz9PBKmXR4bIY/uKbEYGMYxFNg/075Z1CTeSOpYXUESSfv4PN5YoHbkCB6/NrOaR8RF1MI9lDGdhJW7bTXVVI5tSZQb6bgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JmkEmHfZ; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JmkEmHfZ"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4954d29264cso2001625e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 14:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786657464; x=1787262264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZMlmsxsJ8rHff6aryetAqpFwiTle5YtFRPBLKUeOZxw=;
        b=JmkEmHfZt08MVn+JraX9DgmF/GPJXBRI2ZirdbPf6BgJ/KlHKbj7g8nUxziK9nkbL6
         B9YeA5lMMBpzN+uyXC+QQ8PrpnW8pSZ+uuxFw0KEeAhUQcicJa/QVmt2xYIMAOSK6ctG
         o81bnBZDEkegiBefnx8ZbvIA6u/7o/7gy9UleUnkTKoMeezHV/RuBxYJTs7YR7b5pJEn
         x5gmsOY85duEqCUztQDQpoBwVnzI4xtohNAakCzosLvnZaNyshdwJasQVrHtAvn2D9EU
         2qfmnPY4ScmkfMGe3QqKcqrpIxzTSgjqrRGVq/LoBL4wpRilTid35RZrelCgZBqCNyP3
         MhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786657464; x=1787262264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZMlmsxsJ8rHff6aryetAqpFwiTle5YtFRPBLKUeOZxw=;
        b=iJP6UDjLwK2xYCiAv7L9DlhHdr9F68uzLMQK7VetGzriXGSRu3Ce8NlFJLLkX0SiqB
         oXBVF9gKsr+qhrLd20HZ7ZhTslXpb+qoQ/yU/boxXE0cxIjzAOLQVPcauWJxICoh1nhs
         Cy+Ns6H7wb3fyxXqzyx5K5duPsBtM1KVZuL3BXKwcd8hqdx45KYLah3DogQAXBlknbNR
         xxWzFt6i/CJYc1E9YNTEPaodH6njAtHRMoaW9RxZjP5JRnHkSvw/OU4iYSFNhB1A5aV6
         ozxxE4baVhj1Z9FmYE38HB8wLVM8q54LmBJvp1EiBmqG96925OcyqfHHdD5lJg57wBr1
         x89A==
X-Forwarded-Encrypted: i=1; AHgh+Roer6/6251LgnJuyXXj3+YmvvtIovOZakUlsc3ix+rl6+KvU/hNoLx3je1HsRzAvzjKvKxu4uWSJGi2R7o6Vg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWF4MExuo9n8YKtxZ4QTZ6U2mn2qAlOiiOXJv4rylObDwwd7RK
	xrF4AkpiAZmB3ZxdO+bh8diB0+Y42G2bNIRZCsMNY+Xz0nhU6FdtuyP7
X-Gm-Gg: AR+sD106ohoGXH+kTgmRsmxQAkfB0u+J+9+zTPh2GNvRJVfOMIcYCCyfHySV+Tj2JpE
	5RaK3Mzm7jGGnUqpHNvmMj+3yVVMl+px2swhURQQVq6bBpYkvSGRXplFQcoE1srQK1wXHFJfoaT
	GfWOeI9v1sOC9ozWuD1b74CCRTjV1RtHcTtKvk71Y2qDQiMEqSlZjcMf2WCLL18ygqxbHepqu06
	DaYbP81cHPY7CJpGxPaNY6Lvv/HALQ372lIvaJJcKBqb0BOncuuNCey26ajVVjf3fPf5tmrrk5p
	Zx9NwvY03wi8C9XnUFaUf+e9QuwbJ9WYmdHCZ5tm0u03MNXh1V5A1iwZumTs5nrHvQhl5jBjjM4
	xDmwsXbHdlj5eJ2LIyaKxGbpjS3VHYh4KvK6qCKZIjGSgTu9UXjT8YfXSOje9oDaoC74+JbsaCI
	AP0lPYqEn6O3+yHps+oy0Njqarh1V7Dz6HpDWmQlB/P+XkHtrCi5LCMaK5ziN+jD8uIw==
X-Received: by 2002:a7b:cd06:0:b0:499:4d4b:be2b with SMTP id 5b1f17b1804b1-49987998f91mr11124145e9.16.1786657463688;
        Thu, 13 Aug 2026 14:44:23 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981b631c1sm189280115e9.14.2026.08.13.14.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 14:44:23 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via the AC queues
Date: Thu, 13 Aug 2026 23:44:22 +0200
Message-ID: <20260813214422.2438768-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <ccc4cb9f-41a8-4de1-a6ca-b5e074385e4d@gmail.com>
References: <ccc4cb9f-41a8-4de1-a6ca-b5e074385e4d@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

Hello Bitterblue,

> Shouldn't mac80211 handle the buffering already?

It handles the decision already, and that turns out to be the key.
For bmc frames in AP mode, ieee80211_tx_h_multicast_ps_buf() sets
IEEE80211_TX_CTL_SEND_AFTER_DTIM only while at least one station is
actually dozing, and then either buffers the frame itself, when the
driver declares IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING and pulls
them with ieee80211_get_buffered_bc() after each DTIM beacon, or
passes it to the driver with the flag set and expects the device to
do the after-DTIM release.

rtw88 is in the second group, but it never looks at the flag: it
routes every bmc frame through the high queue whether anybody sleeps
or not, which is what lets the backlog build up. The full host
buffering model does not really fit rtw88 USB, the beacons come from
the firmware and there is no per-beacon event to pull buffered frames
on. Honoring the flag fits, and it is a one line change: flagged
frames keep the high queue with the MORE_DATA/HGQMD handling from
076f786a0ae1, everything else goes out through the AC queues at line
rate. The vendor driver gates on the same condition, a station
actually being in PS, just with its own bookkeeping.

I have sent a v2 doing exactly that. It passes the same reconnect
test that fails on stock (RTL8822BU 10/10 with 4/4 pings on every
cycle, first association included). The dozing-station path keeps the
existing high queue code unchanged; I could not exercise a client in
powersave on this bench yet and will follow up with that measurement
next week.

Thanks,
Mehmet
