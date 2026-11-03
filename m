Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699648;
	b=rRMHqfpqsZ7GuK6UcPpvh2BN/VxoVKbhGE0qsBHq2E+B8I3cKGa2dwBeOWOsRnU+Eu2F
	 k9Vp4wYu09MgVsDddt55/0WvEy7PKioVstY1s6WbVSnJMoEHQUTRcs0MsMVtc8oPpr70J
	 5ELYQS9X8DKUKhQkVOew9ssQc3ND0ZzTYRd6srC/XIuFYxU4Rqtgs2B9FOwgvro+XyJyq
	 4JTfgE5h7lzM+3wAff7uQ8q3Sx5IpuAav9TcXAi7PVVqrZBkIJh48j6BxgW0UjVLloysB
	 IFEmoJBMReSU+ba0hn/3gUkoVxwW8CseqNAHoBP5Bm8i67CRWtRSyq9+KBEuB7oCAbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699648;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jbjvMfDuDuXUDR4iPq+3JWGKi44yl0e/poRZehcu4ik=;
	b=AZo2ZI8HkCpDMzC7YleQh/rYtrPuyP8JvnR4pv1IRZMGlOh3Px6lfwlPtwEbn53pdZxO
	 VW0PVPE4oal9yBwmQU5DpYUYVTFeBP2CPg+ghCps+jb8dTh58g0NY8lCFapROiuIzwNVC
	 xXKMczxjPaDnJgWLganIkZzHQyM+aR0/otA/+dcodhjRQ4Zp0GaTXogitrIiQuGzWnsmH
	 IMV2R0jGLxyqyIO1+AmkY59Wtz/RocWeZzQFP5Sa2zJfSyAztAJrhLra0h1aHTktoT34E
	 Wdi1oA7X133j938tdIRAN46DvNyh56vVY4c80lbAHkAA7+f47GuVuc5QfIffT7uU8bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i5tMbKGr;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7572606D834
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7572606D834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i5tMbKGr
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1b1ce85287aso1896921c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793699647; x=1794304447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jbjvMfDuDuXUDR4iPq+3JWGKi44yl0e/poRZehcu4ik=;
        b=i5tMbKGrzSEwpDtMhyx1XFsfkdJmc7ueGLgO8DfQafEtkEb9FgjyW0LaEykrHgkFOM
         CfYF4++LzgQZslFeUnvBJn18OBZtcYkBlpCwsUecQkZzYZzynNL2aZ3Qraid/SM1iCMW
         T3fjUixictRSqCDS7b+3FniKBOEXl0fDfczVkI83rE8B41e/3FtQNXaUI9AWSe9Bl4rY
         OKhsv6nK6NXq+p4s8cZsnR1YxZon1Sgs3EE4NQZ6MaJHsGgXWF2G69zj5iqWnbW3qkgL
         EbJpEesWRaF3yjZoEQtbDwof3ASQMw6FBEe5Xq2fItW/zABiMpFs6346v+8yjon7UbE5
         E6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793699647; x=1794304447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jbjvMfDuDuXUDR4iPq+3JWGKi44yl0e/poRZehcu4ik=;
        b=GlXEvIgvSqduAbcNVXhrcylOhQeOhoIc+syjeE9cxwoy1WztmjGDh9U5nIj0aSty6Y
         ep3UvkxvCj8OV8K+s11IfhK9ggst+tz4NlgwVKZXqjFt7EIMPG0LY3BcAOY6HfAs8aP7
         CCHkdMKvR+nFM4OC700oEwVOvyDdceZgpcH/bKU1vAQGseaNCkYk9q/zZauxGMGHmM0g
         mEnzBra9fWtMamplMknVvRkHck994F4+msnNqhGg6S368XfUBp0/Lbi6SuuZahEEhktn
         P7MdunZaNsZck2TNB4q1p0MICTAkwEsk6fHuc4FVwyW0Ys9qWu0fgRebKAYl7NyAoyLq
         GMFg==
X-Forwarded-Encrypted: i=1; AKwUvBwtwFmjYPRLQDTkOqmgsNdC71RaqlAwk0AL99PxwnDd+txYmsYFf+VOjQjVGm+w+myaotbOiycN2C2UpW+hpw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9PM8j7QMypXV+jWRiuKrJTxVZs7byf3wWTDq9qxKSR/aA94kl0
	/p9QuQZnTGYmwA+N67QZtZ6aGwCH5SPMSCISvbRzDgzgH8nW9yxhDGB3spjPWw==
