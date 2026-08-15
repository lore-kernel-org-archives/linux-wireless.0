Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66B332779D
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786813200; cv=none; b=d9tPXv/2rdVYR2GKc6FJPpTnKhJbxmysPdjxyUN4ofwb4Z+BoXLUIhJrN/bWgBCk60uP++iYSzxTqCaspm5yOmALhiCiJLT9PNEQ4aGuO59pWBV4M4mIMWgWvN7QgxhsHMzyRNsDuXj+T9iHu2BEeI++OsJ35W+dAh+4CREWDek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786813200; c=relaxed/simple;
	bh=hk8ey2BiC+ojmYOxKlXaJZgRJXTiWL54rqZdd/V98p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r//Ei70Er6s8GEf/VU4pUK76Wr+VbAEeBWzZl9pSfNNXMvBcJ90rPjnZTSHfjcwTmLLTpyTbXLpcXC/rq5t2yoIxC0tXRTbRC87DMG5V7mwuFjgvXrJpVXqNJQl37QGoT8YYRGWzN4eEoBhvDfCEXOm0RrzMHvZAxEd2dLy4xco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jMfRVYie; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jMfRVYie"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aebd52488cso2164871e87.2
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 09:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786813197; x=1787417997; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vo0gH5walmOuH9TG7vKE8plLHSq7YWG1GGcACj/aHik=;
        b=jMfRVYieVSeIk81PPacHcktuUqySQmbZqEsbp256ge9rl7ht6LhY9SqrrbE+y04Maa
         v0AJYcROCKrvVCJVvnpPcVnAMDNYmSq8VlAff6QSd7I5GYS35LyOzsr7zROJdyFNj4je
         LNOkW/o+l36llRkNZ4w5wrHmMGWm8daJrO8WDRiLeh/fTY/zH7ScHHzq2QsbA1Pt12vD
         RNcst31OPTFmY1eRkoiGDKYuMaNID5vKx2PchWYCWgWqr7dYmmlZExtSgVDxYL2rCpos
         i2JrnDj22Bb3MlhUWZnJrRHL5fn3N/hXoRy6JNApXmauJLsW4wOaSp9M+PZkk0KJVX+a
         c1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786813197; x=1787417997;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vo0gH5walmOuH9TG7vKE8plLHSq7YWG1GGcACj/aHik=;
        b=LRTWX+fY4eYyLSAxx8DYLml4ucyxcO/YcJdG3hdBFZY6WVwBTjRpUPASYfKPTZto6w
         BwprmPop0G4Pr9jjsiyLwrq6FBEyPpip/52VFqSkPDiYrp/wZBKQzSgHxp27cZeYhm6F
         AwNKBdTe5nnfG7FReS5iPazV0bciDOnO7THHO5XRmVOY3ku4iS681wMEG6J8/sV9halJ
         SFqYpBmXd4or7w64YcIPzfOe8ddwtEL306U/eJICWqC5q7O4/N0XVf6J0CsmcxahnmjG
         08Gh+6WqFS36/3g9WcSvzMXPb63tDUsyv7ZXHZ7GofYAAUFs5jIdYoz8H4+923Eg0cNl
         JfBg==
X-Forwarded-Encrypted: i=1; AHgh+RrAFOPZwmjVIxLvMOu1dITmtyyXPv89hBokti6LSlI/x6+c2Vu2epnxN/zmXYnh4Q92EiNSYZX7DIwxDhnmQA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLzP+qj7AeJZdW3EqQeuoQD7Oevqu9J72i/nY01z2rJ0Id2PUV
	uF2b+y263rTPZrZcSOWVS60nhticHmeVQV3lwYtnQw7eUyIApWz7NG5B
