Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71071C46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 19:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DCA12082E
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 19:49:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="haig1atz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DCA12082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bobcopeland.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbeJZEXY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 00:23:24 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45182 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbeJZEXX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 00:23:23 -0400
Received: by mail-io1-f65.google.com with SMTP id p83-v6so6241860iod.12
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2018 12:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mqiCydNCGpPZbXmPy27/5ByY+QLuDG7aQHKQeWXnLTs=;
        b=haig1atz52daKAWVtU6lSkFx2C0iNLfrApz4QOgeofWymRjqyM9x3PLjGvnTYBUL+n
         8pQFEqZczZtdZ230jw+EGCkN377VUSDDV2T0sE2dukKM31iDyqsylAt3kBAlU0PHY8oZ
         ZSd5TAlu0GXa718dn9DaJ/E50/rApX7uibfagd3lKNt+qCuZu2ZeT4LyoDwqpXsJWK6b
         iJCL+/sYUbHBh8uwbwKluJqS57GNzgfGpnc2NAR8R5t0OzGptC80Ot++j1qSXhhwneLm
         4TOtbUuF0iKZ1rUrBy2G8sPHLmUsncUMcdlywFnqM9dmJM7grLBbUbQiJgEwZ9gZgTrJ
         iwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mqiCydNCGpPZbXmPy27/5ByY+QLuDG7aQHKQeWXnLTs=;
        b=VZYZuZJ5MYZTgkMV8BObfcWDMqSMDw23t+nMUfDfdLnsvzX0dK+6Ws3Mzebmp/kvK7
         sl0cpT/5x4yaQ3rM1shEuA/5lcyfT/KAU26Fr6skeaVO8OsULMUuDvF4KfnhdjDXRPEv
         TtAYMmtTXNZOoWvyQAlY9Rsb9MzEDCuv2nduIOPIv7aRoBBYrhlldwyc0bG9rWzYEqkV
         gGtElF8zN3p5GzEEoa/yBR1Z78KBANs/Odi5IgbOeqUrouyP6LLhT8kZgyGU25fckP6w
         ANldwKEyR7DJlUd393ijJGYp01sgT/g/syepFbBimbFF1ejOjIFdAdEwyNUsv0nR82tR
         SK1w==
X-Gm-Message-State: AGRZ1gKbhhAxOlDa+F5wrznuve9K2deqbbgT88/g5603tWc6suyEJdfr
        JPbpB4nmkk+8yfT+ntzFSGsFTA==
X-Google-Smtp-Source: AJdET5eL0joskfEmBuMPogOM/QARCSPzAgMSZe9NGetLOWw3u08EBfUJ2gqA936jyD1p8R/coH0Dog==
X-Received: by 2002:a6b:901:: with SMTP id t1-v6mr364296ioi.207.1540496955692;
        Thu, 25 Oct 2018 12:49:15 -0700 (PDT)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id m70-v6sm1234432itm.27.2018.10.25.12.49.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Oct 2018 12:49:15 -0700 (PDT)
Received: from bob by hash with local (Exim 4.89)
        (envelope-from <me@bobcopeland.com>)
        id 1gFld4-00034O-AD; Thu, 25 Oct 2018 15:49:14 -0400
From:   Bob Copeland <me@bobcopeland.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, kernel-team@fb.com,
        Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>
Subject: [PATCH 2/3] {nl,mac}80211: report gate connectivity in station info
Date:   Thu, 25 Oct 2018 15:48:53 -0400
Message-Id: <20181025194854.11676-2-me@bobcopeland.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181025194854.11676-1-me@bobcopeland.com>
References: <20181025194854.11676-1-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Capture the current state of gate connectivity from the mesh
formation field in mesh config whenever we receive a beacon,
and report that via GET_STATION.  This allows applications
doing mesh peering in userspace to make peering decisions
based on peers' current upstream connectivity.

Signed-off-by: Bob Copeland <bobcopeland@fb.com>
---
 include/linux/ieee80211.h    | 2 ++
 include/net/cfg80211.h       | 3 +++
 include/uapi/linux/nl80211.h | 3 +++
 net/mac80211/mesh_plink.c    | 3 +++
 net/mac80211/sta_info.c      | 4 +++-
 net/mac80211/sta_info.h      | 2 ++
 net/wireless/nl80211.c       | 1 +
 7 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 0ef67f837ae1..407d6fd66fa9 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -812,6 +812,8 @@ enum mesh_config_capab_flags {
 	IEEE80211_MESHCONF_CAPAB_POWER_SAVE_LEVEL	= 0x40,
 };
 
