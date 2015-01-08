Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:52465 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbbAHKhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 05:37:40 -0500
Received: by mail-wg0-f53.google.com with SMTP id x13so1811194wgg.12
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 02:37:39 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fill max_num_vdevs for wmi-tlv
Date: Thu,  8 Jan 2015 11:36:56 +0100
Message-Id: <1420713416-14634-1-git-send-email-michal.kazior@tieto.com> (sfid-20150108_113744_835092_C360CF48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent commit
30c78167bc6536d9074aa79385a575596343bf69 ("ath10k:
set max_num_vdevs based on wmi op version")
skipped wmi-tlv case and left max_num_vdevs reset.
Make sure it is properly set.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2d0671e..a546575 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -927,6 +927,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	case ATH10K_FW_WMI_OP_VERSION_TLV:
 		ar->max_num_peers = TARGET_TLV_NUM_PEERS;
 		ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
+		ar->max_num_vdevs = TARGET_TLV_NUM_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
-- 
1.8.5.3

