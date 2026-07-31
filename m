Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5208644CF40
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514032; cv=none; b=gvd9enAMqA3FggUyzZTXfAzQicMUi6lx5Vi7VkIdOCH9Blh2SP2iILl9jnvZpEBGKFIC75Nxu/JVH98EllcXF+B8+f0j1gLNUrIWT8NKJ95NOZEwCVhbnFaHjPtwwjsh9dzcA0WojMgR7QdmZKunWjKzpCnL83XavSLz0OJLEps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514032; c=relaxed/simple;
	bh=+EEZHSVtxvI8sBTxmE1ATnsB2rk61KuaQLlBtFDwhfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CrtN+yBvLNS3qnBXHw4VWl2iwIT8MM78fXRtRb1R4sURboF2Gb8Zfuj0daEZweMLVze/sa4ugQVbfoqOyogeSu0FUnQFEUdT1k1BQC6h1Ajg5tTDOa/N/HpuyTFEqDgAvOGLIErwPcWoNBrfVNc0WGxg9gZ47MLmofl5T85YEWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hHH51q6d; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hHH51q6d"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38f57e312ecso59668a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785514030; x=1786118830; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sR/djYwS2eYkXntdPLamATqE5su3p7aKJoAI8mED+Wg=;
        b=hHH51q6dPQyu1u8+v6B05L7GJvezelvOdsHQMsxP/07QTiTBJFvMzUmwzozcZBQ1Xd
         F0vgFb4BuGQcJrjUemcmpJbeNy1x5r4s5NQCLMnMaNJQmQb51gz+gBaI4M86Om5/Ev3x
         oZgCZGOmXiTJoNm6fgg0jxOiPAoRIAIGJHNUq0u4iRPRs6RSFT0YBCa01/jkJklZxZkq
         TtCe58HX5OsZIrnhE+N+iQLzRZZZxC4XqysyGu0894t/C+Chqnv62jK8IjGCht4IyWNK
         SKtQDq77TE9HF/54Zj3Tdlobxl4oZJ71yQtpJ7TxbxloniZknupY3gixfYeYe3JdwqHX
         EuBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514030; x=1786118830;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sR/djYwS2eYkXntdPLamATqE5su3p7aKJoAI8mED+Wg=;
        b=mPt1LiroRGvbn1UblDthJGm8CxCK8QRYQnIIOXLD3KcrXB2dCZCfZxVrDXJfqQ9bRJ
         DhY+MbjomPU58Dw0484Dn/8lKKUMaQYxpxQwMvWGILDj9pmxeejjPXWN3VpZBdJGpzTp
         zKobkxIgcvCGgK5XtAdKAbSUJ+x95NIeLtNyD+CXox/gxfZdf2Un2dPsGWy0m5Pq8E/6
         9M5SprhEYmqK3EYwwCB40q2Ph3Zd9mnpKQXDSBsKCpR2JTrVo99u0Xe3jeu4PN2RbrqL
         BuFC+7IMSQRLaVg17XDvV5vJ3R+zSYMU3NV7QDwNa71du/Vg6sWbtMTbDUH27OZYQPrx
         69aA==
X-Gm-Message-State: AOJu0YzDRKymK/ekzHv2UJBR85Cpcp1dZrz9zSwdoHiQ4bor0J8ks2Qt
	zNvMI4ztpLRZGRZOuDsPxAxxdsQODAYi1zvSFSgDeShBmhOnryuzVeSj
X-Gm-Gg: AR+sD12UWYguXSm4iX5fMI1XF00OxLOcRWUmo/bEVnTsDUomq7PiRID+T/A8bes4iZJ
	azTOSL8hXnihgzgyaopIk/wV0hH4OK7wXcXv7MsmNq0EiRG7USNL0bvCnvwX4ijEF8TyQESqtWC
	IxXW2xAwjSYoCQeE6D2nASzk6ejGY1HCr9jY3ZTqgaumPaRP4Mc6g8RNEzUJ9xloxF9/7ImY/nC
	DVD6XMbPmltuwQbeFWI+LiCX3Xmdq2AbWGQDuzxhZGOJ/PVZ9LIEH8Q87Ux5wDGmdERwTxk3YuK
	XyLbZn7RKghmV5KvSB51OiL0fmo8sJlzPQSZpEj/Rm318pGlUQ015PvgtnblFSSPFyjJiWHbjx1
	YoiP1Yj1CmIpUkvyBpEkfehD5edsYrYjJ29cqs4AZ4BnCLSWqvliGusgknfccUeAQuFBY/8X6vE
	vnaQmdE+lGWnqEUK+msypP/6SR/b/bi0kIxaKHKlIZNlKZHTR6C5zhh7u2/I159jx3xTya63/eT
	sXa33ajeAOIGRYjkMA=
X-Received: by 2002:a17:90b:520c:b0:38f:aa76:88b with SMTP id 98e67ed59e1d1-38fbc506f17mr600038a91.4.1785514030468;
        Fri, 31 Jul 2026 09:07:10 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c93dsm7881425eec.8.2026.07.31.09.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:07:10 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v4 6/8] wifi: brcmfmac: pcie: replace msleep polling with usleep_range and backoff
Date: Fri, 31 Jul 2026 16:06:23 +0000
Message-ID: <20260731160646.3812-7-chanelshivesh@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731160646.3812-1-chanelshivesh@gmail.com>
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Two latency improvements:

