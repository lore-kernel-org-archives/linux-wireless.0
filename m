Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7B92BDC0F
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 19:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786820848; cv=none; b=gVXDmaWyIDtvK8fjCvCP+Fd5/FueCTnVXkonUjXm1FXc187UZO94sT16A34f9GSJc84pCE3CTITZnHQDSDTFwFU6VjHex+EeAOhfbZ//8mnUCt1iAMBDuB9caTnPD1QcoH43n2+e5heO8arWO1vC6V7EM9P5ukcOGqNbQ3ZrPeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786820848; c=relaxed/simple;
	bh=hZ4gYeXG/cpS7vApLblCiJV4ysyLLA3A3BFTbWbGUMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E74TnB5i/VU4XIkdDv9C5fvkAzMrqcmYeETEbECpGBWkL09pc41ICwCm3EgN2Sgs4/vJX/eXp8b7cDHaDTTukEbxhLoVLlNQkSS1+K4fJQeGm/h+3ysaV1ZfpuEZWurl80bbSSim31GytFzLm4jIZBNXRqZtxgEFEQ9/c6yxBgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HoaWilZR; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HoaWilZR"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38f620399a0so1831659a91.2
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 12:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786820847; x=1787425647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q9z+ilZvjkaA4hnn8ASyfNzyt6HCWJVXyXA6SWj/0JA=;
        b=HoaWilZRTkMorUzLfzripBGlAJdfzd/LA//Y07wGqWv6x8AtNH+l1yOvDDirpefEUo
         pUq4yrBQQ+fQINXCXd+HRZep4zYzOQj9XGAPv32HFna98iJ36W2CWQvTk9o9gRU+4z/Y
         zSnvFcD8iN3vWZwqDUbLQ4uo/R/ow79U0HdMadEycQZQs2NksVHGS0IfLaCUkY1b2lgm
         V/jY2xraI1hj3RZho0teAopkVM5Wrm7JEzNKGCHZy65GrIfd/t4ENSlOuPW3jvQAluV/
         v5PNTHCsFq6z03QSfhbQUls4J9PX2BGdVVunubVpul8Kxe06547mEz6+wrUVEQ++cQKz
         x3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786820847; x=1787425647;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q9z+ilZvjkaA4hnn8ASyfNzyt6HCWJVXyXA6SWj/0JA=;
        b=qiE2e2gIUml5Qz1o/5Pyl5NL1NXmwKqeL8LGVbrw3CleGyRlUc+7cMQ3qjeOJYGIjm
         n/kszKVDs7J8m5v6UKYo0iqY5ubTIP68RermCly/BlKfg0qqXT8g/DMjQTatp0NB/xPk
         EfBjVMw3Yw7cLEsOIOcWh7qdGDqYDGUo/aTYJwqkfnCoWR3aSd7kWWLAUf6ZnQEFi/n3
         Hq8UH8qMCus9f50cHVbByvzWViySCw9N0CxWPl6gpSINg4oUpZ/vemnVDftmnF9TWnmc
         NIR7nDqAH26EBoQ1+kzNH0hIZEz7VDpEl+UmdaZT4OKEvzSD6K5mx9WvxNzdIv1wlL9w
         7PUQ==
X-Gm-Message-State: AOJu0YyWsVBrxpdPWqJwHGZC04KV9KwPTxDuhEe+zRTO10nugpGgJuwf
	DCF+s3Zuj7zmj4InBtrKZ7baz1DW/KMWIICy9LM0GL+mRFaDlGAnT6I42MKSHw==
