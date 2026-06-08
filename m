Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C971FF1B5
	for <linux-wireless@vger.kernel.org>; Mon,  8 Jun 2026 05:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780896505; cv=pass; b=XDK8fs/BVqwertij1VhzJ750ijk3opuqObnQs/8/TYM5ONpYqEp56NW4VvHUezM1g7321XGSKXviON/3YXkO13Kup63PRCcFtxx3oQ5nPvcL4cbX7dDktnFZXji2ba5sT4kxPhDSnjuvWLgFgBN7eut/7xIfBaGggOhTXPG/vK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780896505; c=relaxed/simple;
	bh=Cd7r9tX81f5e4GevObYRIvKFKIjgJsqAqNi2akdw1D8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rvsWqO1HuWNJqmu8gDVovMU8yl5b0hCrF+qkpihGFIOG6TlrAzTtktemOyxg1rn3nKNWNVzPHpN6d207wwOoFqui3zNf3Jx1dSZKS7NDX2FiKGe+p7h3ZkhDt0Lb3eDUkNiDT7LCi9tBsy28U0cseQ/t5w75Bhm2CjYbUfhF73w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oLjFqOqd; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oLjFqOqd"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-69e1f777bcaso2942251eaf.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2026 22:28:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780896503; cv=none;
        d=google.com; s=arc-20240605;
        b=d7JfTpv2mrQmv0O/77sW+L2g7OdgiCIR8BLr1LWXcZQ41KD4muLCcrPA+sEr/Pm2hL
         nfxKHM/lQOU9T0Fu5Oi/Di71tirBZdut+lQqYgJrOt82UclViB0EwZzzgkwvpIqgQ8JK
         GJwc/stVy/vbPnU69NHQiakgoZ5urRULX0A9US3hD8JqjlR/Nk9qYlhXyzzWQlrXOCDU
         /A26QgkOuK+JQhYZaRFmwYDGHpY9vx1ERROzyVAufS7K7Da2Rasj9DKmsvgsCoXtBId7
         e08ZTca4YlQHKqQ85ZQ4VE+rRspUeEJHG1ZiNn3UgIUI7pYg9CCHcXpdYtfveCnmVR7W
         8djw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Cd7r9tX81f5e4GevObYRIvKFKIjgJsqAqNi2akdw1D8=;
        fh=FNM59O5jNIF7oAThOYQ5nqtYPcI9hnlxdOohMrOh+fk=;
        b=Yo9CHQ3roBT0Y4BXdb0vOiKM/V0qgmK1XeKSB7UO+jokyfOm1McadUOZits+lweOAS
         pRdMb67npIKW4ehBWE+F6lSgRPREv2hB8SR0fuc037a7Lu/i+3sU0fI8UhvPDir2q3Hc
         EWDBEPZid7t7FYNyYoWFLw7MC9gu7sEaqXn0uFXBZPgA57gSzvyU6J9XBGy7ANnYYiPJ
         TwzzcpzcU+Lxg7zbQBSdDJHJ9BRfxQpUzHGLwzY+MpYSgT1VD9lp6rU/RHW4iTvpWVFT
         pB93LB56cTcb+By42owFHddwG0gake4vRm4mD0aEjv4ERYKCOUEZM59zRx+8d8umRLPD
         sGHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780896503; x=1781501303; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cd7r9tX81f5e4GevObYRIvKFKIjgJsqAqNi2akdw1D8=;
        b=oLjFqOqdbW7otJf8RjS/kj5pCzqPz/nXMUCKJ8c5p9WkvC2BcLKIupe/rxoblDn2cu
         t7mlycKarqGNJiLL0+bQ/SBD+5U56g19BcVUxekc78mLpu4sT1M27yq2Q5fR6NOgGIJj
         NFjU8LpsSM3qOqc9oloZiObYu9506EXxF1FtnAkNWu+190jTIoTSGI+NvZ4s5WWDDUXt
         2d/wSBDOGzFj/b9SyU52gUWTbahgHv+QOL2krKB0Gt/Q1q2IV91SMpaJ6LqoeuYButeQ
         c/zgY7GvbRnHGB4llaawcWo70fT2L/COIWf25saVwj3uZvlKknD+J7e2Iabof64ZVQ9r
         /Fhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780896503; x=1781501303;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cd7r9tX81f5e4GevObYRIvKFKIjgJsqAqNi2akdw1D8=;
        b=AVIXUf9/iKi12VE/pH4/gRMsqOEkWMDeS1pI19bOMRGZkWEYhJk7fw6fTdOXJYPe5h
         772oRj6vm8AeWRQUuZn80SvII2Ykb8gW+dFKT5jEK3QjkvrSoBWP8UPSJqg9v94bo5/6
         Do9mXc2YZig7SprFoo83Xq9APgims8t99vuYr+fqMl/pXvJKuv19Dcl4KkwXZBGF43u7
         ljnaaEwcCxt0aH9RILF7Jfh5/xGU71Ra+FpO5MqFj2C2XlVMQs2B5PXq9D41YWc4ZLkX
         1ADLPI8KxPYoRy15lfAW5t1eH88j2btWiM6NBOBzj7kppp6rj2jAhyfQSx+vB2M3LZkb
         q5Ew==
