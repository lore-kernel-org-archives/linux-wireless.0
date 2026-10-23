Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792719941;
	b=RSzDJFqvu3BizydCs1T/tdT2/rTw0ARXPWDGYHM24Ale5UATRsPZNmireTYnCqTw9dMU
	 cRl56gVp1StI9OCZDpC6faK5u1bV2VrK2e8Cw76jSSz+4G1HW2GnENEF9BIlaQDRl7XWY
	 xed3oo8qkvvdfaM3BLrHOYlfH61VJZM+JP+j/OO5qnWv6m3bVzj2vzg/4E/P5YGsYaqJ6
	 h3eKMIHVQK9dj/yHzJEOXB8Jno0ksq5jHKwtkgEW6YJqc+a+Rg3a75WLjE4oAhgvqrntW
	 B5DLa3mchepySFa11fG71Z4GAKp9aX2+QdZLyUjZyN0s5tsWjeH5GM03JIxYKjZ7Jqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792719941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=RB+DdowYFUusKDyE0rZ+ShBEFBQzLjYfSX55pdLeabY=;
	b=ilitvDkYKAlOrCwTp0vgq7FTN+ZEtXHkqyplsHdjTsncvaOuFCjBzT/1XcU5glTbqJkc
	 egIAMImUL/YwrerKCWE6qrw14weCu1lt1fZzxRCZWoYKNk/F+4KB9G5Cuc6grh4YO5QNp
	 eMa14YFh3vSvwq6u2Xj78ULvmyBrrq6JtFmPPUFzVlKRj/wmlDK33DyjPoLUNvypWLeh/
	 C1mRAl2EKZxiOLkkQZlO/5jEMl6Kn8oNCAnC6ACZBcK0fLULMl29D2u8AWFQiHDlNuHMM
	 niyH8pfiFbvO3QG9HKqsfu8jPP+0cFvvNLOZIxapQmyj7X1W1w7C05iVFCsd7AYPMbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=s18chXSL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.50
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09401606A319
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 01:45:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09401606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=s18chXSL
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-833e671ee9fso319370a34.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 18:45:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792719940; cv=none;
        d=google.com; s=arc-20260327;
        b=ScqR99JIyNQmS/q8IM6dQhJGnT+3hPiMO5In0TOu0jKKnrFGJXtBm2sifQvzpPtOB7
         /zC8EMRHSiRpHqHzHnKWQpbwM5Xh4iwy8DYBUwCyzvRqtnAlwFiZejggt7Bih7TfIzWU
         NPmE+UBqC5j8wicuZ4RYjaOQRhlOsVS3l/2NDWA5q+vIUP/pbJLvgiaTE/R2b3X3tAtl
         2NAl1TTTyV5TcJrlBk+rEWoA4PGjwz5ZufGA/vOPJnMzV6MskkNzPivAAfkXYM8fa5cC
         IcNjzKKKQ8KKQu84oVsa1AVA7fJPOcvU/KA/8+/k6v+mnTFjTmVaChM4ZZHRrNhRMP43
         2MiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=RB+DdowYFUusKDyE0rZ+ShBEFBQzLjYfSX55pdLeabY=;
        fh=WUA31yBv7YTWwp1IJ+5nfW/1Vb/+JiQePvNgmqxLHlg=;
        b=X7tpVJOJmhGxryxBF/LZyE58SutBiFKt8+AYL+DWHpQMU1jASGvkRkWPiK7Rqnr5P/
         CvmLjmacYod2G9W2Y//WYzNcLX/KNU+hoLm/3DnRDMA/zVD52URLkodpsdwY7qfcxO0f
         W5NIhyQqU3CsLNtY00UgtHqcDe5cEEQp+cqXlyd8b2Q+BJoAohClmS3DLbcY14lRULcn
         9Uhbig6FMsjqMf+UrFBos209zuw0aqEiEsktU038sRgoP3uz0P0E0V8cd2Sus+vjfLhl
         l2oofojAeMVG0/Et3pb76gFd0IDWklqPuRbBSxEEIeHMfk0FekGgRn+0QWG30VYfrDDK
         5OqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792719940; x=1793324740; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RB+DdowYFUusKDyE0rZ+ShBEFBQzLjYfSX55pdLeabY=;
        b=s18chXSLzxKtkMkk+5oTNFr2Ef0BSn4lmrPp+qlyQ1Zpt7HXpOnf36AuBWsgZ1ebB0
         Vj/lt1JPtsKJLUWUEMxjtSl5OVaTnfStilW9RfizVPNLOTyaf+x3+dwYuUERMYCbYup6
         7W9bjzTDi3uEdfs7iFkLVES4y/283BNdRCoqoTUiV4iR1GrdpigMTngXozU1RtSslD8/
         dkP73ZLjXeajyXirV2bGxd7uPhn5nC8czcQav+P95/B9X6L77F0XdRJfk6tFE1FUdY5r
         8G0YD/1TWOmlDV9IE3R6KDb4oeVa0dooBVXVNI65xEuQrrXnKIoia9N6LN6wPUDrDbYX
         6Uug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792719940; x=1793324740;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RB+DdowYFUusKDyE0rZ+ShBEFBQzLjYfSX55pdLeabY=;
        b=0WxrrW/i7TX5a8hUDThDzdTyWl74pU3U4QwN7CpkCvTnvIEufDUyQhmNtjzjz9ja6P
         HNPQXAzOHJlHD7vjXeRJZkds59aKcJsFgf8uxfmKc9IRMJtQA3Y8kAqkeWsg6xjwUMwf
         CxmWXHlo1eMojzL1BwHHhJk63VwhUrKEcroUGKG6+R1RZPe/3pMjs3nLnzFXCK6lEoyx
         MMx6WC+robC3DZ5QMSxe7De6ug0SBzDm7UNCzUBhAforxj5M0OnetqDdeDUGfwG4UhCN
         edYNNd3csS0Mc/zKHdKJ2jXuNL8rmqhh4FaJ2wElX9a5QjuzykR6HhnjApq8m6LKYSco
         6DVg==
