Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49991 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbcEIXL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:27 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 12/21] ath10k: Support up to 64 vdevs.
Date: Mon,  9 May 2016 16:11:06 -0700
Message-Id: <1462835475-11079-13-git-send-email-greearb@candelatech.com> (sfid-20160510_011143_813907_9F47B426)
In-Reply-To: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The (1 << x) - 1 trick won't work when you
are trying to fill up all 64 bits, so add special
case for that.

And, move the limits to the per-nic structure instead
of per-driver to allow better dynamic use of the limits.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 3f1786c..fa71d57 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1819,7 +1819,10 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	if (status)
 		goto err_hif_stop;
 
-	ar->free_vdev_map = (1LL << ar->max_num_vdevs) - 1;
+	if (ar->max_num_vdevs >= 64)
+		ar->free_vdev_map = 0xFFFFFFFFFFFFFFFFLL;
+	else
+		ar->free_vdev_map = (1LL << ar->max_num_vdevs) - 1;
 
 	INIT_LIST_HEAD(&ar->arvifs);
 
-- 
2.4.3

