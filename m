Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793158861;
	b=M62P5tECoc/MZUGqDvTYebWLAUonJjnPpGstLZwpYSx2yMbgL7NrNfh2WLfFBvFU++8M
	 wWoiWPMl2lHE9K0c7ot9BxWYOhoW+92GD9/BEyaEIbGyf8YQXcERPdPDE5prwAHqfhUp0
	 qgmL1YOUfhe/YaLwwPgIHtbLPF87J3oKY41DkX00CF96T8b7g1Hbs0mjPjoGSxsvHuoWw
	 idDLFixIV76U5FcmUFTEFz+gLq19sMJ1+5yrWPOJOfdA+97f5/LFntlV1HRlhDPD04leR
	 qWkJyI7l2wzzXyB0BgO7x+iogOlwrHIOMoC3JGAypOuEYt8qU2g+GMm5Pm18M9+6srg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793158861;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=DFz26Eku7ZAlqmVMiKR0VvxuKqR6CneczdW4fGPibk8=;
	b=s5+jbEhZ/QN4clKCUbWqrXX3V1pWtJBTtf8By3cEuRBZVGGJycUniL8HWVqAufU7UbmA
	 v2VOzVhcq7wxyixZ7kIvQoke+EshCcpsYJ2cEahbgBgE77aa8xdjDoXA9A6RVThyNkolg
	 H4064DXOrqweGhLwrC8+uH63a5DO10TpKkW0LUO7MmJAZblsAzYxR5Xc3dfaOekCW4LAA
	 BuNQ+VnBomXnjvjRGOHdF4xJU3lWS6h3ufKRYbdtd4hQC68RK+/kznhElMSRbNeOgAJj6
	 qb6LmRSxIhSerdlj/JyKh3wzTlk+luFK2VO/iMws0r4axamnvVAsswbrSviDRkGHW7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KI1fFyCr;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7791606A31E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 03:41:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7791606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KI1fFyCr
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a06210b29fso270044b3a.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 20:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793158860; x=1793763660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DFz26Eku7ZAlqmVMiKR0VvxuKqR6CneczdW4fGPibk8=;
        b=KI1fFyCrQ6/xarfMSgFToJby/ICKLKjhUdNrft0pkdzl/Fp/VCteRjr7fHn+bqLLPh
         kBFGBrlTdVT5K/lk9cGG9YnGbToV76MKL3wl85LvLnAair9FceeTHffe6gJR+3+pY2xt
         YaHZPVdlyrV0Zv3EPGNj88rHvBzGkt+lkzF39H0GQpl195JVPBLORJHhGlY/Z6PTrp6D
         XHwI5PXECBihqVS2w7To/hffRaMvR+GsiOsGvPldGwoxY+PGv5vrHzpJb3sicT4Zjdkh
         ro8Okf6LIzVAH8noerCpRrlJ3yPuwWUPi+uGzgF3J78EbALrCRmVGVYdDkv7MrpYSAyO
         c3kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793158860; x=1793763660;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DFz26Eku7ZAlqmVMiKR0VvxuKqR6CneczdW4fGPibk8=;
        b=I67yCAOnRPYCvvjZ2Xl5fU9XabilobtcTysGTqniIxN6egTO0w88xy6LgZDyTStxrv
         W6LEu6es+zX555vuxA7d+sQ0M7e8C8pYJKvL7ZO4z/rsedxvjQOMIfa0xkISFfcg3vbL
         WlEv8RrAzfhhKUXsax2b1JOyiWiIykYNWqxuh+G26ZV+iOapt8AOh2gn4xPSSf4kD4OB
         gFvajnxXpHN6Eso/pCZlZCFNqjLgXBM2QdBvIoIbyqyT57yEHjooF+2HSBXQOmSXM5yI
         MXo2YKbYqwyiI5TqqdGtzLftUOCZgor3CVwFQ4PIhwQ1PZl1UCdygJRCM6HXWc0IJ3lv
         yk3w==
X-Gm-Message-State: AFq9FYLSZsYQssD9jL5aHAz4IugYUFSC0GR7YwvlJww8UKkWInBEMYBj
	ydOZqrv02YDzwbkWd8O8y627ljzK9/rn83J6Lp5op/ABYBFIf9pHDP8ZVSpqpA==
