Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39624 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1DBBcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 21:32:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: return success in set_default_key for WPA/WPA2
Date: Fri,  1 Apr 2011 18:36:46 -0700
Message-Id: <1301708207-16265-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When testing wpa_supplicant with 'nl80211' driver to connect
to an AP with WPA/WPA2 security, we notice the followings:

1) add_key is called firstly with the key from cfg80211
2) set_defaut_key is called next

set_default_key() is specific to WEP keys and should not be
called in case of WPA/WPA2 security. The set_default_key()
won't be called if wpa_supplicant uses "-Dwext" option,
but it's been called if "-Dnl80211" option is specified.

We can fix this issue by adding a check to return from
set_default_key() if WEP key is not configured.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 2d96800..4ac4f5a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -228,6 +228,10 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	int ret;
 
+	/* Return if WEP key not configured */
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED)
+		return 0;
+
 	ret = mwifiex_set_encode(priv, NULL, 0, key_index, 0);
 
 	wiphy_dbg(wiphy, "info: set default Tx key index\n");
-- 
1.7.0.2

