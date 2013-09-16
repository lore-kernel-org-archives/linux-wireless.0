Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:60942 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab3IPMtn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 08:49:43 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 4/4] ath10k: align RX frames properly
Date: Mon, 16 Sep 2013 14:49:17 +0200
Message-ID: <1379335757-15180-5-git-send-email-michal.kazior@tieto.com> (sfid-20130916_144947_572493_46E3F362)
In-Reply-To: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
References: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ethernet-like decapping mode leaves IP protocol
frame not aligned to 4-byte boundaries. This leads
to re-aligning in mac80211 which in turn leads to
CPU cache thrashing on lower end host machines and
very poor performance.

Since HW doesn't allow to change payload offset
properly the solution is to force HW to decap in
Native Wifi mode which always has 24-bytes long
802.11 header (even for QoS frames). This means IP
frame is properly aligned in this decap mode.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 643f0c9..8c1be768 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -74,7 +74,11 @@ enum ath10k_mcast2ucast_mode {
 #define TARGET_RX_CHAIN_MASK			(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_RX_TIMEOUT_LO_PRI		100
 #define TARGET_RX_TIMEOUT_HI_PRI		40
-#define TARGET_RX_DECAP_MODE			ATH10K_HW_TXRX_ETHERNET
+
+/* Native Wifi decap mode is used to align IP frames to 4-byte boundaries and
+ * avoid a very expensive re-alignment in mac80211. */
+#define TARGET_RX_DECAP_MODE			ATH10K_HW_TXRX_NATIVE_WIFI
+
 #define TARGET_SCAN_MAX_PENDING_REQS		4
 #define TARGET_BMISS_OFFLOAD_MAX_VDEV		3
 #define TARGET_ROAM_OFFLOAD_MAX_VDEV		3
-- 
1.7.9.5

