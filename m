Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D918493D53;
	Wed, 23 Sep 2026 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165125; cv=none; b=Kmmgjzo7eQGG+ZEB7Oyg36rlRCQsBWp3NNKmRV8jx9+EGHJBo7PIXApB7bFmLFTkPTPOjtRExVtQQE0/scxdI7u6KsKaJntZmajQf29cWTntrzlknSUgfWprJ85ESiU8fXXv2JNcXSR9cNeEGbS6GQ3neIVOrOBmWYqHhR1Tyk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165125; c=relaxed/simple;
	bh=f5A3aOPcpzcnyloEZkCpzWN2JqMgiC0WgPDk/yfr8jk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qhyF43G8LqJ7L6al0FNZk6lWNlKUpIAdMyEGxn4n4qtL3/aTOhCYXaVzOgkRDMnoJjcHQzsfy4OzIYT+gpvFqqprMsDsMBIhSLOrzD/Nv8MJrGSvyXz3BPXoabAj849DBl93AG5+22FPhShlhAoX/bfQEcWQ4qwX8Y89Yk5H9Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HVBX4hOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HVBX4hOh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E8F9C2BCFC;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790165121;
	bh=f5A3aOPcpzcnyloEZkCpzWN2JqMgiC0WgPDk/yfr8jk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HVBX4hOh/YRnQc4UjLUWKa//MqZ9sZsYuIRRDHjz6E181sNABE+xo1K+++sp+Vm5O
	 YoeCJsQBQMR7x7xUVnFfZB3/POrK/G+PpSApVZGgk+D48YOGr0y85pUwigahoyfVF1
	 6REN0Q2O5OzshLTXCZ9ZtQ5JNC0ePgkyQ/Ka/djvJgXi7VDMgucYCsbGT6/PN4Ofic
	 CxXesyhSsGw1MTmcmkvy3BXjx7ZMeKYYX+01aOJkX5g1zu7dU70ZqjLcZcjZtZ3y5T
	 +dAlCNMQfiwqsPKeNMbtkiIFaOE07jmSjVHrmbVK/jFblkENL00sU83gjX+ukcfZtB
	 ZAWFkQqjwWGPw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFABC9830C;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Wed, 23 Sep 2026 16:05:15 +0400
Subject: [PATCH ath-next 09/16] wifi: ath11k: Power down userPD
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-ipq5018-qcn6122-mpd-v1-9-86729521a75c@outlook.com>
References: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
In-Reply-To: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
To: Johannes Berg <johannes@sipsolutions.net>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 ath11k@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com>, 
 Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>, 
 linux-arm-msm@vger.kernel.org, 
 George Moussalem <george.moussalem@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790165117; l=1688;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=f09E/N0UiP2BKaMQj6y/PbCNtm6/77F+Gx3rtxqkmB0=;
 b=8Th6YZPBmOceHukUz3XAVEKAdI2Cb3gd5mOzw5oZb3/5aqmJLgMbeVE3tRwO8PaAU9+RY1cc6
 W713+4AAuEVBuPqzDvgliJZ/m4MhgZmELOS/ZXzN9j2FWPOlmA5dlAo
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

Set the stop bit in SMEM to stop the userPD. Wait for stop-ack IRQ to
indicate power down completion.

For IPQ5018 wifi specifically, invoke an SCM call to power down the
radio.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 2c41cf585d00..1b9115311bed 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -491,9 +491,32 @@ static int ath11k_ahb_power_up(struct ath11k_base *ab)
 	return 0;
 }
 
+static void ath11k_ahb_stop_user_pd(struct ath11k_base *ab)
+{
+	struct ath11k_ahb *ab_ahb = ath11k_ahb_priv(ab);
+	unsigned long time_left;
+
+	qcom_smem_state_update_bits(ab_ahb->stop_state, BIT(ab_ahb->stop_bit),
+				    BIT(ab_ahb->stop_bit));
+
+	time_left = wait_for_completion_timeout(&ab_ahb->userpd_stopped,
+						ATH11K_USERPD_STOP_TIMEOUT);
+	if (!time_left)
+		ath11k_warn(ab, "UserPD stop wait timed out\n");
+
+	qcom_smem_state_update_bits(ab_ahb->stop_state, BIT(ab_ahb->stop_bit), 0);
+
+	if (ab->hw_rev == ATH11K_HW_IPQ5018_HW10)
+		qcom_scm_pas_set_wifi_power_mode(MPD_WCNSS_PAS_ID, false);
+}
+
 static void ath11k_ahb_power_down(struct ath11k_base *ab, bool is_suspend)
 {
-	return;
+	struct ath11k_ahb *ab_ahb = ath11k_ahb_priv(ab);
+
+	if (ab_ahb->userpd_id > 0 &&
+	    ab_ahb->userpd_id < ATH11K_AHB_USERPD_ID_MAX)
+		ath11k_ahb_stop_user_pd(ab);
 }
 
 static void ath11k_ahb_init_qmi_ce_config(struct ath11k_base *ab)

-- 
2.53.0


