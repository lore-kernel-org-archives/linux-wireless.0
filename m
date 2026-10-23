Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792786739;
	b=4SMDJfOePKFurpTkLXQjLVEs0pOs/Ecwk9KN4fc6+yDPUvnxKYGeAiFg7nNeDoV4wMQ3
	 ZfLA158tYsHdaWp4Uybu0S9dXtJsuQh5Mx+qA9nBi2P16k5SV3bNhi5qj+zzNpLMxy0hT
	 YPxL0kyT/Rzx5un5aSopxl10orgSXJLZCs+VR0NqexPlGAV5ucnxo3p7A3Qhd9dfYhtwk
	 V9NnbdXQmkwmPgfpyEbhtuezIi6LkKrog7T27Q8XCBxocVrKiRrgaukNWoIk91YeNgD9i
	 wEwYKFmI8WBz8+ZZUG+H9exvzPyNlTo3Yuhzi95ZWLsudHfhp94lPooZdvXcBdA7lFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792786739;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z4F/ImH8yxE/VRoOLYwaqjuUYoovX1fJCMr3I3n0sY0=;
	b=sf+sJ7gtVFhGRYnwEzcrkElgahKdfGLCKGAdiKHFeIFgO7/WMMh0veqFmdvJn2xKjicM
	 to802rpZXKFOsqolDIAM0IbNqe4uIzNU8CrnrPCe3IvlzYlltOzlPMLMdUWrM2TSid3qU
	 mF2tkM48G/2mc23VQ2WJD22B2YIlHIaEKD4zIa4lE4YTyu2Zq4SFT1KSNdTMXceWW7kOf
	 DUqEUctoTNzwxIbYY2PMfSnD0YeLf0hSGX38E8ePSTutkAHzp2WkCRsAueg3zovNO1Fl6
	 qDGZsMtg+df7RFsg6Ckxa0IK61vsXH9YNpXjV6+6e8ROPNoSG5FDU61iy72jcL+urwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OnSOYJ7s;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7F0606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 20:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D7F0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OnSOYJ7s
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so8224795e9.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 13:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792786738; x=1793391538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z4F/ImH8yxE/VRoOLYwaqjuUYoovX1fJCMr3I3n0sY0=;
        b=OnSOYJ7sSZSo+sIbdKGUDezq9IstUgoO5zNriBrrV+25tw/dyO/LouDslTFUayCi6n
         nDn0t8uIjw0qrylVU7Hgywou1ag6PVeQ09qZYU8d6Q6wbC+KHsBQ8N1xL2QQ80remFTh
         MP5HMJDNLagzU0vbJmMV9Cco0N5B/ZY0zXsLT8yQbiNO2SAHVYfJ1003HNLxvxuIa5Y8
         NpaDwRQsIGNhMvHOJP5mzM4KFtdQvt82+rp0I+kgOuAEHwvxaz6+x3nCZPYsNkqqwCQs
         7nA0YLJj2yczBI6oMvAO7S16NyVbUNAcGyi8+YjNQVzfWaUE6bucZkJ4nkkCefueYany
         srpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792786738; x=1793391538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=z4F/ImH8yxE/VRoOLYwaqjuUYoovX1fJCMr3I3n0sY0=;
        b=u35YmooqsrGFPN7sR96iyYnZL1zUZzxP5fHUZ0vpFlj18LSYE7DRiV5et0H9xqQpAl
         h9U407nunnNMMQLj+46ij6y32Jy20+CYHHRQeL1rwDE++dcgLwRUA0m+1CAXzI+vt2/a
         J+s0jawVNg/18eWUbdUXOXkEYBEoCGYhl8XyMXshjnrbEodq+If2F5yddqNM65zs1vRJ
         mF2i60mDZHqjtjR/ysyrhUYX3Pxd3GIPO6nEpXQeBSN69Zk042FGbfuF9iwFgjiLcw+4
         m1LMSmCKapjP0mPbUGx9F6Xt3/nR/SS61AnKR0FgDSJdaoG9L8r+Dp9CNwnikjcZ6gFu
         thkA==
