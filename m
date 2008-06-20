Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYFTJna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 05:43:30 -0400
Subject: [PATCH] mac80211: rework debug settings and make debugging safer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 11:42:45 +0200
Message-Id: <1213954966.8967.148.camel@johannes.berg> (sfid-20080620_114336_090505_DE118F63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reworks the mac80211 debug settings making them more focused
and adding help text for those that didn't have one. It also removes a
number of printks that can be triggered remotely and add no value, e.g.
"too short deauthentication frame received - ignoring".

If somebody really needs to debug that they should just add a monitor
interface and look at the frames in wireshark.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Requires my tx/rx inline patches to be applied.

Reduces module size significantly:
   text	   data	    bss	    dec	    hex	filename
 197881	    936	    108	 198925	  3090d	/tmp/mac80211.ko.old
 191473	    936	    108	 192517	  2f005	net/mac80211/mac80211.ko

I may clean up the #ifdefs later.

 net/mac80211/Kconfig       |  133 ++++++++++++++++++++---------
 net/mac80211/ieee80211_i.h |    2 
 net/mac80211/iface.c       |    6 -
 net/mac80211/main.c        |   35 ++++++-
 net/mac80211/mlme.c        |  206 ++++++++++-----------------------------------
 net/mac80211/rx.c          |  106 ++---------------------
 net/mac80211/sta_info.c    |    2 
 net/mac80211/tx.c          |    9 +
 net/mac80211/wep.c         |   13 --
 net/mac80211/wme.c         |    1 
 net/mac80211/wpa.c         |   28 ------
 11 files changed, 197 insertions(+), 344 deletions(-)

--- everything.orig/net/mac80211/iface.c	2008-06-20 11:25:23.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-06-20 11:29:37.000000000 +0200
@@ -184,9 +184,9 @@ void ieee80211_if_set_type(struct net_de
 		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
 				      MONITOR_FLAG_OTHER_BSS;
 		break;
-	default:
-		printk(KERN_WARNING "%s: %s: Unknown interface type 0x%x",
-		       dev->name, __func__, type);
+	case IEEE80211_IF_TYPE_INVALID:
+		BUG();
+		break;
 	}
 	ieee80211_debugfs_change_if_type(sdata, oldtype);
 }
--- everything.orig/net/mac80211/main.c	2008-06-20 11:25:24.000000000 +0200
+++ everything/net/mac80211/main.c	2008-06-20 11:29:37.000000000 +0200
@@ -151,9 +151,7 @@ static int ieee80211_change_mtu(struct n
 	/* FIX: what would be proper limits for MTU?
 	 * This interface uses 802.3 frames. */
 	if (new_mtu < 256 ||
-		new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
-		printk(KERN_WARNING "%s: invalid MTU %d\n",
-		       dev->name, new_mtu);
+	    new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
 		return -EINVAL;
 	}
 
@@ -636,7 +634,9 @@ int ieee80211_start_tx_ba_session(struct
 
 	sta = sta_info_get(local, ra);
 	if (!sta) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Could not find the station\n");
+#endif
 		ret = -ENOENT;
 		goto exit;
 	}
@@ -664,9 +664,11 @@ int ieee80211_start_tx_ba_session(struct
 	sta->ampdu_mlme.tid_tx[tid] =
 			kmalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
 	if (!sta->ampdu_mlme.tid_tx[tid]) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_ERR "allocate tx mlme to tid %d failed\n",
 					tid);
+#endif
 		ret = -ENOMEM;
 		goto err_unlock_sta;
 	}
@@ -736,7 +738,9 @@ int ieee80211_start_tx_ba_session(struct
 	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =
 				jiffies + ADDBA_RESP_INTERVAL;
 	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+#ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
+#endif
 	goto exit;
 
 err_unlock_queue:
@@ -818,8 +822,10 @@ void ieee80211_start_tx_ba_cb(struct iee
 	DECLARE_MAC_BUF(mac);
 
 	if (tid >= STA_TID_NUM) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
 				tid, STA_TID_NUM);
+#endif
 		return;
 	}
 
@@ -827,8 +833,10 @@ void ieee80211_start_tx_ba_cb(struct iee
 	sta = sta_info_get(local, ra);
 	if (!sta) {
 		rcu_read_unlock();
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Could not find station: %s\n",
 				print_mac(mac, ra));
+#endif
 		return;
 	}
 
@@ -836,8 +844,10 @@ void ieee80211_start_tx_ba_cb(struct iee
 	spin_lock_bh(&sta->lock);
 
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "addBA was not requested yet, state is %d\n",
 				*state);
+#endif
 		spin_unlock_bh(&sta->lock);
 		rcu_read_unlock();
 		return;
@@ -848,7 +858,9 @@ void ieee80211_start_tx_ba_cb(struct iee
 	*state |= HT_ADDBA_DRV_READY_MSK;
 
 	if (*state == HT_AGG_STATE_OPERATIONAL) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
+#endif
 		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 	}
 	spin_unlock_bh(&sta->lock);
@@ -865,8 +877,10 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	DECLARE_MAC_BUF(mac);
 
 	if (tid >= STA_TID_NUM) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
 				tid, STA_TID_NUM);
+#endif
 		return;
 	}
 
@@ -878,8 +892,10 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	rcu_read_lock();
 	sta = sta_info_get(local, ra);
 	if (!sta) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Could not find station: %s\n",
 				print_mac(mac, ra));
+#endif
 		rcu_read_unlock();
 		return;
 	}
@@ -889,7 +905,9 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	 * ieee80211_stop_tx_ba_session will let only
 	 * one stop call to pass through per sta/tid */
 	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
+#endif
 		rcu_read_unlock();
 		return;
 	}
@@ -931,9 +949,11 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
 	struct sk_buff *skb = dev_alloc_skb(0);
 
 	if (unlikely(!skb)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_WARNING "%s: Not enough memory, "
 			       "dropping start BA session", skb->dev->name);
+#endif
 		return;
 	}
 	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
@@ -954,9 +974,11 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
 	struct sk_buff *skb = dev_alloc_skb(0);
 
 	if (unlikely(!skb)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_WARNING "%s: Not enough memory, "
 			       "dropping stop BA session", skb->dev->name);
+#endif
 		return;
 	}
 	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
