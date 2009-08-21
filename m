Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58694 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932318AbZHUUxh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:53:37 -0400
Message-ID: <4A8F0951.50108@gmx.de>
Date: Fri, 21 Aug 2009 22:53:37 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH 2/2 v2] ar9170: remove unnecessary call to ar9170_set_beacon_timers
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Joerg Albert <jal2@gmx.de>

---
 drivers/net/wireless/ath/ar9170/main.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 911e502..5b73194 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2031,12 +2031,6 @@ static int ar9170_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out;
 	}
 
-	if (changed & BSS_CHANGED_BEACON_INT) {
-		err = ar9170_set_beacon_timers(ar);
-		if (err)
-			goto out;
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 
 		/* adjust slot time for 5 GHz */
-- 
1.6.0.4

