Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43665 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbcFNGSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 02:18:20 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	<greearb@candelatech.com>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH] ath10k: fix system hang at qca99x0 probe on x86 platform
Date: Tue, 14 Jun 2016 11:47:28 +0530
Message-ID: <20160614061728.570-1-rmanohar@qti.qualcomm.com> (sfid-20160614_081823_559270_92C0791C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit b057886524be ("ath10k: do not use coherent memory for allocated
device memory chunks") replaced coherent memory allocation for memory
chunks to fix low memory platforms. Unfortunately this is causing system
freeze on x86 platform while bringing up qca99x0 device. The system
hangs while DMA mapping bigger memory chunks (689816/865444 bytes). Fix
this by limiting maximum memory chunk size to 256 KiB per request.

Cc: Felix Fietkau <nbd@nbd.name>
Fixes: b057886524be ("ath10k: do not use coherent memory for allocated device memory chunks")
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 6 ++++++
 drivers/net/wireless/ath/ath10k/wmi.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6279ab4a760e..7c15f65fe5ed 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4411,6 +4411,12 @@ static int ath10k_wmi_alloc_chunk(struct ath10k *ar, u32 req_id,
 		if (!pool_size)
 			return -EINVAL;
 
+		if (pool_size > WMI_MAX_MEM_CHUNK_SIZE) {
+			num_units = WMI_MAX_MEM_CHUNK_SIZE /
+					round_up(unit_len, 4);
+			pool_size = num_units * round_up(unit_len, 4);
+		}
+
 		vaddr = kzalloc(pool_size, GFP_KERNEL | __GFP_NOWARN);
 		if (!vaddr)
 			num_units /= 2;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 90f594e89f94..dea1f235a54d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6184,6 +6184,7 @@ struct wmi_roam_ev {
 #define ATH10K_DEFAULT_ATIM 0
 
 #define WMI_MAX_MEM_REQS 16
+#define WMI_MAX_MEM_CHUNK_SIZE (256 * 1024) /* 256 KB */
 
 struct wmi_scan_ev_arg {
 	__le32 event_type; /* %WMI_SCAN_EVENT_ */
-- 
2.8.3

