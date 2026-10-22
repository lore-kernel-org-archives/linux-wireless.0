Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792635827;
	b=a8q89E/Cf5gC9vXxmtlbWRzwDkde++TnJwulGk5Z8n6wfp4yd5DPnuvPB9nYS3vMKUC/
	 KyVHBUs/LVfNK53d7kX0oaVCQMdRHbOOp2TrH/AwJvLdMIRn88rM4etRSm8NTdObw3nxN
	 S2Clia1/rARRInFhmgyIkUdzmfYoZjWYP1vg4TrmvDsgBZ5dO6hONaouLyKx6r1K/5Lok
	 lUyLKlR7QkZnvVPCthtWLD94qcsehbrXFA3vdghB78HWq34nOo5zDXCrBj8IPzxwOQI70
	 swIqf2kZ9E+pgL2CzxSG6BMQi0jSIf3V3GUwbh9hJUh2n6D6yoSNVoEvzEJwWtgiWsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792635827;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=BL3IHRvJ9+gWwxp3abRrWJFWvxWrWClVc4DpkC67oPM=;
	b=2das2u7cf4mFcKBD/a9C+raGa+72bgM4YZ7wq1NxvQM6w+7c7pJZj1jlTrHnXOc8zTt4
	 gPts0dDS1pZMHT+Ft7eN7uvnLxDVKSEDvl9enucwkSg1ZZd62GeHTf/ML83qBoCpRNrzz
	 gjpXy62Y7yrcG5l/MUMu0Pbb08rRngIs12rD4iDzEvyBx8EP7jh8UxSaPcTVYS+7UQp6y
	 1Q86xmOmTTIIG6kGZZU/W8BiLzLhodCQLV2IDLqGq9aZRwMEI6KyoVX6nxJfMcH+yyzZP
	 twFo9EWONmxANWf2b/BbYYlAidsDi+rv6X3rQCxekYutwDrQNZnKWCXbAojvfO0fILg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jDW3F65f;
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D649606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:23:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D649606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jDW3F65f
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so209863a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 19:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792635826; x=1793240626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BL3IHRvJ9+gWwxp3abRrWJFWvxWrWClVc4DpkC67oPM=;
        b=jDW3F65fISoaz7+amfP89O1a+TNphBoF8sXcXEbXqNHiXy05gjaPxmmP9qspk2t3Fe
         JuQCtSOIZh6fLy5lcF9Kter3YdL6FRhO/CO4tzPoK/DzJ/956HE5p99gDAJEvuqWjK9I
         6y27cGBiAxdHopYyhntNX6nkFY8E0t5VOpEYqWJBvTiIp/u//Id8fFNHFT2Ud2wIe6oZ
         ZV0fDoNkiPdJMqbJSJGGtEoBjSXRNT+3hxGTQXsApCGeJRL3YabEWqheiTZJC2XqwOoQ
         4hWOsmEdjS7+ffdURfEqu+v5M4I1nSwbx3uygcurNxU4OB9C34H1vX1lmI+DdqpFOsCj
         vQ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792635826; x=1793240626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BL3IHRvJ9+gWwxp3abRrWJFWvxWrWClVc4DpkC67oPM=;
        b=T1hpcOwaMVxrlLfdWe3kcnn16oOIjZjn5tBBG6y/aVgIilMdNQSMXcBrRPBPDW6C84
         JBz1Ha7Gw6Jc/TPzr+bGiIeEgVCoPZXEHNPsY1COqubeVaHY+RaK74b/kSLK24I84nLY
         lb10s0xUA5EnvQ2JEBiAvDPrwdeEjV1w7z+5hQ0nsY/k4MITqEqcwDopLYtargUoMrzm
         Be9EwEktxXrpOaFeHu5ePc/HLJp9GY+VOlfnwSPQ8HQVNscJcy91wG3JPMYvL8CAoKUN
         h0MBw2iTZb/OBRmpkGp+uKPTwwa4XRhtuK24qGLdxShq2De0HC6iGBnroahvToxogYuV
         7/Vw==
X-Gm-Message-State: AFq9FYJLsoFDQaF210WjQrpAW6kuvpNTNG+DijnuwrNuf9ZM4XFq18e3
	KuYEbWhb3UQh7BVvdouLaxl6KZyvLGKSzq9JB8ju4dd392HvJu/eSnByw/TlA1ZP
