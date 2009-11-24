Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:52888 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933226AbZKXPZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 10:25:42 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC 2/3] cfg80211: Add PMKSA wext compatibility handler
Date: Tue, 24 Nov 2009 16:26:53 +0100
Message-Id: <fce5ca6545ef79bb7ce9c9abf3e9348d070637dc.1259075573.git.sameo@linux.intel.com>
In-Reply-To: <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
References: <cover.1259075573.git.sameo@linux.intel.com>
 <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
In-Reply-To: <cover.1259075573.git.sameo@linux.intel.com>
References: <cover.1259075573.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the addition of the *_pmksa cfg80211 ops, we can now add the
corresponding wireless extensions compatibility handler.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/wireless/wext-compat.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 29091ac..7e7985e 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1401,6 +1401,47 @@ int cfg80211_wext_giwessid(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwessid);
 
+int cfg80211_wext_siwpmksa(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_pmksa cfg_pmksa;
+	struct iw_pmksa* pmksa = (struct iw_pmksa *)extra;
+
+	memset(&cfg_pmksa, 0, sizeof(struct cfg80211_pmksa));
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION)
+		return -EINVAL;
+
+	cfg_pmksa.bssid = pmksa->bssid.sa_data;
+	cfg_pmksa.pmkid = pmksa->pmkid;
+
+	switch (pmksa->cmd) {
+	case IW_PMKSA_ADD:
+		if (!rdev->ops->set_pmksa)
+			return -EOPNOTSUPP;
+
+		return rdev->ops->set_pmksa(&rdev->wiphy, dev, &cfg_pmksa);
+
+	case IW_PMKSA_REMOVE:
+		if (!rdev->ops->del_pmksa)
+			return -EOPNOTSUPP;
+
+		return rdev->ops->del_pmksa(&rdev->wiphy, dev, &cfg_pmksa);
+
+	case IW_PMKSA_FLUSH:
+		if (!rdev->ops->flush_pmksa)
+			return -EOPNOTSUPP;
+
+		return rdev->ops->flush_pmksa(&rdev->wiphy, dev);
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const iw_handler cfg80211_handlers[] = {
 	[IW_IOCTL_IDX(SIOCGIWNAME)]	= (iw_handler) cfg80211_wext_giwname,
 	[IW_IOCTL_IDX(SIOCSIWFREQ)]	= (iw_handler) cfg80211_wext_siwfreq,
@@ -1433,6 +1474,7 @@ static const iw_handler cfg80211_handlers[] = {
 	[IW_IOCTL_IDX(SIOCSIWAUTH)]	= (iw_handler) cfg80211_wext_siwauth,
 	[IW_IOCTL_IDX(SIOCGIWAUTH)]	= (iw_handler) cfg80211_wext_giwauth,
 	[IW_IOCTL_IDX(SIOCSIWENCODEEXT)]= (iw_handler) cfg80211_wext_siwencodeext,
+	[IW_IOCTL_IDX(SIOCSIWPMKSA)]	= (iw_handler) cfg80211_wext_siwpmksa,
 };
 
 const struct iw_handler_def cfg80211_wext_handler = {
-- 
1.6.3.3