X-Gm-Message-State: AFq9FYIJjGtIzEXtGQNFMJOzeRAVGecvvdZKPjfpt9WpaXQnhLQFmwKk
	VA6TrhNOpGimsLXIoMrUWDrWiT2NXaVaYiU0GJEp8BiWKiqVaeDG1U6Jj6HedD3Gzf9lWRC220c
	j00PHoXFpkes1YeKWUBBYA5/V6wRGS3htY6QC8sQ=
X-Gm-Gg: AYBFou3lZTM9yz5krMdJFvB3IvMTn1G8bzSbpcFAEExO84s1utmy4MfIhfsnsPxg7q9
	n115+fJcgBThV526KQ1bqmKhHkNyS0QoC09qBOAR72JcRFiDRebzz15t41XJEHhVw7HLMIcNY2s
	ZdK8vNemX+qHVIU67ME+53V6KObUqx9NjnXwblFARdi4nx0fx2bHsFLyIe7e0zn/RndSU6h2SOm
	WlTcHkzSpHeCmEyhUEFSotuhyo6dbqNZOBAoR4pyaUBwmfHlbPWpxAYjhKk2hQXdQks7BGCAlDm
	Mrn1UWbNHy3CQejjZGwTm/tZ8467sItTrIA4MdEVZnD8CCAmQ9Oum4/I8JH4DR8X4LM5eSFfMg7
	62bI2vIwrZqFOBbwLKinfZoFyaMOJznnclo+ZKt1ZGEeMbxKpx+qwuE+mVUX1VXdQN32oSc7GN/
	a2tAEvLjAYMfU=
X-Received: by 2002:a05:6808:4f0f:b0:54c:97ac:4b85 with SMTP id
 5614622812f47-55be83e8c14mr546424b6e.64.1792719939871; Thu, 22 Oct 2026
 18:45:39 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Jason Hodge <jasonvhodge@gmail.com>
Date: Thu, 22 Oct 2026 21:45:28 -0400
X-Gm-Features: AclHuK8ZD7sTcvFSC9g4BN6WyvBfJUyaXYJUku4-wudnO9wAMpaxCd0cRsrHKQA
Message-ID: <CAEC_7rB38g-S-1xkJQ=uz1BjLBX-wpsS5VCqCC7c8vH==jt05A@mail.gmail.com>
Subject: [BUG] wifi: mt76: mt7925e: resume fails with -110 on MT7927,
 occasional system hang
To: linux-wireless@vger.kernel.org
Cc: sean.wang@mediatek.com, nbd@nbd.name, mingyen.hsieh@mediatek.com, 
	yu-ching.liu@mediatek.com, emery.hsin@mediatek.com
Content-Type: text/plain; charset="UTF-8"

Hi,

On an MT7927 card, mt7925e fails to resume from S3 suspend on every
wake in my logs, and occasionally the whole system hangs.

Hardware: MT7927 [14c3:7927], subsystem Foxconn [105b:e104]
Board: ASUS ROG MAXIMUS X HERO (WI-FI AC), BIOS 1602
CPU: Intel Core i7-8700K
Kernel: 7.2.11-1-cachyos (CachyOS-patched; happy to retest on mainline)
linux-firmware: 20260916
Sleep: S3 (deep)

Every resume logs:

  mt7925e 0000:03:00.0: PM: dpm_run_callback(): pci_pm_resume returns -110
  mt7925e 0000:03:00.0: PM: failed to resume async: error -110
  mt7925e 0000:03:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260414133750a
  mt7925e 0000:03:00.0: WM Firmware Version: ____000000, Build Time:
20260414134255

Most wakes recover, but sometimes the system is completely
unresponsive after wake (keyboard, mouse, power button) and needs a
hard reset; the journal ends before any resume messages.

After each failed resume, the interface comes back as wlan1 instead of
wlan0, suggesting the device is re-probed rather than resumed.

Workaround: unloading mt7925e before suspend and reloading it after
(systemd-sleep hook) avoids the problem.

This looks like the same issue as
https://bugzilla.kernel.org/show_bug.cgi?id=220395 (MT7925, s2idle,
AMD laptop), which is still open, so it seems to affect both chips and
both sleep modes. My full kernel log is attached there.

I can provide more logs or test patches.

Thanks,
Jason
