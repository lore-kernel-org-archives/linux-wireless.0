Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:32921 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaJYTgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:36:44 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so3061163wgh.34
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:36:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 20/31] staging: vt6655: mac80211 conversion: device_free_info
Date: Sat, 25 Oct 2014 09:20:30 +0100
Message-Id: <1414225241-5480-21-git-send-email-tvboxspy@gmail.com> (sfid-20141025_213652_034637_61CFD748)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove net device code and add mac80211 unregister code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 77d81b3..451b608 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -806,31 +806,20 @@ static bool device_get_pci_info(struct vnt_private *pDevice,
 
 static void device_free_info(struct vnt_private *pDevice)
 {
-	struct net_device *dev = pDevice->dev;
-
-	ASSERT(pDevice);
-//2008-0714-01<Add>by chester
-	device_release_WPADEV(pDevice);
-
-//2008-07-21-01<Add>by MikeLiu
-//unregister wpadev
-	if (wpa_set_wpadev(pDevice, 0) != 0)
-		pr_err("unregister wpadev fail?\n");
+	if (!pDevice)
+		return;
 
-#ifdef HOSTAP
-	if (dev)
-		vt6655_hostap_set_hostapd(pDevice, 0, 0);
-#endif
-	if (dev)
-		unregister_netdev(dev);
+	if (pDevice->mac_hw)
+		ieee80211_unregister_hw(pDevice->hw);
 
 	if (pDevice->PortOffset)
 		iounmap(pDevice->PortOffset);
 
 	if (pDevice->pcid)
 		pci_release_regions(pDevice->pcid);
-	if (dev)
-		free_netdev(dev);
+
+	if (pDevice->hw)
+		ieee80211_free_hw(pDevice->hw);
 }
 
 static bool device_init_rings(struct vnt_private *pDevice)
-- 
1.9.1

