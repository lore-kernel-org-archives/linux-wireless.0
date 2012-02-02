Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:54150 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753802Ab2BBEnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 23:43:12 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix NULL pointer dereference in set_channel()
Date: Wed,  1 Feb 2012 20:41:44 -0800
Message-Id: <1328157705-21564-2-git-send-email-bzhao@marvell.com> (sfid-20120202_054316_105335_A86845B3)
In-Reply-To: <1328157705-21564-1-git-send-email-bzhao@marvell.com>
References: <1328157705-21564-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In set_channel() callback handler, "priv" pointer is derived from
net_device. Sometimes net_device pointer coming from the stack
is NULL which causes kernel crash.
This patch fixes the problem by deriving "priv" from wiphy
when net_device pointer is NULL.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6fef492..54e45c8 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -376,7 +376,12 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan,
 			     enum nl80211_channel_type channel_type)
 {
-	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv;
+
+	if (dev)
+		priv = mwifiex_netdev_get_priv(dev);
+	else
+		priv = mwifiex_cfg80211_get_priv(wiphy);
 
 	if (priv->media_connected) {
 		wiphy_err(wiphy, "This setting is valid only when station "
-- 
1.7.0.2

