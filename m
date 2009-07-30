Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:39378 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZG3Qrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:47:35 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 03/10] rndis_wlan: clear cfg80211 scan on rndis_wlan_stop()
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Thu, 30 Jul 2009 19:41:31 +0300
Message-ID: <20090730164131.28317.71430.stgit@fate.lan>
In-Reply-To: <20090730164120.28317.53313.stgit@fate.lan>
References: <20090730164120.28317.53313.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scanning gets stuck if device is stopped when scan is active. Fix by
clearing/aborting cfg80211 scan on rndis_wlan_stop().

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 3c7c620..dee0551 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1484,6 +1484,9 @@ static void rndis_get_scan_results(struct work_struct *work)
 
 	devdbg(usbdev, "get_scan_results");
 
+	if (!priv->scan_request)
+		return;
+
 	ret = rndis_check_bssid_list(usbdev);
 
 	cfg80211_scan_done(priv->scan_request, ret < 0);
@@ -2522,6 +2525,11 @@ static int rndis_wlan_stop(struct usbnet *usbdev)
 	cancel_work_sync(&priv->work);
 	flush_workqueue(priv->workqueue);
 
+	if (priv->scan_request) {
+		cfg80211_scan_done(priv->scan_request, true);
+		priv->scan_request = NULL;
+	}
+
 	return retval;
 }
 