X-Gm-Message-State: AFq9FYJAXXYwqpJhtcz38pjyMf9GEIT2X0UhHHH4gjEcDXaGRbSBrWb3
	Eg/NM8FiGXMtbf7MhDSno+Tc7yGlrNZbB6yHpKshp0cXdE3fCVWMMIAPhp1CoxrFb9k=
X-Gm-Gg: AYBFou3938pVExkHSxyv9nkR8fWzlGoCFTK+sAG/7mERZ4bkTgonalmwCGX4VvOFwuC
	txvA/hwECpa+S4gvA7jSRf9xNTwjh1pfbJA6MpuvWwyr+jblqJ+TYkecqXNa97u+ucOSI9mWhhi
	hYfwdxuoB6Fhg65gKBBb+Oje6rNSfw2ojtLviGBtm5DMbUzfb1J9ZW8P3OSFKjXTkIFXdIX6j02
	ttRNNDpJZJpPkbLfkYyXNjLT4F20NP3ZtpGAS7ZIQzCdNeJs9Nl1plPjgItZ4gITDgcSmvNobws
	KLIQ3TkBmcP5d/rqnSmLtRvJMZd2IrWjmIReuFiTR4L1EQ8+TIiq/wFbli3qj4O/zNoIidLwd3I
	EtNVtDA4OVAPUpyvxmbDF94grK3xmXltRestu9UycAIcovRJ/N1rkVaSeJsfpfMAVGHcU/ytNum
	TMWjF8SzBqKTvMEyfuxTrfzG+92Ik0npLjSwEaU/kwmh9MiqHvTzB70nMZ+frpURHB8PKBNRqYj
	dSACvEtat/hrjrUfjkdUrF46InMcllLqryNVCj5JDOHxsdQgg/AroeGUz8NHlqE+pV+i7UOdMw/
X-Received: by 2002:a05:600c:3d92:b0:4a1:d8fc:8165 with SMTP id 5b1f17b1804b1-4a35aca3f99mr32855e9.20.1792786737380;
        Fri, 23 Oct 2026 13:18:57 -0700 (PDT)
Received: from omarchy.tailf282f0.ts.net ([102.208.20.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a59d998sm4969545e9.15.2026.10.23.13.18.56
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 13:18:56 -0700 (PDT)
From: Carl Quist <equalizerjr@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723d: add iface combination
Date: Fri, 23 Oct 2026 20:17:24 +0000
Message-ID: <20261023201724.68885-1-equalizerjr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <b35b82f1331141faa3603574fa3697ac@realtek.com>
References: <b35b82f1331141faa3603574fa3697ac@realtek.com>
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

Thanks for the review.

Ping-Ke Shih wrote:
> As you confirmed RTL8723DE work well, it is okay to me.
>
> Did you setup an air sniffer to capture packets? I suggest you can have
> one to check AP behavior including:

No, I have not. I only have this one RTL8723DE laptop and no second
Wi-Fi adapter that can capture in monitor mode, so I cannot check the
five points you listed over the air (beacon interval, DTIM behavior, the
TIM bit for a sleeping station, and broadcast/multicast after the
beacon).

What I did test on the RTL8723DE (kernel 7.2.5, hostapd 2.12, station
and AP on 2.4 GHz channel 1):

- With v1, the AP served a phone beside the station for about four
  hours, and the station re-associated within one second each of four
  times I disconnected it with the AP running.
- With the LPS PG patch, beacons of 192, 312 and 592 bytes were built
  and downloaded without any "rsvd page over size" error (a 312 byte
  beacon failed without it), and a 639 byte beacon was still rejected,
  as calculated.

That last test only shows that the driver builds and downloads the
beacon. It does not show what is transmitted over the air.

Would you be fine with sending v2 as it is, with the commit message
stating exactly what was and was not tested? Or would you rather wait
until someone with a sniffer can run your checks? If there is a way to
check any of those points with a single adapter, I am happy to try it.

Best regards,
Carl
