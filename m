Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37821 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911Ab2ESIun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 04:50:43 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <mcgrof@frijolero.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] atheros-initvals: update ar9462 initval table to fix rx nfcal
Date: Sat, 19 May 2012 14:20:32 +0530
Message-ID: <1337417432-1703-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120519_105052_624450_08BE5344)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wrong ADC sample phase that happen between awake and
network/full sleep will lead to improper rx noisefloor
calibration.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 ar9462_2p0_initvals.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ar9462_2p0_initvals.h b/ar9462_2p0_initvals.h
index 32ea34e..ea18cb8 100644
--- a/ar9462_2p0_initvals.h
+++ b/ar9462_2p0_initvals.h
@@ -959,7 +959,7 @@ static const u32 ar9462_2p0_radio_core[][2] = {
 	{0x0001604c, 0x2699e04f},
 	{0x00016050, 0x6db6db6c},
 	{0x00016058, 0x6c200000},
-	{0x00016080, 0x00040000},
+	{0x00016080, 0x000c0000},
 	{0x00016084, 0x9a68048c},
 	{0x00016088, 0x54214514},
 	{0x0001608c, 0x1203040b},
@@ -982,7 +982,7 @@ static const u32 ar9462_2p0_radio_core[][2] = {
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

