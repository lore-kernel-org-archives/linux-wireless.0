Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51377 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1CQV5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 17:57:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: add set_default_key callback function support
Date: Thu, 17 Mar 2011 15:00:25 -0700
Message-Id: <1300399225-13066-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300399225-13066-1-git-send-email-bzhao@marvell.com>
References: <1300399225-13066-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The function invokes mwifiex_set_encode() which stores
the default Tx key index in driver and also passes it
to firmware.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   10 ++++++++++
 drivers/net/wireless/mwifiex/sta_ioctl.c |    3 ++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e28f1c7..f4d240e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -225,6 +225,16 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 				 u8 key_index, bool unicast,
 				 bool multicast)
 {
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	int ret;
+
+	ret = mwifiex_set_encode(priv, NULL, 0, key_index, 0);
+
+	wiphy_dbg(wiphy, "info: set default Tx key index\n");
+
+	if (ret)
+		return -EFAULT;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 436310d..1f8d562 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -2168,7 +2168,8 @@ int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 	encrypt_key.key_len = key_len;
 	if (!disable) {
 		encrypt_key.key_index = key_index;
-		memcpy(encrypt_key.key_material, key, key_len);
+		if (key_len)
+			memcpy(encrypt_key.key_material, key, key_len);
 	} else {
 		encrypt_key.key_disable = true;
 	}
-- 
1.7.0.2

