Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0981C36607D
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 04:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790829945; cv=none; b=lvpYZz/rF8DJut18UJCU7XkMPhMB3wOVbRyydMf2vyPkApqm6HnR61NQVs2pQP1ta5Ec46+npG31wP7/YBpK8Jkuqqu+8jPOm/VOytTrBnjsmU1KQO3a7JzEZEupooDB+uGT29SZnuYIu8+NQB4XZ6DHEA6dgV8RlAIsT6O1PUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790829945; c=relaxed/simple;
	bh=eEl8QR+rB9IOMQDWRHcUt7vIZSR3LbsxWeksxBhbqT4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=RWK+Es3kV1DIaLNwONoVLF8CnYFhb0RrP8A3HF1YChkRcjY3MiBsltU5jLGLUEO/ewNpn0J+rsRhF1tb34MM33PyNq7S3Sqt7TrApBZAwqlBHsdqTz21aikepsp9bL/cvYOo6Fru7xLyQSvnyBrNI3v10Pp7gIEH5n+aVcd7Ako=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PKwdPYAl; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PKwdPYAl"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34c0b552ccfso1249153eec.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 21:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829940; x=1791434740; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dXeIZLOIAX5LEZkoUbZIMdBzX/lThU3KbCUVJA49llg=;
        b=PKwdPYAlXPiSlFk20xReaHE3QR43JnVDuiftO1UPVb39LbVHRXKPuQpT4rA1RLzVrb
         v/1DyKyheNKvN8rKIXiwmp0XgcoM2rR3QxFWBk8vgxkoD32iSAzfIQUu625kpZZl8JI5
         Som3Na6DFFQ0QdooXQwvqy8wCoWLvOU3v0RZyhBDFnPKGgglkQ/k2AtUERgDE3Ph8q+h
         YqZb9Upon88FeNvw1Va+EutyYjIahjd5QqukSvTETYDWR4NNDtv10V7V9lVVtFqlJ9hs
         jgpSEMLtx7NWwFaCdHhO5IfdiTsiHM5+rdRX5Y6vmkggwCNzjHC2AJXZce2wQE0mPxvO
         8mXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829940; x=1791434740;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dXeIZLOIAX5LEZkoUbZIMdBzX/lThU3KbCUVJA49llg=;
        b=QqeMa9AAgSM+AeoVBGnof6KfqpyYF5Sav8i6CC/mGorqfmQ72snhVG4ISxW4BjnBYE
         CB2Dq/OWZAP7ganechJVVxdW6erc5noMg61U8z9dVXR0nsvim4HUsGeAqF9a4MCaboAJ
         Z+bNr2FAaBUmkXFUTPlBP70hqUgnFSWBW5NUiz5AJrJbsbSvjSZKGm5psp8x8ne3E2Fv
         syzBGBzAXzP0PEd1XlkMMyY6EtoDxmgt7yEm0X/owE81ajGOYyIDOQ9AIuyCZAczOWHN
         HceB5JT3jUA3hqxa+5thEKaxG20OxKrDu+30vC9C9RB3T5Trck2jx/RteknDJdE20v+7
         Sm6A==
X-Forwarded-Encrypted: i=1; AKwUvBxBF0DT99WQHrcxJXS5pDVTNtOk0xylN+MKkUbIY56UJjP2ZkE+Scuugm0JvhPD+jijLBIfES4n7yGcaJouoQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ3dX3uqV5IYfYClQPZWF+bLbL/AURNsmJJwmhno0eNq2gwzk1u
	z1tCEiV+lsIbNJ2/aq67g7AFLQAu4cVyEP6+qd6NKp1C/qnW+DDUFVAijaQwR5xl
