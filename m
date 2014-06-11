Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33927 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaFKOSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:50 -0400
Received: by mail-wg0-f51.google.com with SMTP id x12so6234617wgg.34
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:48 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 10/10] mac80211: protect TDLS discovery session
Date: Wed, 11 Jun 2014 17:18:27 +0300
Message-Id: <1402496307-32522-10-git-send-email-arik@wizery.com> (sfid-20140611_161853_445776_0CA4C088)
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After sending a TDLS discovery-request, we expect a reply to arrive on
the AP's channel. We must stay on the channel (no PSM, scan, etc.), since
a TDLS setup-response is a direct packet not buffered by the AP.
Add a new mac80211 driver callback to allow discovery session protection.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h    | 12 ++++++++++++
 net/mac80211/driver-ops.h | 16 ++++++++++++++++
 net/mac80211/tdls.c       | 10 +++++++++-
 net/mac80211/trace.h      |  7 +++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8d876dc..18c2bdb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2764,6 +2764,15 @@ enum ieee80211_roc_type {
  *	mac80211 will transmit the frame right away.
  *	The callback is optional and can (should!) sleep.
  *
+ * @mgd_protect_tdls_discover: Protect a TDLS discovery session. After sending
+ *	a TDLS discovery-request, we expect a reply to arrive on the AP's
+ *	channel. We must stay on the channel (no PSM, scan, etc.), since a TDLS
+ *	setup-response is a direct packet not buffered by the AP.
+ *	mac80211 will call this function just before the transmission of a TDLS
+ *	discovery-request. The recommended period of protection is at least
+ *	2 * (DTIM period).
+ *	The callback is optional and can sleep.
+ *
  * @add_chanctx: Notifies device driver about new channel context creation.
  * @remove_chanctx: Notifies device driver about channel context destruction.
  * @change_chanctx: Notifies device driver about channel context changes that
@@ -2981,6 +2990,9 @@ struct ieee80211_ops {
 	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif);
 
+	void	(*mgd_protect_tdls_discover)(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif);
+
 	int (*add_chanctx)(struct ieee80211_hw *hw,
 			   struct ieee80211_chanctx_conf *ctx);
 	void (*remove_chanctx)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index bd782dc..2265bd7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -970,6 +970,22 @@ static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void
+drv_mgd_protect_tdls_discover(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata)
+{
+	might_sleep();
+
+	if (!check_sdata_in_driver(sdata))
+		return;
+	WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION);
+
+	trace_drv_mgd_protect_tdls_discover(local, sdata);
+	if (local->ops->mgd_protect_tdls_discover)
+		local->ops->mgd_protect_tdls_discover(&local->hw, &sdata->vif);
+	trace_drv_return_void(local);
+}
+
 static inline int drv_add_chanctx(struct ieee80211_local *local,
 				  struct ieee80211_chanctx *ctx)
 {
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index f100c12..a937cd9 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -10,6 +10,7 @@
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 
 /* give usermode some time for retries in setting up the TDLS session */
 #define TDLS_PEER_SETUP_TIMEOUT	(15 * HZ)
@@ -444,8 +445,15 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 						   peer_capability, initiator,
 						   extra_ies, extra_ies_len);
 		break;
-	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
+		/*
+		 * Protect the discovery so we can hear the TDLS discovery
+		 * response frame. It is transmitted directly and not buffered
+		 * by the AP.
+		 */
+		drv_mgd_protect_tdls_discover(sdata->local, sdata);
+		/* fall-through */
+	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
 		/* no special handling */
 		ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer,
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index b22d696..e7a52a3 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1330,6 +1330,13 @@ DEFINE_EVENT(local_sdata_evt, drv_mgd_prepare_tx,
 	TP_ARGS(local, sdata)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_mgd_protect_tdls_discover,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+
+	TP_ARGS(local, sdata)
+);
+
 DECLARE_EVENT_CLASS(local_chanctx,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_chanctx *ctx),
-- 
1.9.1