X-Gm-Message-State: AOJu0YzxnH9+J+ttpeH46i6qVNdjc4Z4kW4FB+M01P35bUafXr1hHHbp
	rTLnz+9TCGH75tAhn1NA7vpnxIY9oFoqjM2Pluo2UbRpQsllalA6ThZDedgNWEDKh+oJnyMMFcz
	S7YPIGmmZYVOSGWkzBt956l3NsmmxG0oQsZ0+zr5YUg==
X-Gm-Gg: Acq92OEyVVkKsgpTRGhZzfgpg+PN7mbXsP7CrG6QqiX7+QjC0wiN/zSXcq9qUNu5Gqh
	lQ0II25fcDcZoKZ9vOdZBzQEp4qJHhJm8LFuMTGFnseiHAvjkS6/YBfkZhXe71PCk724NHdu+Y3
	GvaarLgHWTKMazM3VJVxI8nkad+PRuD+JAJ1vCPOyjZwZb2gmedGYbrjw0CxkTTB6yyhn0AzEak
	zfSq8vRUM7Km7SWXz8zOY0uT0VbNWdhvSfp16u1SYidIeS/2CmlX0BrrEK4SASmSajjmD0pZyoc
	c24gP0NCcciZ/jYJLB6B7PR1vI3R6g==
X-Received: by 2002:a05:6820:16a1:b0:69d:9132:566c with SMTP id
 006d021491bc7-69e6d3850b5mr5320851eaf.13.1780896503164; Sun, 07 Jun 2026
 22:28:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zitong Zhao <zitongzhaooo@gmail.com>
Date: Mon, 8 Jun 2026 13:28:17 +0800
X-Gm-Features: AVVi8CeTdh9nKNC9Rjxo42hkd8Bz9am3PVHARf_PYwqxQQB7SsQc7Gte861HNjw
Message-ID: <CALaig7Pf++Hqn_c4hEa8zXHKkJpbmfSk=Bet_W574o7eBKF6Rw@mail.gmail.com>
Subject: [mt76][mt7921] Question about host-visible deterministic TX
 scheduling / TX completion timestamps
To: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	shayne.chen@mediatek.com, sean.wang@mediatek.com, deren.wu@mediatek.com
Content-Type: text/plain; charset="UTF-8"

Hi mt76 maintainers,

Resending as plain text because the previous HTML mail was rejected by
linux-mediatek.

We are working on a deterministic Wi-Fi TDMA research prototype using
MT7921/MT7922 with the mt76/mt7921e driver.

We would like to understand whether the MT7921/MT7922
hardware/firmware exposes any supported host-visible primitive for:

1. TSF-scheduled TX or hardware-timed queue release
2. firmware TX queue admission / queue pause-resume
3. reliable per-packet firmware/PHY TX completion timestamps
4. TWT service-period control usable for deterministic UL/DL scheduling

From the public mt76 driver and our local diagnostics, we currently observe:

- RX MACTIME is available and useful for RX-side timestamping.
- TXS can be forced for diagnostics, but coverage is partial/asymmetric.
- WTBL_QUERY returns only a short status-like response in our setup.
- TWT_AGRT_UPDATE returns ACK/status, but we have not found evidence
that it provides host-controllable deterministic queue admission.
- We did not find an exposed TSF-scheduled TX path in mt7921e.

Could you confirm whether this hardware/firmware stack supports any
host-visible deterministic TX scheduling or reliable per-packet TX
completion timestamp interface?

If this is not available in the public mt76 driver, is it a firmware
limitation, or is there a documented MediaTek interface available
through another channel?

Hardware/firmware in our setup:
- AP side: MT7961/MT7921e path
- STA side: MT7922/RZ616-family, mt7921e path
- Driver base: mt76/mt7921e with local research diagnostics

We do not need confidential details on the public mailing list. A
yes/no answer about whether such primitives exist would already be
very helpful. If this requires MediaTek confidential documentation or
an NDA channel, could you point us to the right contact/process?

Thanks,
Zitong Zhao
Cyber Physical System Lab from Shanghai Jiao Tong University
