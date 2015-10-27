Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f195.google.com ([209.85.212.195]:32966 "EHLO
	mail-wi0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbbJ0RV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 13:21:58 -0400
From: Punit Vara <punitvara@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org, johnny.kim@atmel.com,
	Punit Vara <punitvara@gmail.com>
Subject: [PATCH v2] Staging: wilc1000: Prefer eth_broadcast_addr over memset()
Date: Tue, 27 Oct 2015 22:51:39 +0530
Message-Id: <1445966499-6175-1-git-send-email-punitvara@gmail.com> (sfid-20151027_182249_461616_56D166C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to the host_interface.c that fixes up following
warning by checkpatch:

-prefer eth_broadcast_addr() over memset()

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5f81eab..53e21cd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4642,7 +4642,7 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 	msg.drv = hif_drv;
 
 	if (!pu8MacAddr)
-		memset(pstrDelStationMsg->mac_addr, 255, ETH_ALEN);
+		eth_broadcast_addr(pstrDelStationMsg->mac_addr);
 	else
 		memcpy(pstrDelStationMsg->mac_addr, pu8MacAddr, ETH_ALEN);
 
-- 
2.5.3

