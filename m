Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:37485 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbZH1J7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:59:25 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 8/8] rndis_wlan: enable infrastructure before setting random
	essid
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Aug 2009 12:59:26 +0300
Message-ID: <20090828095926.10554.15679.stgit@fate.lan>
In-Reply-To: <20090828095849.10554.58857.stgit@fate.lan>
References: <20090828095849.10554.58857.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Random essid must be set to turn on radio when not connected. If device is
in ad-hoc mode, this results 'media connect' indications with the random
essid which should be ignored.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d117620..c5a674d 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -921,6 +921,7 @@ static int freq_to_dsconfig(struct iw_freq *freq, unsigned int *dsconfig)
 /*
  * common functions
  */
+static int set_infra_mode(struct usbnet *usbdev, int mode);
 static void restore_keys(struct usbnet *usbdev);
 static int rndis_check_bssid_list(struct usbnet *usbdev);
 
@@ -1014,6 +1015,11 @@ static int disassociate(struct usbnet *usbdev, int reset_ssid)
 	/* disassociate causes radio to be turned off; if reset_ssid
 	 * is given, set random ssid to enable radio */
 	if (reset_ssid) {
+		/* Set device to infrastructure mode so we don't get ad-hoc
+		 * 'media connect' indications with the random ssid.
+		 */
+		set_infra_mode(usbdev, NDIS_80211_INFRA_INFRA);
+
 		ssid.length = cpu_to_le32(sizeof(ssid.essid));
 		get_random_bytes(&ssid.essid[2], sizeof(ssid.essid)-2);
 		ssid.essid[0] = 0x1;

