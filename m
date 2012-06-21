Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:44915 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756129Ab2FUONd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:33 -0400
Received: by eaak11 with SMTP id k11so238063eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:28 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 07/12] wlcore: do not report noise level in get survey op
Date: Thu, 21 Jun 2012 17:13:06 +0300
Message-Id: <1340287991-15241-8-git-send-email-coelho@ti.com> (sfid-20120621_161413_642133_A26E3F8C)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yoni Divinsky <yoni.divinsky@ti.com>

The get survey op expects the low level driver to report
the noise level for a a given channel.

The noise calculated in wlcore is (rssi-snr/2), but since
the snr reported by the FW is a derivative from the rssi
this calculation is useless, and should not be reported
to the user space.

Reporting incorrect noise, results in the wpa_supplicant
miscalculating the roaming candidate priority, thus causing
a situation where an AP with a lower rssi level would be
chosen over a better AP.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3279a94..a7c5e32 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4108,16 +4108,13 @@ out:
 static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 				struct survey_info *survey)
 {
-	struct wl1271 *wl = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 
 	if (idx != 0)
 		return -ENOENT;
 
 	survey->channel = conf->channel;
-	survey->filled = SURVEY_INFO_NOISE_DBM;
-	survey->noise = wl->noise;
-
+	survey->filled = 0;
 	return 0;
 }
 
-- 
1.7.10

