Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCUDqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 23:46:19 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, j@w1.fi
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211_hwsim: let the reg workqueue breathe when regtest is set
Date: Fri, 20 Mar 2009 23:46:11 -0400
Message-Id: <1237607171-3516-1-git-send-email-lrodriguez@atheros.com> (sfid-20090321_044658_206561_30CB6ADC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this the regulatory domain isn't seen and we end up
intersecting for each request (each radio).

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a15078b..1a680cb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1035,6 +1035,9 @@ static int __init init_mac80211_hwsim(void)
 			break;
 		}
 
+		/* give the regulatory workqueue a chance to run */
+		if (regtest)
+			schedule_timeout_interruptible(1);
 		err = ieee80211_register_hw(hw);
 		if (err < 0) {
 			printk(KERN_DEBUG "mac80211_hwsim: "
-- 
1.6.0.6