@@ -1285,9 +1307,8 @@ static void ieee80211_tasklet_handler(un
 						 ra_tid->ra, ra_tid->tid);
 			dev_kfree_skb(skb);
 			break ;
-		default: /* should never get here! */
-			printk(KERN_ERR "%s: Unknown message type (%d)\n",
-			       wiphy_name(local->hw.wiphy), skb->pkt_type);
+		default:
+			WARN_ON(1);
 			dev_kfree_skb(skb);
 			break;
 		}
@@ -1414,12 +1435,14 @@ static void ieee80211_handle_filtered_fr
 		return;
 	}
 
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	if (net_ratelimit())
 		printk(KERN_DEBUG "%s: dropped TX filtered frame, "
 		       "queue_len=%d PS=%d @%lu\n",
 		       wiphy_name(local->hw.wiphy),
 		       skb_queue_len(&sta->tx_filtered),
 		       !!test_sta_flags(sta, WLAN_STA_PS), jiffies);
+#endif
 	dev_kfree_skb(skb);
 }
 
--- everything.orig/net/mac80211/mlme.c	2008-06-20 11:25:23.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-06-20 11:29:37.000000000 +0200
@@ -327,7 +327,7 @@ static void ieee80211_sta_wmm_params(str
 		params.cw_max = ecw2cw((pos[1] & 0xf0) >> 4);
 		params.cw_min = ecw2cw(pos[1] & 0x0f);
 		params.txop = pos[2] | (pos[3] << 8);
-#ifdef CONFIG_MAC80211_DEBUG
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		printk(KERN_DEBUG "%s: WMM queue=%d aci=%d acm=%d aifs=%d "
 		       "cWmin=%d cWmax=%d txop=%d\n",
 		       dev->name, queue, aci, acm, params.aifs, params.cw_min,
@@ -352,6 +352,7 @@ static u32 ieee80211_handle_protect_prea
 	u32 changed = 0;
 
 	if (use_protection != bss_conf->use_cts_prot) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: CTS protection %s (BSSID="
 			       "%s)\n",
@@ -359,11 +360,13 @@ static u32 ieee80211_handle_protect_prea
 			       use_protection ? "enabled" : "disabled",
 			       print_mac(mac, ifsta->bssid));
 		}
+#endif
 		bss_conf->use_cts_prot = use_protection;
 		changed |= BSS_CHANGED_ERP_CTS_PROT;
 	}
 
 	if (use_short_preamble != bss_conf->use_short_preamble) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: switched to %s barker preamble"
 			       " (BSSID=%s)\n",
@@ -371,6 +374,7 @@ static u32 ieee80211_handle_protect_prea
 			       use_short_preamble ? "short" : "long",
 			       print_mac(mac, ifsta->bssid));
 		}
+#endif
 		bss_conf->use_short_preamble = use_short_preamble;
 		changed |= BSS_CHANGED_ERP_PREAMBLE;
 	}
@@ -1132,14 +1136,10 @@ static void ieee80211_auth_challenge(str
 	u8 *pos;
 	struct ieee802_11_elems elems;
 
-	printk(KERN_DEBUG "%s: replying to auth challenge\n", dev->name);
 	pos = mgmt->u.auth.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
-	if (!elems.challenge) {
-		printk(KERN_DEBUG "%s: no challenge IE in shared key auth "
-		       "frame\n", dev->name);
+	if (!elems.challenge)
 		return;
-	}
 	ieee80211_send_auth(dev, ifsta, 3, elems.challenge - 2,
 			    elems.challenge_len + 2, 1);
 }
@@ -1321,9 +1321,11 @@ static void ieee80211_sta_process_addba_
 	sta->ampdu_mlme.tid_rx[tid] =
 			kmalloc(sizeof(struct tid_ampdu_rx), GFP_ATOMIC);
 	if (!sta->ampdu_mlme.tid_rx[tid]) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_ERR "allocate rx mlme to tid %d failed\n",
 					tid);
+#endif
 		goto end;
 	}
 	/* rx timer */
@@ -1339,9 +1341,11 @@ static void ieee80211_sta_process_addba_
 	tid_agg_rx->reorder_buf =
 		kmalloc(buf_size * sizeof(struct sk_buff *), GFP_ATOMIC);
 	if (!tid_agg_rx->reorder_buf) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_ERR "can not allocate reordering buffer "
 			       "to tid %d\n", tid);
+#endif
 		kfree(sta->ampdu_mlme.tid_rx[tid]);
 		goto end;
 	}
@@ -1408,8 +1412,6 @@ static void ieee80211_sta_process_addba_
 
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
 		spin_unlock_bh(&sta->lock);
-		printk(KERN_DEBUG "state not HT_ADDBA_REQUESTED_MSK:"
-			"%d\n", *state);
 		goto addba_resp_exit;
 	}
 
@@ -1428,22 +1430,14 @@ static void ieee80211_sta_process_addba_
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
 			== WLAN_STATUS_SUCCESS) {
-		if (*state & HT_ADDBA_RECEIVED_MSK)
-			printk(KERN_DEBUG "double addBA response\n");
-
 		*state |= HT_ADDBA_RECEIVED_MSK;
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
 
-		if (*state == HT_AGG_STATE_OPERATIONAL) {
-			printk(KERN_DEBUG "Aggregation on for tid %d \n", tid);
+		if (*state == HT_AGG_STATE_OPERATIONAL)
 			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
-		}
 
 		spin_unlock_bh(&sta->lock);
-		printk(KERN_DEBUG "recipient accepted agg: tid %d \n", tid);
 	} else {
-		printk(KERN_DEBUG "recipient rejected agg: tid %d \n", tid);
-
 		sta->ampdu_mlme.addba_req_num[tid]++;
 		/* this will allow the state check in stop_BA_session */
 		*state = HT_AGG_STATE_OPERATIONAL;
@@ -1542,7 +1536,7 @@ void ieee80211_sta_stop_rx_ba_session(st
 					ra, tid, NULL);
 	if (ret)
 		printk(KERN_DEBUG "HW problem - can not stop rx "
-				"aggergation for tid %d\n", tid);
+				"aggregation for tid %d\n", tid);
 
 	/* shutdown timer has not expired */
 	if (initiator != WLAN_BACK_TIMER)
