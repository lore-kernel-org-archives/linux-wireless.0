Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56503 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbcDDXUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 19:20:22 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath10k: enable set_tsf vdev command to WMI 10.4
Date: Mon, 4 Apr 2016 16:19:16 -0700
Message-ID: <1459811956-26186-4-git-send-email-poh@qca.qualcomm.com> (sfid-20160405_012028_801475_4A74991C)
In-Reply-To: <1459811956-26186-1-git-send-email-poh@qca.qualcomm.com>
References: <1459811956-26186-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.4 firmware has addeded set_tsf vdev parameter,
hence enable it.
set_tsf function can be used to shift TBTT that will
help avoid its clockdrift which happens when beacons
are collided.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index db3e9a4..e8d9a3e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1008,7 +1008,7 @@ static struct wmi_vdev_param_map wmi_10_4_vdev_param_map = {
 	.meru_vc = WMI_10_4_VDEV_PARAM_MERU_VC,
 	.rx_decap_type = WMI_10_4_VDEV_PARAM_RX_DECAP_TYPE,
 	.bw_nss_ratemask = WMI_10_4_VDEV_PARAM_BW_NSS_RATEMASK,
-	.set_tsf = WMI_VDEV_PARAM_UNSUPPORTED,
+	.set_tsf = WMI_10_4_VDEV_PARAM_TSF_INCREMENT,
 };
 
 static struct wmi_pdev_param_map wmi_pdev_param_map = {
-- 
1.9.1

