Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:44623 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZH1J7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:59:05 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/8] rndis_wlan: increase scan timer delay
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Aug 2009 12:59:05 +0300
Message-ID: <20090828095905.10554.19344.stgit@fate.lan>
In-Reply-To: <20090828095849.10554.58857.stgit@fate.lan>
References: <20090828095849.10554.58857.stgit@fate.lan>
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
index 2309ad2..cb362b0 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1607,7 +1607,7 @@ static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm)
 }
 
 
-#define SCAN_DELAY_JIFFIES (HZ)
+#define SCAN_DELAY_JIFFIES (6 * HZ)
 static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request)
 {