@@ -1648,12 +1642,16 @@ void sta_addba_resp_timer_expired(unsign
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
 		spin_unlock_bh(&sta->lock);
 		*state = HT_AGG_STATE_IDLE;
+#ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "timer expired on tid %d but we are not "
 				"expecting addBA response there", tid);
+#endif
 		goto timer_expired_exit;
 	}
 
+#ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
+#endif
 
 	/* go through the state check in stop_BA_session */
 	*state = HT_AGG_STATE_OPERATIONAL;
@@ -1681,7 +1679,9 @@ static void sta_rx_agg_session_timer_exp
 	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
 					 timer_to_tid[0]);
 
+#ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
+#endif
 	ieee80211_sta_stop_rx_ba_session(sta->sdata->dev, sta->addr,
 					 (u16)*ptid, WLAN_BACK_TIMER,
 					 WLAN_REASON_QSTA_TIMEOUT);
@@ -1711,47 +1711,24 @@ static void ieee80211_rx_mgmt_auth(struc
 	DECLARE_MAC_BUF(mac);
 
 	if (ifsta->state != IEEE80211_AUTHENTICATE &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS) {
-		printk(KERN_DEBUG "%s: authentication frame received from "
-		       "%s, but not in authenticate state - ignored\n",
-		       dev->name, print_mac(mac, mgmt->sa));
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return;
-	}
 
-	if (len < 24 + 6) {
-		printk(KERN_DEBUG "%s: too short (%zd) authentication frame "
-		       "received from %s - ignored\n",
-		       dev->name, len, print_mac(mac, mgmt->sa));
+	if (len < 24 + 6)
 		return;
-	}
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-	    memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0) {
-		printk(KERN_DEBUG "%s: authentication frame received from "
-		       "unknown AP (SA=%s BSSID=%s) - "
-		       "ignored\n", dev->name, print_mac(mac, mgmt->sa),
-		       print_mac(mac, mgmt->bssid));
+	    memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0)
 		return;
-	}
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0) {
-		printk(KERN_DEBUG "%s: authentication frame received from "
-		       "unknown BSSID (SA=%s BSSID=%s) - "
-		       "ignored\n", dev->name, print_mac(mac, mgmt->sa),
-		       print_mac(mac, mgmt->bssid));
+	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
-	}
 
 	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
 	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
-	printk(KERN_DEBUG "%s: RX authentication from %s (alg=%d "
-	       "transaction=%d status=%d)\n",
-	       dev->name, print_mac(mac, mgmt->sa), auth_alg,
-	       auth_transaction, status_code);
-
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		/*
 		 * IEEE 802.11 standard does not require authentication in IBSS
@@ -1759,26 +1736,16 @@ static void ieee80211_rx_mgmt_auth(struc
 		 * However, try to reply to authentication attempts if someone
 		 * has actually implemented this.
 		 */
-		if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1) {
-			printk(KERN_DEBUG "%s: unexpected IBSS authentication "
-			       "frame (alg=%d transaction=%d)\n",
-			       dev->name, auth_alg, auth_transaction);
+		if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
 			return;
-		}
 		ieee80211_send_auth(dev, ifsta, 2, NULL, 0, 0);
 	}
 
 	if (auth_alg != ifsta->auth_alg ||
-	    auth_transaction != ifsta->auth_transaction) {
-		printk(KERN_DEBUG "%s: unexpected authentication frame "
-		       "(alg=%d transaction=%d)\n",
-		       dev->name, auth_alg, auth_transaction);
+	    auth_transaction != ifsta->auth_transaction)
 		return;
-	}
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
-		printk(KERN_DEBUG "%s: AP denied authentication (auth_alg=%d "
-		       "code=%d)\n", dev->name, ifsta->auth_alg, status_code);
 		if (status_code == WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG) {
 			u8 algs[3];
 			const int num_algs = ARRAY_SIZE(algs);
@@ -1807,9 +1774,6 @@ static void ieee80211_rx_mgmt_auth(struc
 				    !ieee80211_sta_wep_configured(dev))
 					continue;
 				ifsta->auth_alg = algs[pos];
-				printk(KERN_DEBUG "%s: set auth_alg=%d for "
-				       "next try\n",
-				       dev->name, ifsta->auth_alg);
 				break;
 			}
 		}
@@ -1839,27 +1803,14 @@ static void ieee80211_rx_mgmt_deauth(str
 	u16 reason_code;
 	DECLARE_MAC_BUF(mac);
 
-	if (len < 24 + 2) {
-		printk(KERN_DEBUG "%s: too short (%zd) deauthentication frame "
-		       "received from %s - ignored\n",
-		       dev->name, len, print_mac(mac, mgmt->sa));
+	if (len < 24 + 2)
 		return;
-	}
 
-	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0) {
-		printk(KERN_DEBUG "%s: deauthentication frame received from "
-		       "unknown AP (SA=%s BSSID=%s) - "
-		       "ignored\n", dev->name, print_mac(mac, mgmt->sa),
-		       print_mac(mac, mgmt->bssid));
+	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN))
 		return;
-	}
 
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
-	printk(KERN_DEBUG "%s: RX deauthentication from %s"
-	       " (reason=%d)\n",
-	       dev->name, print_mac(mac, mgmt->sa), reason_code);
-
 	if (ifsta->flags & IEEE80211_STA_AUTHENTICATED)
 		printk(KERN_DEBUG "%s: deauthenticated\n", dev->name);
 
@@ -1884,27 +1835,14 @@ static void ieee80211_rx_mgmt_disassoc(s
 	u16 reason_code;
 	DECLARE_MAC_BUF(mac);
 
-	if (len < 24 + 2) {
-		printk(KERN_DEBUG "%s: too short (%zd) disassociation frame "
-		       "received from %s - ignored\n",
-		       dev->name, len, print_mac(mac, mgmt->sa));
+	if (len < 24 + 2)
 		return;
-	}
 
-	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0) {
-		printk(KERN_DEBUG "%s: disassociation frame received from "
-		       "unknown AP (SA=%s BSSID=%s) - "
-		       "ignored\n", dev->name, print_mac(mac, mgmt->sa),
-		       print_mac(mac, mgmt->bssid));
+	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN))
 		return;
