Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1538 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2DYHHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 03:07:30 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2] ath6kl: Don't advertise HT capability for incapable firmware
Date: Wed, 25 Apr 2012 12:38:18 +0530
Message-ID: <1335337698-7221-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120425_090733_576544_744387F5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With firmwares which do not support rsn capability override
(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE) from host would
cause 4-way handshake failure when HT cap is advertised.
To fix this, do not advertise HT cap with cfg80211 for
those fw.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
V2 - Rebased on top of Tomas' "ath6kl: support fw reporting phy capabilities"

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index dd5e79a..0f4df78 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3480,7 +3480,14 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 		return -EINVAL;
 	}
 
-	if (!ht) {
+	/*
+	 * Even if the fw has HT support, advertise HT cap only when
+	 * the firmware has support to override RSN capability, otherwise
+	 * 4-way handshake would fail.
+	 */
+	if (!(ht &&
+	    test_bit(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
+		     ar->fw_capabilities))) {
 		ath6kl_band_2ghz.ht_cap.cap = 0;
 		ath6kl_band_2ghz.ht_cap.ht_supported = false;
 		ath6kl_band_5ghz.ht_cap.cap = 0;
-- 
1.7.0.4

