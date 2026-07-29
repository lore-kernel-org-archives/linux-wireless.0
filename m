Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CFD43F8CB
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785315575; cv=pass; b=eG9al7yDyFzwKzSXYioH/dAPTUlQNRN5oZlf1NQlexSWkYAFx6Dhp/X+TFKX//8B81GppOHDa/b7lHU5BhC5/xFjz1bVv/F8dJiYCIcDfDl1iwiITpBaqKimD/kj+Rh1TMgBVAH8lJt11mg2ltnFOTjmTEjcStKS1gY3uGfSL9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785315575; c=relaxed/simple;
	bh=eL5o/U4F6LVrV7LPnpLyFghjh0EbsFFgFHArnrgIKqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AoIGLpH4Z5OhxZOymd2X9OQN3N/6vipw8ExkqfBozffFPlDX6IWfnSdDnVjTslfTSZtfGPjGf0ZggMGfaPR0gWpT00l1r27TZMygYQNmYlDHe1JzklAnwZo3VJ48UJefekjBn3rCQUnTv42pp8ts+X5okBYBFrmtafay8nRF+fw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Bz4ZhGn3; arc=pass smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Bz4ZhGn3"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ca97d139d8dso392182a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:59:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785315574; cv=none;
        d=google.com; s=arc-20260327;
        b=HhxjUwnKq7lMMUA0MouuhEyMpFPqUpbWpfK7OdMWzcd8IgbgV8haLRGVyIMkSSL3Fv
         MKPjCLk8jWY6vZB0vyp2jQ6nxSKvlJxh/FdaLcXKYFWPuN5RjxK1K5eTx0orOSz7eBYa
         Zbl1c1oQYMlVae1TbIT+/zgjTRMNCWjAskytUxQjJ1/nUljMDr+7CzWETglUmVcseP4k
         lNhNUFWwg1lbG7s+oPP1JrcpkKaVCzn0CIcqFd41cJdv7Cl4O1TDFpT/eJLRxqYJxexi
         /ErIn5EyiexkloqdBkR4tciQoLH/c10NZYZGd451AT/aR0sgvN84Gm1EgSG6+pi4I0lT
         iHkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eL5o/U4F6LVrV7LPnpLyFghjh0EbsFFgFHArnrgIKqc=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=Soe7FS0vbbt1fvyoclTpKJhSYWbpuApLbLv9fHqOrgHwFxWUVRUcc/U8dscakay+Su
         0KQYexjKyOuhXp7unrE7oRPrZ3fK33nm6M2a54GMeRnAJ2Z8bVuj8ZRlGQO413JYSDT9
         hpfczggWp9EB4+EAuY8Q/CWi0ecJh367BRnSaxqhBK7L7Ldd1joExWVCnner+CuSm8Er
         m3I1Q/T88MY58SwrnLLVXbFJmc7EDSq/LJcmdyXl2YR3zEILU6KwO6f2xrHh3bsnBgzY
         +MwiAYARqn00Ycg97kPe8N8KbYMYxuk02a2o5VG86YOFZpjf7fzXUjuTTkCEIOi20Xxb
         28xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785315574; x=1785920374; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eL5o/U4F6LVrV7LPnpLyFghjh0EbsFFgFHArnrgIKqc=;
        b=Bz4ZhGn3TUh51o2tAv+dgRDdI7Xr8MrOsxQ4Y7msi1+SDIN0123gxBmRvhNr+T0A8j
         qRqmxt3aJPWB19SX2PE1uzb/Ps9jGvIe2YIP1ygtvKLAAh5FK+kMGFlT3wNXr7dFW9oN
         WhnNDD1O5sFPcb0Ruc6mqUrZ9o7C2o4hEbLjpBPA0R6Yf0D6slUbYPvjFhpBbJOxEJMH
         U/btrE01+zPyFJXJF5adIpJdSHgfca0x1kqQuA/8mmsHGefmNmwzYLcZ0RYZezyiqtgs
         FyX3IWEOthZyS0udk+u3i+33pKcTRHwFtqwE4n7VXagQoo7BQiB7MmW7VZAwNh6Ex6UD
         sE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785315574; x=1785920374;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eL5o/U4F6LVrV7LPnpLyFghjh0EbsFFgFHArnrgIKqc=;
        b=iuQNKeQXBiO08Q7MhqhxhCzznB2RxTj/4/o9x/fJ3m3A+qGtWaF+T1mP4eKXu7i5d9
         K8xNq9gX54CsQ3UvAAZ0WMD5kfCanoWM9ptdlTOY/B52ozW1MLbFMEwrmtj0kq8OSrHz
         1EVZivTvVCh0UBYnSVMXWJy9tVnpqf+8V6n7NzK7zDKqxBG5kMKy9fJmW3+NIoGFPFNq
         HfoiaDWcz7XvzPZEiANlULo4GDq1lCg9RfqX3HJOC6Y+swzlQi2Y25xMA5sQgrdBFc1d
         Oy+K/nRbwpU7T3dRvM/7JDfmeXESV8tu/oPgtEi/PnRHsX31if43S6xifzSmAINew+lC
         Lvnw==
