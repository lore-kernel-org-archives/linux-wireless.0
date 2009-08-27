Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:33317 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZH0Hiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 03:38:54 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: increase scan timer delay
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 27 Aug 2009 10:38:54 +0300
Message-ID: <20090827073854.27662.68095.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increase scan delay from 1 sec to 6 sec. Spec says that scan by
OID_802_11_BSSID_LIST_SCAN completes in 6 seconds.
Before rfkill patch too short delay was not problem as device was
always active (radio on) and performing background scanning.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index f181b00..6d49e80 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1599,7 +1599,7 @@ static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm)
 }
 
 
-#define SCAN_DELAY_JIFFIES (HZ)
+#define SCAN_DELAY_JIFFIES (HZ * 6)
 static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request)
 {

