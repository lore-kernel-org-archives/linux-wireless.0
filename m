Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab0CZQsw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 12:48:52 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	<wey-yi.w.guy@intel.com>, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] mac80211: explicitly disable/enable QoS
Date: Fri, 26 Mar 2010 17:46:31 +0100
Message-Id: <1269621992-5034-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add interface to disable/enable QoS (aka WMM or WME). Currently drivers
enable it explicitly when ->conf_tx method is called, and newer disable.
Disabling is needed for some APs, which do not support QoS, such
we should send QoS frames to them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/mac80211.h     |    5 +++++
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/iface.c       |    2 +-
 net/mac80211/mlme.c        |   13 ++++++++++---
 net/mac80211/util.c        |   12 ++++++++++--
 5 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 45d7d44..3ff4b07 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -580,11 +580,15 @@ struct ieee80211_rx_status {
  *	may turn the device off as much as possible. Typically, this flag will
  *	be set when an interface is set UP but not associated or scanning, but
  *	it can also be unset in that case when monitor interfaces are active.
+ * QIEEE80211_CONF_QOS: Enable 802.11e QoS also know as WMM (Wireless
+ *      Multimedia). On some drivers (iwlwifi is one of know) we have
+ *      to enable/disable QoS explicitly.
  */
 enum ieee80211_conf_flags {
 	IEEE80211_CONF_MONITOR		= (1<<0),
 	IEEE80211_CONF_PS		= (1<<1),
 	IEEE80211_CONF_IDLE		= (1<<2),
+	IEEE80211_CONF_QOS		= (1<<3),
 };
 
 
@@ -609,6 +613,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+	IEEE80211_CONF_CHANGE_QOS		= BIT(9),
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 241533e..ef55403 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1137,7 +1137,7 @@ int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
 				     gfp_t gfp);
-void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata, bool wmm_on);
 void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0793d7a..a083d45 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -315,7 +315,7 @@ static int ieee80211_open(struct net_device *dev)
 		 * need to initialise the hardware if the hardware
 		 * doesn't start up with sane defaults
 		 */
-		ieee80211_set_wmm_default(sdata);
+		ieee80211_set_wmm_default(sdata, true);
 	}
 
 	ieee80211_recalc_ps(local, -1);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index be5f723..3d7ba04 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -589,6 +589,9 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	int count;
 	u8 *pos, uapsd_queues = 0;
 
+	if (!local->ops->conf_tx)
+		return;
+
 	if (local->hw.queues < 4)
 		return;
 
@@ -663,11 +666,15 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		       params.aifs, params.cw_min, params.cw_max, params.txop,
 		       params.uapsd);
 #endif
-		if (drv_conf_tx(local, queue, &params) && local->ops->conf_tx)
+		if (drv_conf_tx(local, queue, &params))
 			printk(KERN_DEBUG "%s: failed to set TX queue "
 			       "parameters for queue %d\n",
 			       wiphy_name(local->hw.wiphy), queue);
 	}
+
+	/* enable WMM or activate new settings */
+	local->hw.conf.flags |=	IEEE80211_CONF_QOS;
+	drv_config(local, IEEE80211_CONF_CHANGE_QOS);
 }
 
 static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
@@ -813,7 +820,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata)
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;
 
-	ieee80211_set_wmm_default(sdata);
+	ieee80211_set_wmm_default(sdata, true);
 
 	/* channel(_type) changes are handled by ieee80211_hw_config */
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
@@ -1130,7 +1137,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 					 elems.wmm_param_len);
 	else
-		ieee80211_set_wmm_default(sdata);
+		ieee80211_set_wmm_default(sdata, false);
 
 	local->oper_channel = wk->chan;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c453226..08fb98b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -734,7 +734,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 	return crc;
 }
 
-void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
+void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata, bool wmm_on)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_queue_params qparam;
@@ -796,6 +796,14 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 
 		drv_conf_tx(local, queue, &qparam);
 	}
+
+	/* activate new settings */
+	if (wmm_on)
+		local->hw.conf.flags |=	IEEE80211_CONF_QOS;
+	else
+		local->hw.conf.flags &=	~IEEE80211_CONF_QOS;
+
+	drv_config(local, IEEE80211_CONF_CHANGE_QOS);
 }
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
@@ -816,7 +824,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	ieee80211_set_wmm_default(sdata);
+	ieee80211_set_wmm_default(sdata, true);
 }
 
 u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
-- 
1.6.2.5

