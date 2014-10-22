Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:54364
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752423AbaJVQqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 12:46:06 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org
Subject: [PATCH] ath10k: add SURVEY_INFO_IN_USE for current channel on survey
Date: Wed, 22 Oct 2014 18:46:02 +0200
Message-Id: <1413996362-44397-1-git-send-email-nbd@openwrt.org> (sfid-20141022_184612_015930_7059A501)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4670930..bc440dc 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3975,6 +3975,9 @@ static int ath10k_get_survey(struct ieee80211_hw *hw, int idx,
 
 	survey->channel = &sband->channels[idx];
 
+	if (ar->rx_channel == survey->channel)
+		survey->filled |= SURVEY_INFO_IN_USE;
+
 exit:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
-- 
2.0.4

