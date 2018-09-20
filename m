Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40718 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbeITMFy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:05:54 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 05/29] staging: wilc1000: change return type to 'void' for wilc_wfi_deinit_mon_interface()
Date: Thu, 20 Sep 2018 11:53:16 +0530
Message-ID: <1537424620-6982-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082454_327490_35E655C8)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 'void' return type for wilc_wfi_deinit_mon_interface(), as same
value always return.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 3 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 1afdb9e..a634468 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -253,7 +253,7 @@ struct net_device *wilc_wfi_init_mon_interface(const char *name,
 	return wilc_wfi_mon;
 }
 
-int wilc_wfi_deinit_mon_interface(void)
+void wilc_wfi_deinit_mon_interface(void)
 {
 	bool rollback_lock = false;
 
@@ -270,5 +270,4 @@ int wilc_wfi_deinit_mon_interface(void)
 		}
 		wilc_wfi_mon = NULL;
 	}
-	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 1858f56..4812c8e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -14,7 +14,7 @@ void wilc_free_wiphy(struct net_device *net);
 void wilc_deinit_host_int(struct net_device *net);
 int wilc_init_host_int(struct net_device *net);
 void wilc_wfi_monitor_rx(u8 *buff, u32 size);
-int wilc_wfi_deinit_mon_interface(void);
+void wilc_wfi_deinit_mon_interface(void);
 struct net_device *wilc_wfi_init_mon_interface(const char *name,
 					       struct net_device *real_dev);
 void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
-- 
2.7.4
