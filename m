Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14700 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbcHBKjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 06:39:55 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH] ath10k: Add WMI_SERVICE_PERIODIC_CHAN_STAT_SUPPORT wmi service
Date: Tue, 2 Aug 2016 16:13:14 +0530
Message-ID: <1470134594-10427-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20160802_123958_671006_0E3E74C4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

WMI_SERVICE_PERIODIC_CHAN_STAT_SUPPORT service has missed in
the commit 7e247a9e88dc ("ath10k: add dynamic tx mode switch
config support for qca4019"). This patch adds the service to
avoid mismatch between host and target.

Fixes:7e247a9e88dc ("ath10k: add dynamic tx mode switch config support for qca4019")
Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3ef4688..f67cc19 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -180,6 +180,7 @@ enum wmi_service {
 	WMI_SERVICE_MESH_NON_11S,
 	WMI_SERVICE_PEER_STATS,
 	WMI_SERVICE_RESTRT_CHNL_SUPPORT,
+	WMI_SERVICE_PERIODIC_CHAN_STAT_SUPPORT,
 	WMI_SERVICE_TX_MODE_PUSH_ONLY,
 	WMI_SERVICE_TX_MODE_PUSH_PULL,
 	WMI_SERVICE_TX_MODE_DYNAMIC,
@@ -305,6 +306,7 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_RESTRT_CHNL_SUPPORT,
 	WMI_10_4_SERVICE_PEER_STATS,
 	WMI_10_4_SERVICE_MESH_11S,
+	WMI_10_4_SERVICE_PERIODIC_CHAN_STAT_SUPPORT,
 	WMI_10_4_SERVICE_TX_MODE_PUSH_ONLY,
 	WMI_10_4_SERVICE_TX_MODE_PUSH_PULL,
 	WMI_10_4_SERVICE_TX_MODE_DYNAMIC,
@@ -402,6 +404,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_MESH_NON_11S);
 	SVCSTR(WMI_SERVICE_PEER_STATS);
 	SVCSTR(WMI_SERVICE_RESTRT_CHNL_SUPPORT);
+	SVCSTR(WMI_SERVICE_PERIODIC_CHAN_STAT_SUPPORT);
 	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_ONLY);
 	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_PULL);
 	SVCSTR(WMI_SERVICE_TX_MODE_DYNAMIC);
@@ -652,6 +655,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_PEER_STATS, len);
 	SVCMAP(WMI_10_4_SERVICE_MESH_11S,
 	       WMI_SERVICE_MESH_11S, len);
+	SVCMAP(WMI_10_4_SERVICE_PERIODIC_CHAN_STAT_SUPPORT,
+	       WMI_SERVICE_PERIODIC_CHAN_STAT_SUPPORT, len);
 	SVCMAP(WMI_10_4_SERVICE_TX_MODE_PUSH_ONLY,
 	       WMI_SERVICE_TX_MODE_PUSH_ONLY, len);
 	SVCMAP(WMI_10_4_SERVICE_TX_MODE_PUSH_PULL,
-- 
1.7.9.5

