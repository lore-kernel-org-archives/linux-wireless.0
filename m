Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.149.13]:14984 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727204AbeH2WJN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 18:09:13 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 0330B3E019
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 12:50:47 -0500 (CDT)
Date: Wed, 29 Aug 2018 12:50:18 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] wil6210: fix unsigned cid comparison with >= 0
Message-ID: <20180829175018.GA3776@embeddedor.com> (sfid-20180829_201112_746930_7AB7AAFF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comparison of cid >= 0 is always true because cid is of type u8
(8 bits, unsigned).

Fix this by removing such comparison and updating the type of
variable cid to u8 in the caller function.

Addresses-Coverity-ID: 1473079 ("Unsigned compared against 0")
Fixes: b9010f105f21 ("wil6210: add FT roam support for AP and station")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index cf6a691..abb8201 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -455,7 +455,7 @@ static inline void parse_cidxtid(u8 cidxtid, u8 *cid, u8 *tid)
  */
 static inline bool wil_cid_valid(u8 cid)
 {
-	return (cid >= 0 && cid < WIL6210_MAX_CID);
+	return cid < WIL6210_MAX_CID;
 }
 
 struct wil6210_mbox_ring {
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index c3ad8e4..4859f0e 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1177,7 +1177,7 @@ static void wmi_evt_ring_en(struct wil6210_vif *vif, int id, void *d, int len)
 	u8 vri = evt->ring_index;
 	struct wireless_dev *wdev = vif_to_wdev(vif);
 	struct wil_sta_info *sta;
-	int cid;
+	u8 cid;
 	struct key_params params;
 
 	wil_dbg_wmi(wil, "Enable vring %d MID %d\n", vri, vif->mid);
-- 
2.7.4
