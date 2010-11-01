Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26084 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcG020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:20 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 04/15] cfg80211: add periodic scan start and stop ops
Date: Mon,  1 Nov 2010 13:52:05 +0200
Message-Id: <1288612336-2830-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add periodic_start and periodic_stop operations to the wireless configuration
API.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/net/cfg80211.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 84518cc..ac7b934 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1158,6 +1158,8 @@ struct cfg80211_pmksa {
  * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
+ * @periodic_start: Tell the driver to start a periodic scan.
+ * @periodic_stop: Tell the driver to stop an ongoing periodic scan.
  *
  * @mgmt_frame_register: Notify driver that a management frame type was
  *	registered. Note that this callback may not sleep, and cannot run
@@ -1316,6 +1318,12 @@ struct cfg80211_ops {
 	void	(*mgmt_frame_register)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       u16 frame_type, bool reg);
+	int	(*periodic_start)(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct cfg80211_periodic_request *request);
+	int	(*periodic_stop)(struct wiphy *wiphy,
+				 struct net_device *dev,
+				 struct cfg80211_periodic_request *request);
 };
 
 /*
-- 
1.7.0.4

