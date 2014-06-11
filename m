Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43905 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaFKOSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:45 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so1215470wib.15
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:43 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/10] mac80211: implement proper Tx path flushing for TDLS
Date: Wed, 11 Jun 2014 17:18:24 +0300
Message-Id: <1402496307-32522-7-git-send-email-arik@wizery.com> (sfid-20140611_161849_567065_621B83E3)
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the spec mandates, flush data in the AP path before transmitting the
first setup frame. Data packets transmitted during setup are already
dropped in the Tx path.

For the teardown flow, flush all packets in the direct path before
transmitting the teardown frame. Un-authorize the peer sta after teardown
is sent, forcing all subsequent Tx to the peer through the AP.

Make sure to flush the queues when disabling the link to get the
teardown packet out.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/tdls.c        | 59 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2e3d18c..851ca7c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -924,6 +924,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
 	IEEE80211_QUEUE_STOP_REASON_FLUSH,
+	IEEE80211_QUEUE_STOP_REASON_TDLS_TEARDOWN,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 92d203a..da7eb7e 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -331,6 +331,8 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 		goto exit;
 	}
 
+	ieee80211_flush_queues(local, sdata);
+
 	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
 					      dialog_token, status_code,
 					      peer_capability, initiator,
@@ -348,6 +350,54 @@ exit:
 	return ret;
 }
 
+static int
+ieee80211_tdls_mgmt_teardown(struct wiphy *wiphy, struct net_device *dev,
+			     const u8 *peer, u8 action_code, u8 dialog_token,
+			     u16 status_code, u32 peer_capability,
+			     bool initiator, const u8 *extra_ies,
+			     size_t extra_ies_len)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	int ret;
+
+	/*
+	 * No packets can be transmitted to the peer via the AP during setup -
+	 * the STA is set as a TDLS peer, but is not authorized.
+	 * During teardown, we prevent direct transmissions by stopping the
+	 * queues and flushing all direct packets.
+	 */
+	ieee80211_stop_queues_by_reason(&local->hw,
+			IEEE80211_MAX_QUEUE_MAP,
+			IEEE80211_QUEUE_STOP_REASON_TDLS_TEARDOWN);
+	ieee80211_flush_queues(local, sdata);
+
+	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
+					      dialog_token, status_code,
+					      peer_capability, initiator,
+					      extra_ies, extra_ies_len);
+	if (ret < 0)
+		sdata_err(sdata, "Failed sending TDLS teardown packet %d\n",
+			  ret);
+
+	/*
+	 * Remove the STA AUTH flag to force further traffic through the AP. If
+	 * the STA was unreachable, it was already removed.
+	 */
+	rcu_read_lock();
+	sta = sta_info_get(sdata, peer);
+	if (sta)
+		clear_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH);
+	rcu_read_unlock();
+
+	ieee80211_wake_queues_by_reason(&local->hw,
+			IEEE80211_MAX_QUEUE_MAP,
+			IEEE80211_QUEUE_STOP_REASON_TDLS_TEARDOWN);
+
+	return 0;
+}
+
 int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, u8 action_code, u8 dialog_token,
 			u16 status_code, u32 peer_capability,
@@ -374,6 +424,12 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 						extra_ies, extra_ies_len);
 		break;
 	case WLAN_TDLS_TEARDOWN:
+		ret = ieee80211_tdls_mgmt_teardown(wiphy, dev, peer,
+						   action_code, dialog_token,
+						   status_code,
+						   peer_capability, initiator,
+						   extra_ies, extra_ies_len);
+		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
@@ -442,6 +498,9 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		ret = 0;
 		break;
 	case NL80211_TDLS_DISABLE_LINK:
+		/* flush a potentially queued teardown packet */
+		ieee80211_flush_queues(local, sdata);
+
 		ret = sta_info_destroy_addr(sdata, peer);
 		break;
 	default:
-- 
1.9.1