1. H2D mailbox polling
   brcmf_pcie_send_mb_data() polled for the dongle to consume the
   previous H2D mailbox message with msleep(10) per iteration. As the
   dongle typically clears the register within a few hundred
   microseconds, each call incurred at least 10ms of unnecessary
   latency (often 20ms+ due to jiffy rounding).

   Replace with usleep_range() using exponential backoff: start at
   ~50us and double each iteration up to 5ms, with a 1-second absolute
   timeout matching the original budget. Add an early-exit check for
   BRCMFMAC_PCIE_STATE_DOWN so a dead dongle does not hold the caller
   for a full second.

2. IRQ teardown polling
   brcmf_pcie_release_irq() waited for in_irq to clear using
   msleep(50) in a 20-iteration loop (up to 1 second). Replace with
   usleep_range(1000, 2000) in a 1000-iteration loop, preserving the
   same ~1 second maximum while allowing the function to return in
   microseconds when the IRQ handler finishes quickly.

Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 66 ++++++++++++++++---
 1 file changed, 58 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 13662aa4b4ea..9338a5faa260 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -268,6 +268,27 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 
 #define BRCMF_PCIE_MBDATA_TIMEOUT		msecs_to_jiffies(2000)
 
+/*
+ * H2D mailbox poll timing parameters.
+ *
+ * The dongle typically clears the H2D mailbox register within a few
+ * hundred microseconds after the doorbell interrupt fires.  The
+ * original code used msleep(10) * 100 iterations, meaning the
+ * minimum observable latency was 10ms even when the dongle was fast.
+ *
+ * We instead start with a short sleep and double it each iteration
+ * (exponential backoff) up to BRCMF_PCIE_MB_POLL_MAX_US, staying
+ * within the same 1-second absolute timeout.
+ *
+ * MIN_US / INITIAL_MAX_US : usleep_range bounds for the first iteration.
+ * MAX_US     : cap on the per-iteration sleep (µs).
+ * TIMEOUT_US : total budget before giving up (1 second).
+ */
+#define BRCMF_PCIE_MB_POLL_MIN_US		40
+#define BRCMF_PCIE_MB_POLL_INITIAL_MAX_US	50
+#define BRCMF_PCIE_MB_POLL_MAX_US		5000
+#define BRCMF_PCIE_MB_POLL_TIMEOUT_US		1000000
+
 #define BRCMF_PCIE_CFGREG_STATUS_CMD		0x4
 #define BRCMF_PCIE_CFGREG_PM_CSR		0x4C
 #define BRCMF_PCIE_CFGREG_MSI_CAP		0x58
@@ -766,7 +787,8 @@ brcmf_pcie_send_mb_data(struct brcmf_pciedev_info *devinfo, u32 htod_mb_data)
 	struct brcmf_core *core;
 	u32 addr;
 	u32 cur_htod_mb_data;
-	u32 i;
+	u32 elapsed_us = 0;
+	u32 sleep_us = BRCMF_PCIE_MB_POLL_INITIAL_MAX_US;
 
 	shared = &devinfo->shared;
 	addr = shared->htod_mb_data_addr;
@@ -776,12 +798,40 @@ brcmf_pcie_send_mb_data(struct brcmf_pciedev_info *devinfo, u32 htod_mb_data)
 		brcmf_dbg(PCIE, "MB transaction is already pending 0x%04x\n",
 			  cur_htod_mb_data);
 
-	i = 0;
+	/*
+	 * Wait for the dongle to consume the previous H2D mailbox message.
+	 *
+	 * There is no interrupt that signals when the dongle clears this
+	 * register, so polling is unavoidable.  The original code used
+	 * msleep(10) per iteration, incurring at least 10ms of latency
+	 * even when the dongle responded in microseconds.
+	 *
+	 * We use usleep_range() with exponential backoff instead:
+	 *   - First iteration sleeps ~50µs (fast path for responsive dongle).
+	 *   - Each subsequent iteration doubles the sleep, capped at 5ms,
+	 *     so long waits still yield the CPU without busy-spinning.
+	 *   - Total timeout matches the original 1-second limit.
+	 *   - We bail early if the device has gone down so that a dead
+	 *     dongle does not hold the caller for a full second.
+	 */
 	while (cur_htod_mb_data != 0) {
-		msleep(10);
-		i++;
-		if (i > 100)
+		if (devinfo->state == BRCMFMAC_PCIE_STATE_DOWN) {
+			brcmf_dbg(PCIE, "Device down, aborting MB send\n");
 			return -EIO;
+		}
+
+		if (elapsed_us >= BRCMF_PCIE_MB_POLL_TIMEOUT_US) {
+			brcmf_err("Timeout waiting for H2D MB slot after %u us\n",
+				  elapsed_us);
+			return -EIO;
+		}
+
+		usleep_range(BRCMF_PCIE_MB_POLL_MIN_US, sleep_us);
+		elapsed_us += sleep_us;
+
+		/* Exponential backoff, capped at BRCMF_PCIE_MB_POLL_MAX_US */
+		sleep_us = min(sleep_us * 2, (u32)BRCMF_PCIE_MB_POLL_MAX_US);
+
 		cur_htod_mb_data = brcmf_pcie_read_tcm32(devinfo, addr);
 	}
 
@@ -1001,10 +1051,10 @@ static void brcmf_pcie_release_irq(struct brcmf_pciedev_info *devinfo)
 	free_irq(pdev->irq, devinfo);
 	pci_disable_msi(pdev);
 
-	msleep(50);
+	usleep_range(1000, 2000);
 	count = 0;
-	while ((devinfo->in_irq) && (count < 20)) {
-		msleep(50);
+	while ((devinfo->in_irq) && (count < 1000)) {
+		usleep_range(1000, 2000);
 		count++;
 	}
 	if (devinfo->in_irq)
-- 
2.53.0

