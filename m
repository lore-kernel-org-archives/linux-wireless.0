Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F8E357D13
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 05:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787982260; cv=none; b=FFOt1GZGzAost0hcnYkf2s3PxrFswc/oHk5FMhPW1aooVnkEpXc5qumt+0wm1+ysk9rmZ/xtFNNhkcucWe3o63+Hgx/tSmdFfqzJoal7kWv9wPq5X6wxy6yfG/4UupygegQAiItMnZ6zBR66XlRlIGmu3jQefzGCrwFW1oNuFaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787982260; c=relaxed/simple;
	bh=u5of8imVxGF2ew+VvUbCkTLZP4l169iFcid4ehUpxio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PLyPQ21L3fLcyjSdQ1faw2tX/KHXXnCfLsOcrgwCJxgn8PSHntxS3xCP4SKc9kjgTIiYOt+DOgU9AnIJNzTQf7c41ncbQyMzKePRzX3ex5fnzHxH49kCPE4LpQj7Llt6iKQowBsEOlTpdUp+ZmuHee5fOaUnj5sdxu7iYB7d2BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T6R50mZm; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T6R50mZm"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b4aff8e8c4so1515452e87.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 22:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787982257; x=1788587057; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b88tU/OTDjrhYgEzbmZ0ec+g11Uj0EOIUGAs/DiSWM0=;
        b=T6R50mZmkuYglRPN567HW2gNfUmpB1ukkNxmxu2I7rPKNsBHkUhnOXA+GfFXtRO3C7
         XUoTIEDzOeR9trXF2Lh12GyCW7EwWplYNQ6W9nOA0z9TIJ44anoca0+kvMCPZigCqBhB
         nOd+Mb8hqgHAJYos7EhNa2UHkJUECKh8IFlVhtETOSyNTyehb5SJ1cr2ynoI7jTZWjZ9
         tRmIzfWpqDZzYX6tPpnIYqtn3Vch0CwOpvyEnwUdFI/aRhHyxZpzXiHTBJLI8/EqMEBo
         SBsFfBebYVFBw+ByxI5CCT5qVG58yjmEHtG4UIsUNKAKIQjgXMFJp/xq3zDuX8KLlZyw
         h8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787982257; x=1788587057;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b88tU/OTDjrhYgEzbmZ0ec+g11Uj0EOIUGAs/DiSWM0=;
        b=IRAswqyUu2Rc40AL+Umuy4FGovdOrFOlhm4g0Vse4/jRN7dniH3h0XYQmcqFl2lP8l
         MnZf1QDzAEPFNG0gQa706Df5Lv67jzSpIcW67Ps+YM7rIHEEzIPWVICCTFKk/SNqGXDQ
         1efAbMcBP2IZ3+SFlexV78q7WN1sc78sPMg8b01ZCUlQmPLnvFW4Hm0uVWYbPLx655Cm
         LcHFRHrli39H7d/IxkkTAB7x2oxZ385DRpCot8ujOXUC1EIW4eSoQMI+/xo5Cvp4I6TT
         3HUHu+fpq5GihAcwaWoFCLuhmP4RdnrapfdoN7h2LDnylvdNKVJmy+uuHHeFpUzeMsEV
         gPoA==
X-Forwarded-Encrypted: i=1; AKwUvBzBgUWSWhftXwtwMl70lQCVAVJe02ASy8cQzcnnC53FaWsZmzlZYVdc9ROuKTj5/ANZhZ7diryYTvJSefHqBg==@vger.kernel.org
X-Gm-Message-State: AFuF++kmHhePnaw9kWV+U6PROakEEnVo6xpLxN3qpXzsR/KHsGHZXosX
	a3KXGiFprDU0UjSJLQYTqlc8syZPEpkL/3nM/v+yox2spXxWP8/yl0ao16Vc
X-Gm-Gg: AYBFou3qcY4Z3Mvzuc4M5p9985uf7kyr88OO7J0Dp35AGhf1Zo09lVEwKNj/zRbfr5Y
	mIowLUNpT1IEV5aO41as2qmK3bXdtWEQ7NGX528eO/y5T+Y3RpR6FQ63+7w51F55JprZhVoFID0
	la/hk+UJvqxAIEBGxWOnvdiRKYdx1Cih7geIhjSzmoXXfSxyvNj9m0truOeJj0dVJ0N+fMf5gho
	Vbo0BM96s5MQSt/r8wRfBrVK46E2MrIExG/pSHwp2nTtRFw/tViap4YU0KWJ2uoRry0AVwAgwmM
	j6oZruY+8xJ0FbP7ES6bMbbUl80f1xU1rrHcyZrpFQcXzzl2zF+ptmhLcwCv0TbJuxfPVkEm5ZQ
	jmWr3PRMFuU4YLMhVBs0RRyFxA2DVfYwkZl3j2CktKkXqaxUJcZdb4PLysvnKwCZIVfuesgD3WN
	i2RBcwmkpLhT3S/DqOCu1mIOKZRdIARet4NUJHVpqnVbZOF2MH/WpwOCXzZdz7YWJ2TOcoF1aWt
	FuG7kUmy6wjuvpawVI458g54XaEyXMflY+iWJABCeRMa/n8M3/Ucf3+YC5l79Wwkbr/Uo/5QxXq
	QiEb
