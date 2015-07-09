Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35649 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbbGIQBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 12:01:41 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/4] staging: vt6655: check ieee80211_bss_conf bssid not NULL
Date: Thu,  9 Jul 2015 17:01:24 +0100
Message-Id: <1436457687-3113-1-git-send-email-tvboxspy@gmail.com> (sfid-20150709_180144_927078_82255D76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes bssid can go null on failed association.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.19+
---
 drivers/staging/vt6655/device_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index ed040fb..b0c8e23 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1418,7 +1418,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 
 	priv->current_aid = conf->aid;
 
-	if (changed & BSS_CHANGED_BSSID) {
+	if (changed & BSS_CHANGED_BSSID && conf->bssid) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&priv->lock, flags);
-- 
2.1.4

