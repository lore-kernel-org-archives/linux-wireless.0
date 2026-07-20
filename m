Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48A940E8C2
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784549806; cv=none; b=lJKsRrZTUNkppgg+W0UPcncYjXp8LsRNhSQie0ElnkxYQ3djg2qag223fBYy7SWZEU2QeodkI6TEhfo7xCMbFLjPllWDZXZfNg0nBulNVT/3kRme3Kqd+p8gQxmdXQjvyLwAgDBPoDMuKGztOaJSwy4GFK8v8WCzrAdYbCrnQ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784549806; c=relaxed/simple;
	bh=JqUrzWVWxHZ5K5VtyNF2MOzrB4NLY1FHBDIwYs8eNFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilq82u5iJfVuzwGDTSQXo4Fc+nsHhHPL6J3Zvp/knY8HGQXSY359AD+JnTCxcijh5Mqhxd7xBf/bkyPDhlzpnF7DZ0DHeCp3uh1oGWN05Y3032hhOBIIHRugCDZwmRZhjY3wJZ7oePKb6/xUzUowCFOz17uLzaOOzCVt6EQ/8cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pokerfj.es; spf=pass smtp.mailfrom=pokerfj.es; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pokerfj.es
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pokerfj.es
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <stian@pokerfj.es>)
	id 1wlmuw-00GPpW-Ac; Mon, 20 Jul 2026 14:16:18 +0200
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <stian@pokerfj.es>)
	id 1wlmuv-0006wl-TN; Mon, 20 Jul 2026 14:16:18 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1471791)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wlmuT-00FXfm-JJ;
	Mon, 20 Jul 2026 14:15:49 +0200
From: Stian Knudsen <stian@pokerfj.es>
To: Jeff Johnson <jjohnson@kernel.org>,
	ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Stian Knudsen <stian@pokerfj.es>
Subject: [PATCH v2] wifi: ath12k: restore country code during resume
Date: Mon, 20 Jul 2026 14:09:13 +0200
Message-ID: <20260720120913.100604-1-stian@pokerfj.es>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <df37460e-f8ba-4e11-b412-4aa8b17cd32e@oss.qualcomm.com>
References: <df37460e-f8ba-4e11-b412-4aa8b17cd32e@oss.qualcomm.com>
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

Fixes: 8d5f4da8d70b ("wifi: ath12k: support suspend/resume")
Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/-_iDJ_M5RrqACWB0qmtleg@pokerfj.es
Signed-off-by: Stian Knudsen <stian@pokerfj.es>
---
v2:
- Add Fixes tag, per Baochen's review comment.
- Link to v1: https://lore.kernel.org/r/20260717130254.36732-1-stian@pokerfj.es
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
