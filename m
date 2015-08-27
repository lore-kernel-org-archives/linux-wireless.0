Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35396 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbbH0K5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 06:57:32 -0400
Received: by iodt126 with SMTP id t126so52456818iod.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 03:57:31 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/3] ath10k: enable monitor when OTHER_BSS requested
Date: Thu, 27 Aug 2015 06:57:02 -0400
Message-Id: <1440673024-13696-2-git-send-email-me@bobcopeland.com> (sfid-20150827_125739_055624_809C05CB)
In-Reply-To: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
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
index 64674c9..7dfe37f 100644
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

