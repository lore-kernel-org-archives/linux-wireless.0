Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:44513 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdLUObG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 09:31:06 -0500
From: <bpothuno@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Balaji Pothunoori <bpothuno@qti.qualcomm.com>
Subject: [PATCH] ath10k: advertising tdls wider bandwidth support for 5GHz
Date: Thu, 21 Dec 2017 20:00:42 +0530
Message-ID: <1513866642-709-1-git-send-email-bpothuno@qti.qualcomm.com> (sfid-20171221_153110_760732_8673C9F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Balaji Pothunoori <bpothuno@qti.qualcomm.com>

This patch advertise tdls wider bandwidth support for 5GHz
based on firmware wmi capabilties.

This patch is required for chipset QCA9888.
Firmware Versoin : 10.4-3.5.1-00018.

Signed-off-by: Balaji Pothunoori <bpothuno@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 drivers/net/wireless/ath/ath10k/wmi.h | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0298cce..9df455f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8271,7 +8271,8 @@ int ath10k_mac_register(struct ath10k *ar)
 	if (test_bit(WMI_SERVICE_TDLS, ar->wmi.svc_map) ||
 	    test_bit(WMI_SERVICE_TDLS_EXPLICIT_MODE_ONLY, ar->wmi.svc_map)) {
 		ar->hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
-		ieee80211_hw_set(ar->hw, TDLS_WIDER_BW);
+		if (test_bit(WMI_SERVICE_TDLS_WIDER_BANDWIDTH, ar->wmi.svc_map))
+			ieee80211_hw_set(ar->hw, TDLS_WIDER_BW);
 	}
 
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index f6d60dc..0fe87ab 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -196,6 +196,7 @@ enum wmi_service {
 	WMI_SERVICE_TDLS_CONN_TRACKER_IN_HOST_MODE,
 	WMI_SERVICE_TDLS_EXPLICIT_MODE_ONLY,
 	WMI_SERVICE_MGMT_TX_WMI,
+	WMI_SERVICE_TDLS_WIDER_BANDWIDTH,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -337,6 +338,7 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_TDLS_UAPSD_SLEEP_STA,
 	WMI_10_4_SERVICE_TDLS_CONN_TRACKER_IN_HOST_MODE,
 	WMI_10_4_SERVICE_TDLS_EXPLICIT_MODE_ONLY,
+	WMI_10_4_SERVICE_TDLS_WIDER_BANDWIDTH,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -445,6 +447,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_SMART_LOGGING_SUPPORT);
 	SVCSTR(WMI_SERVICE_TDLS_CONN_TRACKER_IN_HOST_MODE);
 	SVCSTR(WMI_SERVICE_TDLS_EXPLICIT_MODE_ONLY);
+	SVCSTR(WMI_SERVICE_TDLS_WIDER_BANDWIDTH);
 	default:
 		return NULL;
 	}
@@ -741,6 +744,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_TDLS_CONN_TRACKER_IN_HOST_MODE, len);
 	SVCMAP(WMI_10_4_SERVICE_TDLS_EXPLICIT_MODE_ONLY,
 	       WMI_SERVICE_TDLS_EXPLICIT_MODE_ONLY, len);
+	SVCMAP(WMI_10_4_SERVICE_TDLS_WIDER_BANDWIDTH,
+	       WMI_SERVICE_TDLS_WIDER_BANDWIDTH, len);
 }
 
 #undef SVCMAP
-- 
2.7.4
