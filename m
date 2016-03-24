Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47057 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbcCXOY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 10:24:28 -0400
Subject: [PATCH 4/4] ath10k: prefer ether_addr_copy() over memcpy()
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 24 Mar 2016 16:24:07 +0200
Message-ID: <20160324142406.15808.88737.stgit@potku.adurom.net> (sfid-20160324_152432_444628_42C8D964)
In-Reply-To: <20160324142217.15808.22638.stgit@potku.adurom.net>
References: <20160324142217.15808.22638.stgit@potku.adurom.net>
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
index ffb300823376..c0ce56804afa 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5797,9 +5797,8 @@ ath10k_wmi_put_start_scan_tlvs(struct wmi_start_scan_tlvs *tlvs,
 		bssids->num_bssid = __cpu_to_le32(arg->n_bssids);
 
 		for (i = 0; i < arg->n_bssids; i++)
-			memcpy(&bssids->bssid_list[i],
-			       arg->bssids[i].bssid,
-			       ETH_ALEN);
+			ether_addr_copy(bssids->bssid_list[i].addr,
+					arg->bssids[i].bssid);
 
 		ptr += sizeof(*bssids);
 		ptr += sizeof(struct wmi_mac_addr) * arg->n_bssids;

