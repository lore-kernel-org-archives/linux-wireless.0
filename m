Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47820 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbFGN4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 09:56:39 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 2/6] wil6210: add NIC memory region mac_rgf_ext
Date: Sun,  7 Jun 2015 16:56:27 +0300
Message-Id: <1433685391-9026-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150607_155648_254940_40A8CBE0)
In-Reply-To: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware defines new memory region, mac_rgf_ext
that need to be accessed from the host for debug purposes.

Add corresponded mapping

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f3513a1..ea0163c 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -281,7 +281,7 @@ struct fw_map {
 };
 
 /* array size should be in sync with actual definition in the wmi.c */
-extern const struct fw_map fw_mapping[7];
+extern const struct fw_map fw_mapping[8];
 
 /**
  * mk_cidxtid - construct @cidxtid field
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 3dc8daf..26c707f 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -85,6 +85,7 @@ const struct fw_map fw_mapping[] = {
 	{0x880000, 0x88a000, 0x880000, "rgf"},     /* various RGF       40k */
 	{0x88a000, 0x88b000, 0x88a000, "AGC_tbl"}, /* AGC table          4k */
 	{0x88b000, 0x88c000, 0x88b000, "rgf_ext"}, /* Pcie_ext_rgf       4k */
+	{0x88c000, 0x88c200, 0x88c000, "mac_rgf_ext"}, /* mac_ext_rgf  512b */
 	{0x8c0000, 0x949000, 0x8c0000, "upper"},   /* upper area       548k */
 	/*
 	 * 920000..930000 ucode code RAM
-- 
2.1.4

