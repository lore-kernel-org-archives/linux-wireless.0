Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:33960 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbbJZTwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 15:52:08 -0400
From: Punit Vara <punitvara@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Punit Vara <punitvara@gmail.com>
Subject: [PATCH] Staging: wilc1000: Fix warning prefer eth_broadcast_addr over memset()
Date: Tue, 27 Oct 2015 01:21:46 +0530
Message-Id: <1445889106-6737-1-git-send-email-punitvara@gmail.com> (sfid-20151026_205229_855294_2ACF93BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to the host_interface.c that fixes up following
warning by checkpatch.pl:

-Prefer eth_broadcast_addr() over memset()

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 09a6c98..87b4eb8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4688,7 +4688,7 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 	msg.drv = hif_drv;
 
 	if (pu8MacAddr == NULL)
-		memset(pstrDelStationMsg->mac_addr, 255, ETH_ALEN);
+		eth_broadcast_addr(pstrDelStationMsg->mac_addr);
 	else
 		memcpy(pstrDelStationMsg->mac_addr, pu8MacAddr, ETH_ALEN);
 
-- 
2.5.3

