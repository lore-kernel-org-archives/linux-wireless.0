Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36254 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753155AbdEMQlj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 12:41:39 -0400
Received: by mail-wr0-f195.google.com with SMTP id v42so10222139wrc.3
        for <linux-wireless@vger.kernel.org>; Sat, 13 May 2017 09:41:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/5] staging: rtl8192e: Let user know mac address associated with.
Date: Sat, 13 May 2017 17:41:20 +0100
Message-Id: <20170513164121.14373-4-tvboxspy@gmail.com> (sfid-20170513_184151_773431_825F9B1E)
In-Reply-To: <20170513164121.14373-1-tvboxspy@gmail.com>
References: <20170513164121.14373-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User cannot tell which mac address(BSIDD) associated with so add
this to info message.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/rtl8192e/rtllib_softmac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index eeda17d6409b..776e99741431 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -1525,7 +1525,8 @@ static void rtllib_associate_complete_wq(void *data)
 				     associate_complete_wq);
 	struct rt_pwr_save_ctrl *pPSC = &(ieee->PowerSaveControl);
 
-	netdev_info(ieee->dev, "Associated successfully\n");
+	netdev_info(ieee->dev, "Associated successfully with %pM\n",
+		    ieee->current_network.bssid);
 	if (!ieee->is_silent_reset) {
 		netdev_info(ieee->dev, "normal associate\n");
 		notify_wx_assoc_event(ieee);
-- 
2.11.0
