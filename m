Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38097 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbbEZOA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:00:28 -0400
Received: by wichy4 with SMTP id hy4so83047098wic.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 07:00:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: add missing firmware declarations
Date: Tue, 26 May 2015 13:09:22 +0200
Message-Id: <1432638562-12954-1-git-send-email-michal.kazior@tieto.com> (sfid-20150526_160032_256741_C2406398)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This could lead userspace initram images getting
built without necessary firmware files included
leading to probing failures of ath10k on boot with
QCA61X4.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 969a1231800e..d88be9f8c2d3 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2790,8 +2790,10 @@ MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_BOARD_DATA_FILE);
 
 /* QCA6174 2.1 firmware files */
 MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" ATH10K_FW_API4_FILE);
+MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" ATH10K_FW_API5_FILE);
 MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" QCA6174_HW_2_1_BOARD_DATA_FILE);
 
 /* QCA6174 3.1 firmware files */
 MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" ATH10K_FW_API4_FILE);
+MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" ATH10K_FW_API5_FILE);
 MODULE_FIRMWARE(QCA6174_HW_3_0_FW_DIR "/" QCA6174_HW_3_0_BOARD_DATA_FILE);
-- 
2.1.4

