Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbeHOMSR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 08:18:17 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, briannorris@chromium.org,
        niklas.cassel@linaro.org, bjorn.andersson@linaro.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v5 2/6] ath10k: Add support to create boardname for non-bmi target
Date: Wed, 15 Aug 2018 14:56:33 +0530
Message-Id: <20180815092637.11455-3-govinds@codeaurora.org> (sfid-20180815_112656_466837_280DC7B1)
In-Reply-To: <20180815092637.11455-1-govinds@codeaurora.org>
References: <20180815092637.11455-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rakesh Pillai <pillair@codeaurora.org>

Add support to create the boardname for non-bmi targets
like WCN3990, which uses qmi for bdf download. This
boardname is used to parse the board data from board-2.bin.

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 8 ++++++++
 drivers/net/wireless/ath/ath10k/core.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 85c58ebbfb26..840e301b6a6e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1440,6 +1440,14 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 		goto out;
 	}
 
+	if (ar->id.qmi_ids_valid) {
+		scnprintf(name, name_len,
+			  "bus=%s,qmi-board-id=%x",
+			  ath10k_bus_str(ar->hif.bus),
+			  ar->id.qmi_board_id);
+		goto out;
+	}
+
 	scnprintf(name, name_len,
 		  "bus=%s,vendor=%04x,device=%04x,subsystem-vendor=%04x,subsystem-device=%04x%s",
 		  ath10k_bus_str(ar->hif.bus),
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 427ee5752bb0..3a4ac3c0d5a6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -941,6 +941,8 @@ struct ath10k {
 		u32 subsystem_device;
 
 		bool bmi_ids_valid;
+		bool qmi_ids_valid;
+		u32 qmi_board_id;
 		u8 bmi_board_id;
 		u8 bmi_chip_id;
 
-- 
2.17.0
