Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35972 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbbIIQsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 12:48:05 -0400
Received: by ioii196 with SMTP id i196so29101193ioi.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2015 09:48:03 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 1/3] ath10k: enable monitor when OTHER_BSS requested
Date: Wed,  9 Sep 2015 12:47:34 -0400
Message-Id: <1441817256-3997-1-git-send-email-me@bobcopeland.com> (sfid-20150909_184813_813949_0BD92D6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By default, ath10k restricts received frames to those matching BSSID.
When other BSS frames are requested (e.g. in mesh mode), add an internal
monitor device so those frames are not filtered.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 989d2a1..80efcc8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1070,6 +1070,7 @@ static bool ath10k_mac_monitor_vdev_is_needed(struct ath10k *ar)
 		return false;
 
 	return ar->monitor ||
+	       ar->filter_flags & FIF_OTHER_BSS ||
 	       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 }
 
-- 
2.1.4

