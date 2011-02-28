Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42984 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab1B1QuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:50:19 -0500
Received: by mail-fx0-f46.google.com with SMTP id 17so3916695fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:50:18 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/9] [mac80211] add method to access oper chan
Date: Mon, 28 Feb 2011 17:46:22 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281746.23102.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm really not sure about this.. is there another/better way to
access the current channel last set on a wiphy?

Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
---
 include/net/cfg80211.h |    2 ++
 net/mac80211/cfg.c     |    8 ++++++++
 net/wireless/chan.c    |    2 +-
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 679a049..8300699 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1121,6 +1121,7 @@ struct cfg80211_pmksa {
  *	doesn't verify much. Note, however, that the passed netdev may be
  *	%NULL as well if the user requested changing the channel for the
  *	device itself, or for a monitor interface.
+ * @get_channel: Get current channel for a given wireless interface.
  *
  * @scan: Request to do a scan. If returning zero, the scan request is given
  *	the driver, and will be valid until passed to cfg80211_scan_done().
@@ -1276,6 +1277,7 @@ struct cfg80211_ops {
 	int	(*set_channel)(struct wiphy *wiphy, struct net_device *dev,
 			       struct ieee80211_channel *chan,
 			       enum nl80211_channel_type channel_type);
+	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
 
 	int	(*scan)(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8b436c7..2a05b31 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1257,6 +1257,13 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	return 0;
 }
 
+static struct ieee80211_channel *ieee80211_get_oper_channel(struct wiphy *wiphy)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return local->oper_channel;
+}
+
 #ifdef CONFIG_PM
 static int ieee80211_suspend(struct wiphy *wiphy)
 {
@@ -2027,6 +2034,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
 	.set_channel = ieee80211_set_channel,
+	.get_channel = ieee80211_get_oper_channel,
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 17cd0c0..4e63e67 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -93,7 +93,7 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 			return -ENETDOWN;
 	}
 
-	if (!rdev->ops->set_channel)
+	if (!rdev->ops->set_channel || !rdev->ops->get_channel)
 		return -EOPNOTSUPP;
 
 	chan = rdev_freq_to_chan(rdev, freq, channel_type);
-- 
1.7.2.3
