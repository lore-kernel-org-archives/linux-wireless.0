Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E687444AB80
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512971; cv=none; b=fCVIuQBOKOBJX+iyqG8k8+RwnblRSX2Kmp4Ng8woQv/6kkn6gAuUfIxm3swN0+3umOtjd3cRjX4g/jesU5zNvcDDPZMhFZN0yHx48dAv7XEKd7MHgb6z7hokP6soBNDKQL75iKmYqSXy/ySO+OIfO+j5Jt3SJW0GRZl6tMEOw9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512971; c=relaxed/simple;
	bh=UrR8l2e2ua0r8hL++ntP47TXScInY+OVnratMs3ND84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sbYsFMFXplNIwNTZ40SePQD2KpdqEKsAGEG+tCctv9aX/axhB0ux8BuRBsNH0seaglNLCxioOFGq/IVtqVQQfHg7xpo0FiQ9sCQSKiGQ3M2qiiDM2hjkm7P/Jsrgyc3oHitkp+1cQn0bC5W5v7W/7BJXDu2uO7Sk8wOm8jp11m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mJc3U1bG; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mJc3U1bG"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38ecc48b3deso135698a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512968; x=1786117768; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9KRSCmcUKJkgpKNhWDdTfQ1+nI5nYS2/gN/zLauhACk=;
        b=mJc3U1bGW9P90atVsLuDi4sRpqjVuww6VYFMDtAj0xbs4tZr6ePT6Nw0YYgfHQr9kb
         zp1u5NakL6S1eELXPv68hYfP9+ZctU/QiMPfk0f5YEm2joFPXew43Sso1mdyABRp0h8f
         rbsfep3HXOCpgxWPY1RRbV7Zwgi+Ne6D+r1E3fC6SH207sFhYxOME0PT7uihDE+n1HJC
         SlqyDzAuTrVJzieN2HZjtyoF63zIZbJWLTYXKFSoBBF4+/el1qoeDKK+LfIGFEo5+ZL1
         jKZE7Dew0MmuPWX5A0vvarA1ygiUoYGelcdLuQzdgc5aTWTlsmg+aVjdz6ZBzRdbI5JM
         2Zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512968; x=1786117768;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9KRSCmcUKJkgpKNhWDdTfQ1+nI5nYS2/gN/zLauhACk=;
        b=rF0Rc3t/o8b/htf0z1CDRnzsOnZxgPl3Ux9FYDSFev51vN7Sm2GQbJl4sFjAHIkUIC
         M05FDKXfqqITfM0V3LhqA3L2A8FxLi7tQ5L5pcizYQVVYWsSLbNtyHy/cZYhsG0UC/hn
         vGSvEOREV3GABOdQ14vlWhXrqv1zyJByNPF8YNGfWXPi1B2131oZ/s0jFv/y5N6+0tCU
         fLsDziM524wto3t4jE5UC+UYz+vW02z47dkzOQ5/Sgpqggc0ckg3/OQawFqzKtnKF6zL
         mnAV+KNS6aeg0Fp+c88FqE8LpIJ5ZOuqboE0gnTuKqOD8nuXLW7BqA7tEb0y3get+GoA
         Vf0Q==
X-Gm-Message-State: AOJu0YygLjAkI+qHeFwCj3BMNrlY5MBsQeeYcLYgGv8DjtD43w+4rf6D
	isXnxaY5mzGuJ9aBsCL5tMc2VEnBUaBAFO1/yCOwZfwfIwV1/R/DOwoc
X-Gm-Gg: AR+sD12WXsDY6CDko6ZgaHfwsbhxVqryq0UQsNxpVzjz70AkHPfTpMK2VERp0CcdK2M
	oNrl8NjpM1Udhf4NfzZPcm0uDdSp4GKGAAX37zaRFZWuFe+AM673OrIcyLlui5rEPUpkx0YfttW
	Ry4i5PuIST5mwuD0wUk0kTYz2lvmSBu2IEgCgegwOq7RVJoIy3tKRyDiyOYoag3F/ARJ/s0+ML5
	v6z2G0/3JwEKMe1eKU6S7AIQ2Yf+qSuiLSGvQcA796sm8R2F8K8qf0tuAcVf89aGc8ty4uFoT/d
	zBvxsWwTIagUQeqTed3R03E12UgAEnSbb7ulVL1DioRp+fUQQqASxglndRz8owavrV+HDFNn7m6
	WAyKIhl4gc+lmNcfcr86rJdg2oA2qPjaIG44OjgjzlTnYD5zFqgnqVLHgbEETlhbH0KQD/eDjal
	LGCzV0Ll4yx3ZNMP6rIZewYMGW3A8sZ4q4i9uIVbCysvcdB9SDNxqzK8pn6MfB+TVb+ElaLbqaz
	LhAhYZQ6fAS2GM=
X-Received: by 2002:a17:90b:3a10:b0:38e:91a8:fb85 with SMTP id 98e67ed59e1d1-38fbc507730mr481174a91.3.1785512968287;
        Fri, 31 Jul 2026 08:49:28 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm11852510eec.19.2026.07.31.08.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:49:27 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v3 6/8] wifi: brcmfmac: pcie: optimize latency and irq teardown
Date: Fri, 31 Jul 2026 15:48:38 +0000
Message-ID: <20260731154901.1822-7-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154901.1822-1-shivesh@example.com>
References: <20260731154901.1822-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

Optimizes mailbox polling with exponential backoff rather than a fixed
msleep(10) loop. Fixes define names. Eliminates coarse msleep(50) delays
during IRQ teardown by replacing them with tight usleep_range polling.

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

