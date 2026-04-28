Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FE933031C;
	Tue, 28 Apr 2026 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393800; cv=none; b=kn3CO0Vct38TFjQr28Ku32ld0ENLq0+m4TQ9fJCtMJisF+HGahCTNDgz5Tgf+bJHBx0mSEM0j53kaltoPATK5IRzml6y3iIkVxqWJ/iSCguURGTMBYcikvFDJBd/M4/RTPm37yGDr/rL8N6KgZ2/FglePH+PPqwwcR8aAcciB1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393800; c=relaxed/simple;
	bh=HiyNk8Hwo3GZNgCXjXwqJh6ftb4UrgqPS7ffEG6uOxQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Gy67bd9Qg1atfcLWcHene791nPIKnSD1L/cHIZWL3bZIq3g++IM0zZK95IXFGM0fIEBFKfUl5FM0LCzEkS9PIQvd4Qr1PY/zvG7fUMfed+4dO8rT2BxXvInyKjQo7zvbemCWqewa4t0gszMWNUHhvx3mm41FW2JXKA6HJrhOpiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/3AnJqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/3AnJqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA81BC2BCAF;
	Tue, 28 Apr 2026 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777393799;
	bh=HiyNk8Hwo3GZNgCXjXwqJh6ftb4UrgqPS7ffEG6uOxQ=;
	h=From:To:Cc:Subject:Date:From;
	b=l/3AnJqkQsZ+QtYY4ItS2XRPnSPsV51wckgmjJbCvpOlkOUEiOqR9rSzO/YFrVHYD
	 RVJAcZhxjsKDd059IItV0ovauw+3bWsHU3KvndQagx9c7SqKku9Z3LZHqDO6h6Xj9A
	 noFA3jeYviVAsyBpYOsAB44g2HZMMAlsGnMcbvgaa/rNZ5XFu0BJTZYyNmD40mTMTm
	 BmcvLwiApz870Oke4Emg6tMkGBw7XB5s/Gdu/Ewr63UXp+6EINYLCnUKRWCa2R3Gk5
	 2xEqcv4ae/xOqq2Sfeoq0j2/MT8dISdKA+E6gddc8kqujvUoBXnNZw/mPQTiYoM9an
	 Zza4KCl2sVoQA==
From: Arnd Bergmann <arnd@kernel.org>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Sumanth Gavini <sumanth.gavini@yahoo.com>,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath10k: drop gpio_led reference
Date: Tue, 28 Apr 2026 18:29:49 +0200
Message-Id: <20260428162955.614739-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The driver uses a 'struct gpio_led' internally, but does not actually interact
with the gpio_led driver, in particular it does not actually use gpiolib here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/core.h | 1 -
 drivers/net/wireless/ath/ath10k/leds.c | 8 +-------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 73a9db302245..dfee432615eb 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1269,7 +1269,6 @@ struct ath10k {
 	} testmode;
 
 	struct {
-		struct gpio_led wifi_led;
 		struct led_classdev cdev;
 		char label[48];
 		u32 gpio_state_pin;
diff --git a/drivers/net/wireless/ath/ath10k/leds.c b/drivers/net/wireless/ath/ath10k/leds.c
index 3a6c8111e7c6..a3961e7760a5 100644
--- a/drivers/net/wireless/ath/ath10k/leds.c
+++ b/drivers/net/wireless/ath/ath10k/leds.c
@@ -19,15 +19,13 @@ static int ath10k_leds_set_brightness_blocking(struct led_classdev *led_cdev,
 {
 	struct ath10k *ar = container_of(led_cdev, struct ath10k,
 					 leds.cdev);
-	struct gpio_led *led = &ar->leds.wifi_led;
 
 	mutex_lock(&ar->conf_mutex);
 
 	if (ar->state != ATH10K_STATE_ON)
 		goto out;
 
-	ar->leds.gpio_state_pin = (brightness != LED_OFF) ^ led->active_low;
-	ath10k_wmi_gpio_output(ar, ar->hw_params.led_pin, ar->leds.gpio_state_pin);
+	ath10k_wmi_gpio_output(ar, ar->hw_params.led_pin, brightness == LED_OFF);
 
 out:
 	mutex_unlock(&ar->conf_mutex);
@@ -63,13 +61,9 @@ int ath10k_leds_register(struct ath10k *ar)
 
 	snprintf(ar->leds.label, sizeof(ar->leds.label), "ath10k-%s",
 		 wiphy_name(ar->hw->wiphy));
-	ar->leds.wifi_led.active_low = 1;
-	ar->leds.wifi_led.name = ar->leds.label;
-	ar->leds.wifi_led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
 
 	ar->leds.cdev.name = ar->leds.label;
 	ar->leds.cdev.brightness_set_blocking = ath10k_leds_set_brightness_blocking;
-	ar->leds.cdev.default_trigger = ar->leds.wifi_led.default_trigger;
 
 	ret = led_classdev_register(wiphy_dev(ar->hw->wiphy), &ar->leds.cdev);
 	if (ret)
-- 
2.39.5

