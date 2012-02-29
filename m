Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16467 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab2B2BZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 20:25:51 -0500
From: Etay Luz <eluz@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Collect residue firmware logs
Date: Tue, 28 Feb 2012 17:18:04 -0800
Message-ID: <1330478284-29968-1-git-send-email-eluz@qca.qualcomm.com> (sfid-20120229_022554_617470_E568B593)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Collect residue firmware logs following firmware assert.
Firmware sends logs to host once the 1500 byte log buffer
has been filled. At time of assert, there could be residue
logs lying in the firmware. This patch pulls those residue
logs. This would give the full picture of the firmware.

Signed-off-by: Etay Luz <eluz@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index ef650b6..3e569b2 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -135,6 +135,7 @@ static int ath6kl_hif_proc_dbg_intr(struct ath6kl_device *dev)
 		ath6kl_warn("Failed to clear debug interrupt: %d\n", ret);
 
 	ath6kl_hif_dump_fw_crash(dev->ar);
+	ath6kl_read_fwlogs(dev->ar);
 
 	return ret;
 }
-- 
1.7.0.4