+#define IEEE80211_MESHCONF_FORM_CONNECTED_TO_GATE 0x1
+
 /**
  * mesh channel switch parameters element's flag indicator
  *
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7a1be3..f2cb1a3c9651 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1296,6 +1296,7 @@ struct cfg80211_tid_stats {
  * @rx_beacon: number of beacons received from this peer
  * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
  *	from this peer
+ * @connected_to_gate: true if mesh STA has a path to mesh gate
  * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
  * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
  *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
@@ -1350,6 +1351,8 @@ struct station_info {
 	u64 rx_beacon;
 	u64 rx_duration;
 	u8 rx_beacon_signal_avg;
+	u8 connected_to_gate;
+
 	struct cfg80211_tid_stats *pertid;
 	s8 ack_signal;
 	s8 avg_ack_signal;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610bae30a9..f2d79f9b4b5a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3074,6 +3074,8 @@ enum nl80211_sta_bss_param {
  *	with an FCS error (u32, from this station). This count may not include
  *	some packets with an FCS error due to TA corruption. Hence this counter
  *	might not be fully accurate.
+ * @NL80211_STA_INFO_CONNECTED_TO_GATE: set to true if STA has a path to a
+ *	mesh gate
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3116,6 +3118,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_ACK_SIGNAL_AVG,
 	NL80211_STA_INFO_RX_MPDUS,
 	NL80211_STA_INFO_FCS_ERROR_COUNT,
+	NL80211_STA_INFO_CONNECTED_TO_GATE,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 5b5b0f95ffd1..5f45a2b273df 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -590,6 +590,9 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		goto out;
 
+	sta->mesh->connected_to_gate = elems->mesh_config->meshconf_form &
+		IEEE80211_MESHCONF_FORM_CONNECTED_TO_GATE;
+
 	if (mesh_peer_accepts_plinks(elems) &&
 	    sta->mesh->plink_state == NL80211_PLINK_LISTEN &&
 	    sdata->u.mesh.accepting_plinks &&
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fb8c2252ac0e..971f06911ff8 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2267,7 +2267,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 				 BIT_ULL(NL80211_STA_INFO_PLINK_STATE) |
 				 BIT_ULL(NL80211_STA_INFO_LOCAL_PM) |
 				 BIT_ULL(NL80211_STA_INFO_PEER_PM) |
-				 BIT_ULL(NL80211_STA_INFO_NONPEER_PM);
+				 BIT_ULL(NL80211_STA_INFO_NONPEER_PM) |
+				 BIT_ULL(NL80211_STA_INFO_CONNECTED_TO_GATE);
 
 		sinfo->llid = sta->mesh->llid;
 		sinfo->plid = sta->mesh->plid;
@@ -2279,6 +2280,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->local_pm = sta->mesh->local_pm;
 		sinfo->peer_pm = sta->mesh->peer_pm;
 		sinfo->nonpeer_pm = sta->mesh->nonpeer_pm;
+		sinfo->connected_to_gate = sta->mesh->connected_to_gate;
 #endif
 	}
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9a04327d71d1..8eb29041be54 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -364,6 +364,7 @@ DECLARE_EWMA(mesh_fail_avg, 20, 8)
  * @nonpeer_pm: STA power save mode towards non-peer neighbors
  * @processed_beacon: set to true after peer rates and capabilities are
  *	processed
+ * @connected_to_gate: true if mesh STA has a path to a mesh gate
  * @fail_avg: moving percentage of failed MSDUs
  */
 struct mesh_sta {
@@ -381,6 +382,7 @@ struct mesh_sta {
 	u8 plink_retries;
 
 	bool processed_beacon;
+	bool connected_to_gate;
 
 	enum nl80211_plink_state plink_state;
 	u32 plink_timeout;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b5851bbf9..ce8c082e6389 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4731,6 +4731,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(LOCAL_PM, local_pm, u32);
 	PUT_SINFO(PEER_PM, peer_pm, u32);
 	PUT_SINFO(NONPEER_PM, nonpeer_pm, u32);
+	PUT_SINFO(CONNECTED_TO_GATE, connected_to_gate, u8);
 
 	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_BSS_PARAM)) {
 		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
-- 
2.11.0

