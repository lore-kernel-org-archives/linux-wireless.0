Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC791491582
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816988; cv=pass; b=CH6FLSAPqlcgiI9UoOfbUE8ki+D9w0mU8yjv1Uzl5AIiceUNc0LBs345Vh/b+9DEjBTplOfVPw8Icy5bJN5wXOL1ixOssZLSFUqOUn6UnzfAWHzd+0/NJ9s8AJr5zgAu1KU3cjJM/jAAQ1PyHrbjxCu6uKmU5iLWbCCeXn3ehc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816988; c=relaxed/simple;
	bh=Kb5s/1sQG9XYIwryOKTCf1h4HlcDSiYJw6L+9ETpVF8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Aln9sYSQTPNyqBh3fn7L3wjs7eVqgp1nJMeTPiS28QuIqurK4Qg0taYdduw/Xhsb9mFXZguCmy+Zxl0EJnsA4Nrk8dv2CV+mGyR7xaRaXcWl9sXdlYf73KH8d2KGZfCxm5w4vkCC6zFA4GoRxgXeGKgLJRZdXlJ0keKQKE9/FUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3Fsaf6w; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3Fsaf6w"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6af9a90e4bbso2024682a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 07:56:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791816984; cv=none;
        d=google.com; s=arc-20260327;
        b=Q8+XDF7SSMf5Ie6XsHwNuZzBzXgAAMqcETxIHQp1vz08zHWipA+Zchvx6l6cmchoDG
         yRUJtsjg4U6pNPd5ybjdyX02RWu9xag/r2QZjz+1dg60sV6x0Psh5wMg+efoa/6BCg6z
         V2WGT6xUjzmuORblIK5TIhJABewKVkOD2crFDwI3QQ+Ow+o2PVPMrgh8QPtkbNr15NtK
         mLM99f0LSOimHaGdgpJQopOBX7K5LjzxS7mwv+L9AHgbGu61dKuV4bvyUEQ0B325sllb
         TqnxN2i1e1t0Fa+VU8Lkc25vrN5uBfx5oOzX3tfPVZUKXWbDbfJtA4jomMDNsv7zQ6V7
         /fJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Kb5s/1sQG9XYIwryOKTCf1h4HlcDSiYJw6L+9ETpVF8=;
        fh=esYzUBYM5aSL29lum9DkaXCbW3UScjqSzFVfzd9Xmfk=;
        b=ioEUlFsJ+5Pm7kPPb0KhDRaRHWMm+yNAm+zpKFJt270uEEhA3k44IijwoIo93qlhT9
         RBBJp0PgisWz4Ug0EOTR+KW1GyEVwXRqortksdNkDWwT226obGW5p7gEy3iL2MK+05SQ
         JVLtyub49yj4X+VybzNuMq9QILUdlVp3aU7ZkUHtMXtvQllmFpQdJxRSV/Fhw0pdpSnZ
         KmtqTgTvhHcv7WkpY0KiZEc+MvepXL+8OWiVjjGrtQuLyFEO4O/V9rvR5SGmD9cZNUYc
         vMHAHkeQ3XhxQ+ZvLYh/QtNhxDLwZjqJ20oCe2ZkOgj7Fq4dlywRadkv4oUJeMn6neKS
         GZfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791816984; x=1792421784; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kb5s/1sQG9XYIwryOKTCf1h4HlcDSiYJw6L+9ETpVF8=;
        b=A3Fsaf6w7k6HHtas5Oah2coskxCTbc7U3Fm/5zI38w0A8qe86pOcvc48gM91yb0gQ/
         v8w/A9/b0yrsyeHux2DSA8zQK1Rvh+VsvLPbJR7CTb08bkigKEBcgOqVwLmtNUliuhnx
         9PXhH5VBn1z4BM/kDGT7Md+iGEH8cK0nOW84zRtQKaiIHru++Y13k7D15SXCvC1jTOFD
         QLLn7H/fBLiKIB6yhKBoaAo7fPsp4iCpBArC2FlgfqgmZsDUqBuPdC78pNQQVp8JgIMo
         nQ8BB1awpPQ0ybvBzQqm4q6+KAZmn4GqR0T+QarTZcgiVxaJdrad/5J5XvCCV8uyYqnn
         YtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791816984; x=1792421784;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Kb5s/1sQG9XYIwryOKTCf1h4HlcDSiYJw6L+9ETpVF8=;
        b=X6aSTsLFKf0LxMPWjGNvXUhBP3mzNHzDoQdeFNugkp1Ns158j6qzK5hnGRJ2Ud/AEP
         cOPaj0drZHxGQOQoXFNILMhRnD0WWzGZOX2tCl4EMvc8y+379UG+TOgtLLhkwvs0zfOw
         UgnK6Rq1WPQXlKbblXEeDWtf4L+Ld8U2HiT9tHnQq1nL2kgqXDfx9nxmOUWklt3uT9XA
         cuwifg1Wex/eGGphDZtxxOWVm4rAKhY1wNzppeDvAVJ9hRqxoGFlu0B61PSHHOLbrQnz
         +u9Rcz9ltjoDYLpGNBt99QOBZsBW3zkcyhmREq+bq27eTzxGggLuORK3LeH2Z552NJpL
         as6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwWOnlfNoU4uj/rGOaWn0cOf2GQVTq5nwiCQPcllv8Kb8jTBg6au0O1dOGmSe+7UiZaQv89jybTPkzIrl/aOw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIqQ5IU9dh/S8J+5Lr1IzYlb8d6GaGh353lAx1SjTItUVm+7afT
	HXzLtlrfzcnEsgcFxUr/ftHP69euNmWSh9cUY9frJTk2QgAjwXvEVMSZukVJHaEtScIA98JdKI3
	RSCCTebD9gjBX/VNAK6Mj8wS1VdRLMWw=
