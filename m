Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:46946 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759746AbbBIOGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 09:06:04 -0500
Received: by lams18 with SMTP id s18so13558775lam.13
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 06:06:02 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: workaround corrupted htt rx events
Date: Mon,  9 Feb 2015 15:04:55 +0100
Message-Id: <1423490695-24829-1-git-send-email-michal.kazior@tieto.com> (sfid-20150209_150608_913384_A2438FC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca6174 WLAN.RM.2.0-00073 firmware uses full rx
reordering offload and delivers Rx via a new HTT
event. The event however is incorrectly generated
in firmware and becomes overly long (with trailing
garbage). This was hitting defined CE buffer limit
that was programmed to the device and caused
device to crash upon busier Rx traffic.

Increasing the CE buffer limit for HTT Rx pipe to
2KBytes seems to be enough to workaround this
problem.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e6972b0..7681237 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -104,7 +104,7 @@ static const struct ce_attr host_ce_config_wlan[] = {
 	{
 		.flags = CE_ATTR_FLAGS,
 		.src_nentries = 0,
-		.src_sz_max = 512,
+		.src_sz_max = 2048,
 		.dest_nentries = 512,
 	},
 
@@ -174,7 +174,7 @@ static const struct ce_pipe_config target_ce_config_wlan[] = {
 		.pipenum = __cpu_to_le32(1),
 		.pipedir = __cpu_to_le32(PIPEDIR_IN),
 		.nentries = __cpu_to_le32(32),
-		.nbytes_max = __cpu_to_le32(512),
+		.nbytes_max = __cpu_to_le32(2048),
 		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
 		.reserved = __cpu_to_le32(0),
 	},
-- 
1.8.5.3

