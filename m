Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A493B7B94;
	Mon, 30 Mar 2026 10:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774865167; cv=none; b=EMHi1nMzaFFTrYEnkKSlF+W4Rpl2QXdslaGI4klpRzc7cIfYYbUktipDfuIyKmAawVzdELZVagjJItPyH3gSAr0M3fmWJsyYI8NRKkwYs8iK45YW7DIObYW2hgre23HIz81Ea8LH3Q/6zeg7lbZFaYMwCkKieBau/pz0Bz9tbq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774865167; c=relaxed/simple;
	bh=hof7rouX38nmEzoDefI3x1AgAGZp8Hxze5p0FV+9bmU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U7yvrV3UcVW+0j+an+/fB3lSKPrSHsZ1ZJSLfV/gzwtyhE/l4niOIxf2utnIqBxu8LMYc8t4whtH9nN85xlXvNyx+EKdZruIknmTUwvHVXT5tbgdhvkaOyMstmwZW7+JML8ifYlPhU3mBUzQseYLDZ4yTCxUrDzm9fXJyc15xYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=F8l017a6; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="F8l017a6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1774865159;
	bh=hof7rouX38nmEzoDefI3x1AgAGZp8Hxze5p0FV+9bmU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=F8l017a6jNR8NndedfguN48w4q6E9iPXvyzJRDXbsqK+z4SEGeRuPFWg6EWdcww1H
	 UKIJVr/UfRo4o9u8WyVjRFD+PSFOzs94LMrY+Zg9Tre8nPw48XKm6/RVeTxuvoW7g1
	 i2zYy1PoZOC7hB6s7IgfmO2hiY2IlSMhOXkrr4VmfvxkX08M0d7yBGiGEptV50YG1K
	 C9FK0rSXI7T5Oenk5cl6V7Ksqd22HBjCsgnnG23HOALuYNb079BDR4RDQJEdwRfheS
	 P8oa5nlOVejlV85ABGu2sICw9gOBqp0RR/ZxXbTVMy2Gek5KleCW71VXWHty3Dyk0P
	 Y5O/21hZD5oIw==
Received: from [192.168.1.53] (unknown [IPv6:2a01:6243:628:0:43ea:f64d:fc7e:3a2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mattl)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id CEBD217E41B3;
	Mon, 30 Mar 2026 12:05:58 +0200 (CEST)
From: Matthew Leach <matthew.leach@collabora.com>
Date: Mon, 30 Mar 2026 11:05:32 +0100
Subject: [PATCH RESEND RFC 2/3] net: ath11k: add firmware lockup detection
 and recovery
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260330-ath11k-lockup-fixes-v1-2-7ed21095c2c4@collabora.com>
References: <20260330-ath11k-lockup-fixes-v1-0-7ed21095c2c4@collabora.com>
In-Reply-To: <20260330-ath11k-lockup-fixes-v1-0-7ed21095c2c4@collabora.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kernel@collabora.com, 
 Matthew Leach <matthew.leach@collabora.com>
X-Mailer: b4 0.15.0

Detect firmware lockup when a WMI command times out and TX descriptor
exhaustion occurs within ATH11K_LOCKUP_DESC_ERR_RANGE_HZ (1 minute). In
this case, consider the firmware dead.

When a lockup is detected, queue reset work to restart the chip.
After reset completes, clear the lockup detection state.

Signed-off-by: Matthew Leach <matthew.leach@collabora.com>
---
 drivers/net/wireless/ath/ath11k/core.h |  2 ++
 drivers/net/wireless/ath/ath11k/mac.c  |  6 ++++++
 drivers/net/wireless/ath/ath11k/wmi.c  | 24 +++++++++++++++++++++++-
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index a0d725923ef2..221dcd23b3dd 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -70,6 +70,7 @@ extern bool ath11k_ftm_mode;
 #define ATH11K_RESET_FAIL_TIMEOUT_HZ (20 * HZ)
 #define ATH11K_RECONFIGURE_TIMEOUT_HZ (10 * HZ)
 #define ATH11K_RECOVER_START_TIMEOUT_HZ (20 * HZ)
+#define ATH11K_LOCKUP_DESC_ERR_RANGE_HZ (60 * HZ)
 
 enum ath11k_supported_bw {
 	ATH11K_BW_20	= 0,
@@ -1039,6 +1040,7 @@ struct ath11k_base {
 
 	struct ath11k_dbring_cap *db_caps;
 	u32 num_db_cap;
+	u64 last_frame_tx_error_jiffies;
 
 	/* To synchronize 11d scan vdev id */
 	struct mutex vdev_id_11d_lock;
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 748f779b3d1b..a0b4d60da330 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -9,6 +9,7 @@
 #include <linux/etherdevice.h>
 #include <linux/bitfield.h>
 #include <linux/inetdevice.h>
+#include <linux/jiffies.h>
 #include <net/if_inet6.h>
 #include <net/ipv6.h>
 
@@ -6546,6 +6547,10 @@ static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
 
 	ret = ath11k_dp_tx(ar, arvif, arsta, skb);
 	if (unlikely(ret)) {
+		scoped_guard(spinlock_bh, &ar->ab->base_lock) {
+			ar->ab->last_frame_tx_error_jiffies = jiffies_64;
+		}
+
 		ath11k_warn(ar->ab, "failed to transmit frame %d\n", ret);
 		ieee80211_free_txskb(ar->hw, skb);
 	}
@@ -9281,6 +9286,7 @@ ath11k_mac_op_reconfig_complete(struct ieee80211_hw *hw,
 				atomic_dec(&ab->reset_count);
 				complete(&ab->reset_complete);
 				ab->is_reset = false;
+				ab->last_frame_tx_error_jiffies = 0;
 				atomic_set(&ab->fail_cont_count, 0);
 				ath11k_dbg(ab, ATH11K_DBG_BOOT, "reset success\n");
 			}
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 40747fba3b0c..7d9f0bcbb3b0 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -7,8 +7,11 @@
 #include <linux/ctype.h>
 #include <net/mac80211.h>
 #include <net/cfg80211.h>
+#include <linux/cleanup.h>
 #include <linux/completion.h>
 #include <linux/if_ether.h>
+#include <linux/jiffies.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/uuid.h>
@@ -325,9 +328,28 @@ int ath11k_wmi_cmd_send(struct ath11k_pdev_wmi *wmi, struct sk_buff *skb,
 			}), WMI_SEND_TIMEOUT_HZ);
 	}
 
-	if (ret == -EAGAIN)
+	if (ret == -EAGAIN) {
+		u64 range_start;
+
 		ath11k_warn(wmi_ab->ab, "wmi command %d timeout\n", cmd_id);
 
+		guard(spinlock_bh)(&ab->base_lock);
+
+		if (ab->last_frame_tx_error_jiffies == 0)
+			return ret;
+
+		range_start =
+			(jiffies_64 > ATH11K_LOCKUP_DESC_ERR_RANGE_HZ) ?
+				jiffies_64 - ATH11K_LOCKUP_DESC_ERR_RANGE_HZ :
+				0;
+
+		if (time_in_range64(ab->last_frame_tx_error_jiffies,
+				    range_start, jiffies_64) &&
+		    queue_work(ab->workqueue_aux, &ab->reset_work))
+			ath11k_err(wmi_ab->ab,
+				   "Firmware lockup detected.  Resetting.");
+	}
+
 	if (ret == -ENOBUFS)
 		ath11k_warn(wmi_ab->ab, "ce desc not available for wmi command %d\n",
 			    cmd_id);

-- 
2.53.0

