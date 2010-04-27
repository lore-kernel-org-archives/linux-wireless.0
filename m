Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:55203 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab0D0JsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 05:48:21 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] cfg80211: Remove default dynamic PS timeout value
Date: Tue, 27 Apr 2010 12:47:41 +0300
Message-Id: <1272361661-16811-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1272361661-16811-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1272361661-16811-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the mac80211 is choosing dynamic ps timeouts based on the ps-qos
network latency configuration, configure a default value of -1 as the dynamic
ps timeout in cfg80211. This value allows the mac80211 to determine the value
to be used.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/cfg80211.h |    2 ++
 net/wireless/core.c    |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5a4efe5..a609b4b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1018,6 +1018,8 @@ struct cfg80211_pmksa {
  *	RSN IE. It allows for faster roaming between WPA2 BSSIDs.
  * @del_pmksa: Delete a cached PMKID.
  * @flush_pmksa: Flush all cached PMKIDs.
+ * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
+ *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
  *
  */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6ac70c1..37d0e0a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -705,7 +705,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 			wdev->ps = true;
 		else
 			wdev->ps = false;
-		wdev->ps_timeout = 100;
+		/* allow mac80211 to determine the timeout */
+		wdev->ps_timeout = -1;
 		if (rdev->ops->set_power_mgmt)
 			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
 						      wdev->ps,
-- 
1.6.3.3

