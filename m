Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50538 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbbAGL7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 06:59:25 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t07BxIPv008663
	for <linux-wireless@vger.kernel.org>; Wed, 7 Jan 2015 03:59:24 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rs21qrfmn-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 03:59:24 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: check driver status in connect and scan handlers
Date: Wed, 7 Jan 2015 03:57:39 -0800
Message-ID: <1420631859-29004-1-git-send-email-akarwar@marvell.com> (sfid-20150107_125928_871033_301FD224)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ignore scan and connection requests from cfg80211 when driver
unload is in process or previous command has timed out due to
a firmware bug. This patch fixes corner case system crash
issues.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 8 ++++++++
 drivers/net/wireless/mwifiex/scan.c     | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 93ab36f..06feb44 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1784,6 +1784,7 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_connect_params *sme)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret;
 
 	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA) {
@@ -1798,6 +1799,13 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		return -EALREADY;
 	}
 
+	if (adapter->surprise_removed || adapter->is_cmd_timedout) {
+		wiphy_err(wiphy,
+			  "%s: Ignore connection. Card removed or FW in bad state\n",
+			  dev->name);
+		return -EFAULT;
+	}
+
 	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
 		  (char *) sme->ssid, sme->bssid);
 
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 984a7a4..e304f07 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1429,6 +1429,12 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 		return -EBUSY;
 	}
 
+	if (adapter->surprise_removed || adapter->is_cmd_timedout) {
+		dev_err(adapter->dev,
+			"Ignore scan. Card removed or firmware in bad state\n");
+		return -EFAULT;
+	}
+
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 	adapter->scan_processing = true;
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-- 
1.8.1.4

