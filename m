Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792519432;
	b=uHTyOhDBEkQCvT6ZFGESPX7rvn4qLLyZ3xoQi4Uu9KTzvDgj44yzRKA3NAcxWFeatN3s
	 MWt5LIZLZAWG6lXEMMnr2d2uW/rBKmOvt8VTG+1R/K4pEf4TvgA6wNf72PW+PoBg1U6d2
	 vUTxouVqIEnAh7z0rrGDPY/fUcmOOuZzJylsmO1SeHHj7zRgybCD9mPMRNO+K7t4XyCMq
	 IqENnxH8/dF315RWnhxZRUwk0FgGkww2GUTQJSUDfLzsnL/CGiwMK3w89D2AYkSLjioJM
	 ddNEh1lmDKTJYyjOhO5Ado32eZz5IptE/adlO3pcpqLgINdz2psF/lIGpVowTEBo95Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792519432;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V4o4fO6pawc66cO2AMtXorTBoaiDvI8IA+mKgSBgKss=;
	b=sy8rm9upri487+Kt94g8MZKBhgI3kKBnOpfJfsXyiRdxS+qdQ6Vy4oEgtlW3P5+SVWTk
	 45Wn7NXYL1VAlhKI6xegg/psnJ1iL56ykMtOYoGh2x86uYlAc2Jw3KVoZOocQV65AZM7n
	 IbJPjWGoE/dDa+27ONWNzqpgU1urWTR+s+betB22cDLScuXKDpqqiCEC/mt6lJzh1Imx+
	 Oqd/IqU9Gdv31yET995kgykrdPvF6zNrc+HDUIQ1MNNJGTKWfLwa28taX3wqxxXB8kIUj
	 D2gkc9u97x2kuBiKlihVpn08soRKAjbu/T4fuQcaN6b06EBzMuGOdkENIbMHD8KEXbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sMKaL3jw;
	arc=none smtp.remote-ip=209.85.217.42
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AA1606A333
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 18:03:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09AA1606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sMKaL3jw
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7cc2bb73cd9so989035137.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792519431; x=1793124231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V4o4fO6pawc66cO2AMtXorTBoaiDvI8IA+mKgSBgKss=;
        b=sMKaL3jww4NESjfkjeOIeXNKJS+7VFSKVupBa0tO6e9ooQthB+ba5KWfOLNjEVfagO
         1OYZQ86JLxpBKETa13S40RLH7/YCqvXLKlW5Qh906kTfw5uEH/mNBSiga9P6G8M4qed+
         5a1i//A/9zrg2zryvzT685ZUUPauNuzL+wgtR+bL8LSGwrf6ceNVWj9cMShNog7nrfbh
         fZOpROdfmRNqbdUHPzxN9rFod6E4VGfMbOzx+kyW4PQCPAL3gvvR5T9tTn1J0RyJxxtU
         /xvpXDBjjV23lNvzUVDueIfYQjWHwytfuiQFbJby6Hs49o4VslLQEytfwbRCiOude6FM
         RxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792519431; x=1793124231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V4o4fO6pawc66cO2AMtXorTBoaiDvI8IA+mKgSBgKss=;
        b=Zfsi1Is/+o2N2281rQhpgE2dW8cqeTewnU1vQdHY2JZgljMoAYJam+RWyYIr5oSJZK
         CTT/EJ6E4Mj7Ifxsu5y8wYvUxmFt/QHSYvaenws3jPGVgn3sEfRIwpqn7EIL1x16C6SA
         6TIP7BdJRFAdSix4WffnodMg9kIw0zyWt0Jp6IhHT9cLYEgHE5q/F3lzV7VLs7HZ8+Og
         sf23ZTZtxrJFGMit06vA4YQjYnwU3rZLIqR5jFTkOwa+q6ryonJTeZZsT1Nl1+m+Ker/
         JvcUmiXkBCNDRhoU0fkVBZvCkL/KwURQ3ppc1vfl6en9oFbX9fHimyzPvSO/Ew+jZlJb
         xCpQ==
X-Forwarded-Encrypted: i=1; AKwUvBzhcr518Cwwx2642ZGulI9x0A2/F8qgajfwI0GmU01EnQb60uEgZJLtrLQBXao5yKzjANmn7O3zxuH5cVsttA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKrzyY3YcAwcFdidVv+Q+RIh1tiBpUVpisMCeUai+uR3o3LjuqU
	McEFGu8PSHp6RkbSHoyW9VSAAYP9HLAerGpLhoZBi315OnW4JIZqZtV1
