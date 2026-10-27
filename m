Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793092396;
	b=dpaCP8iSp7UabqBJuRnZGtP0+VeT4MiH2Dgdqu3MJpRgE7XAbHZNq+q0B9ZjMlguoRKL
	 wCdrj2VVSvWJzDEDX56zl5s3EKbQuUCFYBnQnNaWbDWqi6TgizzLNgrfMv9KD3BbDdVY3
	 15mtvDIWdjfuoXXecvAtk9Q9SQ4X7w4fZrZV80IROHLqNW/ma+HWg5LfEvMZhlcRfVqLD
	 DVk0RopfS+5H+ptH4IGTeYw+5/6NuLYQHTrgdElqdmgpB/5hPcJ4iov2ZE4Pz40hiS22N
	 IFaaHyzoSIfhJqSiNScZYuBTJE4oFyM3TY09GMt4ba5tlk4C1jQ9FPWiUQO0qxA6pJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793092396;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RI7lOu4cwkLNhIfCj4KVRkhNhnRXK1KgWJIU3o3fGYY=;
	b=vz/Lcn1dh7gq51ehd6q+UL6HJI/1XLkaFjyDg1l8Sb4+qjqNSkulc3QkthwkC5LA6RWM
	 3mQsOkgB0el6VgS7+d2RPXldzoa3FKk//0wIfdiay+KwIvGTvsRYLl+umk0vm22hXEOjN
	 1KC+1vAZP4EAA3jPJIxUS8qhuwbwEF770Xru/KM4pNyrfvzC5CpSSyHbdxs9DMAPYgWry
	 QxCv5fULASSYAU8Dgw4R1Rezya0LoZh9ikMC6akgq2B19sWIQa8sJ2KUO4ua+fFulVBr2
	 JXTBm9uc1hYJ//5Q6100+XIqWeaZ782wHqU8/OEXMoUsDLUezVFIZsOtxD7CI40OscA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="r5/+lntm";
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8FA606A31E
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 09:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC8FA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=r5/+lntm
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so21205635e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 02:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793092394; x=1793697194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RI7lOu4cwkLNhIfCj4KVRkhNhnRXK1KgWJIU3o3fGYY=;
        b=r5/+lntmV0LWHi4EUnDlg01N8ivpv919JLT+sz/G4ZlbBg63OR9FoWccvkAKIhcx8i
         hHTTQfIJusyCmvr2bpF+k+5EJRmBR0xjrdtOkPZE8bI0MnzdvkzPFmQyhIjvaHhXuH+f
         LRqqNa9wdV6FyLIbp5DuqVb6oO3wT+GyJ38nnh6KslFa3ZpI52dGxF8YOf8lH9r4W8CG
         rBYIZ/u5fH8tJw4PZqfde3viSNtoZxltXXlcXMBxkWgQBKOrdw9mDNB3APSm1OTFaS6X
         X8kG9/TlV3VGiyks+RxJgTaATLcU+ATveKHE8iDNeqf+c0aAO03sq5+vZAKR2R83t/S4
         QOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793092394; x=1793697194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RI7lOu4cwkLNhIfCj4KVRkhNhnRXK1KgWJIU3o3fGYY=;
        b=UVoBJt8B4avcpWLuJCjLwUPYmodfF8yyfKW3lxtFbwMPiW6AHDUgrozgxy3bgxnUiM
         df7ZbjBCJapbJHyvLAx2KlvvEilsss0dKHPRB6CHbYEFYh2/AkjbVPO7wZMhJuNW3+nD
         V0h+UYgZwfGID6rO9btX8iE4hcGwIxN9hQeGG+6maJjwyAaV45dOhvYY8Lk+Y9nmhVMP
         SZzXBREpOLT89b3sFPJHUHlsUsIA0GGQ+o+M/OioOOa/3fSQN/ARkDc8DHTqAhJNLAYb
         miywXDdChe3t7S+fX2hXXYY2bzCFflMB2ibZRRB63CQbkMGFc9DUzTL1F1AQq0hoYK8x
         jEag==
X-Forwarded-Encrypted: i=1; AKwUvBzzlOBUFRZyFrvDQ4WTg4awjUy2ZfPWCd72um1zm/reAVt2JO93PHNCMjT1eAZ/AiKAW9W5TawdUzp9px4zrg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKwKAgn8Ypu4SEPDwAq82m4SAvWhXJc1pRvB/4L2+Nc6C+pU9u6
	jeLYuoxmwiTQFUw4TEyFrOGvldAYl9RgCjsowTLCRY3ayF39XzGtEWzo
X-Gm-Gg: AYBFou0p1NQilO6B/Nu48tOoo1DHTuvUer4qf2V66zDfbzbarG8ltTDLR6rsm4swFgk
	T832IJ6XHcH+Q0dT5e4AU9C7unYQgoEtNh1PP4BfZNe9GXGNYoZGjGegvkYCyBPm5mLB8O6GA+v
	FBBooepyPMk0p6wRjj0BTIG24RZPPkDHdZSZkY5nKIlnqIullcgxfPxn0hg8f5bkvqT/kPxEw2l
	D/oqd+ONGk2qDOBsJPxIUgQ22p8InKe+95tazPVTD0L4QyboT5jxOIVHDcBcIi/Uj+zFu5OdfEZ
	prprd9cULMmZyMcT8ERDdQa4l2eUka8bzu12wTb9Pi/HO3wz8j1JfolaEBeh/CJLUkMvDjZmTGx
	IFVtkTsAwJTKXVNV1QGQ+/9/iAfApZlmy3GpZNKJMMC8sdI0sElYFhltOVZy8Q9ZUk2k3XhLWIt
	i0cVuT0C38m6oH2GbaGwm0zvZOQzgajOhXowlOuZ+z4VPNw46qyN+gjVGsBuFuG53AAaI9Zdlc9
	6GGCuTChLLtpiVy3Csr1XQRp/Ky+pUOflP1ryHVSuSDZwGvEMIJciIKnLaFJ1b44tGIG3CXHghQ
	M6oa6pY=
X-Received: by 2002:a05:600c:608c:b0:4a7:7f3f:6f8e with SMTP id 5b1f17b1804b1-4a77f3f7008mr59179755e9.0.1793092393953;
        Tue, 27 Oct 2026 02:13:13 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a2d9280sm249768265e9.13.2026.10.27.02.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 02:13:13 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v8 2/3] wifi: rtw88: support channel switch in AP mode
Date: Tue, 27 Oct 2026 10:13:12 +0100
Message-ID: <20261027091312.1421798-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <64d3a24e0afd460db4a182bfa2214aa0@realtek.com>
References: 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

> During the WoW suspend, I think AP stays on original channel and sends
> beacon without countdown. How does associated STA do? Will it switch to
> target channel and disconnect result from no beacon?

Yes. I tried it with mac80211_hwsim on wireless/main: the station
switches on its timer even when the AP goes on beaconing on the old
channel without the CSA element, and disconnects after the beacon
loss. From the code, only drivers with abort_channel_switch (iwlwifi,
mt7921, mt7925) abort the switch on such a beacon and stay.

The AP stays up during WoWLAN only with AP + station on the 8822C:
WoWLAN takes a station vif only, so with an AP alone rtw_ops_suspend()
returns 1 and cfg80211 stops the AP before suspending. I checked this
on an RTL8822CU during a countdown.

Refusing WoWLAN during a switch would not help the stations, cfg80211
would stop the AP as well, so I would keep v9. The resume path does
not run on USB, the device is unbound during suspend; an 8822CE is on
order, it takes two to three weeks, and I can test it when it arrives.

Mehmet
