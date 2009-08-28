Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:44128 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZH1K2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:28:23 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 08/10] rndis_wlan: convert mic failure wireless event to
	cfg80211
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:28:24 +0300
Message-ID: <20090828102824.15684.18948.stgit@fate.lan>
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 6919c54..01cd341 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2720,9 +2720,10 @@ static void rndis_wlan_auth_indication(struct usbnet *usbdev,
 {
 	u8 *buf;
 	const char *type;
-	int flags, buflen;
+	int flags, buflen, key_id;
 	bool pairwise_error, group_error;
 	struct ndis_80211_auth_request *auth_req;
+	enum nl80211_key_type key_type;
 
 	/* must have at least one array entry */
 	if (len < offsetof(struct ndis_80211_status_indication, u) +
@@ -2758,23 +2759,24 @@ static void rndis_wlan_auth_indication(struct usbnet *usbdev,
 		devinfo(usbdev, "authentication indication: %s (0x%08x)", type,
 				le32_to_cpu(auth_req->flags));
 
-		if (pairwise_error || group_error) {
-			union iwreq_data wrqu;
-			struct iw_michaelmicfailure micfailure;
+		if (pairwise_error) {
+			key_type = NL80211_KEYTYPE_PAIRWISE;
+			key_id = -1;
 
-			memset(&micfailure, 0, sizeof(micfailure));
-			if (pairwise_error)
-				micfailure.flags |= IW_MICFAILURE_PAIRWISE;
-			if (group_error)
-				micfailure.flags |= IW_MICFAILURE_GROUP;
+			cfg80211_michael_mic_failure(usbdev->net,
+							auth_req->bssid,
+							key_type, key_id, NULL,
+							GFP_KERNEL);
+		}
 
-			memcpy(micfailure.src_addr.sa_data, auth_req->bssid,
-				ETH_ALEN);
+		if (group_error) {
+			key_type = NL80211_KEYTYPE_GROUP;
+			key_id = -1;
 
-			memset(&wrqu, 0, sizeof(wrqu));
-			wrqu.data.length = sizeof(micfailure);
-			wireless_send_event(usbdev->net, IWEVMICHAELMICFAILURE,
-						&wrqu, (u8 *)&micfailure);
+			cfg80211_michael_mic_failure(usbdev->net,
+							auth_req->bssid,
+							key_type, key_id, NULL,
+							GFP_KERNEL);
 		}
 
 		buflen -= le32_to_cpu(auth_req->length);

