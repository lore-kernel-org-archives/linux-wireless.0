Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51853 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab0LPA6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 19:58:00 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: modify set_default_key() prototype
Date: Wed, 15 Dec 2010 16:57:57 -0800
Message-Id: <1292461079-26318-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1292461079-26318-1-git-send-email-bzhao@marvell.com>
References: <1292461079-26318-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This fixes compilation warning introduced recently due to
set_default_key prototype change in cfg80211.h (dbd2fd6 by
Johannes Berg):

cfg80211/nl80211: separate unicast/multicast default TX keys

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 99dade5..8d74446 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -64,7 +64,8 @@ static int mwifiex_cfg80211_del_key(struct wiphy *wiphy,
 
 static int mwifiex_cfg80211_set_default_key(struct wiphy *wiphy,
 					    struct net_device *netdev,
-					    u8 key_index);
+					    u8 key_index, bool unicast,
+					    bool multicast);
 static int mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 					   struct net_device *dev, bool enabled,
 					   int timeout);
@@ -314,7 +315,8 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
  */
 static int
 mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
-				 u8 key_index)
+				 u8 key_index, bool unicast,
+				 bool multicast)
 {
 	return 0;
 }
-- 
1.7.0.2

