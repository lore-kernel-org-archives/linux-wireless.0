Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34953 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbbCWMlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 08:41:09 -0400
Received: by laae1 with SMTP id e1so784625laa.2
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 05:41:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: allow loading device specific board files
Date: Mon, 23 Mar 2015 12:38:21 +0000
Message-Id: <1427114301-18886-3-git-send-email-michal.kazior@tieto.com> (sfid-20150323_134113_612799_E1C13C35)
In-Reply-To: <1427114301-18886-1-git-send-email-michal.kazior@tieto.com>
References: <1427114301-18886-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices differ slightly and require different
board files. These devices can be differentiated
by looking at PCI subsystem device id. That is the
case for qca6174 devices at least.

Use that and load subsystem id specific board
files if possible. Otherwise fall back to use the
(old) generic board file path.

Using wrong board data may cause device crashes or
invalid behaviour (wrong tx power, garbled RF
signal).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c  | 55 ++++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/core.h  |  3 ++
 drivers/net/wireless/ath/ath10k/debug.c |  6 +++-
 drivers/net/wireless/ath/ath10k/pci.c   |  5 +++
 4 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1785e0e..12da7fa 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -482,10 +482,26 @@ static int ath10k_fetch_cal_file(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_core_fetch_board_file(struct ath10k *ar)
+static int ath10k_core_fetch_spec_board_file(struct ath10k *ar)
 {
-	int ret;
+	char filename[100];
 
+	scnprintf(filename, sizeof(filename), "board-%s-%s.bin",
+		  ath10k_bus_str(ar->hif.bus), ar->spec_board_id);
+
+	ar->board = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, filename);
+	if (IS_ERR(ar->board))
+		return PTR_ERR(ar->board);
+
+	ar->board_data = ar->board->data;
+	ar->board_len = ar->board->size;
+	ar->spec_board_loaded = true;
+
+	return 0;
+}
+
+static int ath10k_core_fetch_generic_board_file(struct ath10k *ar)
+{
 	if (!ar->hw_params.fw.board) {
 		ath10k_err(ar, "failed to find board file fw entry\n");
 		return -EINVAL;
@@ -494,14 +510,39 @@ static int ath10k_core_fetch_board_file(struct ath10k *ar)
 	ar->board = ath10k_fetch_fw_file(ar,
 					 ar->hw_params.fw.dir,
 					 ar->hw_params.fw.board);
-	if (IS_ERR(ar->board)) {
-		ret = PTR_ERR(ar->board);
-		ath10k_err(ar, "failed to fetch board data: %d\n", ret);
-		return ret;
-	}
+	if (IS_ERR(ar->board))
+		return PTR_ERR(ar->board);
 
 	ar->board_data = ar->board->data;
 	ar->board_len = ar->board->size;
+	ar->spec_board_loaded = false;
+
+	return 0;
+}
+
+static int ath10k_core_fetch_board_file(struct ath10k *ar)
+{
+	int ret;
+
+	if (strlen(ar->spec_board_id) > 0) {
+		ret = ath10k_core_fetch_spec_board_file(ar);
+		if (ret) {
+			ath10k_info(ar, "failed to load spec board file, falling back to generic: %d\n",
+				    ret);
+			goto generic;
+		}
+
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "found specific board file for %s\n",
+			   ar->spec_board_id);
+		return 0;
+	}
+
+generic:
+	ret = ath10k_core_fetch_generic_board_file(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to fetch generic board data: %d\n", ret);
+		return ret;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c1f43b0..90b5b10 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -568,6 +568,9 @@ struct ath10k {
 
 	const struct firmware *cal_file;
 
+	char spec_board_id[100];
+	bool spec_board_loaded;
+
 	int fw_api;
 	enum ath10k_cal_mode cal_mode;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 301081d..9c824e2 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -124,10 +124,14 @@ EXPORT_SYMBOL(ath10k_info);
 
 void ath10k_print_driver_info(struct ath10k *ar)
 {
-	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
+	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
+		    (strlen(ar->spec_board_id) > 0 ? ", " : ""),
+		    ar->spec_board_id,
+		    (strlen(ar->spec_board_id) > 0 && !ar->spec_board_loaded
+		     ? " fallback" : ""),
 		    ar->hw->wiphy->fw_version,
 		    ar->fw_api,
 		    ar->htt.target_version_major,
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b4aacfa..1e528bc 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2627,6 +2627,11 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci->dev = &pdev->dev;
 	ar_pci->ar = ar;
 
+	if (pdev->subsystem_vendor || pdev->subsystem_device)
+		scnprintf(ar->spec_board_id, sizeof(ar->spec_board_id),
+			  "0x%04x:0x%04x",
+			  pdev->subsystem_vendor, pdev->subsystem_device);
+
 	spin_lock_init(&ar_pci->ce_lock);
 	setup_timer(&ar_pci->rx_post_retry, ath10k_pci_rx_replenish_retry,
 		    (unsigned long)ar);
-- 
2.1.4

