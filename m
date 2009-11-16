Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:56335 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZKPKGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 05:06:12 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: handle NL80211_AUTHTYPE_AUTOMATIC
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 16 Nov 2009 11:56:54 +0200
Message-ID: <20091116095653.17419.49151.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_wlan didn't know about NL80211_AUTHTYPE_AUTOMATIC and simple
setup with 'iwconfig wlan essid no-encrypt' would fail (ENOSUPP).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 54175b6..dfc61fd 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1070,7 +1070,8 @@ static int set_auth_mode(struct usbnet *usbdev, u32 wpa_version,
 			auth_mode = NDIS_80211_AUTH_WPA_NONE;
 	} else if (auth_type == NL80211_AUTHTYPE_SHARED_KEY)
 		auth_mode = NDIS_80211_AUTH_SHARED;
-	else if (auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
+	else if (auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM ||
+			auth_type == NL80211_AUTHTYPE_AUTOMATIC)
 		auth_mode = NDIS_80211_AUTH_OPEN;
 	else
 		return -ENOTSUPP;

