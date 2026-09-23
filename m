Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EA651475A;
	Wed, 23 Sep 2026 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165125; cv=none; b=l7dByBlo14o9V0L9cmG4OYSPW0qgxYWam/BUI4+9R5nevkaxrDloXSG3yWbnQhBxlnZ6bBo3+/fX9rStI/HfMv6BFUzZVs9JTs9u8mBlCAKYe3/hCqFwW5sq5m4bJhFzZ73BMQAjD4fj5TK5sQ+78jJw+o6DNKY5MIGZaBFtqr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165125; c=relaxed/simple;
	bh=+v0rqjwUQgtaaLTpQID1QK2JxJIvh8LNAtxyU29DchY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aWvLnxMXOv8DEtQ8MzKUIdKzugMdRoK8e2va/tAkgoUNIE44j5IbD8D8M2NWkwnD19aRrYUPw8AyMPRvI5SgisZgdX8yIY83TANd9QWutaaSYu1KBZAicoxaDlhgF+zmKlL4CWNWoGy+3+8/sAYVSBOJQVTMMwZ5tpdP3HIxxqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cg9fvkrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cg9fvkrP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CF48C2BCFA;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790165121;
	bh=+v0rqjwUQgtaaLTpQID1QK2JxJIvh8LNAtxyU29DchY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Cg9fvkrP3kshvhtKyRAX5GHIfxGh0kON0BidN4V9+GXFGNEjTBGNQPU88ES9ggAjf
	 AVVf++CwoM8jNmOXIFUlPDfj0yVoBMkuLfaPufYNXURz3VRrbbSJz8sxDkJfNOiWvT
	 u1B/M/+h3hRq+hu8Tzpvqr8sjDjSRpkAVQei5nxi+FX7HbttEIg1uLvP6/IpYhY2/Z
	 xrF/D6GkU/80ScHh8YRXfvwXUp9DBS1LBtSUOfYgrkLnb6+mDRRPup4AXhjsKj4yeh
	 nDFdqbNoTdW8hPUBxqwC88der3RQGMQNTRVa7vwHyFLTVh2kpGFpO0IcRSryVO/Cea
	 vgAOxxUBopBcQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A42CC982FA;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Wed, 23 Sep 2026 16:05:14 +0400
Subject: [PATCH ath-next 08/16] wifi: ath11k: Power up userPD
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-ipq5018-qcn6122-mpd-v1-8-86729521a75c@outlook.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790165117; l=3294;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=blryMPihJDe3QtxZzbmPzNM8CFDhfBVHVgX5a2hkIxQ=;
 b=9hjw2jEOld1XMsIhO0M9lg/fpvmOgz2+LYOHgijLKI10d7TIalZds5O8qjonbkonLd7w3aGfz
 UYDqoL8Ic3xDweFd1/CEGee56UJzQ8HCr3zCn0pHOLkDLJTggLjsnMI
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

Set the spawn bit to instruct Q6 to spawn the userPD thread.
Wait for userPD to spawn which is indicated by spawn interrupt. The
ready interrupt is triggered once the userPD is powered up completely.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 56 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/ahb.h |  7 +++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 25f9a992a7d2..2c41cf585d00 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -11,6 +11,7 @@
 #include <linux/of.h>
 #include <linux/of_reserved_mem.h>
 #include <linux/dma-mapping.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/iommu.h>
 #include "ahb.h"
 #include "debug.h"
@@ -430,8 +431,63 @@ static void ath11k_ahb_stop(struct ath11k_base *ab)
 	ath11k_ce_cleanup_pipes(ab);
 }
 
+static int ath11k_ahb_boot_user_pd(struct ath11k_base *ab)
+{
+	struct ath11k_ahb *ab_ahb = ath11k_ahb_priv(ab);
+	unsigned long time_left;
+	int ret;
+
+	if (ab->hw_rev == ATH11K_HW_IPQ5018_HW10) {
+		ret = qcom_scm_pas_set_wifi_power_mode(MPD_WCNSS_PAS_ID, true);
+		if (ret) {
+			ath11k_err(ab, "failed to power up wifi: %d\n", ret);
+			return ret;
+		}
+	}
+
+	ret = qcom_smem_state_update_bits(ab_ahb->spawn_state, BIT(ab_ahb->spawn_bit),
+					  BIT(ab_ahb->spawn_bit));
+	if (ret) {
+		ath11k_err(ab, "Failed to update spawn state %d\n", ret);
+		return ret;
+	}
+
+	time_left = wait_for_completion_timeout(&ab_ahb->userpd_spawned,
+						ATH11K_USERPD_SPAWN_TIMEOUT);
+	if (!time_left) {
+		ath11k_err(ab, "UserPD spawn wait timed out\n");
+		return -ETIMEDOUT;
+	}
+
+	time_left = wait_for_completion_timeout(&ab_ahb->userpd_ready,
+						ATH11K_USERPD_READY_TIMEOUT);
+	if (!time_left) {
+		ath11k_err(ab, "UserPD ready wait timed out\n");
+		return -ETIMEDOUT;
+	}
+
+	qcom_smem_state_update_bits(ab_ahb->spawn_state, BIT(ab_ahb->spawn_bit), 0);
+
+	ath11k_dbg(ab, ATH11K_DBG_AHB, "UserPD%d is now UP\n", ab_ahb->userpd_id);
+
+	return 0;
+}
+
 static int ath11k_ahb_power_up(struct ath11k_base *ab)
 {
+	struct ath11k_ahb *ab_ahb = ath11k_ahb_priv(ab);
+	int ret;
+
+	if (ab_ahb->userpd_id > 0 &&
+	    ab_ahb->userpd_id < ATH11K_AHB_USERPD_ID_MAX) {
+		ret = ath11k_ahb_boot_user_pd(ab);
+		if (ret) {
+			ath11k_err(ab, "failed to boot userPD%d: %d\n",
+				   ab_ahb->userpd_id, ret);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath11k/ahb.h b/drivers/net/wireless/ath/ath11k/ahb.h
index 12e0c4d27a0c..0647bdb9ea62 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.h
+++ b/drivers/net/wireless/ath/ath11k/ahb.h
@@ -19,6 +19,13 @@
 #define ATH11K_ROOTPD_READY_TIMEOUT		(5 * HZ)
 #define ATH11K_RPROC_AFTER_POWERUP		QCOM_SSR_AFTER_POWERUP
 
+#define ATH11K_USERPD_SPAWN_TIMEOUT		(5 * HZ)
+#define ATH11K_USERPD_READY_TIMEOUT		(10 * HZ)
+#define ATH11K_USERPD_STOP_TIMEOUT		(5 * HZ)
+#define ATH11K_USERPD_FW_NAME_LEN		35
+
+#define MPD_WCNSS_PAS_ID			0xD
+
 enum ath11k_ahb_userpd_id {
 	ATH11K_AHB_USERPD_ID_1 = 1,
 	ATH11K_AHB_USERPD_ID_MAX,

-- 
2.53.0


