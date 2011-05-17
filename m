Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45408 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1EQHNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 03:13:55 -0400
Received: by mail-pz0-f46.google.com with SMTP id 9so109978pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 00:13:55 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19922.8152.253601.275017@gargle.gargle.HOWL> (sfid-20110517_091358_804733_E35ACD6A)
Date: Tue, 17 May 2011 12:42:24 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 7/8] ath9k_htc: Change credit limit for UB94/95
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Reduce the credit size for UB94/95 to fix target hangs.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d222456..8657d26 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -258,7 +258,7 @@ static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid,
 	 */
 
 	if (IS_AR7010_DEVICE(drv_info))
-		priv->htc->credits = 48;
+		priv->htc->credits = 45;
 	else
 		priv->htc->credits = 33;
 
-- 
1.7.5.1

