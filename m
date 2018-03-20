Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:22755 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbeCTQ4Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 12:56:24 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/11] staging: wilc1000: remove line over 80 char in cfg_connect_result()
Date: Tue, 20 Mar 2018 22:25:42 +0530
Message-ID: <1521564944-3565-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180320_175628_198723_23AD6975)
In-Reply-To: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issues reported by checkpatch.pl script in
cfg_connect_result().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 34 +++++++++++++++--------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1b6fe64..af1b8aa 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -460,6 +460,17 @@ static void cfg_scan_result(enum scan_event scan_event,
 	}
 }
 
+static inline bool wilc_wfi_cfg_scan_time_expired(int i)
+{
+	unsigned long now = jiffies;
+
+	if (time_after(now, last_scanned_shadow[i].time_scan_cached +
+		       (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ))))
+		return true;
+	else
+		return false;
+}
+
 int wilc_connecting;
 
 static void cfg_connect_result(enum conn_event conn_disconn_evt,
@@ -505,17 +516,14 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 			bool scan_refresh = false;
 			u32 i;
 
-			memcpy(priv->associated_bss, conn_info->bssid, ETH_ALEN);
+			memcpy(priv->associated_bss, conn_info->bssid,
+			       ETH_ALEN);
 
 			for (i = 0; i < last_scanned_cnt; i++) {
 				if (memcmp(last_scanned_shadow[i].bssid,
 					   conn_info->bssid,
 					   ETH_ALEN) == 0) {
-					unsigned long now = jiffies;
-
-					if (time_after(now,
-						       last_scanned_shadow[i].time_scan_cached +
-						       (unsigned long)(nl80211_SCAN_RESULT_EXPIRE - (1 * HZ))))
+					if (wilc_wfi_cfg_scan_time_expired(i))
 						scan_refresh = true;
 
 					break;
@@ -527,9 +535,11 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 		}
 
 		cfg80211_connect_result(dev, conn_info->bssid,
-					conn_info->req_ies, conn_info->req_ies_len,
-					conn_info->resp_ies, conn_info->resp_ies_len,
-					connect_status, GFP_KERNEL);
+					conn_info->req_ies,
+					conn_info->req_ies_len,
+					conn_info->resp_ies,
+					conn_info->resp_ies_len, connect_status,
+					GFP_KERNEL);
 	} else if (conn_disconn_evt == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
 		wilc_optaining_ip = false;
 		p2p_local_random = 0x01;
@@ -546,9 +556,9 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 		else if (!wfi_drv->IFC_UP && dev == wl->vif[1]->ndev)
 			disconn_info->reason = 1;
 
-		cfg80211_disconnected(dev, disconn_info->reason, disconn_info->ie,
-				      disconn_info->ie_len, false,
-				      GFP_KERNEL);
+		cfg80211_disconnected(dev, disconn_info->reason,
+				      disconn_info->ie, disconn_info->ie_len,
+				      false, GFP_KERNEL);
 	}
 }
 
-- 
2.7.4
