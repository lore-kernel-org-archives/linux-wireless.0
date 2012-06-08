Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31290 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076Ab2FHH4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 03:56:12 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20433.45007.548676.466652@gargle.gargle.HOWL> (sfid-20120608_095617_155276_0A53C109)
Date: Fri, 8 Jun 2012 13:24:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_hw: Initvals update for AR9462
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MSI is enabled by default for most of the 4th generation
chips. Add this for AR9462 - this fixes PowerSave operation,
the chip was not entering Network-Sleep mode earlier.
With proper powering down of the MAC now, power consumption
in associated state is reduced considerably.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index a10ece0..4a93e15 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -1007,6 +1007,7 @@ static const u32 ar9462_2p0_radio_core[][2] = {
 
 static const u32 ar9462_2p0_soc_preamble[][2] = {
 	/* Addr      allmodes  */
+	{0x000040a4 ,0x00a0c1c9},
 	{0x00007020, 0x00000000},
 	{0x00007034, 0x00000002},
 	{0x00007038, 0x000004c2},
-- 
1.7.10.3

