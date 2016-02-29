Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbcB2NZg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 08:25:36 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, QH <qiumin.hu@gmail.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Etan Cohen <etancohen@google.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/12] cfg80211: add utility functions to clone and free nan_func
Date: Mon, 29 Feb 2016 15:25:08 +0200
Message-Id: <1456752313-5792-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160229_142538_605119_1F1FD134)
In-Reply-To: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Add cfg80211_free_nan_func and cfg80211_clone_nan_func. These helper
functions will be used by mac80211 in the next patch.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h |  21 ++++++++++
 net/wireless/util.c    | 112 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a016abc..157376b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5510,6 +5510,27 @@ void cfg80211_nan_func_terminated(struct wireless_dev *wdev,
 				  enum nl80211_nan_func_term_reason reason,
 				  u64 cookie, gfp_t gfp);
 
+/**
+ * cfg80211_free_nan_func_members - free nan function members
+ * @f: NAN function that should be freed
+ *
+ * Frees all the allocated members of the given function, however
+ * it doesn't frees the pointed memory. This function can be only called if @f
+ * was cloned using cfg80211_clone_nan_func_members()
+ */
+void cfg80211_free_nan_func_members(struct cfg80211_nan_func *f);
+
+/**
+ * cfg80211_clone_nan_func_members - clone nan function
+ * @f1: destination
+ * @f2: source
+ *
+ * Clones @f2 to @f1. The function doesn't allocate @f1. Returns 0 on success.
+ * To free @f1's members cfg80211_free_nan_func_members() should be used.
+ */
+int cfg80211_clone_nan_func_members(struct cfg80211_nan_func *f1,
+				    const struct cfg80211_nan_func *f2);
+
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index bdf0c40..09f07c7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1757,6 +1757,118 @@ int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
 }
 EXPORT_SYMBOL(cfg80211_get_station);
 
+void cfg80211_free_nan_func_members(struct cfg80211_nan_func *f)
+{
+	int i;
+
+	kfree(f->serv_spec_info);
+	kfree(f->srf_bf);
+	kfree(f->srf_macs);
+	for (i = 0; i < f->num_rx_filters; i++)
+		kfree(f->rx_filters[i].filter);
+
+	for (i = 0; i < f->num_tx_filters; i++)
+		kfree(f->tx_filters[i].filter);
+
+	kfree(f->rx_filters);
+	kfree(f->tx_filters);
+}
+EXPORT_SYMBOL(cfg80211_free_nan_func_members);
+
+static int
+ieee80211_clone_match_filters(struct cfg80211_nan_func_filter *filt1,
+			      const struct cfg80211_nan_func_filter *filt2,
+			      int num_filters)
+{
+	int i;
+
+	for (i = 0; i < num_filters; i++) {
+		filt1[i].filter = kmemdup(filt2[i].filter, filt2[i].len,
+					  GFP_KERNEL);
+		filt1[i].len = filt2[i].len;
+
+		if (!filt1[i].filter)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+int cfg80211_clone_nan_func_members(struct cfg80211_nan_func *f1,
+				    const struct cfg80211_nan_func *f2)
+{
+	memcpy(f1, f2, sizeof(*f1));
+
+	/* set all pointers to NULL so we can free them in case of failure */
+	f1->serv_spec_info = NULL;
+	f1->srf_bf = NULL;
+	f1->srf_macs = NULL;
+	f1->rx_filters = NULL;
+	f1->tx_filters = NULL;
+	f1->num_rx_filters = 0;
+	f1->num_tx_filters = 0;
+
+	if (f2->serv_spec_info_len) {
+		f1->serv_spec_info = kmemdup(f2->serv_spec_info,
+					     f2->serv_spec_info_len,
+					     GFP_KERNEL);
+		if (!f1->serv_spec_info)
+			goto err;
+	}
+
+	if (f2->srf_bf_len) {
+		f1->srf_bf = kmemdup(f2->srf_bf, f2->srf_bf_len, GFP_KERNEL);
+		if (!f1->srf_bf)
+			goto err;
+	}
+
+	if (f2->srf_num_macs) {
+		f1->srf_macs = kmemdup(f2->srf_macs,
+				       f2->srf_num_macs *
+				       sizeof(*f2->srf_macs),
+				       GFP_KERNEL);
+		if (!f1->srf_macs)
+			goto err;
+	}
+
+	if (f2->num_rx_filters) {
+		f1->rx_filters = kcalloc(f2->num_rx_filters,
+					 sizeof(*f1->rx_filters),
+					 GFP_KERNEL);
+		if (!f1->rx_filters)
+			goto err;
+
+		if (!ieee80211_clone_match_filters(f1->rx_filters,
+						   f2->rx_filters,
+						   f2->num_rx_filters))
+			goto err;
+
+		f1->num_rx_filters = f2->num_rx_filters;
+	}
+
+	if (f2->num_tx_filters) {
+		f1->tx_filters = kcalloc(f2->num_tx_filters,
+					 sizeof(*f1->tx_filters),
+					 GFP_KERNEL);
+		if (!f1->tx_filters)
+			goto err;
+
+		if (!ieee80211_clone_match_filters(f1->tx_filters,
+						   f2->tx_filters,
+						   f2->num_tx_filters))
+			goto err;
+
+		f1->num_tx_filters = f2->num_tx_filters;
+	}
+
+	return 0;
+err:
+	cfg80211_free_nan_func_members(f1);
+
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(cfg80211_clone_nan_func_members);
+
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
 const unsigned char rfc1042_header[] __aligned(2) =
-- 
2.5.0

