Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab0G0UdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 16:33:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211_hwsim: supress scan conflict message
Date: Tue, 27 Jul 2010 16:33:07 -0400
Message-Id: <1280262788-9890-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1280262788-9890-1-git-send-email-lrodriguez@atheros.com>
References: <1280262788-9890-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes already debugged this and determined it was due
to a race condition in mac80211, in order to fix this though
we would need to change drivers quite a bit so for now just
supress this and we'll correct this on the next kernel release.

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 01ad7f7..d766a5f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -995,10 +995,8 @@ static void mac80211_hwsim_sw_scan(struct ieee80211_hw *hw)
 
 	mutex_lock(&hwsim->mutex);
 
-	if (hwsim->scanning) {
-		printk(KERN_DEBUG "two hwsim sw_scans detected!\n");
+	if (hwsim->scanning)
 		goto out;
-	}
 
 	printk(KERN_DEBUG "hwsim sw_scan request, prepping stuff\n");
 	hwsim->scanning = true;
-- 
1.7.0.4

