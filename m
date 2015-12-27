Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35029 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbbL0Q45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2015 11:56:57 -0500
Date: Sun, 27 Dec 2015 23:58:53 +0700
From: Ivan Safonov <insafonov@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: wilc1000: min_t macro instead of ternary
 condition operator used
Message-ID: <20151227165853.GA22264@alpha.sfu-kras.ru> (sfid-20151227_175754_165620_57376462)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

min_t macro bit shorter then ?: operator.

Signed-off-by: Ivan Safonov <insafonov@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8c77520..5a770bb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4570,7 +4570,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				pNewJoinBssParam->rsn_grp_policy = pu8IEs[rsnIndex];
 				rsnIndex++;
 				jumpOffset = pu8IEs[rsnIndex] * 4;
-				pcipherCount = (pu8IEs[rsnIndex] > 3) ? 3 : pu8IEs[rsnIndex];
+				pcipherCount = min_t(u8, pu8IEs[rsnIndex], 3);
 				rsnIndex += 2;
 
 				for (i = pcipherTotalCount, j = 0; i < pcipherCount + pcipherTotalCount && i < 3; i++, j++)
@@ -4581,7 +4581,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 
 				jumpOffset = pu8IEs[rsnIndex] * 4;
 
-				authCount = (pu8IEs[rsnIndex] > 3) ? 3 : pu8IEs[rsnIndex];
+				authCount = min_t(u8, pu8IEs[rsnIndex], 3);
 				rsnIndex += 2;
 
 				for (i = authTotalCount, j = 0; i < authTotalCount + authCount; i++, j++)
-- 
2.4.10