X-Gm-Gg: AYBFou2IM6zEJAiAXADQ5HCBb5FzlQoRGo0VI2/LMV6BfztHGPj+ZBaiEemxhddlusu
	04sr/F1We6EVuFpV3GoIbYPCOY/xKabZxW9nRkazjoRWI3Mr1AD9VSuCMBcHH2hBZMa/jf+Ioj1
	fak/q2sJmgwYeXl7w8NV1PZuv7peSfiTEYdwxEdAcKg2byUD7Ufhj43FfbFgGDtcEmcyunVmGS0
	B15bDSL8dgqTauWb1cn2nIwihWETv+8sBSI9kYMIQWQ0hMXCMjyq6XL9Ri+hHjWFG2ojQ6r4rQz
	uCu7Dt4Rpho45FWayORZcDepsp4coZKk99tnSf0XwPjRWmheha0SDvqCen5cQor3h/RMZSPj3sw
	m1wwfwumgMdtrCMVthXNQ9gMuIsjO6hBU0ig95I1Pc6AKFGOITRRmEFeJs/B9zrSUO7e4IB6i5k
	Okz/ufO00Mxl+mSrZDsqKVPA0d/EM1mf2dsr8gV6bAnvTgPAfvB3aUlikSWiklxi7E3eTa+NY5u
	zh7DXyMK+zRADsY79pOblqcSQ/NM/y19qBAublk1cAopkbB+tmqWaRGGBYUJNE=
X-Received: by 2002:a05:7300:5552:b0:33b:e3c8:aef4 with SMTP id 5a478bee46e88-34cd6100ce9mr3727853eec.0.1790829939700;
        Wed, 30 Sep 2026 21:45:39 -0700 (PDT)
Received: from dtor-ws.sjc.corp.google.com ([2a00:79e0:2ebe:8:9835:e0ad:476f:74a9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db3e3414asm3891332eec.19.2026.09.30.21.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 21:45:39 -0700 (PDT)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/2] wifi: carl9170: revert broken devres conversions for
 input and hwrng
Date: Wed, 30 Sep 2026 21:45:29 -0700
Message-Id: <20260930-carl9170-reverts-v1-0-7033b5716c14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGnlvWoC/yXMQQqDMBCF4avIrA0ksY2kVxEXSZzqSLEyoyKId
 2+qyw/e+w8QZEKBV3EA40ZC3ynDlAWkIUw9KuqywWrrtK+0SoE/3tRa5TXyIiqmR6yiCybYJ+T
 bzPim/Uo27W1Z44hp+XfgPH/Mq+UMdAAAAA==
X-Change-ID: 20260930-carl9170-reverts-bc4b3b6a1a25
To: Christian Lamparter <chunkeey@googlemail.com>, 
 Kalle Valo <kvalo@kernel.org>
Cc: Christian Lamparter <chunkeey@gmail.com>, 
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-6c14f

Commits 23de0fa0d2a0 ("carl9170: devres-ing hwrng_register usage") and
87ddb2fc29f1 ("carl9170: devres-ing input_allocate_device") converted
the HWRNG and WPS button input device registrations in carl9170 to
devres attached to the parent struct usb_device (&ar->udev->dev) and
removed the explicit unregistration calls from carl9170_unregister().

Because carl9170_register() runs asynchronously from the
request_firmware_nowait() callback after probe has returned, and
carl9170_usb_disconnect() frees struct ar9170 immediately in the
interface disconnect callback before devres_release_all() runs, both the
WPS input device (along with its ar->wps.name and ar->wps.phys strings)
and the embedded struct hwrng remain registered after struct ar9170 has
been freed, leading to use-after-free bugs.

Revert both commits to restore explicit lifecycle management in
carl9170_unregister().

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
Dmitry Torokhov (2):
      wifi: carl9170: Revert "carl9170: devres-ing input_allocate_device"
      wifi: carl9170: Revert "carl9170: devres-ing hwrng_register usage"

 drivers/net/wireless/ath/carl9170/carl9170.h |  1 +
 drivers/net/wireless/ath/carl9170/main.c     | 42 ++++++++++++++++++++++++----
 2 files changed, 38 insertions(+), 5 deletions(-)
---
base-commit: 6474fa070f2b8013b4b87350b775b8c3be6e8aac
change-id: 20260930-carl9170-reverts-bc4b3b6a1a25

Thanks.

-- 
Dmitry

