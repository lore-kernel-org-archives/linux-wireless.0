Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959B73BB57
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 01:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790472199; cv=none; b=k3Mr/vE74MuSdgQpyEZa/T3pSJpmE45WyJeGAVPUe2JvTKwYEYDZstMbNyyw/dNCjm3K0g1Yl13B62XqoRGx7w0JjAIreF1aDksWfjzrkF/ugP3cTm78tPRk/HVMw8v523UaSLHUx58hwZSjxLrRMcMQA3iGFrYDu99xm8yuRWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790472199; c=relaxed/simple;
	bh=8tbbajoap/6DrjifprPNOaXITTzEiCrPaQzp9bpbBvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AL3KyEgpePIrbyKJxRCR68bPQ44dxho85n3loH9+U3qzX3sfNghFI3XtHZZdi5pjl8scGFWFuvRrCSZX1LRQoqwMaUXUxqUSNr3k6u7emC7yP33umtdbO9CoMC3N0zUIHkYCEhjrcY4oXmdQRUI6okP4SAGdmPvr2HjJGF7FvrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=perenite.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fhwuadAq; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=perenite.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhwuadAq"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccead2aecso9062055e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 18:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790472196; x=1791076996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bxwshbrxYLFrgDXVSsiEGqJVWdpJpdakWMZ76gQ4IE0=;
        b=fhwuadAqzylMMwkwgB7rh+JTGO31d8Cn0jc0pfDXT1Hag+arZ3uTpO/Fy29Xs9RuXu
         6hrtESLWU/l1udl99oQKXWjI/M6ad1Vil/ndcifbTEsx0KCLntP8BabxaC6jJYX6tzeY
         MuJxhFW0lZ2HhjnJZqKBP6Z9KZVg4PeJJi3FU6xDV7IUw1JOvlp6dbh17+l6NIp6ZdDX
         x/4IZnVj7C8/WCAma5bhVX+tOP1Ki602F+1VmOhbOyvHliICaxbhwOJZgI5BeXVjeIxU
         On0RZoaWbZvEQSQ/dKUkIm9YAFC1rs95PqIYV2NQpH1DhrblGQ5l87sYhRcpo604RutS
         c6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790472196; x=1791076996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bxwshbrxYLFrgDXVSsiEGqJVWdpJpdakWMZ76gQ4IE0=;
        b=bwAwnX0U/PXOocxTmEr9WiRwvIC+JFDJnUMD8Jznw2Bvtp/QVidJxepeOuAuKu6AuY
         yCdvuSjqlyqZKDmXXpXfliJlD4T4DdNeOtPB+d8uC8rFQ7a786tumCPV03Llu3o4OWA9
         JzY8mCYScmFLXbtxyl3gWGYNPNmUQFAB7GEZo8CgcMte0RZgYug7YOISipeWGWWVAcR9
         hwrh+egH3u/xGSeEtVOMCXOC0CGGmHZ/cvYX6wZpNVSomKzwynkpEzP7DGmIh8qUzmvb
         G9pfph5EE/oHoNqKfa7V8ZP1brdEytLFDW1YEdl6Ps1gEeoAJEGHz9WnqO4oK/Ed/94A
         T+Bw==
X-Gm-Message-State: AFuF++nCRPOFkhg9ctbyt8VvDt8ikjtIaNgFbhzIxjcm5TrG66gdSTD7
	zSA6OaZf2acIq8dW5iHFrCCwEK9WgPVaFF/wDckrhj8zTnPlWHEplLpA
X-Gm-Gg: AYBFou1DMWBFWQJIsXxgoVDSQWRPJRsnGpbTSoc93XwGvWl4yDprbnNqwzpdayvwlgE
	+2AuAHUHT423+ICyTY0HW2HrXrr4qmCtu4riKPreexHN6G9rlL1kXJ26+tOxedas68FyKJu2Rmv
	+orNAS+uSMZV8XcKgxD+8Mebi3j7sb1Rqc5tTSHAGtQdUXyWiLbMo+T15QurwfaLfxB8/+z4Pvc
	PokWva695VUByiZuDc6xqQHY+AwGU6UBgGnjXkQ+ni2HvDruHEx2GUJUpZvjZEC08t1jZMibCOc
	yJQ8k6YyT1LLqhNtyHgdhJm6P2SbmzCY1mtGuONrRQvrFUba2AIAWp5xirDQD/qMxVf6unt8Gde
	XkiqSW7/1yDTIdWiZGHezGGFsOb6qpSBAZpCdQyEdrryqaU6atpXfgSFAQVjfBH+sAtt3NIbAth
	0s7hNDowxgaMNOlHr5wdeIUNxU8OiL9K+Pg8+HFn2GCN9PJKfwpypFaTLFShYvhbhpmU0N97cfY
	CvuywzVFO9Xjr3KySS644moJw==
