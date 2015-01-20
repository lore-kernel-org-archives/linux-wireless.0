Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40508 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbATKZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 05:25:38 -0500
Received: by mail-wg0-f48.google.com with SMTP id x12so7916259wgg.7
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 02:25:37 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] ath10k: disable uapsd autotrigger
Date: Tue, 20 Jan 2015 11:24:57 +0100
Message-Id: <1421749497-10553-2-git-send-email-michal.kazior@tieto.com> (sfid-20150120_112544_731392_D4F921AE)
In-Reply-To: <1421749497-10553-1-git-send-email-michal.kazior@tieto.com>
References: <1421749497-10553-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only userspace can make an educated decision when
a trigger frame is required so make sure the
autotrigger service is disabled.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9524bc5..08e61cb 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3987,6 +3987,8 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 				u16 ac, bool enable)
 {
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct wmi_sta_uapsd_auto_trig_arg arg = {};
+	u32 prio = 0, acc = 0;
 	u32 value = 0;
 	int ret = 0;
 
@@ -3999,18 +4001,26 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 	case IEEE80211_AC_VO:
 		value = WMI_STA_PS_UAPSD_AC3_DELIVERY_EN |
 			WMI_STA_PS_UAPSD_AC3_TRIGGER_EN;
+		prio = 7;
+		acc = 3;
 		break;
 	case IEEE80211_AC_VI:
 		value = WMI_STA_PS_UAPSD_AC2_DELIVERY_EN |
 			WMI_STA_PS_UAPSD_AC2_TRIGGER_EN;
+		prio = 5;
+		acc = 2;
 		break;
 	case IEEE80211_AC_BE:
 		value = WMI_STA_PS_UAPSD_AC1_DELIVERY_EN |
 			WMI_STA_PS_UAPSD_AC1_TRIGGER_EN;
+		prio = 2;
+		acc = 1;
 		break;
 	case IEEE80211_AC_BK:
 		value = WMI_STA_PS_UAPSD_AC0_DELIVERY_EN |
 			WMI_STA_PS_UAPSD_AC0_TRIGGER_EN;
+		prio = 0;
+		acc = 0;
 		break;
 	}
 
@@ -4052,6 +4062,29 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 		return ret;
 	}
 
+	if (test_bit(WMI_SERVICE_STA_UAPSD_BASIC_AUTO_TRIG, ar->wmi.svc_map) ||
+	    test_bit(WMI_SERVICE_STA_UAPSD_VAR_AUTO_TRIG, ar->wmi.svc_map)) {
+		/* Only userspace can make an educated decision when to send
+		 * trigger frame. The following effectively disables u-UAPSD
+		 * autotrigger in firmware (which is enabled by default
+		 * provided the autotrigger service is available).
+		 */
+
+		arg.wmm_ac = acc;
+		arg.user_priority = prio;
+		arg.service_interval = 0;
+		arg.suspend_interval = WMI_STA_UAPSD_MAX_INTERVAL_MSEC;
+		arg.delay_interval = WMI_STA_UAPSD_MAX_INTERVAL_MSEC;
+
+		ret = ath10k_wmi_vdev_sta_uapsd(ar, arvif->vdev_id,
+						arvif->bssid, &arg, 1);
+		if (ret) {
+			ath10k_warn(ar, "failed to set uapsd auto trigger %d\n",
+				    ret);
+			return ret;
+		}
+	}
+
 exit:
 	return ret;
 }
-- 
1.8.5.3