X-Gm-Message-State: AOJu0YzAEUShREN/G/rOyt2DbLeRw/zBk1wKr5zlFAEJ7icS5IG7lFHm
	ELla1utdDLoVqv8AcRXYhk4brHON6T2Nak6rHTN3JYjOJFsBjukwOvDHjG7WdwETiWhkO0Ozo/Z
	Q2atZmssmXTxrd6LnuwN3mut/fA5UZ0E=
X-Gm-Gg: AR+sD13xinhLAb/VOS9gzjmN7XXCJ0BVjNKjjiCy9c07nA5PqoSWV91m1geTtSiih9G
	hH7zKrPOIeVtKaa7TFSisjLEbJEUDzNvnLPbA2Mujie/YNUWwzahHwxQSMcDfm3egHQR4Xht3Q8
	n89Oi/WGOkwT/ge4UFJ9a4mPTVn6h5A2Z8QFbIjGMZWVn+crofzUt6h1PrGUlb562nCF3D1RwSh
	vrAnMh2kiQE9TuvDUWAutu+SXR02g3+qXq7t4n8O20mfBgWkro3j8V9VLgFod8264UfrGlz3n7S
	EEPbcQ72Ys7QpPxZvPJpC84QjIx5n/YOV0fpFEpIQBxrnDXFQCYN7GuR9lc0B5XXJ++NJWxfYqt
	69Hbv7d8GKaGWsqNQ7XjFpSxbQfKD8ws=
X-Received: by 2002:a05:6a21:490:b0:3c6:56b3:54d6 with SMTP id
 adf61e73a8af0-3c8ba6273b9mr6971419637.62.1785315573568; Wed, 29 Jul 2026
 01:59:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com> <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com> <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
In-Reply-To: <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
From: Adrodoc <adrodoc55@googlemail.com>
Date: Wed, 29 Jul 2026 10:59:22 +0200
X-Gm-Features: AUfX_myseAyWx6oeg122gRez1UFPnlANk1nQOFiT1oeFI41RLMBxOlPNwvsCW9Q
Message-ID: <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
Subject: Re: Error in rtw89 using Kernel 7.1.4
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

For some reason the first link I sent you is already dead:
https://paste.cachyos.org/p/7f39b6e.log
I don't know how long the retention of these links is and apparently
there is a mediatek.com policy preventing mail attachments, so I
uploaded them to the github issue to make sure they aren't lost:
* https://github.com/morrownr/rtw89/issues/116
* https://github.com/user-attachments/files/30497149/2026-07-27.13.02.12.7.1.4-1-cachyos.log
* https://github.com/user-attachments/files/30497150/2026-07-28.19.40.14.6.18.38-2-cachyos-lts.log

Unfortunately I no longer have the log file from 23.07.2026, but the
one from 27.07.2026 used the same kernel version.

> The RTL8852AE is supported since kernel 5.16. It will help if you can help to bisect the version.

I'll look into it and report back if I have success with installing an
old kernel.

> How sure why the disassociation doesn't present in 7.1.4 log.

That does indeed look strange.
