Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EA8450401
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427489; cv=none; b=fGHiXKsy4huSDQcEwByRMG3exhKz5SUq2H1g37c+s2AKfnByIgOHy8Uk64cm2txWjBVtp+3/X4dV/a3CwyOCFWVPV3vTdVCmkoYz6PYSCmqknzuq4Xb69/wEQpIiPrdOYVBOjMmomm3j+eCb44ljTuicdJ0j2QUinF569JM7ZRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427489; c=relaxed/simple;
	bh=d4nOnT31foNOR63+DrFJFTVwqLjcoSlCGbUdKsH6CIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=srO4c2DvGF5na031MdSMzXEIHxrwjqH3fo5Q+kbDj/XwcmM0OvB+eUw6zcganNV+ov2HOmt5uMgJCbWyrq8uiK7HiN87ybGPIQ27WdBJc/iDIfTOCjg17HjOD+damg/t1nC7GtSHdDzjCWutkX0qfs5ujUo2FjP1c53ro5vnPsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o4hXgFWD; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o4hXgFWD"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-384c94c9423so3747a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785427488; x=1786032288; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dYPgSDDfqeqUZ3RR4zRVMJgkhHA+lOjtpoEJpFazOss=;
        b=o4hXgFWDI+YfTNxvQCpjKPsqHWo60gdYkBFz1P4OJGfJBRK41O/yQ1pG3A6CjNxFpG
         qhpUNbYOU0nZifHSE+BZr6TKUhgEyNIyKYOCy1sY4PAwI3bUdNu8WFclW52yWf1cqCUY
         YwUc5fmgTDOKXHhJMalIBRvy1oYV5nb3qZ56gi6FPuprnZmOpdb0+HZs6XaEL/O6duH9
         3Ej5E0gqDRRqPZf55jE7RCeKAz0AfLgc8srl9DeSxZblmqV3Z+pO+mlAYLzEUhQxmcmv
         2eey/XZy5OVsXFgaZZ1Gg9/ryLlxtvTbfd0x2KqnnhdFaJ00lpzAgn7hQFpnJHwcaU+n
         SroA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427488; x=1786032288;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dYPgSDDfqeqUZ3RR4zRVMJgkhHA+lOjtpoEJpFazOss=;
        b=MevjGmh7QG/UHo1k8M64FxQtstonB8+nCtYRRb9lDOgKTbWkM02ThTCe0ym1E+S716
         hAG7QJ0l6PLDiV9YPpn9tYKyQcYv0jd1DB0A9+k24NEiJLmtOI6rsjN7pyfiYBD7G6cj
         4BnGAygxgIC+6SdB4nczc44wBq8GJ6t1vBNeNcA9oX8MAOyfrkbBF1yWnMq4nv+Wl15O
         Mm7OQxeVA4g7DURp3qTzX+kWwGfRrOd52N5TkPHra+S+bracx0ngG4hET588WT01FOo3
         1dIQYU57ks/gS4SgWG/ULqp36K80pncNgPZ6HFXAryTrQkLdoeKKYbFl0GDpqhXcED6j
         eJ8Q==
X-Gm-Message-State: AOJu0Yxnm8vQ3edtMWsguylseygwh9P45ydcaq+VM5uP4K1k1FJWJZws
	G6cVR1plmv6lKHhSbgGLYr2G8Nc2NP9BEAqFx0kWONVVrjnXcbLeAQGW
X-Gm-Gg: AR+sD12HhZDYfqNDo1RFuVnvvAhn3/n6g/HURb4xsc3Z+HOwRD+DWoW0LrAGkg17RBJ
	WEMG3upNWHmczulvWGP5s+at3h8TzqSANMvturRG5jL0rlWJ+DxHvJdEahIOAzZJM8xVHM3M4HB
	+BAailvboIkWQ+RnC7RecaHJF/fj7gO2qqSfIh4XKCuaw+nP5eCTmdJN5ti3FwKd0bWGvcvTUex
	St31DA7FleHtbwRO6uq2iXu3hNjfmxYLQtuvzBeK4KJurq0IvLQnuqm9tdmViW5j5DjCeXuIdwM
	MFO47FXdmHVpAHpdx15INpW6fMvcXHXjDTzYK01fAzslbS5QXGrfCf5ka4M574OMgQLbF6M1wqF
	Ftu0euz3EQrzeJMcwrxjGVDllzMRh12o+yRiak3McZnrQt+UTFZtVxQkcYVcHavsvhQn46Tb/aq
	yTKlC41zgoneQNTTFVfLQt9UTVEvjkkiIVxiffDBbRqwihyZDBf499zSYOcK0v1dwLHOol4LadF
	NDUvr8tGrtUUg==
X-Received: by 2002:a17:90b:5784:b0:38e:480b:99a5 with SMTP id 98e67ed59e1d1-38fa7fe2179mr773181a91.2.1785427487341;
        Thu, 30 Jul 2026 09:04:47 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm35012783c88.5.2026.07.30.09.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:04:46 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <shivesh@example.com>
Subject: [PATCH 6/8] wifi: brcmfmac: pcie: optimize latency and irq teardown
Date: Thu, 30 Jul 2026 16:03:54 +0000
Message-ID: <20260730160425.11933-6-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730160425.11933-1-shivesh@example.com>
References: <20260730160425.11933-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Optimizes mailbox polling with exponential backoff rather than a fixed
msleep(10) loop. Fixes define names. Eliminates coarse msleep(50) delays
during IRQ teardown by replacing them with tight usleep_range polling.

Signed-off-by: Shivesh <shivesh@example.com>
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

