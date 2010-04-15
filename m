Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab0DOVjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 18/97] ath9k: disable the MIB interrupt if ANI is disabled
Date: Thu, 15 Apr 2010 17:38:23 -0400
Message-Id: <1271367582-992-19-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f7ef114..494456c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1436,7 +1436,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	if ((vif->type == NL80211_IFTYPE_STATION) ||
 	    (vif->type == NL80211_IFTYPE_ADHOC) ||
 	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
-		ah->imask |= ATH9K_INT_MIB;
+		if (ah->config.enable_ani)
+			ah->imask |= ATH9K_INT_MIB;
 		ah->imask |= ATH9K_INT_TSFOOR;
 	}
 
-- 
1.6.3.3

