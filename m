Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37051 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753208AbYKFIvZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 03:51:25 -0500
From: Alexey Fisher <bug-track@fisher-privat.net>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, rjw@sisk.pl,
	kernel-testers@vger.kernel.org, torvalds@linux-foundation.org,
	yi.zhu@intel.com, Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH] ipw2200: make assocaittion only if SSID is known.
Date: Thu,  6 Nov 2008 09:51:16 +0100
Message-Id: <1225961476-5658-1-git-send-email-bug-track@fisher-privat.net> (sfid-20081106_095130_381333_E35BA0BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'iwconfig eth1 channel 6' would trigger association to _something_, 
which is wrong.  Changing the channel should (and does) trigger reassociation, 
but only if there is an SSID to associate with.

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
Acked-by: Zhu Yi <yi.zhu@intel.com>

---
 drivers/net/wireless/ipw2200.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index dcce354..d26beed 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -7581,8 +7581,7 @@ static int ipw_associate(void *data)
 	}
 
 	if (!(priv->config & CFG_ASSOCIATE) &&
-	    !(priv->config & (CFG_STATIC_ESSID |
-			      CFG_STATIC_CHANNEL | CFG_STATIC_BSSID))) {
+	    !(priv->config & (CFG_STATIC_ESSID | CFG_STATIC_BSSID))) {
 		IPW_DEBUG_ASSOC("Not attempting association (associate=0)\n");
 		return 0;
 	}
-- 
1.5.6.3

