Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:37947 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZKPKti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 05:49:38 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH v2] rndis_wlan: handle NL80211_AUTHTYPE_AUTOMATIC
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Mon, 16 Nov 2009 12:49:43 +0200
Message-ID: <20091116104937.3845.62090.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_wlan didn't know about NL80211_AUTHTYPE_AUTOMATIC and simple
setup with 'iwconfig wlan essid no-encrypt' would fail (ENOSUPP).

v2: use NDIS_80211_AUTH_AUTO_SWITCH instead of _OPEN.
    This will make device try shared key auth first, then open.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 54175b6..aa1880a 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1072,6 +1072,8 @@ static int set_auth_mode(struct usbnet *usbdev, u32 wpa_version,
 		auth_mode = NDIS_80211_AUTH_SHARED;
 	else if (auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
 		auth_mode = NDIS_80211_AUTH_OPEN;
+	else if (auth_type == NL80211_AUTHTYPE_AUTOMATIC)
+		auth_mode = NDIS_80211_AUTH_AUTO_SWITCH;
 	else
 		return -ENOTSUPP;
 

