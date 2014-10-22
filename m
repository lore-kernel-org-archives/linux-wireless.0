Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61210 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049AbaJVMif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 08:38:35 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so2686094lbv.7
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 05:38:34 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: call correct function for frag threshold
Date: Wed, 22 Oct 2014 14:27:05 +0200
Message-Id: <1413980825-11186-1-git-send-email-michal.kazior@tieto.com> (sfid-20141022_143838_338753_2801577C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rts threshold was being configured instead of
fragmentation threshold.

Keep in mind available firmware binaries don't
seem to support fragmentation anyway so this
doesn't fix fragmentation threshold per se.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f6d2fd0..1d119116 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3872,7 +3872,7 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d fragmentation threshold %d\n",
 			   arvif->vdev_id, value);
 
-		ret = ath10k_mac_set_rts(arvif, value);
+		ret = ath10k_mac_set_frag(arvif, value);
 		if (ret) {
 			ath10k_warn(ar, "failed to set fragmentation threshold for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
-- 
1.8.5.3

