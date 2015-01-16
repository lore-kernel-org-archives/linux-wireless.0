Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43007 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbAPOJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 09:09:37 -0500
Received: by mail-wi0-f180.google.com with SMTP id bs8so4084678wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 06:09:36 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix dtim period with beacon templates
Date: Fri, 16 Jan 2015 15:08:56 +0100
Message-Id: <1421417336-19371-1-git-send-email-michal.kazior@tieto.com> (sfid-20150116_150940_732363_65B6ABEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware supporting beacon templates (i.e. wmi-tlv
for qca6174) doesn't implicitly take dtim period
from the template. Instead it requires vdev param
to be set accordingly.

This fixes dtim period being stuck at 3.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9524bc5..99af537 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3435,7 +3435,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				    arvif->vdev_id, ret);
 	}
 
-	if (changed & BSS_CHANGED_BEACON_INFO) {
+	if (changed & (BSS_CHANGED_BEACON_INFO | BSS_CHANGED_BEACON)) {
 		arvif->dtim_period = info->dtim_period;
 
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
-- 
1.8.5.3

