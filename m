Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:57470 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaHYKXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 06:23:01 -0400
Received: by mail-la0-f42.google.com with SMTP id pv20so12669726lab.29
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2014 03:22:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix fw crash dumping
Date: Mon, 25 Aug 2014 12:13:14 +0200
Message-Id: <1408961594-2440-1-git-send-email-michal.kazior@tieto.com> (sfid-20140825_122306_143186_24C5305E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent crash dump patches introduced a regression.
If debugfs was disabled upon crash user could only
see the following:

 [  793.880000] ath10k: firmware crashed! (uuid n/a)
 [  793.890000] ath10k: qca988x hw2.0 (0x4100016c, 0x043202ff) fw 10.1.467.2-1 api 2 htt 2.1
 [  793.890000] ath10k: debug 0 debugfs 0 tracing 0 dfs 1

The report was missing register dump. Fix it by
printing registers regardless if crash_data is
present or not.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
Note: This is based on my logging patch.

 drivers/net/wireless/ath/ath10k/pci.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 83ef6ef..144eb8a3 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -916,6 +916,9 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
 
+	if (!crash_data)
+		return;
+
 	/* crash_data is in little endian */
 	for (i = 0; i < REG_DUMP_COUNT_QCA988X; i++)
 		crash_data->registers[i] = cpu_to_le32(reg_dump_values[i]);
@@ -937,13 +940,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 
 	ath10k_err(ar, "firmware crashed! (uuid %s)\n", uuid);
 	ath10k_print_driver_info(ar);
-
-	if (!crash_data)
-		goto exit;
-
 	ath10k_pci_dump_registers(ar, crash_data);
 
-exit:
 	spin_unlock_bh(&ar->data_lock);
 
 	queue_work(ar->workqueue, &ar->restart_work);
-- 
1.8.5.3