X-Gm-Gg: AR+sD10RXT48GUgLCxIC1IoFxFm3Y5XsUF90PuvnVSfcIP6/guFkh7YBA/ngPQb24C/
	/SWt4KOayOLsZZszlcsvgTGAdjw0w9HKTOykfecJqvTPLiGgFMwrIxVSn9h5k3+yu0wtvwiY/Ty
	cTEcO68ujKFhHmxkNZ2jza/jgC3lZUl8O5CzH8J0IbD31Lwz/nZXmt7AqSmdTiO96vfNg10t4eh
	yc9vDMOWFQSzLRKsAizFT3rRgNDprPnkVnGPoVGOHZ6PITOT8BTd3yZbSuo8aRNoYiKJzqJCvpf
	8rLQKtUCQNWldOpM3Obwc0XgjELMYwURzsRWx4CpZwK4TCGF1QAX87SAZhKtjEWywUsRCJ9prb7
	CT8zM68RPrtJysxCa6t3MF/XQRiGFkTBDwf/uUlx4S/TZzqVjrfQJPPxZBalz0MQqoSxy/dhb0H
	HS6qxCpg59GPaJvWhsOCXY0M7DoUbI+UF4P0lnTr6rutwH0iYpvR437/444Ph1n+BM92k8sQyfp
	rXn4dUudHH9qI7elwKXDkLiaFoW0rpycb5fmKf/MyUiDw+rLcNqUYChUhUL/W9t4rcj8/TzehUY
	rMy0OWYiWp3X+rCTMQtRqSlVfmRLREAJjh8pi0lrDwDLen6SBA==
X-Received: by 2002:a17:90b:4ec6:b0:38d:e658:5959 with SMTP id 98e67ed59e1d1-3933b80052cmr16223928a91.5.1786820846796;
        Sat, 15 Aug 2026 12:07:26 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39339cec8c8sm2971210a91.1.2026.08.15.12.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 12:07:26 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 wireless] mac80211: stop tpt LED trigger timer before freeing trigger
Date: Sat, 15 Aug 2026 12:07:24 -0700
Message-ID: <20260815190724.16943-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The throughput (tpt) LED trigger timer is only stopped in
ieee80211_stop_tpt_led_trig(), which is reached via ieee80211_stop_device()
when the interface is brought down. On a hot unplug, the device is torn down
through ieee80211_unregister_hw() without ever going through
ieee80211_do_stop(), so the timer is never stopped.

ieee80211_led_exit() then frees local->tpt_led_trigger (which embeds the
timer) without cancelling it. The still-armed timer keeps firing and
dereferences the freed tpt_trig, walking local->tpt_led's LED list in
led_trigger_blink() -> led_blink_set_nosleep() on the freed rt2x00 LED class
device, causing a use-after-free page fault in interrupt context.

Call ieee80211_stop_tpt_led_trig() in ieee80211_led_exit(), before
unregistering the trigger and freeing the struct, so the timer is always
stopped and can never run after the trigger/LEDs are torn down.

Fixes: e1e540685437 ("mac80211: add throughput based LED blink trigger")
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: move static function instead of forward declaration
 net/mac80211/led.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index b5600d223452..42dcd56eb983 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -194,6 +194,19 @@ void ieee80211_led_init(struct ieee80211_local *local)
 	}
 }
 
+static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
+{
+	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
+
+	if (!tpt_trig->running)
+		return;
+
+	tpt_trig->running = false;
+	timer_delete_sync(&tpt_trig->timer);
+
+	led_trigger_event(&local->tpt_led, LED_OFF);
+}
+
 void ieee80211_led_exit(struct ieee80211_local *local)
 {
 	if (local->radio_led.name)
@@ -206,6 +219,7 @@ void ieee80211_led_exit(struct ieee80211_local *local)
 		led_trigger_unregister(&local->rx_led);
 
 	if (local->tpt_led_trigger) {
+		ieee80211_stop_tpt_led_trig(local);
 		led_trigger_unregister(&local->tpt_led);
 		kfree(local->tpt_led_trigger);
 	}
@@ -335,19 +349,6 @@ static void ieee80211_start_tpt_led_trig(struct ieee80211_local *local)
 	mod_timer(&tpt_trig->timer, round_jiffies(jiffies + HZ));
 }
 
-static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
-{
-	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
-
-	if (!tpt_trig->running)
-		return;
-
-	tpt_trig->running = false;
-	timer_delete_sync(&tpt_trig->timer);
-
-	led_trigger_event(&local->tpt_led, LED_OFF);
-}
-
 void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
 				unsigned int types_on, unsigned int types_off)
 {
-- 
2.55.0

