Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:34831 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbeEKIPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:15:25 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 27/30] staging: wilc1000: added comments for mutex and spinlock_t
Date: Fri, 11 May 2018 13:43:28 +0530
Message-ID: <1526026411-11058-28-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101529_487037_D9E876E3)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added comments for mutex and spinlock_t to avoid checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.h     | 2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 08b3ba7..068b587 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -271,7 +271,7 @@ struct host_if_drv {
 
 	u8 assoc_bssid[ETH_ALEN];
 	struct cfg_param_attr cfg_values;
-
+	/*lock to protect concurrent setting of cfg params*/
 	struct mutex cfg_values_lock;
 	struct completion comp_test_key_block;
 	struct completion comp_test_disconn_block;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 607dae0..78f3312 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -131,10 +131,11 @@ struct wilc {
 	u8 vif_num;
 	struct wilc_vif *vif[NUM_CONCURRENT_IFC];
 	u8 open_ifcs;
-
+	/*protect head of transmit queue*/
 	struct mutex txq_add_to_head_cs;
+	/*protect txq_entry_t transmit queue*/
 	spinlock_t txq_spinlock;
-
+	/*protect rxq_entry_t receiver queue*/
 	struct mutex rxq_cs;
 	struct mutex hif_cs;
 
-- 
2.7.4
