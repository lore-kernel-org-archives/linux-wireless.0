Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24632 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0DULuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 07:50:13 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3LBnIbH019584
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 14:50:10 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3LBnavp016358
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 14:49:37 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv4 2/2] cfg80211: Remove default dynamic PS timeout value
Date: Wed, 21 Apr 2010 14:47:38 +0300
Message-Id: <1271850458-32437-3-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1271850458-32437-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1271850458-32437-1-git-send-email-juuso.oikarinen@nokia.com>
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
index 37cebd3..873edf9 100644
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

