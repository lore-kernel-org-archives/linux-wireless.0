Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047AbZKRRmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 12:42:32 -0500
Subject: [PATCH] mac80211: remove encrypt parameter from ieee80211_tx_skb
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 18:42:05 +0100
Message-ID: <1258566125.30511.44.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the flags moved into skb->cb, there's no
longer a need to have the encrypt bool passed
into the function, anyone who requires it set
to 0 (false) can just set the flag directly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c      |    2 +-
 net/mac80211/agg-tx.c      |    5 +++--
 net/mac80211/ht.c          |    2 +-
 net/mac80211/ibss.c        |    3 ++-
 net/mac80211/ieee80211_i.h |    3 +--
 net/mac80211/mesh_hwmp.c   |    4 ++--
 net/mac80211/mesh_plink.c  |    2 +-
 net/mac80211/mlme.c        |   13 +++++++++----
 net/mac80211/rx.c          |    2 +-
 net/mac80211/spectmgmt.c   |    2 +-
 net/mac80211/tx.c          |    7 +------
 net/mac80211/util.c        |    6 ++++--
 12 files changed, 27 insertions(+), 24 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-18 17:48:11.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-18 17:49:13.000000000 +0100
@@ -1015,8 +1015,7 @@ void mac80211_ev_michael_mic_failure(str
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
 				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
-void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		      int encrypt);
+void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
--- wireless-testing.orig/net/mac80211/tx.c	2009-11-18 17:48:15.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-11-18 17:49:07.000000000 +0100
@@ -2281,17 +2281,12 @@ ieee80211_get_buffered_bc(struct ieee802
 }
 EXPORT_SYMBOL(ieee80211_get_buffered_bc);
 
-void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		      int encrypt)
+void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	skb_set_mac_header(skb, 0);
 	skb_set_network_header(skb, 0);
 	skb_set_transport_header(skb, 0);
 
-	if (!encrypt)
-		info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-
 	/*
 	 * The other path calling ieee80211_xmit is from the tasklet,
 	 * and while we can handle concurrent transmissions locking
--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-11-18 17:50:34.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-11-18 17:50:55.000000000 +0100
@@ -167,7 +167,7 @@ static void ieee80211_send_addba_resp(st
 	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
 	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
 
-	ieee80211_tx_skb(sdata, skb, 1);
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_process_addba_request(struct ieee80211_local *local,
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-11-18 17:49:45.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-11-18 17:50:46.000000000 +0100
@@ -91,7 +91,7 @@ static void ieee80211_send_addba_request
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_tx_skb(sdata, skb, 1);
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn)
@@ -120,7 +120,8 @@ void ieee80211_send_bar(struct ieee80211
 	bar->control = cpu_to_le16(bar_control);
 	bar->start_seq_num = cpu_to_le16(ssn);
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, skb);
 }
 
 static int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
--- wireless-testing.orig/net/mac80211/ht.c	2009-11-18 17:49:24.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-11-18 17:49:32.000000000 +0100
@@ -134,7 +134,7 @@ void ieee80211_send_delba(struct ieee802
 	mgmt->u.action.u.delba.params = cpu_to_le16(params);
 	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
 
-	ieee80211_tx_skb(sdata, skb, 1);
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/ibss.c	2009-11-18 17:51:03.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2009-11-18 17:51:12.000000000 +0100
@@ -659,7 +659,8 @@ static void ieee80211_rx_mgmt_probe_req(
 	printk(KERN_DEBUG "%s: Sending ProbeResp to %pM\n",
 	       sdata->dev->name, resp->da);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	ieee80211_tx_skb(sdata, skb, 0);
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, skb);
 }
 
 static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2009-11-18 17:52:58.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2009-11-18 17:53:08.000000000 +0100
@@ -187,7 +187,7 @@ static int mesh_path_sel_frame_tx(enum m
 		memcpy(pos, &target_sn, 4);
 	}
 
-	ieee80211_tx_skb(sdata, skb, 1);
+	ieee80211_tx_skb(sdata, skb);
 	return 0;
 }
 
@@ -250,7 +250,7 @@ int mesh_path_error_tx(u8 ttl, u8 *targe
 	pos += 4;
 	memcpy(pos, &target_rcode, 2);
 
-	ieee80211_tx_skb(sdata, skb, 1);
+	ieee80211_tx_skb(sdata, skb);
 	return 0;
 }
 
--- wireless-testing.orig/net/mac80211/mesh_plink.c	2009-11-18 17:52:49.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_plink.c	2009-11-18 17:52:53.000000000 +0100
@@ -222,7 +222,7 @@ static int mesh_plink_frame_tx(struct ie
 		memcpy(pos, &reason, 2);
 	}
 
-	ieee80211_tx_skb(sdata, skb, 1);
+	ieee80211_tx_skb(sdata, skb);
 	return 0;
 }
 
--- wireless-testing.orig/net/mac80211/mlme.c	2009-11-18 17:51:17.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-11-18 17:51:58.000000000 +0100
@@ -426,7 +426,8 @@ static void ieee80211_send_assoc(struct 
 		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
 	}
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, skb);
 }
 
 
@@ -467,7 +468,9 @@ static void ieee80211_send_deauth_disass
 			__cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
 		else
 			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
-	ieee80211_tx_skb(sdata, skb, ifmgd->flags & IEEE80211_STA_MFP_ENABLED);
+	if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_send_pspoll(struct ieee80211_local *local,
@@ -498,7 +501,8 @@ void ieee80211_send_pspoll(struct ieee80
 	memcpy(pspoll->bssid, ifmgd->bssid, ETH_ALEN);
 	memcpy(pspoll->ta, sdata->dev->dev_addr, ETH_ALEN);
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_send_nullfunc(struct ieee80211_local *local,
@@ -531,7 +535,8 @@ void ieee80211_send_nullfunc(struct ieee
 	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->u.mgd.bssid, ETH_ALEN);
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, skb);
 }
 
 /* spectrum management related things */
--- wireless-testing.orig/net/mac80211/rx.c	2009-11-18 17:52:06.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-18 17:52:11.000000000 +0100
@@ -1666,7 +1666,7 @@ static void ieee80211_process_sa_query_r
 	       mgmt->u.action.u.sa_query.trans_id,
 	       WLAN_SA_QUERY_TR_ID_LEN);
 
-	ieee80211_tx_skb(sdata, skb, 1);
+	ieee80211_tx_skb(sdata, skb);
 }
 
 static ieee80211_rx_result debug_noinline
--- wireless-testing.orig/net/mac80211/spectmgmt.c	2009-11-18 17:52:17.000000000 +0100
+++ wireless-testing/net/mac80211/spectmgmt.c	2009-11-18 17:52:20.000000000 +0100
@@ -65,7 +65,7 @@ static void ieee80211_send_refuse_measur
 			IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED;
 	msr_report->u.action.u.measurement.msr_elem.type = request_ie->type;
 
-	ieee80211_tx_skb(sdata, skb, 1);
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/util.c	2009-11-18 17:52:28.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-11-18 17:52:39.000000000 +0100
@@ -872,7 +872,8 @@ void ieee80211_send_auth(struct ieee8021
 		WARN_ON(err);
 	}
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, skb);
 }
 
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
@@ -974,7 +975,8 @@ void ieee80211_send_probe_req(struct iee
 	skb_put(skb, ieee80211_build_preq_ies(local, pos, ie, ie_len,
 					      local->hw.conf.channel->band));
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, skb);
 }
 
 u32 ieee80211_sta_get_rates(struct ieee80211_local *local,


