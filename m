Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A1B51FCC7
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788547998; cv=none; b=ZMCqLe/d0BBUnedH2kWj6yJ1ZmSAKhd5XoikBV0haFt4NmtTbA7TSeymzYwz9pyACTyegytstgnOIGzpU0tNqToLWaWy4lwh86yo4YwGym8e6ZXhbPVJm6XCm3kVrD+7JcXCV7J7jg5g+eQ2h/B494f+Ii7edadF79rHIt5eDE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788547998; c=relaxed/simple;
	bh=q0jBlW76LvL4fU60HQWKpNaPKvxyoQqAS/s/hZ+Rji0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RMKYZUbUzeOk11RUyHx3JIGhqHaJf4s6Knf13fgBVIh0Cj6NRkqJdcINAr9Q1aVyo4mqupqopEtsHwgrqV433A91VZicuqwVgY/hew8w7HjwvqjSCtOH7qLyb8lCJd+hOfNCENpc/10NoPFdEuow7P2FWIdtKIm+vvhM4EJLshM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TbxFVEUG; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TbxFVEUG"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49cf4f81d86so10552315e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788547993; x=1789152793; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=d85C0WGMaBUKYmEMA486RpdKAWHT2Sz0LL4lVc+yQdE=;
        b=TbxFVEUGpEXmEx/mHYEwVc+DGkPBK/u9epodKRApuXuRSFS46JEmqSTMCbFB0lFHRa
         7BNLkruNxYdkRMTmFY23ZH1q45In9g4mcIgKGgP4Nq2iM6kUjGX+XiuwplnaVqsJSiU6
         rejbo4OqSmzCS4rTEmB9xK1bw8MLuKK3goIzJ+kr7RsqcPOLqJ38CPiSv/0YgNT3/MGQ
         rjQ2WsTga2cxvmE7cDXwdnwiGsN/F5FUiUU/KADWLwjQRjQpmnflfW4Iut8skyrGfAU+
         puIKGTW1XC7v/VKefWzFHWbXCwbqZYzi7bB4fUuoNp/mzklSRSFM2AX9r/ffEBGSQok+
         Sdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788547993; x=1789152793;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d85C0WGMaBUKYmEMA486RpdKAWHT2Sz0LL4lVc+yQdE=;
        b=EpZENiGGBTqW4CmlpU+hpRLnt5CYmvQQK7l8XoOI7aY7xMGb0H9veQpu37c2nli0Ho
         4fM4KX7dlxUeNmztV4ZhyJKL9AIzTxyK4D+s5rQRmDP5hlGri7X2DdYlfhqoLTefV0v0
         dF+gOIOEZGX2FwSGjH/Gg4CSWkB/EQkMpidW+EdHpaGjdLUH2o5hydk1QHf3Vcg1vMzd
         HtEL1P9UDQHxpcu+HP10jjpaROT0wgOUHp0Ag1Sr1pZ6U2W+c/x52fEhmNqOd3VAvo2c
         yXSQ2f/mE9hcv1+zyIIIvOGstxG1R0ADzYn0snsP2pphdq2WQO2rWr/x5HuBvFY+9AQv
         U6gA==
X-Forwarded-Encrypted: i=1; AKwUvBxTk0WKPfacwvA8+d9kL6U+2tsplft61WiNTLFNC++DuotAC3dAHAt2BUKBSP+amHRccVmc0gE85SAhEjzTgA==@vger.kernel.org
X-Gm-Message-State: AFuF++kZYqPDCMD9VQckC9m9eTvAUKd8SAX4MnNSBCXJMyfi9mSoeA1i
	HILxflRsK4WAt4mQ9vmj5AShyl8gymjeRRXk/fPaqE5bDO0NDELDeZU=
X-Gm-Gg: AYBFou3NCDJ7W0sEFGUMpSe8beB3z/xr1hgtYrj6pILOho3KA077ISqmgcCZ3sKZkza
	U/eoLrM0Fi1IZbaXeS+J1s7EY/wtFBxZy6S379uNMBI1Iw6nibf8nnP7jttMN3lpAeS69Pv/762
	x4QIwnZ+LhkM5lJ3nVXFnPbLSRBkr496Y0AyvfP5plG5AjsIWImFmecG8v9qZ2MdVtULTur+7Ms
	7n0d1ZK3JAZfhKXJ6NBWlWxEIU2ehWYJ0ICqeGBD4/yGEhrQLHqM4P7I+BLMHz55wCtDb5Q0gO2
	hfzooM6MIhTmn2HC/GbDHhN1MyJs+8knSARqmuySJBvP4gLRtoG6ELuzfwRBKGqGnHDzUX4r9fn
	XlTxNNHSKn0ZpeeN6URTYk1hCF7omlIUbtlQ6wEnz7HiyO+Z2XbP0KgaBozY6n5EWuA9Zcv7oKc
	vo1T837Cq/16NnrA9QBdWd1WuDAqBQ1k7GXeOkUajwpr2IoM9Z2MxXz9QZqXVG5Bkv6/QCWaOHi
	BxU5l4t4IxNY93uiJPh35VHmOjyGb7vWsKepQKhFQ0Lumaf1fpaKmE5L8qDNmQ+BZjKKS3mZ8vU
	HBR0PuBEShtj3Viz
X-Received: by 2002:a05:600c:3495:b0:499:726b:7375 with SMTP id 5b1f17b1804b1-49cf8279f41mr82218115e9.14.1788547993229;
        Fri, 04 Sep 2026 11:53:13 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfbe5b252sm58607715e9.3.2026.09.04.11.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:53:12 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/5] wifi: ath9k: check all tx queues with one multi-read
Date: Fri,  4 Sep 2026 21:52:51 +0300
Message-ID: <20260904185253.809209-4-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
References: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Before a channel change, ath9k_hw_channel_change() calls
ath9k_hw_numtxpending() for each of the 10 queues. Each call reads
AR_QSTS and then AR_Q_TXE, so confirming that the radio has drained
takes up to 20 register reads. On the USB devices each read is a
synchronous WMI round trip, paid on every channel change before tuning
starts.

Add ath9k_hw_first_txpending(), which collects the 10 queue status
registers and AR_Q_TXE with REG_READ_MULTI() and applies the same
pending test. Use it in ath9k_hw_channel_change(). On PCI the
multi-read is a loop of single reads, so the register traffic there is
unchanged.

A multi-read that fails over USB returns all ones, which counts as
pending, so a lost read still fails the fast channel change and the
caller falls back to a full reset.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 13 +++++----
 drivers/net/wireless/ath/ath9k/mac.c | 40 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.h |  1 +
 3 files changed, 47 insertions(+), 7 deletions(-)

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
index b070403e083f..27926b67d628 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -77,6 +77,46 @@ u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 }
 EXPORT_SYMBOL(ath9k_hw_numtxpending);
 
+/**
+ * ath9k_hw_first_txpending - find a tx queue that still has frames pending
+ * @ah: hardware
+ *
+ * Asking ath9k_hw_numtxpending() about each queue in turn costs up to two
+ * register reads per queue, and on the USB devices every one of those is a
+ * synchronous WMI round trip. Collect the queue status registers and AR_Q_TXE
+ * with the multi-read op instead, in chunks of ATH9K_MULTI_READ_MAX. A
+ * multi-read that fails over USB reads as all ones, which counts as pending,
+ * so a WMI timeout still refuses the fast channel change.
+ *
+ * Return: the first queue with frames pending, or -1 if all are drained.
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