X-Gm-Gg: AR+sD11OfQnS6YJyRXBh4/nQG2/jz+LdLgIc30szVTenSjYRyb3leEjPc/K2/WAsyNq
	ck4d4OdYm2O6zkmURwsdX0BDyQhWO2e7BPkSuYUFPXiHNIitL9LwH29FqgVvHH/hUdqJqcHJofU
	Yppbzur14QHE2X+Dvctz2jebVIgW1F70QK3kOmyItKCCjYVBdwUWTBGZfZRt3TkrTvHz5j1NtbG
	r4mJZe2DGOrs2Adl9GS5oR6iObRY9jEc2CH2ksTP7xMmI4GxawVhO9DtdLl7O5YJ+1H7CXo+HKD
	x6jz6Gpa5WTj7J8i8evMG1mHaXP409iWf5mMHRP4Y77hlx2e3nsPdNpQ943dsNMbNk2RQTvJY2C
	7DT2+cASciQMjd0lcGggInpPff7d94p7UQAcg1g4qFydHB/McSjFfuA4P7sjhDMn/R1qx4OJb6R
	iTs/ffImCbXKUWZnU6IJhf3KaIKR+xXwb49to8gBIjmFOrkmUMR0J2IioxB4ZXdJfkoeqcSzXhv
	LxtqW2ElRfFj2t38Cc91HHs/LrnZ2O+0yc=
X-Received: by 2002:a05:6512:3043:b0:5b4:5352:e2da with SMTP id 2adb3069b0e04-5b459109648mr2103872e87.6.1786813196636;
        Sat, 15 Aug 2026 09:59:56 -0700 (PDT)
Received: from localhost (host-80-73-162-2.rev.as20985.net. [80.73.162.2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458b9a9bfsm1274885e87.6.2026.08.15.09.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 09:59:56 -0700 (PDT)
From: Andrey Golovko <andrey.golovko@gmail.com>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
 Thorsten Leemhuis <regressions@leemhuis.info>,
 Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>, Bert Karwatzki <spasswolf@web.de>,
 Devin Wittmayer <lucid_duck@justthetip.ca>,
 Eric Biggers <ebiggers@kernel.org>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH wireless] Revert "wifi: mt76: Disable napi when removing
 device"
Date: Sat, 15 Aug 2026 20:12:00 +0300
Message-ID: <20260815201000.9134-1-andrey.golovko@gmail.com>
In-Reply-To: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
References: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Tested-by: Andrey Golovko <andrey@golovko.me>

Third machine, third form factor: an ASUS ProArt PX13 HN7306EAC, AMD
Strix Halo, MT7925 on PCIe (14c3:7925, mt7925e).  Kernel is v7.2-rc6
plus unrelated ASoC patches, so the regression is still there in rc6 and
rc7 - the 7.2 release is about to ship with it.

Before the revert: every poweroff and every reboot hangs after the
displays go off, machine stays powered, only holding the power button
recovers it.  'modprobe -r mt7925e' hangs the same way, with the stack
you posted:

  napi_disable_locked+0xe9/0x100
  napi_disable+0x25/0x50
  mt76_dma_cleanup+0x178/0x370 [mt76]
  mt792x_dma_cleanup+0x8f/0xb0 [mt792x_lib]
  mt7925_pci_remove+0xd7/0x1a0 [mt7925e]

After the revert: five poweroffs and one reboot in a row, all clean, and
'modprobe -r mt7925e' returns immediately.

One thing that may save the next person some time.  The hang is silent -
no watchdog fires, and here even the panic-on-stall sysctls were all set
to 1 by kdump-tools, so hung_task_panic could not catch it either.  But
device_shutdown() prints "<device>: shutdown" before each callback when
initcall_debug is on, so booting with

  initcall_debug nomodeset

names the culprit on the console: nomodeset keeps amdgpu from taking
over the framebuffer, so efifb survives to the end of the shutdown, and
the last line on the screen is

  mt7925e 0000:c2:00.0: shutdown

with no "reboot: Power down" after it.  That points at the guilty
.shutdown callback in one boot, without netconsole and without a serial
port, which on a laptop is the difference between diagnosable and not.

Andrey
