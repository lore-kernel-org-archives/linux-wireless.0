Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47936 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbcCBOoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 09:44:18 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <greearb@candelatech.com>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix firmware assert in monitor mode
Date: Wed, 2 Mar 2016 20:13:52 +0530
Message-ID: <1456929832-6147-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160302_154429_487647_3771BE51)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 166de3f1895d ("ath10k: remove supported chain mask") had revealed
an issue on monitor mode. Configuring NSS upon monitor interface
creation is causing target assert in all qca9888x and qca6174 firmware.
Firmware assert issue can be reproduced by below sequence even after
reverting commit 166de3f1895d ("ath10k: remove supported chain mask").

ip link set wlan0 down
iw wlan0 set type monitor
iw phy0 set antenna 7
ip link set wlan0 up

This issue is originally reported on qca9888 with 10.1 firmware.

Fixes: 5572a95b4b ("ath10k: apply chainmask settings to vdev on creation")
Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 78999c9..c42866d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4489,7 +4489,10 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		goto err_vdev_delete;
 	}
 
-	if (ar->cfg_tx_chainmask) {
+	/* Configuring number of spatial stream for monitor interface is causing
+	 * target assert in qca9888 and qca6174.
+	 */
+	if (ar->cfg_tx_chainmask && (vif->type != NL80211_IFTYPE_MONITOR)) {
 		u16 nss = get_nss_from_chainmask(ar->cfg_tx_chainmask);
 
 		vdev_param = ar->wmi.vdev_param->nss;
-- 
2.7.2

