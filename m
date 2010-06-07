Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab0FGKCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 06:02:42 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/4 2.6.34.y] mac80211: explicitly disable/enable QoS
Date: Mon,  7 Jun 2010 12:01:06 +0200
Message-Id: <1275904869-6634-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit e1b3ec1a2a336c328c336cfa5485a5f0484cc90d upstream.

Add interface to disable/enable QoS (aka WMM or WME). Currently drivers
enable it explicitly when ->conf_tx method is called, and newer disable.
Disabling is needed for some APs, which do not support QoS, such
we should send QoS frames to them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/mlme.c    |    9 ++++++++-
 net/mac80211/util.c    |    5 +++++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 45d7d44..ea607d6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -580,11 +580,15 @@ struct ieee80211_rx_status {
  *	may turn the device off as much as possible. Typically, this flag will
  *	be set when an interface is set UP but not associated or scanning, but
  *	it can also be unset in that case when monitor interfaces are active.
+ * @IEEE80211_CONF_QOS: Enable 802.11e QoS also know as WMM (Wireless
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
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 875c8de..1b80e2b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -592,6 +592,9 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	int count;
 	u8 *pos, uapsd_queues = 0;
 
+	if (!local->ops->conf_tx)
+		return;
+
 	if (local->hw.queues < 4)
 		return;
 
@@ -666,11 +669,15 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
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
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 53af570..582f43a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -796,6 +796,11 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 
 		drv_conf_tx(local, queue, &qparam);
 	}
+
+	/* after reinitialize QoS TX queues setting to default,
+	 * disable QoS at all */
+	local->hw.conf.flags &=	~IEEE80211_CONF_QOS;
+	drv_config(local, IEEE80211_CONF_CHANGE_QOS);
 }
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
-- 
1.6.2.5

