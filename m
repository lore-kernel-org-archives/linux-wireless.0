Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYIINHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 09:07:16 -0400
Subject: [PATCH] mac80211: move frame TX function
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 15:07:09 +0200
Message-Id: <1220965629.31304.174.camel@johannes.berg> (sfid-20080909_150721_229404_CFE2A0EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee80211_sta_tx function isn't MLME code any more,
it's getting used by a lot of code. Move it to utils and
rename it to ieee80211_tx_skb.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ht.c          |    8 ++++----
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/mesh_hwmp.c   |    4 ++--
 net/mac80211/mesh_plink.c  |    2 +-
 net/mac80211/mlme.c        |   24 +++++-------------------
 net/mac80211/scan.c        |    2 +-
 net/mac80211/spectmgmt.c   |    2 +-
 net/mac80211/util.c        |   14 ++++++++++++++
 8 files changed, 30 insertions(+), 30 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-09 14:59:31.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-09 15:01:12.000000000 +0200
@@ -912,8 +912,6 @@ u32 ieee80211_reset_erp_info(struct ieee
 u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
-void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		int encrypt);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      u8 *ssid, size_t ssid_len);
 void ieee802_11_parse_elems(u8 *start, size_t len,
@@ -1000,6 +998,8 @@ int ieee80211_frame_duration(struct ieee
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		      int encrypt);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- everything.orig/net/mac80211/mlme.c	2008-09-09 14:59:19.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-09 15:01:12.000000000 +0200
@@ -96,20 +96,6 @@ static int ieee80211_compatible_rates(st
 }
 
 /* frame sending functions */
-void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		      int encrypt)
-{
-	skb->dev = sdata->local->mdev;
-	skb_set_mac_header(skb, 0);
-	skb_set_network_header(skb, 0);
-	skb_set_transport_header(skb, 0);
-
-	skb->iif = sdata->dev->ifindex;
-	skb->do_not_encrypt = !encrypt;
-
-	dev_queue_xmit(skb);
-}
-
 static void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 				struct ieee80211_if_sta *ifsta,
 				int transaction, u8 *extra, size_t extra_len,
@@ -144,7 +130,7 @@ static void ieee80211_send_auth(struct i
 	if (extra)
 		memcpy(skb_put(skb, extra_len), extra, extra_len);
 
-	ieee80211_sta_tx(sdata, skb, encrypt);
+	ieee80211_tx_skb(sdata, skb, encrypt);
 }
 
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
@@ -204,7 +190,7 @@ void ieee80211_send_probe_req(struct iee
 		*pos = rate->bitrate / 5;
 	}
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
@@ -412,7 +398,7 @@ static void ieee80211_send_assoc(struct 
 	if (ifsta->assocreq_ies)
 		memcpy(ifsta->assocreq_ies, ies, ifsta->assocreq_ies_len);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 
@@ -442,7 +428,7 @@ static void ieee80211_send_deauth_disass
 	/* u.deauth.reason_code == u.disassoc.reason_code */
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 /* MLME */
@@ -1797,7 +1783,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	printk(KERN_DEBUG "%s: Sending ProbeResp to %s\n",
 	       sdata->dev->name, print_mac(mac, resp->da));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 static void ieee80211_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
--- everything.orig/net/mac80211/util.c	2008-09-09 14:59:27.000000000 +0200
+++ everything/net/mac80211/util.c	2008-09-09 15:01:13.000000000 +0200
@@ -598,3 +598,17 @@ void ieee80211_set_wmm_default(struct ie
 	for (i = 0; i < local_to_hw(local)->queues; i++)
 		local->ops->conf_tx(local_to_hw(local), i, &qparam);
 }
+
+void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		      int encrypt)
+{
+	skb->dev = sdata->local->mdev;
+	skb_set_mac_header(skb, 0);
+	skb_set_network_header(skb, 0);
+	skb_set_transport_header(skb, 0);
+
+	skb->iif = sdata->dev->ifindex;
+	skb->do_not_encrypt = !encrypt;
+
+	dev_queue_xmit(skb);
+}
--- everything.orig/net/mac80211/ht.c	2008-09-09 15:00:18.000000000 +0200
+++ everything/net/mac80211/ht.c	2008-09-09 15:01:12.000000000 +0200
@@ -113,7 +113,7 @@ static void ieee80211_send_addba_request
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
@@ -159,7 +159,7 @@ static void ieee80211_send_addba_resp(st
 	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
 	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 static void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
@@ -202,7 +202,7 @@ static void ieee80211_send_delba(struct 
 	mgmt->u.action.u.delba.params = cpu_to_le16(params);
 	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn)
@@ -231,7 +231,7 @@ void ieee80211_send_bar(struct ieee80211
 	bar->control = cpu_to_le16(bar_control);
 	bar->start_seq_num = cpu_to_le16(ssn);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid,
--- everything.orig/net/mac80211/mesh_hwmp.c	2008-09-09 15:00:19.000000000 +0200
+++ everything/net/mac80211/mesh_hwmp.c	2008-09-09 15:01:12.000000000 +0200
@@ -149,7 +149,7 @@ static int mesh_path_sel_frame_tx(enum m
 	pos += ETH_ALEN;
 	memcpy(pos, &dst_dsn, 4);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 	return 0;
 }
 
@@ -198,7 +198,7 @@ int mesh_path_error_tx(u8 *dst, __le32 d
 	pos += ETH_ALEN;
 	memcpy(pos, &dst_dsn, 4);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 	return 0;
 }
 
--- everything.orig/net/mac80211/mesh_plink.c	2008-09-09 15:00:19.000000000 +0200
+++ everything/net/mac80211/mesh_plink.c	2008-09-09 15:01:12.000000000 +0200
@@ -217,7 +217,7 @@ static int mesh_plink_frame_tx(struct ie
 		memcpy(pos, &reason, 2);
 	}
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 	return 0;
 }
 
--- everything.orig/net/mac80211/scan.c	2008-09-09 15:00:20.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-09 15:01:13.000000000 +0200
@@ -421,7 +421,7 @@ static void ieee80211_send_nullfunc(stru
 	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->u.sta.bssid, ETH_ALEN);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
--- everything.orig/net/mac80211/spectmgmt.c	2008-09-09 15:00:20.000000000 +0200
+++ everything/net/mac80211/spectmgmt.c	2008-09-09 15:01:13.000000000 +0200
@@ -65,7 +65,7 @@ static void ieee80211_send_refuse_measur
 			IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED;
 	msr_report->u.action.u.measurement.msr_elem.type = request_ie->type;
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 0);
 }
 
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,


