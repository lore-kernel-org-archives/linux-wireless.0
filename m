Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63899 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1DDR0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 13:26:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 10:25:46 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/5] ath9k: deny new interface addtion on IBSS mode
Date: Mon, 4 Apr 2011 22:56:16 +0530
Message-ID: <1301937979-14770-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The present check denies the IBSS interface addtion if we
already have any other vifs. But it fails to deny interface
addition if IBSS was already present.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6a41302..67b0eea 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1483,8 +1483,9 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		}
 	}
 
-	if ((vif->type == NL80211_IFTYPE_ADHOC) &&
-	    sc->nvifs > 0) {
+	if ((ah->opmode == NL80211_IFTYPE_ADHOC) ||
+	    ((vif->type == NL80211_IFTYPE_ADHOC) &&
+	     sc->nvifs > 0)) {
 		ath_err(common, "Cannot create ADHOC interface when other"
 			" interfaces already exist.\n");
 		ret = -EINVAL;
-- 
1.7.4.2

