Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB15A3FFAA6
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 13:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293463; cv=none; b=hMd+djXHP6LZdxr93gIqFCmcei8p7Bnw4nN156KeO/1Hm96aTGsP/OICkFB8JUDXqGlYBQlO1fnCETLlOyrZrtcETgFCJpOKTORXU2Jrj+DOys0PzgeqriBDFyERvBv5HUV585mF0l/533mRPJocl7/P5ejNcccapS87bBuPoHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293463; c=relaxed/simple;
	bh=4Nmg/0QLWXSmTlUWl1fWhL78IAkWNt9MRM6SDkpEXM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GEd306Ag1SBTXUmh3FQcIsvonZd34FEfxBPLY0UZQZJp7px0MK5P4G7hcaGriVCrxQqAiUZFRHYQQp6k23moOz/pMAphjJ68Gob2Js9jYSJNR4a5Dsgf1k7p2ZTzS1xD85cn21qlZ6VGEKR7WKRP/MaSZ4++jFlsBTXAyxfIb9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pokerfj.es; spf=pass smtp.mailfrom=pokerfj.es; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pokerfj.es
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pokerfj.es
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <stian@pokerfj.es>)
	id 1wkiEc-007w39-Rw; Fri, 17 Jul 2026 15:04:10 +0200
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <stian@pokerfj.es>)
	id 1wkiEb-0007t6-Ts; Fri, 17 Jul 2026 15:04:10 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1471791)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wkiEH-006cwm-QR;
	Fri, 17 Jul 2026 15:03:49 +0200
From: Stian Knudsen <stian@pokerfj.es>
To: Jeff Johnson <jjohnson@kernel.org>,
	ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Stian Knudsen <stian@pokerfj.es>
Subject: [PATCH] wifi: ath12k: restore country code during resume
Date: Fri, 17 Jul 2026 15:02:54 +0200
Message-ID: <20260717130254.36732-1-stian@pokerfj.es>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The country code configured before suspend is lost after resume:
the device is powered down in suspend_late and powered back up in
resume_early, so firmware reboots with its default regulatory
settings and the previously set country code is no longer applied.

On WCN7850 the firmware comes back in the world regulatory domain
(country 00) and takes ~7 seconds to rediscover the country code
from AP beacons, part of a ~16 second total delay before wifi
reconnects after resume.

Restore it by resending WMI_SET_CURRENT_COUNTRY_CMDID during resume
if a country code was set before suspend, i.e. when ar->alpha2 is
valid. This follows the same approach as ath11k commit 7f0343b7b871
("wifi: ath11k: restore country code during resume").

Note that only single_pdev_only devices support suspend/resume (see
ath12k_core_continue_suspend_resume()), so handling the first and
only pdev is sufficient.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/-_iDJ_M5RrqACWB0qmtleg@pokerfj.es
Signed-off-by: Stian Knudsen <stian@pokerfj.es>
---
 drivers/net/wireless/ath/ath12k/core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -197,6 +197,7 @@ EXPORT_SYMBOL(ath12k_core_resume_early);

 int ath12k_core_resume(struct ath12k_base *ab)
 {
+	struct ath12k *ar;
 	long time_left;
 	int ret;

@@ -211,6 +212,26 @@ int ath12k_core_resume(struct ath12k_base *ab)
 		return -ETIMEDOUT;
 	}

+	/* So far only single_pdev_only devices can reach here,
+	 * so it is valid to handle the first, and the only, pdev.
+	 */
+	ar = ab->pdevs[0].ar;
+	if (ab->hw_params->current_cc_support &&
+	    ar->alpha2[0] != 0 && ar->alpha2[1] != 0) {
+		struct wmi_set_current_country_arg arg = {};
+
+		memcpy(&arg.alpha2, ar->alpha2, 2);
+
+		reinit_completion(&ar->regd_update_completed);
+
+		ret = ath12k_wmi_send_set_current_country_cmd(ar, &arg);
+		if (ret) {
+			ath12k_warn(ab, "failed to set country code during resume: %d\n",
+				    ret);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(ath12k_core_resume);
--
2.50.0