-	}
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
-	printk(KERN_DEBUG "%s: RX disassociation from %s"
-	       " (reason=%d)\n",
-	       dev->name, print_mac(mac, mgmt->sa), reason_code);
-
 	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
 		printk(KERN_DEBUG "%s: disassociated\n", dev->name);
 
@@ -1940,27 +1878,14 @@ static void ieee80211_rx_mgmt_assoc_resp
 	/* AssocResp and ReassocResp have identical structure, so process both
 	 * of them in this function. */
 
-	if (ifsta->state != IEEE80211_ASSOCIATE) {
-		printk(KERN_DEBUG "%s: association frame received from "
-		       "%s, but not in associate state - ignored\n",
-		       dev->name, print_mac(mac, mgmt->sa));
+	if (ifsta->state != IEEE80211_ASSOCIATE)
 		return;
-	}
 
-	if (len < 24 + 6) {
-		printk(KERN_DEBUG "%s: too short (%zd) association frame "
-		       "received from %s - ignored\n",
-		       dev->name, len, print_mac(mac, mgmt->sa));
+	if (len < 24 + 6)
 		return;
-	}
 
-	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0) {
-		printk(KERN_DEBUG "%s: association frame received from "
-		       "unknown AP (SA=%s BSSID=%s) - "
-		       "ignored\n", dev->name, print_mac(mac, mgmt->sa),
-		       print_mac(mac, mgmt->bssid));
+	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0)
 		return;
-	}
 
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
@@ -2555,12 +2480,6 @@ static void ieee80211_rx_bss_info(struct
 	if (!beacon && memcmp(mgmt->da, dev->dev_addr, ETH_ALEN))
 		return; /* ignore ProbeResp to foreign address */
 
-#if 0
-	printk(KERN_DEBUG "%s: RX %s from %s to %s\n",
-	       dev->name, beacon ? "Beacon" : "Probe Response",
-	       print_mac(mac, mgmt->sa), print_mac(mac2, mgmt->da));
-#endif
-
 	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
 	if (baselen > len)
 		return;
@@ -2595,15 +2514,6 @@ static void ieee80211_rx_bss_info(struct
 			sta->supp_rates[rx_status->band] =
 				sdata->u.sta.supp_rates_bits[rx_status->band];
 		}
-		if (sta->supp_rates[rx_status->band] != prev_rates) {
-			printk(KERN_DEBUG "%s: updated supp_rates set for "
-			       "%s based on beacon info (0x%llx & 0x%llx -> "
-			       "0x%llx)\n",
-			       dev->name, print_mac(mac, sta->addr),
-			       (unsigned long long) prev_rates,
-			       (unsigned long long) supp_rates,
-			       (unsigned long long) sta->supp_rates[rx_status->band]);
-		}
 	}
 
 	rcu_read_unlock();
@@ -2857,11 +2767,10 @@ static void ieee80211_rx_bss_info(struct
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 		if (beacon_timestamp > rx_timestamp) {
 #ifndef CONFIG_MAC80211_IBSS_DEBUG
-			if (net_ratelimit())
+			printk(KERN_DEBUG "%s: beacon TSF higher than "
+			       "local TSF - IBSS merge with BSSID %s\n",
+			       dev->name, print_mac(mac, mgmt->bssid));
 #endif
-				printk(KERN_DEBUG "%s: beacon TSF higher than "
-				       "local TSF - IBSS merge with BSSID %s\n",
-				       dev->name, print_mac(mac, mgmt->bssid));
 			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
 			ieee80211_ibss_add_sta(dev, NULL,
 					       mgmt->bssid, mgmt->sa,
@@ -2991,11 +2900,11 @@ static void ieee80211_rx_mgmt_probe_req(
 	pos = mgmt->u.probe_req.variable;
 	if (pos[0] != WLAN_EID_SSID ||
 	    pos + 2 + pos[1] > end) {
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "%s: Invalid SSID IE in ProbeReq "
-			       "from %s\n",
-			       dev->name, print_mac(mac, mgmt->sa));
-		}
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+		printk(KERN_DEBUG "%s: Invalid SSID IE in ProbeReq "
+		       "from %s\n",
+		       dev->name, print_mac(mac, mgmt->sa));
+#endif
 		return;
 	}
 	if (pos[1] != 0 &&
@@ -3051,11 +2960,6 @@ static void ieee80211_rx_mgmt_action(str
 				break;
 			ieee80211_sta_process_delba(dev, mgmt, len);
 			break;
-		default:
-			if (net_ratelimit())
-			   printk(KERN_DEBUG "%s: Rx unknown A-MPDU action\n",
-					dev->name);
-			break;
 		}
 		break;
 	case PLINK_CATEGORY:
@@ -3066,11 +2970,6 @@ static void ieee80211_rx_mgmt_action(str
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			mesh_rx_path_sel_frame(dev, mgmt, len);
 		break;
-	default:
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: Rx unknown action frame - "
-			"category=%d\n", dev->name, mgmt->u.action.category);
-		break;
 	}
 }
 
@@ -3106,11 +3005,6 @@ void ieee80211_sta_rx_mgmt(struct net_de
 		skb_queue_tail(&ifsta->skb_queue, skb);
 		queue_work(local->hw.workqueue, &ifsta->work);
 		return;
-	default:
-		printk(KERN_DEBUG "%s: received unknown management frame - "
-		       "stype=%d\n", dev->name,
-		       (fc & IEEE80211_FCTL_STYPE) >> 4);
-		break;
 	}
 
  fail:
@@ -3240,8 +3134,10 @@ static void ieee80211_sta_expire(struct 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
 			       dev->name, print_mac(mac, sta->addr));
+#endif
 			__sta_info_unlink(&sta);
 			if (sta)
 				list_add(&sta->list, &tmp_list);
@@ -3324,13 +3220,10 @@ void ieee80211_sta_work(struct work_stru
 	if (local->sta_sw_scanning || local->sta_hw_scanning)
 		return;
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT) {
-		printk(KERN_DEBUG "%s: ieee80211_sta_work: non-STA interface "
-		       "(type=%d)\n", dev->name, sdata->vif.type);
+	if (WARN_ON(sdata->vif.type != IEEE80211_IF_TYPE_STA &&
+		    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+		    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT))
 		return;
-	}
 	ifsta = &sdata->u.sta;
 
 	while ((skb = skb_dequeue(&ifsta->skb_queue)))
@@ -3384,8 +3277,7 @@ void ieee80211_sta_work(struct work_stru
 		break;
 #endif
 	default:
-		printk(KERN_DEBUG "ieee80211_sta_work: Unknown state %d\n",
-		       ifsta->state);
+		WARN_ON(1);
 		break;
 	}
 
@@ -3420,8 +3312,6 @@ static void ieee80211_sta_reset_auth(str
 		ifsta->auth_alg = WLAN_AUTH_LEAP;
 	else
 		ifsta->auth_alg = WLAN_AUTH_OPEN;
-	printk(KERN_DEBUG "%s: Initial auth_alg=%d\n", dev->name,
-	       ifsta->auth_alg);
 	ifsta->auth_transaction = -1;
 	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
 	ifsta->auth_tries = ifsta->assoc_tries = 0;
@@ -4330,8 +4220,10 @@ struct sta_info *ieee80211_ibss_add_sta(
 	if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid))
 		return NULL;
 
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Adding new IBSS station %s (dev=%s)\n",
 	       wiphy_name(local->hw.wiphy), print_mac(mac, addr), dev->name);
