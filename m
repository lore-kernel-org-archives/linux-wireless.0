Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56051C6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 14:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDC7820665
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 14:04:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="aIlFlyvn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDC7820665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bobcopeland.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbeJZWlN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 18:41:13 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:51498 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbeJZWlN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 18:41:13 -0400
Received: by mail-it1-f196.google.com with SMTP id 74-v6so1649894itw.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2018 07:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=6kVp/d0kms0avBpRwzZw754P1hcaqRGj+Km3GnrsTC0=;
        b=aIlFlyvnLli0qv/3wR5krtHUmRQ1UlPj+ntjrXnNo54cEUfX/tRfU/qr1JjSUPiQ5l
         H50qM/FpYGsCO02KVGaXv4iJ0jNU1/0mQjqxU9OQSYrSUTt6TCiJGhkMtzrbbF6YY0oa
         xQpAZBUSm5B3lK5roKONW1MT3SHZNW2/c+MRZGizcsR3QfkTsKzWflrXSZzw0/nnXSRe
         OPERKdX4P81HWA1kO0J16L+Gt1vV6gfdSwJSEBTvEAqVubRhUySIZfZXU+MrfzFDPqJ+
         50v0nXtfve/q4NWDDxWl+RX6sy2oZDZ1o2+oNP6oQ6ndvk1QbqRCw9nWjclLwuF/fbw5
         /jKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6kVp/d0kms0avBpRwzZw754P1hcaqRGj+Km3GnrsTC0=;
        b=JQnGNWdzM2pyvh6G1Tu+p26xR28F5qrS75sYrsVFl2C5zcDuxs0y3VSB47GF+4hHkh
         /Qtg94+9qL63b6pdAssg9jOScF8vO+c2OBuE/1tpU8A2D4jKsflkbt9y4zBe22SxcbSD
         SK0tV5MSOc+VPeU+Eb1Aa5Zpt4Hww9bU/n7/daKUXbdyNUsxvaeCg6Mxvh2QfNMMiC8I
         wUY4ZUfW6q4mkuc2zadB4kv1t/x4pH/TltXDKJXiwZ/UHHQwILeH6MIEYrL5xeRajItV
         KAIMH+F22/5brKB3e/K1C7IgyskyCaCKjSGjBgCdcjj3rDga6Mc+INn38UzGSCq0hyiX
         jEgQ==
X-Gm-Message-State: AGRZ1gKV9G8vikJX2cFYrBhJaDYd+l4n4GlALLYHtCZLX9xs28fg7aPu
        4yNHu8vyLCX5amebL7QAcNXjKQ==
X-Google-Smtp-Source: AJdET5eBNwASp38oqOFb3vHgRaUzkFknEon9ppRcJmQX/7TKutkndUZqd5qRps4mVlKApuuz8QSfdQ==
X-Received: by 2002:a24:9f42:: with SMTP id c63-v6mr3682803ite.165.1540562639255;
        Fri, 26 Oct 2018 07:03:59 -0700 (PDT)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id 201-v6sm2362120itm.29.2018.10.26.07.03.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Oct 2018 07:03:58 -0700 (PDT)
Received: from bob by hash with local (Exim 4.89)
        (envelope-from <me@bobcopeland.com>)
        id 1gG2iT-00082O-2v; Fri, 26 Oct 2018 10:03:57 -0400
From:   Bob Copeland <me@bobcopeland.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, kernel-team@fb.com,
        Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>
Subject: [PATCH] {nl,mac}80211: add rssi to mesh candidates
Date:   Fri, 26 Oct 2018 10:03:50 -0400
Message-Id: <20181026140350.30855-1-me@bobcopeland.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When peering is in userspace, some implementations may want to control
which peers are accepted based on RSSI in addition to the information
elements being sent today.  Add signal level so that info is available
to clients.

Signed-off-by: Bob Copeland <bobcopeland@fb.com>
---
 include/net/cfg80211.h    |  3 ++-
 net/mac80211/mesh.c       |  3 ++-
 net/mac80211/mesh.h       |  3 ++-
 net/mac80211/mesh_plink.c | 32 ++++++++++++++++++++++----------
 net/wireless/nl80211.c    |  7 +++++--
 5 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7a1be3..2e7710adacb0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5328,7 +5328,8 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * cfg80211 then sends a notification to userspace.
  */
 void cfg80211_notify_new_peer_candidate(struct net_device *dev,
-		const u8 *macaddr, const u8 *ie, u8 ie_len, gfp_t gfp);
+		const u8 *macaddr, const u8 *ie, u8 ie_len,
+		int sig_dbm, gfp_t gfp);
 
 /**
  * DOC: RFkill integration
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8bad414c52ad..ea76d4dbdd49 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1191,7 +1191,8 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		if (!sdata->u.mesh.user_mpm ||
 		    sdata->u.mesh.mshcfg.rssi_threshold == 0 ||
 		    sdata->u.mesh.mshcfg.rssi_threshold < rx_status->signal)
-			mesh_neighbour_update(sdata, mgmt->sa, &elems);
+			mesh_neighbour_update(sdata, mgmt->sa, &elems,
+					      rx_status);
 	}
 
 	if (ifmsh->sync_ops)
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 21526630bf65..cad6592c52a1 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -273,7 +273,8 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
 
 /* Mesh plinks */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-			   u8 *hw_addr, struct ieee802_11_elems *ie);
