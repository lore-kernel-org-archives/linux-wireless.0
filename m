Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7063 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbaIJTa3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 15:30:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211/mac80211: add wmm info to assoc event
Date: Wed, 10 Sep 2014 22:26:40 +0300
Message-Id: <1410377200-20831-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_213246_652844_873CEA52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Userspace might need to know what queues are configured
for uapsd (e.g. for setting proper default values in tspecs).

Add this bitmap to the association event (inside wmm
nested attribute)

Add additional parameter to cfg80211_rx_assoc_resp,
and update its callers.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h |  4 +++-
 net/mac80211/mlme.c    |  9 ++++++++-
 net/wireless/mlme.c    |  4 ++--
 net/wireless/nl80211.c | 28 +++++++++++++++++++++-------
 net/wireless/nl80211.h |  3 ++-
 5 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0d17ec9..825ffd0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3925,6 +3925,7 @@ void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr);
  *	moves to cfg80211 in this call
  * @buf: authentication frame (header + body)
  * @len: length of the frame data
+ * @uapsd_queues: bitmap of ACs configured to uapsd. -1 if n/a.
  *
  * After being asked to associate via cfg80211_ops::assoc() the driver must
  * call either this function or cfg80211_auth_timeout().
@@ -3933,7 +3934,8 @@ void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr);
  */
 void cfg80211_rx_assoc_resp(struct net_device *dev,
 			    struct cfg80211_bss *bss,
-			    const u8 *buf, size_t len);
+			    const u8 *buf, size_t len,
+			    int uapsd_queues);
 
 /**
  * cfg80211_assoc_timeout - notification of timed out association
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a7b92f5..efa41fc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2817,6 +2817,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
 	u16 capab_info, status_code, aid;
 	struct ieee802_11_elems elems;
+	int ac, uapsd_queues = -1;
 	u8 *pos;
 	bool reassoc;
 	struct cfg80211_bss *bss;
@@ -2886,9 +2887,15 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		 * is set can cause the interface to go idle
 		 */
 		ieee80211_destroy_assoc_data(sdata, true);
+
+		/* get uapsd queues configuration */
+		uapsd_queues = 0;
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+			if (sdata->tx_conf[ac].uapsd)
+				uapsd_queues |= BIT(ac);
 	}
 
-	cfg80211_rx_assoc_resp(sdata->dev, bss, (u8 *)mgmt, len);
+	cfg80211_rx_assoc_resp(sdata->dev, bss, (u8 *)mgmt, len, uapsd_queues);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 369fc33..2c52b59 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -19,7 +19,7 @@
 
 
 void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
-			    const u8 *buf, size_t len)
+			    const u8 *buf, size_t len, int uapsd_queues)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -43,7 +43,7 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 		return;
 	}
 
-	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL);
+	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL, uapsd_queues);
 	/* update current_bss etc., consumes the bss reference */
 	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
 				  status_code,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cf178d2..75e81be 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10402,7 +10402,8 @@ nla_put_failure:
 static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
 				    struct net_device *netdev,
 				    const u8 *buf, size_t len,
-				    enum nl80211_commands cmd, gfp_t gfp)
+				    enum nl80211_commands cmd, gfp_t gfp,
+				    int uapsd_queues)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -10422,6 +10423,19 @@ static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
 	    nla_put(msg, NL80211_ATTR_FRAME, len, buf))
 		goto nla_put_failure;
 
+	if (uapsd_queues >= 0) {
+		struct nlattr *nla_wmm =
+			nla_nest_start(msg, NL80211_ATTR_STA_WME);
+		if (!nla_wmm)
+			goto nla_put_failure;
+
+		if (nla_put_u8(msg, NL80211_STA_WME_UAPSD_QUEUES,
+			       uapsd_queues))
+			goto nla_put_failure;
+
+		nla_nest_end(msg, nla_wmm);
+	}
+
 	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
@@ -10438,15 +10452,15 @@ void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 			  size_t len, gfp_t gfp)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_AUTHENTICATE, gfp);
+				NL80211_CMD_AUTHENTICATE, gfp, -1);
 }
 
 void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev, const u8 *buf,
-			   size_t len, gfp_t gfp)
+			   size_t len, gfp_t gfp, int uapsd_queues)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_ASSOCIATE, gfp);
+				NL80211_CMD_ASSOCIATE, gfp, uapsd_queues);
 }
 
 void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
@@ -10454,7 +10468,7 @@ void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
 			 size_t len, gfp_t gfp)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_DEAUTHENTICATE, gfp);
+				NL80211_CMD_DEAUTHENTICATE, gfp, -1);
 }
 
 void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
@@ -10462,7 +10476,7 @@ void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 			   size_t len, gfp_t gfp)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_DISASSOCIATE, gfp);
+				NL80211_CMD_DISASSOCIATE, gfp, -1);
 }
 
 void cfg80211_rx_unprot_mlme_mgmt(struct net_device *dev, const u8 *buf,
@@ -10483,7 +10497,7 @@ void cfg80211_rx_unprot_mlme_mgmt(struct net_device *dev, const u8 *buf,
 		cmd = NL80211_CMD_UNPROT_DISASSOCIATE;
 
 	trace_cfg80211_rx_unprot_mlme_mgmt(dev, buf, len);
-	nl80211_send_mlme_event(rdev, dev, buf, len, cmd, GFP_ATOMIC);
+	nl80211_send_mlme_event(rdev, dev, buf, len, cmd, GFP_ATOMIC, -1);
 }
 EXPORT_SYMBOL(cfg80211_rx_unprot_mlme_mgmt);
 
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 49c9a48..7ad70d6 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -23,7 +23,8 @@ void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 			  const u8 *buf, size_t len, gfp_t gfp);
 void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev,
-			   const u8 *buf, size_t len, gfp_t gfp);
+			   const u8 *buf, size_t len, gfp_t gfp,
+			   int uapsd_queues);
 void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
 			 struct net_device *netdev,
 			 const u8 *buf, size_t len, gfp_t gfp);
-- 
1.9.1

