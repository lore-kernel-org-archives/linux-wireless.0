Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40841 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab2HKAaq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:30:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: adapt changes in cfg80211.h in wil6210
Date: Sat, 11 Aug 2012 02:30:24 +0200
Message-Id: <1344645025-26796-1-git-send-email-hauke@hauke-m.de> (sfid-20120811_023049_094718_8D20B0C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct cfg80211_ops changed and this patches changes wil6210 to use the
correct parameter types in the callback functions.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 ...s-adds-the-802.11ad-60-GHz-wil6210-driver.patch |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crap/0004-wireless-adds-the-802.11ad-60-GHz-wil6210-driver.patch b/crap/0004-wireless-adds-the-802.11ad-60-GHz-wil6210-driver.patch
index 32ee1fc..d3406de 100644
--- a/crap/0004-wireless-adds-the-802.11ad-60-GHz-wil6210-driver.patch
+++ b/crap/0004-wireless-adds-the-802.11ad-60-GHz-wil6210-driver.patch
@@ -323,7 +323,7 @@ Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
 +	return 0;
 +}
 +
-+static int wil_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
++static int wil_cfg80211_scan(struct wiphy *wiphy,
 +			     struct cfg80211_scan_request *request)
 +{
 +#if 0
@@ -601,7 +601,7 @@ Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
 +	return 0;
 +}
 +
-+static int wil_mgmt_tx(struct wiphy *wiphy, struct net_device *ndev,
++static int wil_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 +		struct ieee80211_channel *chan, bool offchan,
 +		enum nl80211_channel_type channel_type,
 +		bool channel_type_valid, unsigned int wait,
@@ -617,7 +617,7 @@ Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
 +}
 +
 +static void wil_mgmt_frame_register(struct wiphy *wiphy,
-+		struct net_device *ndev, u16 frame_type, bool reg)
++		struct wireless_dev *wdev, u16 frame_type, bool reg)
 +{
 +	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 +	wil_info(wil, "%s()\n", __func__);
-- 
1.7.9.5

