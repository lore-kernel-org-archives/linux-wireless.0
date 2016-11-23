Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:52757 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934841AbcKWK1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 05:27:04 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 11/12] brcmfmac: use requested scan interval in scheduled scan
Date: Wed, 23 Nov 2016 10:25:30 +0000
Message-Id: <1479896731-5091-12-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161123_112730_397795_D96B3221)
In-Reply-To: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User-space can specify the interval for the scheduled scan. This
interval is found in scheduled scan plan. The driver supports only
one plan, which is legacy behaviour.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c      | 6 +++++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h      | 6 ++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ad526e1..38b1563 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6311,6 +6311,7 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
 	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
 	wiphy->max_sched_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
+	wiphy->max_sched_scan_plan_interval = BRCMF_PNO_SCHED_SCAN_MAX_PERIOD;
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index bc33bdc..f273cab 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -63,6 +63,10 @@ static int brcmf_pno_config(struct brcmf_if *ifp, u32 scan_freq,
 	pfn_param.exp = BRCMF_PNO_FREQ_EXPO_MAX;
 
 	/* set up pno scan fr */
+	if (scan_freq < BRCMF_PNO_SCHED_SCAN_MIN_PERIOD) {
+		brcmf_dbg(SCAN, "scan period too small, using minimum\n");
+		scan_freq = BRCMF_PNO_SCHED_SCAN_MIN_PERIOD;
+	}
 	pfn_param.scan_freq = cpu_to_le32(scan_freq);
 
 	if (mscan) {
@@ -191,7 +195,7 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 	}
 
 	/* configure pno */
-	ret = brcmf_pno_config(ifp, BRCMF_PNO_SCHED_SCAN_PERIOD, 0, 0);
+	ret = brcmf_pno_config(ifp, req->scan_plans[0].interval, 0, 0);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
index 5803a4c..bae55b2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
@@ -16,8 +16,10 @@
 #ifndef _BRCMF_PNO_H
 #define _BRCMF_PNO_H
 
-#define BRCMF_PNO_SCAN_COMPLETE		1
-#define BRCMF_PNO_MAX_PFN_COUNT		16
+#define BRCMF_PNO_SCAN_COMPLETE			1
+#define BRCMF_PNO_MAX_PFN_COUNT			16
+#define BRCMF_PNO_SCHED_SCAN_MIN_PERIOD	10
+#define BRCMF_PNO_SCHED_SCAN_MAX_PERIOD	508
 
 /**
  * brcmf_pno_clean - disable and clear pno in firmware.
-- 
1.9.1
