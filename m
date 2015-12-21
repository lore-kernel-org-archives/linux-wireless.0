Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35560 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbLUC3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 21:29:08 -0500
Received: by mail-pf0-f173.google.com with SMTP id 78so7031491pfw.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2015 18:29:08 -0800 (PST)
From: Dan Lenski <dlenski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Lenski <dlenski@gmail.com>, larry.finger@lwfinger.net
Subject: [PATCH] enable setting MAC address for r8723au
Date: Sun, 20 Dec 2015 18:28:36 -0800
Message-Id: <1450664916-25205-2-git-send-email-dlenski@gmail.com> (sfid-20151221_032911_563210_AFA213CE)
In-Reply-To: <1450664916-25205-1-git-send-email-dlenski@gmail.com>
References: <1450664916-25205-1-git-send-email-dlenski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Lenski <dlenski@gmail.com>
---
 drivers/staging/rtl8723au/os_dep/os_intfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
index b8848c2..228e19f 100644
--- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
@@ -240,8 +240,11 @@ static int rtw_net_set_mac_address(struct net_device *pnetdev, void *p)
 	struct rtw_adapter *padapter = netdev_priv(pnetdev);
 	struct sockaddr *addr = p;
 
-	if (!padapter->bup)
-		ether_addr_copy(padapter->eeprompriv.mac_addr, addr->sa_data);
+	if (padapter->bup)
+		DBG_8723A_LEVEL(_drv_warning_, "Trying to set MAC address while bup =%d\n", padapter->bup);
+	ether_addr_copy(padapter->eeprompriv.mac_addr, addr->sa_data);
+	ether_addr_copy(pnetdev->dev_addr, addr->sa_data);
+
 	return 0;
 }
 
-- 
2.5.0

