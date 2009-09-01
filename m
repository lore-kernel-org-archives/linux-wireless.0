Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:54183 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbZIAMdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 08:33:05 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/4] rndis_wlan: fix sparse endianess warnings
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 01 Sep 2009 15:33:06 +0300
Message-ID: <20090901123306.9213.26466.stgit@fate.lan>
In-Reply-To: <20090901123255.9213.57970.stgit@fate.lan>
References: <20090901123255.9213.57970.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index add2eb8..54175b6 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -253,8 +253,8 @@ struct ndis_80211_pmkid_cand_list {
 struct ndis_80211_status_indication {
 	__le32 status_type;
 	union {
-		enum ndis_80211_media_stream_mode	media_stream_mode;
-		enum ndis_80211_radio_status		radio_status;
+		__le32					media_stream_mode;
+		__le32					radio_status;
 		struct ndis_80211_auth_request		auth_request[0];
 		struct ndis_80211_pmkid_cand_list	cand_list;
 	} u;
@@ -1296,7 +1296,7 @@ static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
 
 static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 			int index, const u8 *addr, const u8 *rx_seq,
-			int seq_len, u32 cipher, int flags)
+			int seq_len, u32 cipher, __le32 flags)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_key ndis_key;
@@ -2023,7 +2023,7 @@ static int rndis_add_key(struct wiphy *wiphy, struct net_device *netdev,
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
 	struct usbnet *usbdev = priv->usbdev;
-	int flags;
+	__le32 flags;
 
 	devdbg(usbdev, "rndis_add_key(%i, %pM, %08x)", key_index, mac_addr,
 							params->cipher);