+			   u8 *hw_addr, struct ieee802_11_elems *ie,
+			   struct ieee80211_rx_status *rx_status);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 u32 mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_timer(struct timer_list *t);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 5b5b0f95ffd1..9e8d80533562 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -513,7 +513,8 @@ __mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *hw_addr)
 
 static struct sta_info *
 mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *addr,
-		    struct ieee802_11_elems *elems)
+		    struct ieee802_11_elems *elems,
+		    struct ieee80211_rx_status *rx_status)
 {
 	struct sta_info *sta = NULL;
 
@@ -521,11 +522,17 @@ mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *addr,
 	if (sdata->u.mesh.user_mpm ||
 	    sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED) {
 		if (mesh_peer_accepts_plinks(elems) &&
-		    mesh_plink_availables(sdata))
+		    mesh_plink_availables(sdata)) {
+			int sig = 0;
+
+			if (ieee80211_hw_check(&sdata->local->hw, SIGNAL_DBM))
+				sig = rx_status->signal;
+
 			cfg80211_notify_new_peer_candidate(sdata->dev, addr,
 							   elems->ie_start,
 							   elems->total_len,
-							   GFP_KERNEL);
+							   sig, GFP_KERNEL);
+		}
 	} else
 		sta = __mesh_sta_info_alloc(sdata, addr);
 
@@ -538,13 +545,15 @@ mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *addr,
  * @sdata: local meshif
  * @addr: peer's address
  * @elems: IEs from beacon or mesh peering frame.
+ * @rx_status: rx status for the frame for signal reporting
  *
  * Return existing or newly allocated sta_info under RCU read lock.
  * (re)initialize with given IEs.
  */
 static struct sta_info *
 mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
-		  u8 *addr, struct ieee802_11_elems *elems) __acquires(RCU)
+		  u8 *addr, struct ieee802_11_elems *elems,
+		  struct ieee80211_rx_status *rx_status) __acquires(RCU)
 {
 	struct sta_info *sta = NULL;
 
@@ -555,7 +564,7 @@ mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
 	} else {
 		rcu_read_unlock();
 		/* can't run atomic */
-		sta = mesh_sta_info_alloc(sdata, addr, elems);
+		sta = mesh_sta_info_alloc(sdata, addr, elems, rx_status);
 		if (!sta) {
 			rcu_read_lock();
 			return NULL;
@@ -576,17 +585,19 @@ mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
  * @sdata: local meshif
  * @addr: peer's address
  * @elems: IEs from beacon or mesh peering frame
+ * @rx_status: rx status for the frame for signal reporting
  *
  * Initiates peering if appropriate.
  */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 			   u8 *hw_addr,
-			   struct ieee802_11_elems *elems)
+			   struct ieee802_11_elems *elems,
+			   struct ieee80211_rx_status *rx_status)
 {
 	struct sta_info *sta;
 	u32 changed = 0;
 
-	sta = mesh_sta_info_get(sdata, hw_addr, elems);
+	sta = mesh_sta_info_get(sdata, hw_addr, elems, rx_status);
 	if (!sta)
 		goto out;
 
@@ -1069,7 +1080,8 @@ mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
 static void
 mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt,
-			 struct ieee802_11_elems *elems)
+			 struct ieee802_11_elems *elems,
+			 struct ieee80211_rx_status *rx_status)
 {
 
 	struct sta_info *sta;
@@ -1134,7 +1146,7 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
 	if (event == OPN_ACPT) {
 		rcu_read_unlock();
 		/* allocate sta entry if necessary and update info */
-		sta = mesh_sta_info_get(sdata, mgmt->sa, elems);
+		sta = mesh_sta_info_get(sdata, mgmt->sa, elems, rx_status);
 		if (!sta) {
 			mpl_dbg(sdata, "Mesh plink: failed to init peer!\n");
 			goto unlock_rcu;
@@ -1200,5 +1212,5 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			return;
 	}
 	ieee802_11_parse_elems(baseaddr, len - baselen, true, &elems);
-	mesh_process_plink_frame(sdata, mgmt, &elems);
+	mesh_process_plink_frame(sdata, mgmt, &elems, rx_status);
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b5851bbf9..9b57de4cc030 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14572,7 +14572,8 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8* ie, u8 ie_len, gfp_t gfp)
+					const u8 *ie, u8 ie_len,
+					int sig_dbm, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -14598,7 +14599,9 @@ void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, addr) ||
 	    (ie_len && ie &&
-	     nla_put(msg, NL80211_ATTR_IE, ie_len , ie)))
+	     nla_put(msg, NL80211_ATTR_IE, ie_len, ie)) ||
+	    (sig_dbm &&
+	     nla_put_u32(msg, NL80211_ATTR_RX_SIGNAL_DBM, sig_dbm)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
-- 
2.11.0