X-Gm-Gg: AYBFou2zpbD0bHVwII+W68erwFfyO0doZZyaEMuZLt3Og/7q5/6MY/b3RYh9ypQIqlR
	qvND1cVozfYXJgkU02iboip4KCo44hwY5e66sxWHIqpH7HCZgpergKMnhYRBvZdL+ORae7NmBTp
	xjSL7JvWyist+Pr5QxVjhlCNia2jPDyPJs/PWjXuVGeFxmR1W8I6W/W90KxAwIJkvt0yYWiRar1
	X5zgSJLUTviyMnpwBn/gFXULgURyYPx1R9wdiAYD4ov6FTlBe7QStlTjJwm/wwQbmilhwwA+irV
	C6Fx5FlYhTcSQ5xPLBCAC53TFurwG0mMwDhvjlvnzgiKr/pauiffzzEi+5FRie2zIOUbOLBleSA
	BkrRGabFRFHU6REqEQEWX3Zu61/dFHtLwObQTFr9lgsgT76c7/tCPjpQv32SOk+31VIld3IFltO
	kSsnYGn/Q4hwGfghJHcXD1wBdyk9BIhgHA4gQXeQmZVltPMpDo9cROds7WPnlr/2zcEIi5BybfO
	TRCAEKhq5hzqAUCurReIZ5zkjX8U6I4ZHFVaFFi+B+dE1lMX2RRzmu+90U3HJKVom+OiwXmT3Dt
	oQhI5Xt/5nP95OWGKS6zo+BWDBJZUxkuW41WLBwUkFuNe9xhCZ9Kd+D5b9bEcivwzNhjn/Y+Fpb
	PkJ8lzqvf
X-Received: by 2002:a05:7022:4392:b0:1a4:c892:b14f with SMTP id a92af1059eb24-1ac5de53bc8mr31064412c88.29.1793699646717;
        Tue, 03 Nov 2026 01:54:06 -0800 (PST)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:9e8b:5db3:accd:585c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aed79b3dfcsm44178383c88.12.2026.11.03.01.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:54:06 -0800 (PST)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next 0/5] wifi: rtlwifi: rtl8192du fixes and additional support
Date: Tue,  3 Nov 2026 17:52:49 +0800
Message-ID: <20261103095256.949327-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
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

Fixes
- BA sessions started for QoS null frames
- signal of A-MPDU frames without PHY status
- rate mask limited by rssi_level, which is always 0

Implements
- USB RX aggregation

Tested on RTL8192DU 2.4 GHz with iperf3.
Testing on 5 GHz did not show any changes.

   before after
TX 7.0    12.6
RX 28.3   39.1

Ho Jie Feng (5):
  wifi: rtlwifi: rc: start no BA session for QoS null frames
  wifi: rtlwifi: rtl8192d: report no signal for frames without PHY
    status
  wifi: rtlwifi: usb: unify the RX code path
  wifi: rtlwifi: rtl8192du: enable USB RX aggregation
  wifi: rtlwifi: rtl8192d: let the firmware use all rates

 drivers/net/wireless/realtek/rtlwifi/rc.c     |  2 +-
 .../realtek/rtlwifi/rtl8192d/hw_common.c      | 12 ++---
 .../wireless/realtek/rtlwifi/rtl8192d/reg.h   |  4 ++
 .../realtek/rtlwifi/rtl8192d/trx_common.c     |  3 ++
 .../wireless/realtek/rtlwifi/rtl8192du/hw.c   | 18 ++++++-
 .../wireless/realtek/rtlwifi/rtl8192du/sw.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192du/trx.c  | 45 ++++++++++++++++
 .../wireless/realtek/rtlwifi/rtl8192du/trx.h  |  5 ++
 drivers/net/wireless/realtek/rtlwifi/usb.c    | 52 ++-----------------
 9 files changed, 85 insertions(+), 58 deletions(-)


base-commit: dc16902cad9c6b08df9395a510c7be44fbab545d
-- 
2.53.0

