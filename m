Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1763 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934172AbZKXW7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 17:59:15 -0500
Date: Wed, 25 Nov 2009 00:01:01 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH v2 2/3] cfg80211: Add PMKSA wext compatibility handler
Message-ID: <20091124230100.GC8290@sortiz.org>
References: <cover.1259075573.git.sameo@linux.intel.com>
 <fce5ca6545ef79bb7ce9c9abf3e9348d070637dc.1259075573.git.sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fce5ca6545ef79bb7ce9c9abf3e9348d070637dc.1259075573.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the addition of the *_pmksa cfg80211 ops, we can now add the
corresponding wireless extensions compatibility handler.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---

v2: Fixed a coding style issue thanks to johill's eagle eye.

 net/wireless/wext-compat.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 29091ac..584eb48 100644
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
+	struct iw_pmksa *pmksa = (struct iw_pmksa *)extra;
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

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