X-Received: by 2002:a05:600c:19cd:b0:49d:2536:402e with SMTP id 5b1f17b1804b1-49ff06f7a45mr117047985e9.30.1790472195756;
        Sat, 26 Sep 2026 18:23:15 -0700 (PDT)
Received: from mac.lan ([2001:861:8b92:2c50:9cf6:601a:85a9:dd7f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0017998dbsm27530395e9.14.2026.09.26.18.23.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 18:23:15 -0700 (PDT)
Sender: Benoit Masson <benoit.masson5@gmail.com>
From: Benoit Masson <benoitm@perenite.com>
X-Google-Original-From: Benoit Masson <yahoo@perenite.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	stable@vger.kernel.org,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Subject: [PATCH] wifi: ath12k: order hw group devices by WSI index
Date: Sun, 27 Sep 2026 03:23:14 +0200
Message-ID: <20260927012314.34857-1-yahoo@perenite.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On multi-chip (WSI/MLO) platforms the devices of a hardware group are
added to ag->ab[] in PCI probe completion order (ab->device_id =
ag->num_probed++). PCI probe is asynchronous, so the order in which the
chips complete firmware bring-up is not stable across boots.

ath12k_mac_allocate() builds the wiphy radio array directly from
ag->ab[], and takes the wiphy device from the first entry. As a result
both the wiphy sysfs path and the mapping of radio indices to bands
change from boot to boot on boards such as the TP-Link Archer BE800,
which has three single-band QCN9274/QCN9224 radios in one group. A
persisted hostapd configuration that pins radio0 to a band then attaches
to a random band.

Order the devices used to build pdev_map[] by ab->wsi_info.index, which
is derived deterministically from the device tree WSI ring and the
qcom,wsi-controller node. ath12k already uses wsi_info.index as the
canonical per-device index for the firmware link IDs in
ath12k_host_cap_hw_link_id_init().

Note that ag->ab[] itself is left untouched: the unassign path indexes it
by ab->device_id, which is the probe-order id.

Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
Cc: stable@vger.kernel.org # 6.14+
Signed-off-by: Benoit Masson <yahoo@perenite.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 99bf5cf..6505255 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -15444,6 +15444,7 @@ static void ath12k_mac_set_device_defaults(struct ath12k_base *ab)
 int ath12k_mac_allocate(struct ath12k_hw_group *ag)
 {
 	struct ath12k_pdev_map pdev_map[ATH12K_GROUP_MAX_RADIO];
+	struct ath12k_base *ab_order[ATH12K_MAX_DEVICES] = {};
 	int mac_id, device_id, total_radio, num_hw;
 	struct ath12k_base *ab;
 	struct ath12k_hw *ah;
@@ -15467,6 +15468,21 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
 	if (WARN_ON(total_radio > ATH12K_GROUP_MAX_RADIO))
 		return -ENOSPC;
 
+	/*
+	 * Order the devices deterministically by WSI index instead of PCI
+	 * probe completion order, so that the wiphy and the radio index to
+	 * band mapping do not change from boot to boot.
+	 */
+	for (i = 0; i < ag->num_devices; i++) {
+		ab = ag->ab[i];
+		if (!ab)
+			continue;
+		if (WARN_ON(ab->wsi_info.index >= ATH12K_MAX_DEVICES))
+			return -EINVAL;
+
+		ab_order[ab->wsi_info.index] = ab;
+	}
+
 	/* All pdev get combined and register as single wiphy based on
 	 * hardware group which participate in multi-link operation else
 	 * each pdev get register separately.
@@ -15483,12 +15499,12 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
 	mac_id = 0;
 	for (i = 0; i < num_hw; i++) {
 		for (j = 0; j < radio_per_hw; j++) {
-			if (device_id >= ag->num_devices || !ag->ab[device_id]) {
+			if (device_id >= ag->num_devices || !ab_order[device_id]) {
 				ret = -ENOSPC;
 				goto err;
 			}
 
-			ab = ag->ab[device_id];
+			ab = ab_order[device_id];
 
 			/*
 			 * the assumption is all devices within an ah
-- 
2.54.0 (Apple Git-157)