X-Received: by 2002:a05:6512:3b8f:b0:5b5:e2f1:e6f9 with SMTP id 2adb3069b0e04-5b5e68bc823mr3717496e87.11.1787982256843;
        Fri, 28 Aug 2026 22:44:16 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b5e89c5b86sm803040e87.12.2026.08.28.22.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 22:44:15 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] wifi: ath9k: check all tx queues with one multi-read
Date: Sat, 29 Aug 2026 08:43:59 +0300
Message-ID: <20260829054401.1198574-3-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829054401.1198574-1-nerijus.bendziunas@gmail.com>
References: <20260829054401.1198574-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Before a channel change ath9k_hw_channel_change() asks
ath9k_hw_numtxpending() about each of the ten queues in turn, and each
call reads AR_QSTS and then AR_Q_TXE, so confirming a drained radio
takes up to twenty register reads. On the USB devices those are twenty
synchronous WMI round trips, paid on every hop before any tuning starts.

Collect the ten queue status registers and AR_Q_TXE through
REG_READ_MULTI() instead, split into chunks the transport can carry, and
apply the same pending test to the results. PCI implements the
multi-read as a loop of ordinary reads, so it sees no change beyond the
loop moving.

Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 13 +++++-----
 drivers/net/wireless/ath/ath9k/mac.c | 36 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.h |  1 +
 3 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e08ab73fcacb..d204cdf3fa8f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1547,7 +1547,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	bool band_switch = false, mode_diff = false;
 	u8 ini_reloaded = 0;
-	u32 qnum;
+	int qnum;
 	int r;
 
 	if (pCap->hw_caps & ATH9K_HW_CAP_FCC_BAND_SWITCH) {
@@ -1556,12 +1556,11 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		mode_diff = !!(flags_diff & ~CHANNEL_HT);
 	}
 
-	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
-		if (ath9k_hw_numtxpending(ah, qnum)) {
-			ath_dbg(common, QUEUE,
-				"Transmit frames pending on queue %d\n", qnum);
-			return false;
-		}
+	qnum = ath9k_hw_first_txpending(ah);
+	if (qnum >= 0) {
+		ath_dbg(common, QUEUE,
+			"Transmit frames pending on queue %d\n", qnum);
+		return false;
 	}
 
 	if (!ath9k_hw_rfbus_req(ah)) {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index b070403e083f..0d8369bbbadf 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -77,6 +77,42 @@ u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 }
 EXPORT_SYMBOL(ath9k_hw_numtxpending);
 
+/*
+ * Asking ath9k_hw_numtxpending() about each queue in turn costs up to two
+ * register reads per queue, and on the USB devices every one of those is a
+ * synchronous WMI round trip. Collect the queue status registers and AR_Q_TXE
+ * with the multi-read op instead, in chunks the transport can carry.
+ *
+ * Returns the first queue that still has frames pending, or -1 if they are
+ * all drained.
+ */
+int ath9k_hw_first_txpending(struct ath_hw *ah)
+{
+	u32 addr[AR_NUM_QCU + 1];
+	u32 val[AR_NUM_QCU + 1];
+	u32 q, txe, done = 0;
+
+	for (q = 0; q < AR_NUM_QCU; q++)
+		addr[q] = AR_QSTS(q);
+	addr[AR_NUM_QCU] = AR_Q_TXE;
+
+	while (done < ARRAY_SIZE(addr)) {
+		u32 count = min_t(u32, ARRAY_SIZE(addr) - done,
+				  ATH9K_MULTI_READ_MAX);
+
+		REG_READ_MULTI(ah, addr + done, val + done, count);
+		done += count;
+	}
+
+	txe = val[AR_NUM_QCU];
+	for (q = 0; q < AR_NUM_QCU; q++) {
+		if ((val[q] & AR_Q_STS_PEND_FR_CNT) || (txe & BIT(q)))
+			return q;
+	}
+
+	return -1;
+}
+
 /**
  * ath9k_hw_updatetxtriglevel - adjusts the frame trigger level
  *
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 16203e7ecf29..5b94ce087be2 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -721,6 +721,7 @@ u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q);
 void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp);
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q);
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q);
+int ath9k_hw_first_txpending(struct ath_hw *ah);
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel);
 bool ath9k_hw_stop_dma_queue(struct ath_hw *ah, u32 q);
 void ath9k_hw_abort_tx_dma(struct ath_hw *ah);
-- 
2.55.0