X-Gm-Gg: AYBFou3wX2LczeqUghDCRVxf0PPxnbAo5bkpzRF/eR8Ye+GAxoXIBjiCczwkyRUBzqU
	WK+BuFxts3mHM2U5k9UmngFrFqMpCyoYdOxxlugCG0iCbu5zLEdz3wUfn5wAa+lBSTft3EsY9DH
	W3WySrbAnLdi6nLR4alCejUg+yr5Jbw5Nkx2U9xF90F6JCMx0gATaKQCbZtN8Lq5Cnqa+GrDMQj
	Zor7ohSRtGLTwkVEDyJWYPGgFrZTejYt1TqEtgS25QnJqIBtpphUVd2VzC212R7WVxdFQDWJ/IM
	1It2I2fd4EJGPovEcrHG8hiETQROnf4doPKaG8bxC2jlwe+C3DdutvSQj5rUm0N3oc9y9y11byu
	/Pk0Gn+7lnWF/8+oS98/tuHIjdVFEl4ymb1o+5IDdMiVChDDUBUFgqjrIdgeDHX8MvTue5R3Qoc
	eI/j6uYL4LPeMKusfuyUepJ8O8wUguPrQv9FOnecBEWxQvjoE/jxVIgWwNwAfrfNwsE9Z1lZwJN
	pxKuWIUJnpPSIDHBn2/lpTSOuHZ09MVA5RWHozLnaNYNg==
X-Received: by 2002:a05:6102:5809:b0:7c3:fc96:fbdc with SMTP id ada2fe7eead31-7cc36af6325mr2439533137.37.1792519430791;
        Tue, 20 Oct 2026 11:03:50 -0700 (PDT)
Received: from localhost.localdomain ([190.177.181.23])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cc923b39efsm25269137.8.2026.10.20.11.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 11:03:50 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: nbd@nbd.name
Cc: lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt7603: discard power-save loopbacks after wakeup
Date: Tue, 20 Oct 2026 15:03:45 -0300
Message-ID: <20261020180345.13263-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8e57a7f2-6495-4535-af99-9abf5bcaa1f9@nbd.name>
References: <8e57a7f2-6495-4535-af99-9abf5bcaa1f9@nbd.name>
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

On 20.10.26 18:44, Felix Fietkau wrote:
> It all depends on whether the receiver has moved on and considers the
> frame lost, or if there is value in sending it to avoid the reorder
> timeout (which would cause some jitter). Either way, we should likely
> only allow immediate-tx if aggregation is enabled.
>
> If you have some time, could you test, which variant works better?

I tried, but I could not get the late case to happen here.

Setup: MT7603E AP (EcoNet EN751221 board, OpenWrt, 6.18), channel 11,
HT20, one Android phone (Galaxy A56) as the only client, screen off,
about -35 dBm. I added a debugfs knob for a loopback that arrives after
the wakeup drained psq: 0 drops it (this patch), 1 sends it right away
only if its TID has an active TX aggregation session, 2 always sends it.
Counters record every loopback, whether it arrived before or after the
wakeup, and how long after the wakeup.

Traffic was ICMP echo from the AP to the phone, 1000 bytes:

- One every 50 ms, modes 0/1/2/0/1/2 for 3 minutes each: 4-21 wakeups
  per phase and no late loopback in any of them, so all three modes ran
  the same code. Loss and RTT matched across modes (0.03-0.06% loss,
  p99 10-15 ms).

- Bursts so the phone dozes between them (30 every 400 ms, 10 every
  250 ms, 60 every 1 s, one minute each), repeated three times: about
  1,000 sleep/wake transitions in total and no late loopback. In the
  runs that also counted on-time loopbacks (about 690 transitions) there
  was exactly one, and it arrived while the station was still asleep.

So with this client the hardware almost never holds a frame for the
station when it starts to doze, and none came back after a wakeup. I
can't say which variant works better, since neither path ran. This is
one client on one AP, though; a client that dozes while traffic is
still flowing could behave differently.

Given that, I'd keep the drop as in this patch, since it is the simpler
path and costs at most an occasional frame. If you'd prefer immediate
TX gated on aggregation, I can send a v2 with that instead, and if you
know a client or traffic pattern that triggers late loopbacks more
often, I'm happy to rerun the test with it.

Cristian