X-Gm-Gg: AYBFou1kBJesPGb9lHbu8h11hottBSMmexnumfOMj6IaIt1dmwpYfIoJtIBvGqC4GvK
	BhhblKR0qh5VeBmozh8wBzWL+xCEbjPVFnaOoxk7SLGeEBCJCgCTNoNw16hZmf8nrPrdrIC2P0y
	2J1nD2cN0Mkv7aH4yT7IMqwVCuZsY84Ca8SAu60An84tV7KjKpMrRecaYgJdif0J9Ib5Nuut2YN
	0nY56Lm1MetOSskY6cndF3rv9VZmxwylbVgr5YkV5luWrlUJXd/qJjmqZqrp9Ro9fIBm8dekHio
	tqSEfsZfqYrK4kgjq4N0FhRriCnJguI8QK2u5bYgDm0qPxSoby83rWLlJ19cw7ZnmqfcBIoHErf
	UXW7K/aJSpmjz
X-Received: by 2002:a05:6402:354b:b0:6ae:550e:5a04 with SMTP id
 4fb4d7f45d1cf-6b17c267f12mr7897936a12.30.1791816983901; Mon, 12 Oct 2026
 07:56:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?0JjQu9GM0Y8g0KjQuNC00LvQvtCy0YHQutC40Lk=?= <shidlovskiyilya@gmail.com>
Date: Mon, 12 Oct 2026 17:56:12 +0300
X-Gm-Features: AclHuK_V_Gr_BzvbzmCXZnPpQdlQCrW27JXkLvyBO5_v8U3WJkVXi-60BRN7WX4
Message-ID: <CAGjg407dj0uZ0rCrL4G=PDkQv4-QC_og9Eeg7ewWzxqBvU4b2w@mail.gmail.com>
Subject: [REGRESSION] 7.3: mt7925e hangs on hibernation restore; fix
 c182bfe944eb only queued for 7.4
To: nbd@nbd.name, johannes@sipsolutions.net
Cc: lorenzo@kernel.org, ck.chang@mediatek.com, eason.lai@mediatek.com, 
	emery.hsin@mediatek.com, sean.wang@mediatek.com, 
	linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Felix, Johannes,

commit c4edf9e3e0e5 ("wifi: mt76: mt7925: replace shared rx irq masks
with per-chip definitions"), merged for v7.3-rc1, breaks resume from
hibernation on MT7925 (PCIe). After the image is restored, the chip
reset path ends up on the MCU_WA NAPI, which is never set up on
MT7925, and the machine hangs hard (no console output, only a power-off
helps). Bert Karwatzki reported the same problem in August.

The fix is already applied:

c182bfe944eb ("wifi: mt76: mt7925: fix reset panic caused by the WM2
rx irq mask")

but only in wireless-next. As things stand, v7.3 will be released with
this regression and the fix will only arrive with 7.4-rc1. It is a small
fix for a regression introduced in this cycle and already carries a
Fixes: tag. Could it go to Linus through the wireless tree for v7.3? If
that is too late, please make sure it is picked up for 7.3.y stable.

Hardware:
Gigabyte Z890M AORUS ELITE WIFI7 ICE, BIOS F21
MT7925 [14c3:7925], subsystem [105b:e112], ASIC revision 79250000
Ubuntu 26.10 kernel 7.3.0-9-generic (based on v7.3-rc6)

Without the fix, every hibernation restore hangs. I narrowed it down by
unbinding groups of drivers before hibernating: only mt7925e triggers
it, and the 7.0 kernel is fine on the same machine. With c182bfe944eb
applied on top of 7.3.0-9 (built as an out-of-tree module), hibernation
and resume work again, including resume after booting another OS in
between.

Tested-by: Ilya Shidlovskiy <shidlovskiyilya@gmail.com>

#regzbot introduced: c4edf9e3e0e5
#regzbot fix: c182bfe944eb

Thanks,
Ilya