X-Gm-Gg: AYBFou0lWU2BpyVnA/WuEHwf8wxdfGQPeSpvzBSDtV4h9DsJA31cBoUb+zvEADHX44f
	ihFH1otQqZscpe4Nb6+jHxs0aBt1qmszaLQb7kg4lnvY1ueVdLPv3uCPMzxxgUXyFzR0/+pwoFq
	BzW4WEupbw/7Bviqy58pBScYSy35yk/LR7Pk5lRP3/tCHOtRLtQY4qQ2GPTh/0m5XjqVHy6kQuO
	QQARVojvYHpnHXXpZAKOiIKcDMr+IVl+/VaDcKRhZhvX4PiUndhHwATe6bg6jmGg6uxs5BGii9C
	2RU8LQsUtTo2pLVoc40XwHRk3A9yRmGrzpBi6/fvrIVcHlF6NsElh+wExF9b1TTzR7IkYOfkOpm
	wS8994d4P8pywYSwQXhdHSD5idqzK6dsAzKeWnhkXsZ7B/w1+u3StagaKZcyRUgJ2rGF5Rd77wl
	43wPIilMcptK2HhGs8jbpS73IGw4vXaqs22SL9ICotRj7GwtRtElCwnJH/9Pg5Ecyo2a4TKumDy
	9vuq1lVB9bY2iA1mSb2aoC6m7co2KBmq2klYbjDawJluHsPCQBuxcDD6D4g87A2Xwldb/vt2gej
	UAJaVX/kaBkZzisLY/qj7OTettz1rwRz5XlUQ6CpHYpzJR1R+TMR8X7pnScNu9DBfqQwkC2xvdy
	yQAk3vVq9IbSI6QooZLUiy3wZ9ZYV
X-Received: by 2002:a17:90b:4c85:b0:3a2:bb9f:f87d with SMTP id 98e67ed59e1d1-3ada6c8842emr643889a91.21.1792635825946;
        Wed, 21 Oct 2026 19:23:45 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e36])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4954979sm1783949a91.17.2026.10.21.19.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:23:45 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	=?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?= <giedrius.statkevicius@gmail.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM:Keyword:(devm_)?gpio_(request|free|direction|get|set))
Subject: [PATCH ath-next] wifi: ath9k: release the LED GPIO after ath9k_stop()
Date: Wed, 21 Oct 2026 19:23:43 -0700
Message-ID: <20261022022343.1409432-1-rosenp@gmail.com>
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

ath9k_deinit_device() frees the LED pin in ath_deinit_leds() before it
unregisters the hw. ath9k_stop() then switches the LED pin back to an
input with ath9k_hw_gpio_request_in(). For a SoC GPIO outside of the
WMAC, ath9k_hw_gpio_request() takes a new descriptor through
gpiod_get_index() at that point, and nothing releases it again. The
next probe fails with "request GPIO12 failed:-16" and every LED update
hits the WARN_ON() in ath9k_hw_set_gpio(). That request also runs
under sc->sc_pcu_lock, while gpiod_get_index() and
gpiod_set_consumer_name() may sleep.

Free the LED pin after ieee80211_unregister_hw() instead. This also
frees the pin when the LED class device could not be registered,
which leaked it before.

Seen on a TP-Link Archer C7 v2 (QCA9558, LED on SoC GPIO 12) when
reloading ath9k.

Fixes: e34f2ff40e03 ("ath9k: bring back direction setting in ath9k_{start_stop}")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 2 --
 drivers/net/wireless/ath/ath9k/init.c | 5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 2dbc7efdd637..d525d8ef9369 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -67,8 +67,6 @@ void ath_deinit_leds(struct ath_softc *sc)
 
 	ath_led_brightness(&sc->led_cdev, LED_OFF);
 	led_classdev_unregister(&sc->led_cdev);
-
-	ath9k_hw_gpio_free(sc->sc_ah, sc->sc_ah->led_pin);
 }
 
 void ath_init_leds(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a7a11781d83d..f6aa2ec1683c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -1128,6 +1128,11 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	ath9k_deinit_debug(sc);
 	ath9k_deinit_wow(hw);
 	ieee80211_unregister_hw(hw);
+
+	/* release the LED pin only after ath9k_stop() has configured it */
+	if (sc->sc_ah->led_pin >= 0)
+		ath9k_hw_gpio_free(sc->sc_ah, sc->sc_ah->led_pin);
+
 	ath_rx_cleanup(sc);
 	ath9k_deinit_softc(sc);
 }
-- 
2.56.0

