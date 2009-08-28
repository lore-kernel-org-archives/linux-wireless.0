Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:34891 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZH1J6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:58:53 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/8] rndis_wlan: get bssid scan list before new scan
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Aug 2009 12:58:55 +0300
Message-ID: <20090828095854.10554.70662.stgit@fate.lan>
In-Reply-To: <20090828095849.10554.58857.stgit@fate.lan>
References: <20090828095849.10554.58857.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OID_802_11_BSSID_LIST_SCAN clears device's bssid list, so retrieve
current bssid list from device before issuing new scan.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 612c2c7..3779621 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -926,6 +926,7 @@ static int freq_to_dsconfig(struct iw_freq *freq, unsigned int *dsconfig)
  * common functions
  */
 static void restore_keys(struct usbnet *usbdev);
+static int rndis_check_bssid_list(struct usbnet *usbdev);
 
 static int get_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 {
@@ -1616,6 +1617,11 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 
 	devdbg(usbdev, "cfg80211.scan");
 
+	/* Get current bssid list from device before new scan, as new scan
+	 * clears internal bssid list.
+	 */
+	rndis_check_bssid_list(usbdev);
+
 	if (!request)
 		return -EINVAL;
 

