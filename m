Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3447 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab3DWKzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 06:55:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/5] brcmfmac: allow scanning to be suppressed in the
 driver
Date: Tue, 23 Apr 2013 12:53:11 +0200
Message-ID: <1366714395-13416-2-git-send-email-arend@broadcom.com> (sfid-20130423_125521_440515_BF89C0E4)
In-Reply-To: <1366714395-13416-1-git-send-email-arend@broadcom.com>
References: <1366714395-13416-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During the DHCP protocol exchange it is benificial to suppress
scan requests which may decrease time to complete DHCP protocol.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   10 ++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h |    4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index ba92d6d..29b4ea4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -856,6 +856,11 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 			  cfg->scan_status);
 		return -EAGAIN;
 	}
+	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
+		brcmf_err("Scanning suppressed: status (%lu)\n",
+			  cfg->scan_status);
+		return -EAGAIN;
+	}
 	if (test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) {
 		brcmf_err("Connecting: status (%lu)\n", ifp->vif->sme_state);
 		return -EAGAIN;
@@ -3017,6 +3022,11 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
 		return -EAGAIN;
 	}
+	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
+		brcmf_err("Scanning suppressed: status (%lu)\n",
+			  cfg->scan_status);
+		return -EAGAIN;
+	}
 
 	if (!request->n_ssids || !request->n_match_sets) {
 		brcmf_err("Invalid sched scan req!! n_ssids:%d\n",
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 0b9263e..e198346 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -77,14 +77,16 @@
 
 
 /**
- * enum brcmf_scan_status - dongle scan status
+ * enum brcmf_scan_status - scan engine status
  *
  * @BRCMF_SCAN_STATUS_BUSY: scanning in progress on dongle.
  * @BRCMF_SCAN_STATUS_ABORT: scan being aborted on dongle.
+ * @BRCMF_SCAN_STATUS_SUPPRESS: scanning is suppressed in driver.
  */
 enum brcmf_scan_status {
 	BRCMF_SCAN_STATUS_BUSY,
 	BRCMF_SCAN_STATUS_ABORT,
+	BRCMF_SCAN_STATUS_SUPPRESS,
 };
 
 /**
-- 
1.7.10.4


