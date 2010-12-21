Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:54133 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0LUUou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 15:44:50 -0500
Subject: [PATCH 5/7] rndis_wlan: remove unused variable from priv structure
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Dec 2010 22:44:34 +0200
Message-ID: <20101221204434.12250.70551.stgit@fate.lan>
In-Reply-To: <20101221204405.12250.35410.stgit@fate.lan>
References: <20101221204405.12250.35410.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d0992fc..aa21d86 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -503,7 +503,6 @@ struct rndis_wlan_private {
 	int infra_mode;
 	bool connected;
 	u8 bssid[ETH_ALEN];
-	struct ndis_80211_ssid essid;
 	__le32 current_command_oid;
 
 	/* encryption stuff */
@@ -1026,7 +1025,6 @@ static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 		return ret;
 	}
 	if (ret == 0) {
-		memcpy(&priv->essid, ssid, sizeof(priv->essid));
 		priv->radio_on = true;
 		netdev_dbg(usbdev->net, "%s(): radio_on = true\n", __func__);
 	}