+#endif
 
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
 	if (!sta)
@@ -4358,7 +4250,7 @@ int ieee80211_sta_deauthenticate(struct 
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 
-	printk(KERN_DEBUG "%s: deauthenticate(reason=%d)\n",
+	printk(KERN_DEBUG "%s: deauthenticating by local choice (reason=%d)\n",
 	       dev->name, reason);
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
@@ -4376,7 +4268,7 @@ int ieee80211_sta_disassociate(struct ne
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 
-	printk(KERN_DEBUG "%s: disassociate(reason=%d)\n",
+	printk(KERN_DEBUG "%s: disassociating by local choice (reason=%d)\n",
 	       dev->name, reason);
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
--- everything.orig/net/mac80211/rx.c	2008-06-20 11:25:23.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-06-20 11:29:37.000000000 +0200
@@ -613,11 +613,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		rx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
 	} else {
-#ifdef CONFIG_MAC80211_DEBUG
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: RX protected frame,"
-			       " but have no key\n", rx->dev->name);
-#endif /* CONFIG_MAC80211_DEBUG */
 		return RX_DROP_MONITOR;
 	}
 
@@ -789,7 +784,7 @@ ieee80211_reassemble_add(struct ieee8021
 		sdata->fragment_next = 0;
 
 	if (!skb_queue_empty(&entry->skb_list)) {
-#ifdef CONFIG_MAC80211_DEBUG
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		struct ieee80211_hdr *hdr =
 			(struct ieee80211_hdr *) entry->skb_list.next->data;
 		DECLARE_MAC_BUF(mac);
@@ -801,7 +796,7 @@ ieee80211_reassemble_add(struct ieee8021
 		       jiffies - entry->first_frag_time, entry->seq,
 		       entry->last_frag, print_mac(mac, hdr->addr1),
 		       print_mac(mac2, hdr->addr2));
-#endif /* CONFIG_MAC80211_DEBUG */
+#endif
 		__skb_queue_purge(&entry->skb_list);
 	}
 
@@ -922,18 +917,8 @@ ieee80211_rx_h_defragment(struct ieee802
 				break;
 		}
 		rpn = rx->key->u.ccmp.rx_pn[rx->queue];
-		if (memcmp(pn, rpn, CCMP_PN_LEN) != 0) {
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: defrag: CCMP PN not "
-				       "sequential A2=%s"
-				       " PN=%02x%02x%02x%02x%02x%02x "
-				       "(expected %02x%02x%02x%02x%02x%02x)\n",
-				       rx->dev->name, print_mac(mac, hdr->addr2),
-				       rpn[0], rpn[1], rpn[2], rpn[3], rpn[4],
-				       rpn[5], pn[0], pn[1], pn[2], pn[3],
-				       pn[4], pn[5]);
+		if (memcmp(pn, rpn, CCMP_PN_LEN))
 			return RX_DROP_UNUSABLE;
-		}
 		memcpy(entry->last_pn, pn, CCMP_PN_LEN);
 	}
 
@@ -1037,7 +1022,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		 *	  have nothing buffered for it?
 		 */
 		printk(KERN_DEBUG "%s: STA %s sent PS Poll even "
-		       "though there is no buffered frames for it\n",
+		       "though there are no buffered frames for it\n",
 		       rx->dev->name, print_mac(mac, rx->sta->addr));
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 	}
@@ -1073,14 +1058,8 @@ static int
 ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 {
 	if (unlikely(!rx->sta ||
-	    !test_sta_flags(rx->sta, WLAN_STA_AUTHORIZED))) {
-#ifdef CONFIG_MAC80211_DEBUG
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: dropped frame "
-			       "(unauthorized port)\n", rx->dev->name);
-#endif /* CONFIG_MAC80211_DEBUG */
+	    !test_sta_flags(rx->sta, WLAN_STA_AUTHORIZED)))
 		return -EACCES;
-	}
 
 	return 0;
 }
@@ -1160,16 +1139,8 @@ ieee80211_data_to_8023(struct ieee80211_
 		memcpy(src, hdr->addr2, ETH_ALEN);
 
 		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_AP &&
-			     sdata->vif.type != IEEE80211_IF_TYPE_VLAN)) {
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: dropped ToDS frame "
-				       "(BSSID=%s SA=%s DA=%s)\n",
-				       dev->name,
-				       print_mac(mac, hdr->addr1),
-				       print_mac(mac2, hdr->addr2),
-				       print_mac(mac3, hdr->addr3));
+			     sdata->vif.type != IEEE80211_IF_TYPE_VLAN))
 			return -1;
