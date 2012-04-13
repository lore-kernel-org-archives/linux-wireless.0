Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28179 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab2DMHps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 03:45:48 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k: fix ibss fair beacon distribution for AR9462
Date: Fri, 13 Apr 2012 13:16:33 +0530
Message-ID: <1334303194-7626-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120413_094552_915314_7A41EFFB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update AR9462 initval to fix unbalance beacon distribution
in Ad-Hoc network.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index b39870c..1d6658e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -1115,9 +1115,9 @@ static const u32 ar9462_2p0_mac_core[][2] = {
 	{0x000081f8, 0x00000000},
 	{0x000081fc, 0x00000000},
 	{0x00008240, 0x00100000},
-	{0x00008244, 0x0010f400},
+	{0x00008244, 0x0010f424},
 	{0x00008248, 0x00000800},
-	{0x0000824c, 0x0001e800},
+	{0x0000824c, 0x0001e848},
 	{0x00008250, 0x00000000},
 	{0x00008254, 0x00000000},
 	{0x00008258, 0x00000000},
-- 
1.7.10

