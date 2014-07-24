Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32893 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665AbaGXKgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:36:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't duplicate station QoS capability data
Date: Thu, 24 Jul 2014 12:36:32 +0200
Message-Id: <1406198192-29442-1-git-send-email-johannes@sipsolutions.net> (sfid-20140724_123645_348075_85F44270)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We currently track the QoS capability twice: for all peer stations
in the WLAN_STA_WME flag, and for any clients associated to an AP
interface separately for drivers in the sta->sta.wme field.

Remove the WLAN_STA_WME flag and track the capability only in the
driver-visible field, getting rid of the limitation that the field
is only valid in AP mode.

Reviewed-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  2 +-
 net/mac80211/cfg.c         | 13 +++----------
 net/mac80211/debugfs_sta.c |  3 ++-
 net/mac80211/ibss.c        |  2 +-
 net/mac80211/mlme.c        |  3 +--
 net/mac80211/sta_info.c    |  4 ++--
 net/mac80211/sta_info.h    |  2 --
 net/mac80211/tdls.c        |  3 +--
 net/mac80211/tx.c          |  6 +++---
 net/mac80211/wme.c         |  4 ++--
 10 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dae2e24616e1..1cd84444665c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1405,7 +1405,7 @@ struct ieee80211_sta_rates {
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_cap: HT capabilities of this STA; restricted to our own capabilities
  * @vht_cap: VHT capabilities of this STA; restricted to our own capabilities
- * @wme: indicates whether the STA supports WME. Only valid during AP-mode.
+ * @wme: indicates whether the STA supports QoS/WME.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  * @uapsd_queues: bitmap of queues configured for uapsd. Only valid
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 927b4ea0128b..4d8989b87960 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1011,15 +1011,8 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 			clear_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE);
 	}
 
-	if (mask & BIT(NL80211_STA_FLAG_WME)) {
-		if (set & BIT(NL80211_STA_FLAG_WME)) {
-			set_sta_flag(sta, WLAN_STA_WME);
-			sta->sta.wme = true;
-		} else {
-			clear_sta_flag(sta, WLAN_STA_WME);
-			sta->sta.wme = false;
-		}
-	}
+	if (mask & BIT(NL80211_STA_FLAG_WME))
+		sta->sta.wme = set & BIT(NL80211_STA_FLAG_WME);
 
 	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
 		if (set & BIT(NL80211_STA_FLAG_MFP))
@@ -3352,7 +3345,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	band = chanctx_conf->def.chan->band;
 	sta = sta_info_get_bss(sdata, peer);
 	if (sta) {
-		qos = test_sta_flag(sta, WLAN_STA_WME);
+		qos = sta->sta.wme;
 	} else {
 		rcu_read_unlock();
 		return -ENOLINK;
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 3db96648b45a..4a20fb8f1e23 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -77,7 +77,8 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
 			    TEST(SHORT_PREAMBLE),
-			    TEST(WME), TEST(WDS), TEST(CLEAR_PS_FILT),
+			    sta->sta.wme ? "WME\n" : "",
+			    TEST(WDS), TEST(CLEAR_PS_FILT),
 			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
 			    TEST(TDLS_PEER_AUTH), TEST(4ADDR_EVENT),
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9713dc54ea4b..5f9654d31a8d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1038,7 +1038,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		}
 
 		if (sta && elems->wmm_info)
-			set_sta_flag(sta, WLAN_STA_WME);
+			sta->sta.wme = true;
 
 		if (sta && elems->ht_operation && elems->ht_cap_elem &&
 		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 31a8afaf7332..0e8d59a0e17e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2677,8 +2677,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
 		set_sta_flag(sta, WLAN_STA_MFP);
 
-	if (elems.wmm_param)
-		set_sta_flag(sta, WLAN_STA_WME);
+	sta->sta.wme = elems.wmm_param;
 
 	err = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 	if (!err && !(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f41177f58b30..673eb868c029 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1179,7 +1179,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb;
 	int size = sizeof(*nullfunc);
 	__le16 fc;
-	bool qos = test_sta_flag(sta, WLAN_STA_WME);
+	bool qos = sta->sta.wme;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 
@@ -1831,7 +1831,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
 	if (test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
-	if (test_sta_flag(sta, WLAN_STA_WME))
+	if (sta->sta.wme)
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_WME);
 	if (test_sta_flag(sta, WLAN_STA_MFP))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d411bcc8ef08..89c40d5c0633 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -31,7 +31,6 @@
  *	when virtual port control is not in use.
  * @WLAN_STA_SHORT_PREAMBLE: Station is capable of receiving short-preamble
  *	frames.
- * @WLAN_STA_WME: Station is a QoS-STA.
  * @WLAN_STA_WDS: Station is one of our WDS peers.
  * @WLAN_STA_CLEAR_PS_FILT: Clear PS filter in hardware (using the
  *	IEEE80211_TX_CTL_CLEAR_PS_FILT control flag) when the next
@@ -69,7 +68,6 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PS_STA,
 	WLAN_STA_AUTHORIZED,
 	WLAN_STA_SHORT_PREAMBLE,
-	WLAN_STA_WME,
 	WLAN_STA_WDS,
 	WLAN_STA_CLEAR_PS_FILT,
 	WLAN_STA_MFP,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 1b21050be174..f2cb3b6c1871 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -316,8 +316,7 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* add the QoS param IE if both the peer and we support it */
-	if (local->hw.queues >= IEEE80211_NUM_ACS &&
-	    test_sta_flag(sta, WLAN_STA_WME))
+	if (local->hw.queues >= IEEE80211_NUM_ACS && sta->sta.wme)
 		ieee80211_tdls_add_wmm_param_ie(sdata, skb);
 
 	/* add any custom IEs that go before HT operation */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 865bdaf06ff1..2d27e91da15a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1844,7 +1844,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 			hdrlen = 30;
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
-			wme_sta = test_sta_flag(sta, WLAN_STA_WME);
+			wme_sta = sta->sta.wme;
 		}
 		ap_sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
 					u.ap);
@@ -1957,7 +1957,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			if (sta) {
 				authorized = test_sta_flag(sta,
 							WLAN_STA_AUTHORIZED);
-				wme_sta = test_sta_flag(sta, WLAN_STA_WME);
+				wme_sta = sta->sta.wme;
 				tdls_peer = test_sta_flag(sta,
 							  WLAN_STA_TDLS_PEER);
 				tdls_auth = test_sta_flag(sta,
@@ -2035,7 +2035,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		sta = sta_info_get(sdata, hdr.addr1);
 		if (sta) {
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
-			wme_sta = test_sta_flag(sta, WLAN_STA_WME);
+			wme_sta = sta->sta.wme;
 		}
 	}
 
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index d51422c778de..6459946f0b74 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -118,7 +118,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP_VLAN:
 		sta = rcu_dereference(sdata->u.vlan.sta);
 		if (sta) {
-			qos = test_sta_flag(sta, WLAN_STA_WME);
+			qos = sta->sta.wme;
 			break;
 		}
 	case NL80211_IFTYPE_AP:
@@ -145,7 +145,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	if (!sta && ra && !is_multicast_ether_addr(ra)) {
 		sta = sta_info_get(sdata, ra);
 		if (sta)
-			qos = test_sta_flag(sta, WLAN_STA_WME);
+			qos = sta->sta.wme;
 	}
 	rcu_read_unlock();
 
-- 
2.0.0

