Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819614E2360
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449802; cv=none; b=U92sSBUqKpG3/p+in0R/NOqALVVH1U41vdnBgH9N2nmPPsyKnexMLlhz0ORGZ7YPorer0tiUaETTolZPv9iZKYyQIplV9brgH4XGuNH07E22robJZycBXPw2webey+wU7uvpshBUyJlKRHPiqDdybv3eMrFDD3ta1C1fM+67JUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449802; c=relaxed/simple;
	bh=tT3Q8k3SBGvhCW+ypFai1zo8VCC9N3bTDH1szrukFBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y7eNAJNO2v9P/dwNxkwIGxS8OMI5mYW9XnPT7O3W9Na79z+lVl/PDeEML1FqF399vSzF9XIhRNGEQc+M3WVdj9uUbYD39AU5iwYsC7CVTGOGULU5kGbTYNdQLbkFvxyXHkhyst1Ti5cyZlany6D1E9KTjnGutqPwKy9WFnYoasw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2KEiPET; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2KEiPET"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b8e527d63so29424865e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 08:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788449798; x=1789054598; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XFFCN85pDa3U+auxuvcaHapqvCSCEcU+9fOdA+AcD88=;
        b=R2KEiPETiX6HOLiotv02anrRukY6a5PRjBYiLxZ2rg/H8S2BmMnA3UBm4W/RIch02K
         tV+KsnCKIYLWtW/CN2bDOdVOh+NvVwcJL5yEtR4Vi+NFeRrI34dzfT58Mfaem9XP4vJD
         qr0INPJ1quJjgFpO2RgJUnNnXG1jzVV4pSCsBxYlMLgc5lq39jfwSxKbBTxpECKO6JRn
         MbXXlLMs6wUz1V1dD7ROq2D2CnBVU30T/HfGEUESCD0rRGuE/3ssYI5QcUUfQO6GNZZw
         IEt/tH/lDb7JF5ETY2Dp/j4ITn/PNk2+P+udM9liPwwYUsfdB9e8U5Q1NqEofcylgGMa
         dRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788449798; x=1789054598;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XFFCN85pDa3U+auxuvcaHapqvCSCEcU+9fOdA+AcD88=;
        b=oAObrktgMGqkUgWTTpWTMpkawSt+Zcdc9ids6rsfrCO13pFmlEc7MieSANrnBg9aRh
         FBtJIis2dvzptCeXSUM92lviZqSwMdsAHfbRc5/XhxzkLrEsXxfKE78AuYkafClB8rCC
         t/f1ih56z+zXC/hQaxjqZEJM6RVxiLtp81niM8SqLF7dAn3Ou1kF2Ss5JqthSp/YTpc1
         n1cxJB+/9v00LB4mMzUyJbnwie7WW5v0mJO4RYoGkCQkPw5JVnmhDlVg+wfrtjiJhi0f
         Cp6EpzKuVLxv29bedtRgxzKWAqo6eWNpKD1jtyZdwKiFlYKcnz+43vlVFtJBLRX9XGYL
         NDXg==
X-Forwarded-Encrypted: i=1; AKwUvByGLUyObTM9PyENaOyZQbPQs7PWSenyJz9FaY0ym/1lUepAsJ5ky0K7qZebnq+E06JGqGor46zf3xjdRZ1+YA==@vger.kernel.org
X-Gm-Message-State: AFuF++myaQUS+HnkAbGbmjnKVw+aXAoVoccRqdY5Ip41gFhg/Gt/Pdye
	vQ3GOkSv9u4OgrjdncIJfcU0blpKRLsHNrffbzqgH+u9lOC1UaHXx5Y=
X-Gm-Gg: AYBFou2vjV5nmA8WiGOckYFxecIEvFZ63wfLFwR6JnmUB83IGxT4TbapURo6Y7QHd0V
	oH4z/cIqItuSt6QB1HiiwdMZrvka6ZWtEoXMn4bnOM+Q08YpSqFY/gfuTC+L8uv4rGZSAH7MgLq
	TEJ6ahm3vly6vxyzi7Zjld5DNolNPcqrmd4zXpPA3vktttXTuBgTxxpknHxtw60jxbldTSCgKqX
	7x1GRoqqCNIUTvYtOqt7W5izk6JtbYD62xTTHmtdhTuke/KXwvfMCf8ep5Kjaw6RqoyZjZzuFhb
	IZVtGPCRlrUy0rEFh9PzBVUYDqMf415O5KHNRQOSE4gQDVm8pTJwTC4J2J9PxVfJJjVWXCkjynz
	ZganntDw5Y4B4DxCB2ZEXCVhfkjNaQGTv0tMVuBMBFkwQWO7HfxrKFHjRN8emQ3hcdfL6ija9Ux
	IjA+2y9LHeZOGncJjV6WnU4jP8rfKiivkcGan3keGBZzMVR8ogzu+Vkq0CiUbWbjZO0Sd3x6Vhi
	//YxPBssL/zDWVkOxp6tSQTEQxhua2xalXno8fpz8aPdmiWnLZkXSppXl/MNe9niGCIg2VJ09PW
	28xDVPyBg1UIN+CC
X-Received: by 2002:a05:600c:1394:b0:499:db27:7b1 with SMTP id 5b1f17b1804b1-49cf5bafa7bmr13645245e9.15.1788449797712;
        Thu, 03 Sep 2026 08:36:37 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce831af89sm75568425e9.1.2026.09.03.08.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:36:37 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] wifi: ath9k: check all tx queues with one multi-read
Date: Thu,  3 Sep 2026 18:36:15 +0300
Message-ID: <20260903153617.990995-4-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903153617.990995-1-nerijus.bendziunas@gmail.com>
References: <20260903153617.990995-1-nerijus.bendziunas@gmail.com>
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
 drivers/net/wireless/ath/ath9k/mac.c | 38 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.h |  1 +
 3 files changed, 45 insertions(+), 7 deletions(-)

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
index b070403e083f..49f59ce92133 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -77,6 +77,44 @@ u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 }
 EXPORT_SYMBOL(ath9k_hw_numtxpending);
 
+/*
+ * Asking ath9k_hw_numtxpending() about each queue in turn costs up to two
+ * register reads per queue, and on the USB devices every one of those is a
+ * synchronous WMI round trip. Collect the queue status registers and AR_Q_TXE
+ * with the multi-read op instead, in chunks the transport can carry. A
+ * multi-read that fails over USB reads as all ones, which counts as pending,
+ * so a WMI timeout still refuses the fast channel change.
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

