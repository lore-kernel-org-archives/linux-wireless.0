Received: from mx-relay94-hz2-if1.hornetsecurity.com (mx-relay94-hz2-if1.hornetsecurity.com [94.100.137.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EF21F16B
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 21:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=94.100.137.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786225029; cv=pass; b=nzaaEj3JcP0p0TSpPVX7H5LslAznoov84j6uc5TotklLNimX/ncVhgatteOaGz+pkbzkTUm5zktRw3O8AukwFy7uAxAdkkZ2CKu4tZ0WUa/0MEltOjaHGFkModht4l13GfiQkz7VUZ/HLc/7xhVAdctc46/JTXwHEf2D8fEi0p8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786225029; c=relaxed/simple;
	bh=ssUlLYZW485ICnysZpLwxNIdK905wC/hRowV3zeAoOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8puYKBMgH35DTt+zcgGpdaC7z5KGsQ43uVERmjGWkJjPupYoOVv/J5SEyvt5z/xPHRzSsXXuxUonhdSiJqTYVlIUQNz9Up43gSI2dvkfYe6p0Fe10yToVYmeRpH0AFwdmn5t87S57EJ5QgriDKRp2DY/FwjaBHhXtcvRTon4t0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marcant.net; spf=pass smtp.mailfrom=marcant.net; dkim=pass (1024-bit key) header.d=marcant.net header.i=@marcant.net header.b=gKOT8jIJ; dkim=pass (2048-bit key) header.d=marcant.net header.i=@marcant.net header.b=MmzUDit5; arc=pass smtp.client-ip=94.100.137.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marcant.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marcant.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marcant.net header.i=@marcant.net header.b="gKOT8jIJ";
	dkim=pass (2048-bit key) header.d=marcant.net header.i=@marcant.net header.b="MmzUDit5"
ARC-Authentication-Results: i=1; mx-gate94-hz2.hornetsecurity.com 1; spf=pass
 reason=mailfrom (ip=217.14.160.69, headerfrom=marcant.net)
 smtp.mailfrom=marcant.net smtp.helo=rossini.marcant.net; dkim=pass
 header.d=marcant.net header.s=gandalf header.a=rsa-sha256; dmarc=pass
 header.from=marcant.net orig.disposition=pass
ARC-Message-Signature: a=rsa-sha256;
 bh=7rwRHGIWKNrcw+0UyMxYv++6Gv0JL9gOrsYEbGDhe+A=; c=relaxed/relaxed;
 d=hornetsecurity.com; h=from:to:date:subject:mime-version:; i=1; s=hse1;
 t=1786224959;
 b=PSCkIFd6+yVbk+/JBoPFAwgoP9daGj/58eqcI9jDl4DTSaQnGZH50o5fbe0sZivxJUCRW2bl
 2o5wwVNapnALtUyIByhu0lEGwY3hWGev3+r4Hl+EdGtehT8tmk48cRyjmuGiwizvTBHFvmTYR34
 MIoy1bwCHuXesaTorqdcXiCgLQK8RI011zq9lDjSUghF6Bw/Tqv/t9BpXYTPe/J/bqzxCtYHoIq
 iUUp80QBU0sEaB7IRGYOVmiD4ZveY1binwb19a8kxXyvD1iKs3NQhtdFEbnUwIpqx1JLPOyjPuo
 Wret3lfWRkgBsc5MCqJZiprJbjkq0+J82JnyJv6RlgV6A==
ARC-Seal: a=rsa-sha256; cv=none; d=hornetsecurity.com; i=1; s=hse1;
 t=1786224959;
 b=WVMwB/jYwo2uVqKqKBinmOVJ8iVWSNwjc5yVlhSLHu57hrWFuOy/RCixPOTlwFNPnuGQAoOU
 Xti2VwN/hNR1B3Id8oqVTKKE/YXS6IL/OWJkjqJIvEXjbrqnq3apftWJujrCiTriEKYMG/FfkIG
 JEjBkcRmTt/V0R8BSpzzNiWrJbH7UG8I/tzj4TqBq7dyPMrF8rtVwZ8A8CvPOVjE13ROry24b/Z
 +9CtYyWmpAiHo50POVKAVB5xWoCm7kOe6/IC0WTOIh3s1SjIuLDWy3lZk4aulV041oK4POdNTrQ
 cB0mKGX3lNURuNj/umV1w0+yPQgwYfRvOZfovp8IB7HpQ==
Received: from rossini.marcant.net ([217.14.160.69]) by mx-gate94-hz2;
 Sat, 08 Aug 2026 23:35:58 +0200
Received: from futile.kalnet.hooya.de (unknown [192.168.203.16])
	by rossini.marcant.net (Postfix) with ESMTP id 5CEB49600B2;
	Sat,  8 Aug 2026 23:35:51 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 rossini.marcant.net 5CEB49600B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marcant.net;
	s=gandalf; t=1786224951;
	bh=7rwRHGIWKNrcw+0UyMxYv++6Gv0JL9gOrsYEbGDhe+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKOT8jIJtjWi/mxqdBIo6tk83rOwvZRdkcWLe18pQ2uHrcnLhCMry7KOEASBHzjmy
	 z1T52gh2/6MPszvyPEoAZm2FhaTqeWBLzu92aDNDtJkL9+e6qoPQyZArb8DwuKJ8Y9
	 xr2CauJ/RKKd8dAkDqA7jiNITzxsFZXlH4D+Er9M=
From: =?UTF-8?q?Andr=C3=A9=20Valentin?= <avalentin@marcant.net>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	Kalle Valo <kvalo@kernel.org>,
	avalentin@marcant.net,
	stable@vger.kernel.org,
	Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
Subject: [PATCH v2] wifi: ath11k: run ahb shutdown() teardown only on WCN6750
Date: Sat,  8 Aug 2026 23:35:51 +0200
Message-ID: <20260808213551.4169863-1-avalentin@marcant.net>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260807094858.1548216-1-avalentin@marcant.net>
References: <20260807094858.1548216-1-avalentin@marcant.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-cloud-security-sender:avalentin@marcant.net
X-cloud-security-recipient:linux-wireless@vger.kernel.org
X-cloud-security-Mailarchiv: E-Mail archived for: avalentin@marcant.net
X-cloud-security-Mailarchivtype:outbound
X-cloud-security-Virusscan:CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-gate94-hz2 with 4hHZ7q73lPz3ckwG
X-cloud-security-connect: rossini.marcant.net[217.14.160.69], TLS=1, IP=217.14.160.69
X-cloud-security-Digest:bbf02fdbf85ecbf72d52eefa7ab56159
X-cloud-security:scantime:1.616
DKIM-Signature: a=rsa-sha256;
 bh=7rwRHGIWKNrcw+0UyMxYv++6Gv0JL9gOrsYEbGDhe+A=; c=relaxed/relaxed;
 d=marcant.net; h=content-type:mime-version:subject:from:to:message-id:date;
 s=hse1; t=1786224958; v=1;
 b=MmzUDit5/G2DKj4z4VLnIOA8drzS2RjlN7nw5CMMVVgopFZJ/9G5xYZXE4uXyxjzGaA9SMOr
 rQXvgaoY+d2DuKHfqHn343oweOZzEYz4iOoMnHs0JxaDvCaJ5gPEgnpuUv/SfoWrk1OMWeBVY5H
 AopnlR0Ih6dUKzapC4ua/5ZNVRgYCQlsipV3L58PYshAcs4kLyFBRXFQu505fYPW/UakUu/BuS8
 xWNh9uEizUAOJmqr/wdNl6dn8APd7Al6ogfwMhKv+LEcQ+HKj+akpKzBvtenus3EiRxZW8r5sk4
 l25zLUQeEsl0zOnVG6Itb+i/W/vOBxL0M6OtVsxUdF5iQ==

The AHB shutdown() callback was added solely for WCN6750, which must stop
DMA before the SMMU is torn down at system reboot/shutdown. It was
registered unconditionally in the shared
ath11k_ahb_driver, so it also runs on the IPQ AHB targets (IPQ8074/
IPQ6018/IPQ5018), which never had a shutdown() handler before and have no
such SMMU requirement.

The commit message claimed the change "will not impact other AHB ath11k
devices", but it does: on IPQ6018 the teardown stops the WCSS Q6 remote
processor firmware, which leaves shared WCSS state such that the boot ROM
hangs during DDR training on the following warm reset -- only a cold
(power-on) reset recovers, so a plain reboot never comes back and needs a
physical power cycle. This was pinned by bisecting the teardown: skipping
ath11k_qmi_firmware_stop() (i.e. not stopping the Q6) is what lets the
warm reset train DDR and boot normally, whereas none of the q6v5 power,
reset or clock steps reproduce it on their own.

Restrict the shutdown() teardown to WCN6750 via hw_params, restoring the
pre-regression behaviour for the IPQ AHB targets: they simply have no
shutdown() teardown again, exactly as they did for years before that
change, and on reboot/shutdown the SoC reset re-initializes the WCSS from
scratch. WCN6750 keeps the teardown. Module removal (rmmod / remove()) is
unchanged for all targets.

Verified on a MikroTik Chateau 5G R17 ax (IPQ6018): before, a plain
reboot froze in the boot ROM during DDR training; after, it trains DDR
and boots the kernel across repeated reboots.

Fixes: ac41c2b642b1 ("wifi: ath11k: Register shutdown handler for WCN6750")
Cc: stable@vger.kernel.org
Cc: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
Signed-off-by: André Valentin <avalentin@marcant.net>
---
Changes in v2 (per Jeff Johnson's review):
- Drive the difference from hw_params instead of comparing ab->hw_rev in
  ath11k_ahb_shutdown(): add shutdown_teardown, set only for WCN6750.
- Frame it as restoring the pre-regression behaviour for the IPQ AHB
  targets (no shutdown() teardown), rather than a per-SoC quirk.

v1: https://lore.kernel.org/linux-wireless/20260807094858.1548216-1-avalentin@marcant.net/

 drivers/net/wireless/ath/ath11k/ahb.c  | 11 +++++++++++
 drivers/net/wireless/ath/ath11k/core.c |  1 +
 drivers/net/wireless/ath/ath11k/hw.h   |  4 ++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 1e1dea4..5d71ff4 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1288,6 +1288,17 @@ static void ath11k_ahb_shutdown(struct platform_device *pdev)
 	 * remove() is invoked during rmmod & shutdown() during
 	 * system reboot/shutdown.
 	 */
+
+	/* The teardown below is only needed on WCN6750 (stop DMA before the
+	 * SMMU is torn down). It was registered for all AHB targets, but on
+	 * the IPQ SoCs it stops the WCSS Q6 firmware and leaves shared state
+	 * that hangs the boot ROM during DDR training on the next warm reset;
+	 * they never had a shutdown() teardown before and the SoC reset
+	 * re-initializes the WCSS from scratch, so skip it there.
+	 */
+	if (!ab->hw_params.shutdown_teardown)
+		return;
+
 	ath11k_ahb_remove_prepare(ab);
 
 	if (!(test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)))
diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 8dacc87..c6df829 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -578,6 +578,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 	{
 		.name = "wcn6750 hw1.0",
 		.hw_rev = ATH11K_HW_WCN6750_HW10,
+		.shutdown_teardown = true,
 		.fw = {
 			.dir = "WCN6750/hw1.0",
 			.board_size = 256 * 1024,
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 4996536..8279eb4 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -231,6 +231,10 @@ struct ath11k_hw_params {
 	bool cfr_support;
 	u32 cfr_num_stream_bufs;
 	u32 cfr_stream_buf_size;
+	/* run the ahb shutdown() teardown; only WCN6750 needs it, to stop
+	 * DMA before the SMMU is torn down at reboot/shutdown
+	 */
+	bool shutdown_teardown;
 };
 
 struct ath11k_hw_ops {

base-commit: f9a2394a23482bfd330911e9c8295b71724feacd
-- 
2.47.3

