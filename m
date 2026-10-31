Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793481574;
	b=YfKguTxP1pH9tjG3PFm8lqOkWYV5BuTO/hb+vO71MD04MsArKx10vSJmSxAGQk2s1hSR
	 cvcYKeVT7oxBJdvIV80iXtJCIQVby3M38CSDzQawc3NlPwzzl3DarnbZRrOFTifgsNNSi
	 GSy0K7BzyXdhRO1LkAep1otwpD8zB6cVl9wxKBGRHIKUdX13BIoBLYM+Hm4a/i5jgreSK
	 UI91O2HoUl4js5wxrMUMul9lkbWv0MzTCsGSULBbjqrfxEOiBeG7BQeW+QFlvUOIPATuQ
	 Qkh0xrBenE7xH6T1K4sZ+ocM3+qplDRWr2PNsyJQVwHSJkGxa73d3/PlxZwSB42i3Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793481574;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RX61jLwYDYv5I+j+19UR19HppQveJQd+TQJZ67BiwVU=;
	b=hEIYsdr11j9zYc2VZeSZhZiMI/+xKTrski1qd1kkQf6rc64snQgLAc6Ki86z7M26Y6Qm
	 6ZE1X56JdjEUluOXLO7p5DEK9qqf5/AFDygH4OT67Qg8uBxmzmb9GnY7LUR3+8X+vS15u
	 wpSLqtj+FIQRzxBQMegNg6rlyR38CR5pFGKjU0XW8eBtYVlg5Rvg1fp9T8ZyVBJ7vm5bU
	 oC/qT1GyUFygIIrcPH6iQOFUM1m6483n71/YsW+y6YUkEPYDD4EskWS8kmlAEmHdO4Q4M
	 zh1njbROlyxZVCzGOofZ2IYHsWC60r60XRs3pTGk+ZhkoRF5dmuFjp+VXWHY5cmTZgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U4cDSkjb;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8A6606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 21:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE8A6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U4cDSkjb
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f20b304c0so172555285a.3
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 14:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793481573; x=1794086373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RX61jLwYDYv5I+j+19UR19HppQveJQd+TQJZ67BiwVU=;
        b=U4cDSkjbhP/C6t+3QMtMsthI+MoUnZh7Ilqj3BvMwF6vRdxw9pacKHfwUw8skNvtZ5
         Xe3SE8axPbqUDwfO9MPwuWVUPNFltdaZc43y/GkXyxEAN3fM+OpA9zjyDGf+hpmBjX/C
         oL1hqLY/MirKszjdQLyjp65Ptap4w0GwmuV3lFi5tqIIxwMZLP6dLEvkQDOvpGIb59Uj
         eiBEwOne70DcEJWqtYMaeMNzbDBra9so9WkT32UydkfSL1d93C/iHIx2HZXTOpFp4qRl
         0m1ItZZfsIv/muACqMNCmAcdlKOme+s6/hiF7QbhJ9+A+87CUakhS3ZlUrhcoraJ21wb
         i5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793481573; x=1794086373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RX61jLwYDYv5I+j+19UR19HppQveJQd+TQJZ67BiwVU=;
        b=QpZ6GgSR31CoVRHXrZcbUucxEg8hTWup/NsVJIej7v48F951fG7CC4ntfqf84Rwq64
         r3jYg7prA3lnTRLgiFG7+2Sm28kyv6o6SHc6bJ3NwwqWXvy1qp5U+ZhuhfT01kg7he5K
         TfTopqoEFTlx0AA+H7onixZ/mjHSUYFhjZWgVvx2xKA6qWLcNJ3UbJZbRMMuc1WnYPuO
         VaNQIRWMtJ+xa68pebcOD9/mbT9a5z9cGP2iNc1CuO5Cic35j6bUFxIbfuc/O+x/a/9Q
         tMeJrIWBUgl3quc22OEprJFJHUu+COqXVpbV7PyCxjETAZaLq+ciQmReqljB10H4pjzx
         KnIQ==
X-Forwarded-Encrypted: i=1; AKwUvBy69l+rgPu9RG6OIhHokdn+lBF51+/NPBTgg/paWotRh8aezCr7L4IdJSMWx6mqCBNmgOn4EtXO4i0B/xaTeg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8UcKjIAd+YEl7/3fwI+jNfwEVbGhjLK+4zYBQnP13+U2Z1nL5
	Fiqj9XznQj8wuHspx2Q02w3pF2TTpjqn3Q9bWkbfGKOlAE8m846ZZ/BC
X-Gm-Gg: AYBFou3Onijoah9N6XTbPj76jQN/JS/xMB387eD5hBiv2ehY2+Ua3UVSHtz16Kb2iqW
	R/cYaO5HKu2Pss06MR6tjU69q7jhrHM4Wcq2u8QXoi1Xuh4+0cjOmKwOXwUc+eV/8Jv2RR1rsvM
	rS59VqpYJNH4Syy8aZGELMzdQrFzDBm2iU1fv5mXmhkGVs1bUAzjT7nAHeJkBGnysBGL05RfbzL
	FgNlM275JAQ7/oxzo9uBJD0FD5V+6+DAZs2k+sSMWzqPx69tDrEa+wmlQOWXNZNvLQRU0KUhrJY
	LGbW1JPQPIRXOQPzEKTaEqIMgfIirj/2yj5Vv2K521ZhcsEyQpt53WZGDfGQlak/+d1Bi6KjRje
	TgHY6jChqA060xRzrCgQO50HjqEHbj4Fdqgp6GZlJ5261Ej4lUuY3tI1zXwo4ss5yab0fYFIj8q
	EimMSMgbnp1hna0HBsYqqZrnTAx+iIZFmRpTnWsDbV0Nv8ANoN3deOxNsvBBZZaA48Rf2nx74nr
	gYVDUKWnCK8KE1gRvcg04+ZSFymTMCP3+mRrBZT+bYiLP/lak4AC3rTdF/Hdms2zgcUc7lOiaof
	WSLrK9t7apkGFJo1QPSuWbDyMGDvZz/GEHA=
X-Received: by 2002:a05:620a:17a4:b0:92e:bc28:5479 with SMTP id af79cd13be357-944214d169fmr1049948185a.2.1793481572859;
        Sat, 31 Oct 2026 14:19:32 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca807d8fasm49629256d6.41.2026.10.31.14.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 14:19:32 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v9 2/3] wifi: rtw88: support channel switch in AP mode
Date: Sat, 31 Oct 2026 22:19:29 +0100
Message-ID: <20261031211929.3296373-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <7ea86f5208f259f01ce8c18b7701f2a3e41e0fca@linux.dev>
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

Hi Luka,

Thanks for the review.

> Maybe clear csa_vif again at the end of rtw_core_stop(), once the mutex
> is taken back?

Yes. The USB chips never start the recovery, rtw_fw_c2h_cmd_isr() is
only called from pci.c, so I started it from a test hook on an
RTL8821CU, held rtw_core_stop() open for 3 s with the mutex dropped and
started a switch in that time:

- before the cancels: the countdown never finished and the next switch
  was refused, 3 of 3 runs;
- after cancel_delayed_work_sync(): the work stayed queued with csa_vif
  set, ran after the power off, and the restart then failed to download
  the firmware, 3 of 3 runs.

With csa_vif cleared again after the mutex_lock(), the switch completed
in all 6 runs. v10 does that.

Mehmet