-		}
 		break;
 	case (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
 		/* RA TA DA SA */
@@ -1177,17 +1148,8 @@ ieee80211_data_to_8023(struct ieee80211_
 		memcpy(src, hdr->addr4, ETH_ALEN);
 
 		 if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_WDS &&
-			     sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)) {
-			 if (net_ratelimit())
-				 printk(KERN_DEBUG "%s: dropped FromDS&ToDS "
-				       "frame (RA=%s TA=%s DA=%s SA=%s)\n",
-				       rx->dev->name,
-				       print_mac(mac, hdr->addr1),
-				       print_mac(mac2, hdr->addr2),
-				       print_mac(mac3, hdr->addr3),
-				       print_mac(mac4, hdr->addr4));
+			     sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT))
 			return -1;
-		}
 		break;
 	case IEEE80211_FCTL_FROMDS:
 		/* DA BSSID SA */
@@ -1204,27 +1166,13 @@ ieee80211_data_to_8023(struct ieee80211_
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr2, ETH_ALEN);
 
-		if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS) {
-			if (net_ratelimit()) {
-				printk(KERN_DEBUG "%s: dropped IBSS frame "
-				       "(DA=%s SA=%s BSSID=%s)\n",
-				       dev->name,
-				       print_mac(mac, hdr->addr1),
-				       print_mac(mac2, hdr->addr2),
-				       print_mac(mac3, hdr->addr3));
-			}
+		if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 			return -1;
-		}
 		break;
 	}
 
-	if (unlikely(skb->len - hdrlen < 8)) {
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "%s: RX too short data frame "
-			       "payload\n", dev->name);
-		}
+	if (unlikely(skb->len - hdrlen < 8))
 		return -1;
-	}
 
 	payload = skb->data + hdrlen;
 	ethertype = (payload[6] << 8) | payload[7];
@@ -1416,10 +1364,8 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
 
 		padding = ((4 - subframe_len) & 0x3);
 		/* the last MSDU has no padding */
-		if (subframe_len > remaining) {
-			printk(KERN_DEBUG "%s: wrong buffer size\n", dev->name);
+		if (subframe_len > remaining)
 			return RX_DROP_UNUSABLE;
-		}
 
 		skb_pull(skb, sizeof(struct ethhdr));
 		/* if last subframe reuse skb */
@@ -1440,8 +1386,6 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
 			eth = (struct ethhdr *) skb_pull(skb, ntohs(len) +
 							padding);
 			if (!eth) {
-				printk(KERN_DEBUG "%s: wrong buffer size\n",
-				       dev->name);
 				dev_kfree_skb(frame);
 				return RX_DROP_UNUSABLE;
 			}
@@ -1593,31 +1537,16 @@ static void ieee80211_rx_michael_mic_rep
 	else
 		keyidx = -1;
 
-	if (net_ratelimit())
-		printk(KERN_DEBUG "%s: TKIP hwaccel reported Michael MIC "
-		       "failure from %s to %s keyidx=%d\n",
-		       dev->name, print_mac(mac, hdr->addr2),
-		       print_mac(mac2, hdr->addr1), keyidx);
-
 	if (!rx->sta) {
 		/*
 		 * Some hardware seem to generate incorrect Michael MIC
 		 * reports; ignore them to avoid triggering countermeasures.
 		 */
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
-			       "error for unknown address %s\n",
-			       dev->name, print_mac(mac, hdr->addr2));
 		goto ignore;
 	}
 
-	if (!(rx->fc & IEEE80211_FCTL_PROTECTED)) {
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
-			       "error for a frame with no PROTECTED flag (src "
-			       "%s)\n", dev->name, print_mac(mac, hdr->addr2));
+	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
 		goto ignore;
-	}
 
 	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_AP && keyidx) {
 		/*
@@ -1626,24 +1555,13 @@ static void ieee80211_rx_michael_mic_rep
 		 * group keys and only the AP is sending real multicast
 		 * frames in the BSS.
 		 */
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: ignored Michael MIC error for "
-			       "a frame with non-zero keyidx (%d)"
-			       " (src %s)\n", dev->name, keyidx,
-			       print_mac(mac, hdr->addr2));
 		goto ignore;
 	}
 
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
 	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
-	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH)) {
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
-			       "error for a frame that cannot be encrypted "
-			       "(fc=0x%04x) (src %s)\n",
-			       dev->name, rx->fc, print_mac(mac, hdr->addr2));
+	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH))
 		goto ignore;
-	}
 
 	mac80211_ev_michael_mic_failure(rx->dev, keyidx, hdr);
  ignore:
--- everything.orig/net/mac80211/sta_info.c	2008-06-20 11:25:23.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-06-20 11:29:37.000000000 +0200
@@ -554,8 +554,10 @@ static void sta_info_cleanup_expire_buff
 
 		sdata = sta->sdata;
 		local->total_ps_buffered--;
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "Buffered frame expired (STA "
 		       "%s)\n", print_mac(mac, sta->addr));
+#endif
 		dev_kfree_skb(skb);
 
 		if (skb_queue_empty(&sta->ps_tx_buf))
--- everything.orig/net/mac80211/tx.c	2008-06-20 11:25:23.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-06-20 11:29:37.000000000 +0200
@@ -329,8 +329,10 @@ static void purge_old_ps_buffers(struct 
 	rcu_read_unlock();
 
 	local->total_ps_buffered = total;
+#ifdef MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: PS buffers full - purged %d frames\n",
 	       wiphy_name(local->hw.wiphy), purged);
+#endif
 }
 
 static ieee80211_tx_result
@@ -360,11 +362,13 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 			purge_old_ps_buffers(tx->local);
 		if (skb_queue_len(&tx->sdata->bss->ps_bc_buf) >=
 		    AP_MAX_BC_BUFFER) {
+#ifdef MAC80211_VERBOSE_PS_DEBUG
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG "%s: BC TX buffer full - "
 				       "dropping the oldest frame\n",
 				       tx->dev->name);
 			}
+#endif
 			dev_kfree_skb(skb_dequeue(&tx->sdata->bss->ps_bc_buf));
 		} else
 			tx->local->total_ps_buffered++;
@@ -405,11 +409,13 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 			purge_old_ps_buffers(tx->local);
 		if (skb_queue_len(&sta->ps_tx_buf) >= STA_MAX_TX_BUFFER) {
 			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf);
+#ifdef MAC80211_VERBOSE_PS_DEBUG
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG "%s: STA %s TX "
 				       "buffer full - dropping oldest frame\n",
 				       tx->dev->name, print_mac(mac, sta->addr));
 			}
