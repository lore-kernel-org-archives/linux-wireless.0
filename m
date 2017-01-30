Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33693 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751988AbdA3ItI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 03:49:08 -0500
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <stable@vger.kernel.org>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv2] ath10k: fix boot failure in UTF mode/testmode
Date: Mon, 30 Jan 2017 14:15:58 +0530
Message-ID: <1485765958-26802-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170130_094919_116466_D884CD62)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

Rx filter reset and the dynamic tx switch mode (EXT_RESOURCE_CFG)
configuration are causing the following errors when UTF firmware
is loaded to the target.

Error message 1:
[ 598.015629] ath10k_pci 0001:01:00.0: failed to ping firmware: -110
[ 598.020828] ath10k_pci 0001:01:00.0: failed to reset rx filter: -110
[ 598.141556] ath10k_pci 0001:01:00.0: failed to start core (testmode): -110

Error message 2:
[ 668.615839] ath10k_ahb a000000.wifi: failed to send ext resource cfg command : -95
[ 668.618902] ath10k_ahb a000000.wifi: failed to start core (testmode): -95

Avoiding these configurations while bringing the target in
testmode is solving the problem.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
v2:
   *Added stable@vger.kernel.org in cc list

 drivers/net/wireless/ath/ath10k/core.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 874c2a7..0d12761 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1922,7 +1922,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "firmware %s booted\n",
 		   ar->hw->wiphy->fw_version);
 
-	if (test_bit(WMI_SERVICE_EXT_RES_CFG_SUPPORT, ar->wmi.svc_map)) {
+	if (test_bit(WMI_SERVICE_EXT_RES_CFG_SUPPORT, ar->wmi.svc_map) &&
+	    mode == ATH10K_FIRMWARE_MODE_NORMAL) {
 		val = 0;
 		if (ath10k_peer_stats_enabled(ar))
 			val = WMI_10_4_PEER_STATS;
@@ -1975,10 +1976,13 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	 * possible to implicitly make it correct by creating a dummy vdev and
 	 * then deleting it.
 	 */
-	status = ath10k_core_reset_rx_filter(ar);
-	if (status) {
-		ath10k_err(ar, "failed to reset rx filter: %d\n", status);
-		goto err_hif_stop;
+	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
+		status = ath10k_core_reset_rx_filter(ar);
+		if (status) {
+			ath10k_err(ar,
+				   "failed to reset rx filter: %d\n", status);
+			goto err_hif_stop;
+		}
 	}
 
 	/* If firmware indicates Full Rx Reorder support it must be used in a
-- 
1.7.9.5