X-Gm-Gg: AYBFou0JjminvU5wi3gYf2HXF23T/cE9UfIsyVsAR3q0OlcIB2bVII/q/bJfdSsFy8C
	XQ6+bMrb4bLBUiCDgwpBnauQyhOlLQHxhcVp/WhMBmYNh9T9r//JJVwCubo6HZVf3GEflnu2A3u
	s7mZ8471xnT5lqBoSrUFPuMr59/f5hffj7op46tBwI8YpfO4LLZ25wqR9gvukQvsdE6mLgj9TfE
	Rv4a0JEqA7FvGhsKv0wZsi2yo7m4dfmCVzEUYpnEDyUPBHT6H6HJMcl+hegtk89JKu8AlhDae8W
	HOmQ9FhqOktaep8cQ0ebdIAMYfmnT/SyaC/86LIImr+s4m+YxQkfnPmugcM7xrKMjYCCX9uut3H
	Cgr5rGu9r6gOssclLXjgW4Gqdt7u26PgF1d2bPOQTYZLL2Zi+0IAS7T+45gSW/wpyKZihFbEq0J
	Mk9WZIGCyo2U3O/w7oORpiVF9AGausk1F9A4FAh9F1HWxMN4i2wUUJJJPUVgGPWWz4JtgS2QjvD
	6vax8p0jlSChh3EBBYzfRilwcHIS52K3PTCJF5xkMOTkW0Oefu1q47mEPGc9Eh/DubkNNtYKUCj
	CJvkcTIiPVfCVmnMadYnKnFEBju68ecDA1KL0eiFVgNjmNNDgy5vBNzJaNLPg26f0Q6l94Q1re1
	IwUJf026I0LRwbeixzb96D+VEtplieJj8h47Sr+hTs71+CPjpysiLNeJIDH/o4El2dc2MDZVkWM
	t3kw==
X-Received: by 2002:a05:6a00:ab0d:b0:8a0:7dc4:95c0 with SMTP id d2e1a72fcca58-8a6e6b175a6mr1061341b3a.15.1793158860024;
        Tue, 27 Oct 2026 20:41:00 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a73bf7efsm596875b3a.52.2026.10.27.20.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:40:59 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	=?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?= <giedrius.statkevicius@gmail.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM:Keyword:(devm_)?gpio_(request|free|direction|get|set))
Subject: [PATCH ath-next v2] wifi: ath9k: don't re-request the LED GPIO in ath9k_stop()
Date: Tue, 27 Oct 2026 20:40:57 -0700
Message-ID: <20261028034057.114021-1-rosenp@gmail.com>
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

The input direction was only added for symmetry with ath9k_start(); the
suspend/resume fix that brought it back only needed the output side.
On WMAC pins it also undoes the "LED off" level written just before it.
Drop it, so the pin simply stays an output driven to the off level.

ath9k_stop() still writes the LED pin, so free the pin after
ieee80211_unregister_hw() instead of in ath_deinit_leds(); otherwise
that write hits the WARN_ON() in ath9k_hw_set_gpio() on SoC GPIOs. This
also frees the pin when the LED class device could not be registered,
which leaked it before.

Seen on a TP-Link Archer C7 v2 (QCA9558, LED on SoC GPIO 12) when
reloading ath9k.

Fixes: e34f2ff40e03 ("ath9k: bring back direction setting in ath9k_{start_stop}")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: remove ath9k_hw_gpio_free in ath_deinit_leds
 drivers/net/wireless/ath/ath9k/gpio.c | 2 --
 drivers/net/wireless/ath/ath9k/init.c | 5 +++++
 drivers/net/wireless/ath/ath9k/main.c | 4 +---
 3 files changed, 6 insertions(+), 5 deletions(-)

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
index a7a11781d83d..d35460e352d9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -1128,6 +1128,11 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	ath9k_deinit_debug(sc);
 	ath9k_deinit_wow(hw);
 	ieee80211_unregister_hw(hw);
+
+	/* ath9k_stop() still drives the LED pin, so release it only now */
+	if (sc->sc_ah->led_pin >= 0)
+		ath9k_hw_gpio_free(sc->sc_ah, sc->sc_ah->led_pin);
+
 	ath_rx_cleanup(sc);
 	ath9k_deinit_softc(sc);
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 740a6fc7b067..07797cc89ee0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -942,11 +942,9 @@ static void ath9k_stop(struct ieee80211_hw *hw, bool suspend)
 
 	spin_lock_bh(&sc->sc_pcu_lock);
 
-	if (ah->led_pin >= 0) {
+	if (ah->led_pin >= 0)
 		ath9k_hw_set_gpio(ah, ah->led_pin,
 				  (ah->config.led_active_high) ? 0 : 1);
-		ath9k_hw_gpio_request_in(ah, ah->led_pin, NULL);
-	}
 
 	ath_prepare_reset(sc);
 
-- 
2.56.0

