Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46844 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949AbYLaPmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 10:42:40 -0500
Message-Id: <20081231154233.247667540@w1.fi> (sfid-20081231_164243_265958_0210970C)
References: <20081231153834.840526845@w1.fi>
Date: Wed, 31 Dec 2008 17:38:43 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [RFC 09/11] mac80211: 802.11w - Do not force Action frames to disable encryption
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending out Action frames, allow ieee80211_tx_skb() to send them
without enforcing do_not_encrypt. These frames will be encrypted if
MFP has been negotiated.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 net/mac80211/ht.c         |    6 +++---
 net/mac80211/mesh_hwmp.c  |    4 ++--
 net/mac80211/mesh_plink.c |    2 +-
 net/mac80211/spectmgmt.c  |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/ht.c	2008-12-31 16:45:08.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2008-12-31 17:20:12.000000000 +0200
@@ -201,7 +201,7 @@ static void ieee80211_send_addba_request
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 1);
 }
 
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
@@ -247,7 +247,7 @@ static void ieee80211_send_addba_resp(st
 	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
 	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 1);
 }
 
 static void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
@@ -290,7 +290,7 @@ static void ieee80211_send_delba(struct 
 	mgmt->u.action.u.delba.params = cpu_to_le16(params);
 	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 1);
 }
 
 void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn)
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2008-12-31 16:45:08.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2008-12-31 17:20:12.000000000 +0200
@@ -149,7 +149,7 @@ static int mesh_path_sel_frame_tx(enum m
 	pos += ETH_ALEN;
 	memcpy(pos, &dst_dsn, 4);
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 1);
 	return 0;
 }
 
@@ -198,7 +198,7 @@ int mesh_path_error_tx(u8 *dst, __le32 d
 	pos += ETH_ALEN;
 	memcpy(pos, &dst_dsn, 4);
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 1);
 	return 0;
 }
 
--- wireless-testing.orig/net/mac80211/mesh_plink.c	2008-12-31 16:45:08.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_plink.c	2008-12-31 17:20:12.000000000 +0200
@@ -217,7 +217,7 @@ static int mesh_plink_frame_tx(struct ie
 		memcpy(pos, &reason, 2);
 	}
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 1);
 	return 0;
 }
 
--- wireless-testing.orig/net/mac80211/spectmgmt.c	2008-12-31 16:45:08.000000000 +0200
+++ wireless-testing/net/mac80211/spectmgmt.c	2008-12-31 17:20:12.000000000 +0200
@@ -65,7 +65,7 @@ static void ieee80211_send_refuse_measur
 			IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED;
 	msr_report->u.action.u.measurement.msr_elem.type = request_ie->type;
 
-	ieee80211_tx_skb(sdata, skb, 0);
+	ieee80211_tx_skb(sdata, skb, 1);
 }
 
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
