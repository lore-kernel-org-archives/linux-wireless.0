Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197168;
	b=smh3geIyWIf4IpR8VcdjJ66TvE4DzUc0NwDDF4l/rjK/df5V1+dUUTyNGeaQIQkZ7aHg
	 PUSzkIqajSC8FFLrRN60uOoxVdJ/V/tXJgp6gHJJj9KJJcgJuRYedMJMlvbdd5w9mbX4X
	 S6JVeJoVDY0v7V8p7QBtSUaAqm+2xsN7RNk8Y6qazjEQpf5w3zWSTwOMiqaqbO+YZlku8
	 5dY97Mo6QnbEC6EKCvd6475eKAbWIXZ3BAQNpiw7ROGP3Ohy+7+l6MpU6x5oxl0k/P4+N
	 253B+SRzEF4gGO/s5EjR0s0jBPKt1U54IvmCEOhgS3S1iwhZlC5+SOfy/eAsKgJ5LWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197168;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wfVFawx1WEgioRP93JnhxZQvMdlK3X24yVnDut49gjc=;
	b=wav9TUtDraud0s6hkSXdvzL3vY1kQq8DNJDmuC1pKwfdBy/O0wfxLH0ir1P1wg6v9AXJ
	 HQAzXuogT8t9JiiEWYoYXSZEU+jMImSgM2JYOicaIVtJlJIe1EkhR5GZWVoKoUq7Fm/d3
	 INBRpBXcAkaCHrRBRCcq9EznZzAUts4MlHO4/EKXU53HIuGrYDEDULU9KmR66+B3snOT2
	 be83h7TMnwBYAXgH4DSVfYrVTFUQwGNMxi/l082cISNhUWpbPrMmxh6niBblKfW17ek8o
	 nYDM0rmz4jpoIrUhe5M8DfUi9sxCbWXTWFQJKSjoN2K79FEuG3MMYbBy8lM8O2KBgpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P1XA+VnQ;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFA6606A33E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:19:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DFA6606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P1XA+VnQ
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-886e61fa30fso510653b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197167; x=1793801967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wfVFawx1WEgioRP93JnhxZQvMdlK3X24yVnDut49gjc=;
        b=P1XA+VnQPQCdb8cQtqtSQOiFR33H3BylLmzvaDP5xvfAoAO+KLEchzy0HUroGMJ9Yf
         pLiTWLeBzGjv60XR0m8sHhiyZhBhnKcQFAwRP+a/UoOGkFHAzOvzxjmV8ZmVxrqb9BFe
         UomSN2nAOriW2X8FvIegSKAg4hCpzjSG0l4pfmHg2R3tdvA8k8FrSlegrlsGYDI9pISc
         RQiJq9VJ4S3ZH3JDGBI7i1S4x/1BXncfu0OaBN7EykMMbBBB6sbtzUSy+GFPNO0ZcFcj
         O4iK9rkiCOpaj3zAQ87CPSqrVOoHRY2+REuScBVAWsgzbiNKjFw5zUQLw9YM/epf+8WD
         y1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197167; x=1793801967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wfVFawx1WEgioRP93JnhxZQvMdlK3X24yVnDut49gjc=;
        b=MEUzmKdlI0iqJYbhgNJu9NZOFZWR60uXuLbKQMLXToXJYUmcFrugThzcmtTAd0yIFC
         U+1EG61qgZTx4OQ+cX3FmlTLmZpc5pb1VHeYpBE1iDZk3Lc49UVcTEEGZKB/pNBonrEL
         w0Hc3TGnKgfp4mnnv1cEMMw/YL3hwjr1HOID425pP90jfwdA82YCLUC9BVZ7RB0wtYXB
         lTjpRFJmqs0YexPkTBOBs020kBoK2c9+El1kkR8x1XhdXL7Mdxc/iPAkZO+QB87vtbqM
         Xe6YXj6S6FDvAGhqvewoZhOVB95bOZFs8bIGVLl5svQevV13EvFEdfvbBlqqbQSSCebb
         D0aw==
X-Forwarded-Encrypted: i=1; AKwUvBxJWlA0AanNDlMhtIzulEx70I6rnw6mHUu9CrhXUWNjr8SHjjULeQ5//VPHBRevo5TUkxOq1QtkJPW8/9Vsjw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKlkm21vh6GYP2rgMqK9ajECb8hfST4mrKPn3ksHG3nQznf9Hlu
	Z1teUI38Vc9b45BUiW2AFD03ZRXGsqwbLLVdPEp0m1jJgePvpxuQkLo/
