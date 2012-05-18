Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33087 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2EROGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 10:06:32 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 01/10] ath9k_hw: update ar9462 initval table to fix rx nfcal
Date: Fri, 18 May 2012 19:37:24 +0530
Message-ID: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120518_160636_831636_F87486B6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wrong ADC sample phase that happen between awake and
network/full sleep will lead to improper rx noisefloor
calibration.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 1d6658e..a10ece0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -958,7 +958,7 @@ static const u32 ar9462_2p0_radio_core[][2] = {
 	{0x0001604c, 0x2699e04f},
 	{0x00016050, 0x6db6db6c},
 	{0x00016058, 0x6c200000},
-	{0x00016080, 0x00040000},
+	{0x00016080, 0x000c0000},
 	{0x00016084, 0x9a68048c},
 	{0x00016088, 0x54214514},
 	{0x0001608c, 0x1203040b},
@@ -981,7 +981,7 @@ static const u32 ar9462_2p0_radio_core[][2] = {
 	{0x00016144, 0x02084080},
 	{0x00016148, 0x000080c0},
 	{0x00016280, 0x050a0001},
-	{0x00016284, 0x3d841400},
+	{0x00016284, 0x3d841418},
 	{0x00016288, 0x00000000},
 	{0x0001628c, 0xe3000000},
 	{0x00016290, 0xa1005080},
-- 
1.7.10.2

