Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:36439 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbbDQJWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 05:22:44 -0400
Received: by lagv1 with SMTP id v1so75602854lag.3
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2015 02:22:42 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/2] ath10k: allow loading device specific board files
Date: Fri, 17 Apr 2015 09:19:17 +0000
Message-Id: <1429262357-25139-2-git-send-email-michal.kazior@tieto.com> (sfid-20150417_112248_593121_36388AA0)
In-Reply-To: <1429262357-25139-1-git-send-email-michal.kazior@tieto.com>
References: <1429262357-25139-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices differ slightly and require different
board files. If wrong board data is used they
crash or behave incorrectly.

These devices can be differentiated by looking at
PCI subsystem device id. That is the case for
qca61x4 devices at least.

The board specific filename is constructed as:

 board-<bus>-<id>.bin

For PCI in particular it is:

 board-pci-<vendor>:<dev>:<subsys_vendor>:<subsys_dev>.bin

These files are looked in device/hw specific
directories. Hence for Killer 1525 (qca6174 hw2.1)
ath10k will request:

  /lib/firmware/ath10k/QCA6174/hw2.1/board-pci-168c:003e:1a56:1525.bin

To not break any existing setups (e.g. in case
some devices in the wild already have subsys ids)
if a board specific file isn't found a generic one
is used which is the one which would be used until
now. This guarantees that after upgrading a driver
device will not suddenly stop working due to
now-missing specific board file. If this is the
case a "fallback" string is appended to the info
string when driver boots.

Keep in mind this is distinct from cal-pci-*.bin
files which contain full calibration data and MAC
address. Cal data is aimed at systems where
calibration data is stored out of band, e.g. on
nand flash instead of device EEPROM - an approach
taken by some AP/router vendors.

Board files are more of a template and needs some
bits to be filled in by the OTP program using
device EEPROM contents.

One could argue to map subsystem ids to some board
design codename strings instead of using raw ids
when building the board filename. Using a mapping
however would make it a lot more cumbersome and
time consuming (due to how patches propagate over
various kernel trees) to add support for some new
device board designs. Adding a board file is a lot
quicker and doesn't require recompilation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * drop `0x` prefix
     * add device/vendor id's into the spec_board_id
       to avoid possible future namespace conflicts
     * improve commit log

 drivers/net/wireless/ath/ath10k/core.c  | 55 ++++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/core.h  |  3 ++
 drivers/net/wireless/ath/ath10k/debug.c |  6 +++-
 drivers/net/wireless/ath/ath10k/pci.c   |  6 ++++
 4 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 70f5b7acc411..987b266278a8 100644
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
index b0e8905ca325..7bb113a443d7 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -592,6 +592,9 @@ struct ath10k {
 
 	const struct firmware *cal_file;
 
+	char spec_board_id[100];
+	bool spec_board_loaded;
+
 	int fw_api;
 	enum ath10k_cal_mode cal_mode;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 1391f00f2b8f..8fa606a9c4dd 100644
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
index 1f770ac28df4..9dc0079a8ea6 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2627,6 +2627,12 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci->dev = &pdev->dev;
 	ar_pci->ar = ar;
 
+	if (pdev->subsystem_vendor || pdev->subsystem_device)
+		scnprintf(ar->spec_board_id, sizeof(ar->spec_board_id),
+			  "%04x:%04x:%04x:%04x",
+			  pdev->vendor, pdev->device,
+			  pdev->subsystem_vendor, pdev->subsystem_device);
+
 	spin_lock_init(&ar_pci->ce_lock);
 	setup_timer(&ar_pci->rx_post_retry, ath10k_pci_rx_replenish_retry,
 		    (unsigned long)ar);
-- 
2.1.4