+#endif
 			dev_kfree_skb(old);
 		} else
 			tx->local->total_ps_buffered++;
@@ -715,7 +721,6 @@ ieee80211_tx_h_fragment(struct ieee80211
 	return TX_CONTINUE;
 
  fail:
-	printk(KERN_DEBUG "%s: failed to fragment frame\n", tx->dev->name);
 	if (frags) {
 		for (i = 0; i < num_fragm - 1; i++)
 			if (frags[i])
@@ -1413,8 +1418,6 @@ int ieee80211_subif_start_xmit(struct sk
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (unlikely(skb->len < ETH_HLEN)) {
-		printk(KERN_DEBUG "%s: short skb (len=%d)\n",
-		       dev->name, skb->len);
 		ret = 0;
 		goto fail;
 	}
--- everything.orig/net/mac80211/wep.c	2008-06-20 11:25:24.000000000 +0200
+++ everything/net/mac80211/wep.c	2008-06-20 11:29:37.000000000 +0200
@@ -260,11 +260,8 @@ int ieee80211_wep_decrypt(struct ieee802
 
 	if (ieee80211_wep_decrypt_data(local->wep_rx_tfm, rc4key, klen,
 				       skb->data + hdrlen + WEP_IV_LEN,
-				       len)) {
-		if (net_ratelimit())
-			printk(KERN_DEBUG "WEP decrypt failed (ICV)\n");
+				       len))
 		ret = -1;
-	}
 
 	kfree(rc4key);
 
@@ -310,14 +307,8 @@ ieee80211_crypto_wep_decrypt(struct ieee
 		return RX_CONTINUE;
 
 	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
-		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
-#ifdef CONFIG_MAC80211_DEBUG
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
-				       "failed\n", rx->dev->name);
-#endif /* CONFIG_MAC80211_DEBUG */
+		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key))
 			return RX_DROP_UNUSABLE;
-		}
 	} else if (!(rx->status->flag & RX_FLAG_IV_STRIPPED)) {
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
 		/* remove ICV */
--- everything.orig/net/mac80211/wme.c	2008-06-20 11:25:23.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-06-20 11:29:37.000000000 +0200
@@ -680,7 +680,6 @@ void ieee80211_requeue(struct ieee80211_
 	if (!qdisc || !qdisc->dequeue)
 		return;
 
-	printk(KERN_DEBUG "requeue: qlen = %d\n", qdisc->q.qlen);
 	for (len = qdisc->q.qlen; len > 0; len--) {
 		skb = qdisc->dequeue(qdisc);
 		root_qd->q.qlen--;
--- everything.orig/net/mac80211/wpa.c	2008-06-20 11:25:24.000000000 +0200
+++ everything/net/mac80211/wpa.c	2008-06-20 11:29:37.000000000 +0200
@@ -138,9 +138,6 @@ ieee80211_rx_h_michael_mic_verify(struct
 		if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 			return RX_DROP_UNUSABLE;
 
-		printk(KERN_DEBUG "%s: invalid Michael MIC in data frame from "
-		       "%s\n", rx->dev->name, print_mac(mac, sa));
-
 		mac80211_ev_michael_mic_failure(rx->dev, rx->key->conf.keyidx,
 						(void *) skb->data);
 		return RX_DROP_UNUSABLE;
@@ -274,15 +271,8 @@ ieee80211_crypto_tkip_decrypt(struct iee
 					  hdr->addr1, hwaccel, rx->queue,
 					  &rx->tkip_iv32,
 					  &rx->tkip_iv16);
-	if (res != TKIP_DECRYPT_OK || wpa_test) {
-#ifdef CONFIG_MAC80211_DEBUG
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: TKIP decrypt failed for RX "
-			       "frame from %s (res=%d)\n", rx->dev->name,
-			       print_mac(mac, rx->sta->addr), res);
-#endif /* CONFIG_MAC80211_DEBUG */
+	if (res != TKIP_DECRYPT_OK || wpa_test)
 		return RX_DROP_UNUSABLE;
-	}
 
 	/* Trim ICV */
 	skb_trim(skb, skb->len - TKIP_ICV_LEN);
@@ -504,16 +494,6 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	(void) ccmp_hdr2pn(pn, skb->data + hdrlen);
 
 	if (memcmp(pn, key->u.ccmp.rx_pn[rx->queue], CCMP_PN_LEN) <= 0) {
-#ifdef CONFIG_MAC80211_DEBUG
-		u8 *ppn = key->u.ccmp.rx_pn[rx->queue];
-
-		printk(KERN_DEBUG "%s: CCMP replay detected for RX frame from "
-		       "%s (RX PN %02x%02x%02x%02x%02x%02x <= prev. PN "
-		       "%02x%02x%02x%02x%02x%02x)\n", rx->dev->name,
-		       print_mac(mac, rx->sta->addr),
-		       pn[0], pn[1], pn[2], pn[3], pn[4], pn[5],
-		       ppn[0], ppn[1], ppn[2], ppn[3], ppn[4], ppn[5]);
-#endif /* CONFIG_MAC80211_DEBUG */
 		key->u.ccmp.replays++;
 		return RX_DROP_UNUSABLE;
 	}
@@ -533,12 +513,6 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 			    skb->data + hdrlen + CCMP_HDR_LEN, data_len,
 			    skb->data + skb->len - CCMP_MIC_LEN,
 			    skb->data + hdrlen + CCMP_HDR_LEN)) {
-#ifdef CONFIG_MAC80211_DEBUG
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: CCMP decrypt failed "
-				       "for RX frame from %s\n", rx->dev->name,
-				       print_mac(mac, rx->sta->addr));
-#endif /* CONFIG_MAC80211_DEBUG */
 			return RX_DROP_UNUSABLE;
 		}
 	}
--- everything.orig/net/mac80211/Kconfig	2008-06-20 11:25:23.000000000 +0200
+++ everything/net/mac80211/Kconfig	2008-06-20 11:29:37.000000000 +0200
@@ -101,9 +101,15 @@ config MAC80211_DEBUGFS
 
 	  Say N unless you know you need this.
 
