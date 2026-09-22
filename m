Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570394E01FF
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 06:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790060349; cv=none; b=fzYj6qA9wwtsOmNilZk82VDIcHBB0nwWSURMQKpEQ1iTx+CACQfCuX5KNjlFNJg6YY61Cg/EQW/xV3OJbvGqf9piHbDBvWfpBzDptNadGjpVBTEmnY9ajYN1moqOtGhUyyfUBjCnregujnraCKl4sNtafp+1D2xpONajFWpogZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790060349; c=relaxed/simple;
	bh=DIBIJ7F+V9aLoSxE9gb83iBtpIq6BCllg3PGaSg4PR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL8OXig5TMulzpxk1jDVdgRL9VBXs1HVeSuFBFBnEgMxsoJwU9I4IX+H+qJSvtMM+ncQOmM5lgUVOVR3gYfLj8rtrKF1mB4PRZ/AEVHPYMw4o30l2qAIRbJ8rm5if0MXPb50qRaPtjXuwXL+Zg+V7K+DPc69X8bcIwSuoswRL+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UyQ5wX8U; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UyQ5wX8U"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cc9f581c4so15927635e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 23:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790060342; x=1790665142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DIBIJ7F+V9aLoSxE9gb83iBtpIq6BCllg3PGaSg4PR0=;
        b=UyQ5wX8UVULJ/MJyp4NXsuXvJp+KPo0P5wZOWHYai2Flbc7D+KLvW0UxHM9ZzHQp1A
         fO6v98w/B6akiugXRUBLNcBORCEn349tfWAK86Kf5/8Lw9JJQK1N3tDzIziw9grMaxIv
         kEiTnjqRNHGBSMxTqONEO8tKMTPnrcmLHvBejF4z8hPPOGMt1WBVQvDMHvZ5QyPAQbKi
         DM/WvT2Ac2DVBuijkdKnQV9OSfI/+hbQt0/LNV9tyKE195i+viPRsPoktabfKghXOcyj
         DmL1EmUtInDjlXGWhuW+Jm3mqUR1FkhAvHh0aB2v0aYl5GzKxpqu+o+/X23QvrbmDLGt
         ydtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790060342; x=1790665142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DIBIJ7F+V9aLoSxE9gb83iBtpIq6BCllg3PGaSg4PR0=;
        b=106/DeLhEvh+ok9Z3/bUeRzucOJc/G77sX/WmTrltUmxdMMTF2lWU6amNpAAOptytf
         vkHXYyGGnv2vR+8pwSF67vy5GBctyJtkF7rwn9L8foWuArf3Ofgc6YtR65pMbKvrPv91
         9KHl/Zrar6EsAL+u02cskMnvcGNj8HdqS5ZFFOStFEj90f3m2NHNMqvUayD/2fBk8H1S
         OUevV5b7OxZ6WvtZd+y/QjdGsrIH90h6IceytYSV+Aw59KfXIt2zKWDZvndOTDY89h4Z
         KK9PNd9zfWLUYEVfRmz1EmthhV/pp3szwFUoDIYiaNTMtaMYkxzlmjotJVrPp/oWXNUg
         PGmA==
X-Forwarded-Encrypted: i=1; AKwUvBwZ0IpVrEeWJqkMQjbkqXdI3TfSnO2Ozg1eqX2kytNUb0dkggdjJh4EWUngyM4VisGOmo2CwoGe7V5lyJAvEw==@vger.kernel.org
X-Gm-Message-State: AFuF++mHtB2c1XMpdmTM7jt8Yy21sQdt6vyf2rmcLExgTaSdsL0YUaGE
	SJThlfodb1Uzv4BY+59cAIPf1jXErluioMeK1jozEfz4FA6CFajdMhaT
X-Gm-Gg: AYBFou3IkpIW7bQNnWc0sbu9okVS7xtmwS0ox2vO1/qYyRifuNIKl7Owp8TV+nKMhsp
	pnmAUqaL7qjpy2aYHwZWpbAddJClxHUfKz3J0FFbR+b2J+98MW5m9Khbi7l219APuBxGVLj2tKC
	ydVfB0iw9Bi1f2J85ApriZJpUhClSAwSrk/jr2JvUFm1dMvmHKWGZbvG+4xhM3v5jvrfLNttBxo
	rNVuWmFm/2kJp4umdDY/JM5hC7Sg0PsMQNGHwmI0IZrE9r53EwOhlNqhoSbCHrlhRENeyEN/BOY
	HZsoNDEbte0U5MrkAFrA6xLNbGj9vXHSZDv6WWC3irLaXLqrD6x+ROo1RYaq2fJxTcC8M2AyYD8
	ItWY4xg47BFfr1QBd1CIpfNRtf7yZ6+L8PCvI8W3MnQbY/zgaGA+4i9qjcxkh5piomZBY/ICTWu
	4ynWDutRJsD14+9tn1t3u+MwP0HyTZd0Iq5j+cmVfMsPNTZpOkwtt06sV055Wc4RfY30Jse1ITD
	NvTQZ87UfIKSFA=
X-Received: by 2002:a05:600c:620f:b0:49e:8222:3451 with SMTP id 5b1f17b1804b1-49fd8a6cdb7mr25402185e9.14.1790060342213;
        Mon, 21 Sep 2026 23:59:02 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fd8cd83aasm48853745e9.10.2026.09.21.23.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 23:59:01 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next] wifi: rtw88: honour the transmit power mac80211 asks for
Date: Tue, 22 Sep 2026 08:59:00 +0200
Message-ID: <20260922065900.1321130-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <c164023223334f7095ef2a28f6bada33@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 22 Sep 2026, Ping-Ke Shih wrote:

> I don't lean to either, but ...
[...]
> Then I'd prefer SAR.

Understood. We will use the SAR interface, and I withdraw the patch;
please mark it as such. Thanks for the review.

Mehmet
