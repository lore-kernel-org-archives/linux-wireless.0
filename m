Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5557 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964811AbcDMLO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 07:14:28 -0400
Subject: [PATCH v2 4/5] ath10k: prefer ether_addr_copy() over memcpy()
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 13 Apr 2016 14:14:02 +0300
Message-ID: <20160413111402.18823.24437.stgit@potku.adurom.net> (sfid-20160413_131431_535816_423E9CF2)
In-Reply-To: <20160413111247.18823.15952.stgit@potku.adurom.net>
References: <20160413111247.18823.15952.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warning:

drivers/net/wireless/ath/ath10k/wmi.c:5800: Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e92ac26865ff..adb31e188ebd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5827,9 +5827,8 @@ ath10k_wmi_put_start_scan_tlvs(struct wmi_start_scan_tlvs *tlvs,
 		bssids->num_bssid = __cpu_to_le32(arg->n_bssids);
 
 		for (i = 0; i < arg->n_bssids; i++)
-			memcpy(&bssids->bssid_list[i],
-			       arg->bssids[i].bssid,
-			       ETH_ALEN);
+			ether_addr_copy(bssids->bssid_list[i].addr,
+					arg->bssids[i].bssid);
 
 		ptr += sizeof(*bssids);
 		ptr += sizeof(struct wmi_mac_addr) * arg->n_bssids;

