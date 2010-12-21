Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:56369 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0LUUoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 15:44:16 -0500
Subject: [PATCH 2/7] rndis_wlan: do not set default_key if not WEP key
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Dec 2010 22:44:12 +0200
Message-ID: <20101221204412.12250.10396.stgit@fate.lan>
In-Reply-To: <20101221204405.12250.35410.stgit@fate.lan>
References: <20101221204405.12250.35410.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_set_default_key did call add_wep_key to set default key on device, even
if key is WPA. This caused rndis_wlan not work with wpa_supplicant in nl80211
mode (causing disconnect from AP).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index de4c050..9e6105c 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2435,6 +2435,9 @@ static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 
 	priv->encr_tx_key_index = key_index;
 
+	if (is_wpa_key(priv, key_index))
+		return 0;
+
 	key = priv->encr_keys[key_index];
 
 	return add_wep_key(usbdev, key.material, key.len, key_index);