X-Gm-Gg: AYBFou0CU3yMdMeXno5zZJgfrLCdb4nqZSzqUCXO23SsrgcTkGU4opgkXvIpjoueFx5
	RbSya+ATx4LchlqKBfZKHtp7GWTn+ZNDcKRyZYKQQbmupgZTL54LVakZGOT7st8hbDqtGq0VsN5
	UuXKzBu967HrNDf36Q/d9p88DTJ+kXpm32deH1IM+uaBJWe1WaqkoQmQEV5d36TX6/k++wMIRcN
	flyJeeO5s0ykLxwOdd7Tvt22+2mCj1djhoOo8SZk2qOWl630ydTC43xvJBf1XtioCMkX2Op3Rur
	5bxpLDvXtzIIzGjfdvdzgSskXjctKi1Hhf75uLS5pdO6vz5zm8XIuSy5ELCaMIuGeD0Y2eUOBgI
	ke2s7zCOpahW9NqRTCELb9SoQRc5S64rAfX63HBCBbtL4Gs0dqKvjFZGtjHZri/tTK+fUmhOijm
	REsLKFI/y6EzbXjchWIcA1r2SL6bnqj3VdOus11FpVkKcaqJ42yGlvOxHdQQEleHMbKOmxXGkM7
	K1+kPxhME6rcAJJYy9ZfGgz/kPWZPcVHl2pzJkdYJMEUUGSaifEsdwWTzrkgSfsmsiGLg3m28/s
	ESn+vKTH6NvmVJ1O8WCss82YvJNGLLYNapyfOQxRACe748yYT1xNQX3gmjYhrY6tKqpB
X-Received: by 2002:a05:6a21:8217:b0:3e2:7030:9080 with SMTP id adf61e73a8af0-3e9023aaec6mr2697680637.47.1793197166415;
        Wed, 28 Oct 2026 07:19:26 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a6cf9489sm1300647b3a.39.2026.10.28.07.19.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:19:26 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: neo_jou <neo_jou@realtek.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Kalle Valo <kvalo@kernel.org>,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: rtw88: usb: stop RX work before unregistering hardware
Date: Wed, 28 Oct 2026 22:19:04 +0800
Message-ID: <20261028141904.8707-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Disconnecting an rtw88 USB device while RX traffic is active can leave
the RX worker running after mac80211 hardware is unregistered. A firmware
event can then queue C2H work onto a destroyed workqueue.

rtw_usb_disconnect() kills active RX URBs and unregisters the hardware
without disabling rx_urb_work or canceling rx_work. The resubmission work
can restart a killed URB, while an in-flight RX worker can keep processing
packets during teardown.

Disable rx_urb_work before killing the active RX URBs, then cancel
rx_work synchronously before unregistering the hardware.

LLM assistance was used to find the bug and review.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Fixes: 3e3aa566dd18 ("wifi: rtw88: usb: Preallocate and reuse the RX skbs")
Cc: stable@vger.kernel.org # needs adjustments for <= 6.13
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed on the rtw
tree. Not reproduced; rtw88 USB hardware was unavailable.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.
Kernels before 6.14 have no rx_urb_work, and 6.6 also lacks
disable_work_sync(). There, killing the URBs already stops resubmission,
so the backport only needs cancel_work_sync(&rtwusb->rx_work) after
rtw_usb_cancel_rx_bufs().

 drivers/net/wireless/realtek/rtw88/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 64e1c3420e0a..1d2759eb96bf 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -1370,7 +1370,10 @@ void rtw_usb_disconnect(struct usb_interface *intf)
 	rtwdev = hw->priv;
 	rtwusb = rtw_get_usb_priv(rtwdev);
 
+	/* Stop deferred resubmission before killing the active RX URBs. */
+	disable_work_sync(&rtwusb->rx_urb_work);
 	rtw_usb_cancel_rx_bufs(rtwusb);
+	cancel_work_sync(&rtwusb->rx_work);
 
 	rtw_unregister_hw(rtwdev, hw);
 	rtw_usb_deinit_tx(rtwdev);

base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
-- 
2.56.0

