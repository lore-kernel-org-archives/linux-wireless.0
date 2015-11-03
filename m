Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18285 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbbKCGV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 01:21:56 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] ath10k: fix invalid NSS for 4x4 devices
Date: Tue, 3 Nov 2015 11:51:33 +0530
Message-ID: <1446531693-23453-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151103_072256_348034_BE949E37)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of spatial streams that are derived from chain mask
for 4x4 devices is using wrong bitmask and conditional check.
This is affecting downlink throughput for QCA99x0 devices. Earlier
cfg_tx_chainmask is not filled by default until user configured it
and so get_nss_from_chainmask never be called. This issue is exposed
by recent commit 166de3f1895d ("ath10k: remove supported chain mask").
By default maximum supported chain mask is filled in cfg_tx_chainmask.

Cc: stable@vger.kernel.org
Fixes: 5572a95b4b ("ath10k: apply chainmask settings to vdev on
creation")
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a7411fe..95a55405 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4225,7 +4225,7 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 
 static u32 get_nss_from_chainmask(u16 chain_mask)
 {
-	if ((chain_mask & 0x15) == 0x15)
+	if ((chain_mask & 0xf) == 0xf)
 		return 4;
 	else if ((chain_mask & 0x7) == 0x7)
 		return 3;
-- 
2.6.2