+menuconfig MAC80211_DEBUG_MENU
+	bool "Select mac80211 debugging features"
+	depends on MAC80211
+	help
+	  This option collects various mac80211 debug settings.
+
 config MAC80211_DEBUG_PACKET_ALIGNMENT
 	bool "Enable packet alignment debugging"
-	depends on MAC80211
+	depends on MAC80211_DEBUG_MENU
 	help
 	  This option is recommended for driver authors and strongly
 	  discouraged for everybody else, it will trigger a warning
@@ -113,33 +119,95 @@ config MAC80211_DEBUG_PACKET_ALIGNMENT
 
 	  Say N unless you're writing a mac80211 based driver.
 
-config MAC80211_DEBUG
-	bool "Enable debugging output"
-	depends on MAC80211
-	---help---
-	  This option will enable debug tracing output for the
-	  ieee80211 network stack.
+config MAC80211_NOINLINE
+	bool "Do not inline TX/RX handlers"
+	depends on MAC80211_DEBUG_MENU
+	help
+	  This option affects code generation in mac80211, when
+	  selected some functions are marked "noinline" to allow
+	  easier debugging of problems in the transmit and receive
+	  paths.
+
+	  This option increases code size a bit and inserts a lot
+	  of function calls in the code, but is otherwise safe to
+	  enable.
+
+	  If unsure, say N unless you expect to be finding problems
+	  in mac80211.
+
+config MAC80211_VERBOSE_DEBUG
+	bool "Verbose debugging output"
+	depends on MAC80211_DEBUG_MENU
+	help
+	  Selecting this option causes mac80211 to print out
+	  many debugging messages. It should not be selected
+	  on production systems as some of the messages are
+	  remotely triggerable.
 
-	  If you are not trying to debug or develop the ieee80211
-	  subsystem, you most likely want to say N here.
+	  Do not select this option.
 
 config MAC80211_HT_DEBUG
-	bool "Enable HT debugging output"
-	depends on MAC80211_DEBUG
+	bool "Verbose HT debugging"
+	depends on MAC80211_DEBUG_MENU
 	---help---
 	  This option enables 802.11n High Throughput features
 	  debug tracing output.
 
-	  If you are not trying to debug of develop the ieee80211
-	  subsystem, you most likely want to say N here.
+	  It should not be selected on production systems as some
+	  of the messages are remotely triggerable.
 
-config MAC80211_VERBOSE_DEBUG
-	bool "Verbose debugging output"
-	depends on MAC80211_DEBUG
+	  Do not select this option.
+
+config TKIP_DEBUG
+	bool "Verbose TKIP debugging"
+	depends on MAC80211_DEBUG_MENU
+	help
+	  Selecting this option causes mac80211 to print out
+	  very verbose TKIP debugging messages. It should not
+	  be selected on production systems as those messages
+	  are remotely triggerable.
+
+	  Do not select this option.
+
+config MAC80211_IBSS_DEBUG
+	bool "Verbose IBSS debugging"
+	depends on MAC80211_DEBUG_MENU
+	help
+	  Selecting this option causes mac80211 to print out
+	  very verbose IBSS debugging messages. It should not
+	  be selected on production systems as those messages
+	  are remotely triggerable.
+
+	  Do not select this option.
+
+config MAC80211_VERBOSE_PS_DEBUG
+	bool "Verbose powersave mode debugging"
+	depends on MAC80211_DEBUG_MENU
+	help
+	  Selecting this option causes mac80211 to print out very
+	  verbose power save mode debugging messages (when mac80211
+	  is an AP and has power saving stations.)
+	  It should not be selected on production systems as those
+	  messages are remotely triggerable.
+
+	  Do not select this option.
+
+config MAC80211_VERBOSE_MPL_DEBUG
+	bool "Verbose mesh peer link debugging"
+	depends on MAC80211_DEBUG_MENU
+	depends on MAC80211_MESH
+	help
+	  Selecting this option causes mac80211 to print out very
+	  verbose mesh peer link debugging messages (when mac80211
+	  is taking part in a mesh network).
+	  It should not be selected on production systems as those
+	  messages are remotely triggerable.
+
+	  Do not select this option.
 
 config MAC80211_LOWTX_FRAME_DUMP
 	bool "Debug frame dumping"
-	depends on MAC80211_DEBUG
+	depends on MAC80211_DEBUG_MENU
 	---help---
 	  Selecting this option will cause the stack to
 	  print a message for each frame that is handed
@@ -150,30 +218,13 @@ config MAC80211_LOWTX_FRAME_DUMP
 	  If unsure, say N and insert the debugging code
 	  you require into the driver you are debugging.
 
-config TKIP_DEBUG
-	bool "TKIP debugging"
-	depends on MAC80211_DEBUG
-
 config MAC80211_DEBUG_COUNTERS
 	bool "Extra statistics for TX/RX debugging"
-	depends on MAC80211_DEBUG
-
-config MAC80211_IBSS_DEBUG
-	bool "Support for IBSS testing"
-	depends on MAC80211_DEBUG
-	---help---
-	  Say Y here if you intend to debug the IBSS code.
-
-config MAC80211_VERBOSE_PS_DEBUG
-	bool "Verbose powersave mode debugging"
-	depends on MAC80211_DEBUG
-	---help---
-	  Say Y here to print out verbose powersave
-	  mode debug messages.
+	depends on MAC80211_DEBUG_MENU
+	depends on MAC80211_DEBUGFS
+	help
+	  Selecting this option causes mac80211 to keep additional
+	  and very verbose statistics about TX and RX handler use
+	  and show them in debugfs.
 
-config MAC80211_VERBOSE_MPL_DEBUG
-	bool "Verbose mesh peer link debugging"
-	depends on MAC80211_DEBUG && MAC80211_MESH
-	---help---
-	  Say Y here to print out verbose mesh peer link
-	  debug messages.
+	  If unsure, say N.
--- everything.orig/net/mac80211/ieee80211_i.h	2008-06-20 11:25:23.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-06-20 11:29:37.000000000 +0200
@@ -942,7 +942,7 @@ int ieee80211_frame_duration(struct ieee
 void mac80211_ev_michael_mic_failure(struct net_device *dev, int keyidx,
 				     struct ieee80211_hdr *hdr);
 
-#ifdef CONFIG_MAC80211_DEBUG
+#ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
 #define debug_noinline


