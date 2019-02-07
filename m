Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A82CC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 20:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA07021721
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 20:15:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nw3hqVLS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfBGUPo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 15:15:44 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34014 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbfBGUPn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 15:15:43 -0500
Received: by mail-pl1-f194.google.com with SMTP id w4so479178plz.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 12:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=y/VB52mm7sDg9LpGrF2wLJjfaHCbtFpkXRAqBFi667k=;
        b=nw3hqVLS/GE1xTXnkXE5LmL6cxFmXr3HVCM83v+GfVbvfPX37DAMSkquorkko56b4t
         nwyOIsr7xnT56+9iPgi16OK3EyD7EHMH2obElIJfpDEj4nGv6gjjgVLDj9p6WM3sUk/Z
         e7epHf3iZ6jPNqW8+TxT5ZGP8IYjfEFr5NW5O3f6MoQfF0M9v2jRD7Cubct5kNx1g/4/
         +a+FSV/isPqq9dvEXTHHecK85hGT9t0e5J69gn2j7Tz+ajGsIp1Nh+tM0Kea/Ddo98Ue
         44KHP84djR9fmTA0EHqqhcAhXJI88v6D4FyvExSrraAwIdyS3pyXCdUiE6SUMDuJCKnI
         SvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=y/VB52mm7sDg9LpGrF2wLJjfaHCbtFpkXRAqBFi667k=;
        b=riYWaSwwEry0wagtGJikezUftcITbmOTBgnfQv5VXhXPM20MfUpYOpyszeqzNhhx+S
         idXexhn5bjiED9w+SlfsUZ91uDTt7qp5P3rNHSnSM7HUg3hIKPNFBXFkv/Rw4exNgsT4
         aM4YaWThonok0NQSZKly1F6Ai38BPq0UOynlnKvJQa3NHoentaq/uY9FOj7F2JFbkXle
         DotJQYwPCniim33E83dU9MlpTLnFPFNk4iaJMX/S8eoYCOcb9cCr37xWVKezc/KRZApr
         TGFfVEOdNRjZcj4OFSgZdER3r6HszdHNQfuF8TU3ThmapizMZpMnRcfgamzhWsDdzomM
         LHCg==
X-Gm-Message-State: AHQUAua8Zp3iiXRSlpYSzalshTUXuOqH43ci9rqUUrkq3ekwuUWcUC9f
        IH6XxJMpxcu2gwTpfyHlExE/BpdEKh0=
X-Google-Smtp-Source: AHgI3IYGF1PuzpxuAJ2RkWEZSlJ/2CZpibB1jEMsxr5sLn0sUHfEXSikHz5THwKhckzT6/XpIZTQvA==
X-Received: by 2002:a17:902:aa07:: with SMTP id be7mr18360021plb.63.1549570543276;
        Thu, 07 Feb 2019 12:15:43 -0800 (PST)
Received: from localhost.localdomain ([100.90.116.195])
        by smtp.googlemail.com with ESMTPSA id m198sm20133857pga.10.2019.02.07.12.15.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 07 Feb 2019 12:15:42 -0800 (PST)
From:   Narayanraddi Masti <team.nmasti@gmail.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Narayanraddi Masti <team.nmasti@gmail.com>
Subject: [PATCH 1/2] mac80211: Add support for NL80211_STA_INFO_AIRTIME_LINK_METRIC
Date:   Thu,  7 Feb 2019 12:16:05 -0800
Message-Id: <1549570566-28658-1-git-send-email-team.nmasti@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support for mesh airtime link metric attribute
NL80211_STA_INFO_AIRTIME_LINK_METRIC.

Signed-off-by: Narayanraddi Masti <team.nmasti@gmail.com>
---
 include/net/cfg80211.h       | 3 +++
 include/uapi/linux/nl80211.h | 2 ++
 net/mac80211/mesh.h          | 2 ++
 net/mac80211/mesh_hwmp.c     | 4 ++--
 net/mac80211/sta_info.c      | 6 ++++++
 net/wireless/nl80211.c       | 1 +
 6 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e0c41eb..f1259e1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1310,6 +1310,7 @@ struct cfg80211_tid_stats {
  * @fcs_err_count: number of packets (MPDUs) received from this station with
  *	an FCS error. This counter should be incremented only when TA of the
  *	received packet with an FCS error matches the peer MAC address.
+ * @airtime_link_metric: mesh airtime link metric.
  */
 struct station_info {
 	u64 filled;
@@ -1361,6 +1362,8 @@ struct station_info {
 
 	u32 rx_mpdu_count;
 	u32 fcs_err_count;
+
+	u32 airtime_link_metric;
 };
 
 #if IS_ENABLED(CONFIG_CFG80211)
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 31ae5c7..99bebbf 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3125,6 +3125,7 @@ enum nl80211_sta_bss_param {
  *	might not be fully accurate.
  * @NL80211_STA_INFO_CONNECTED_TO_GATE: set to true if STA has a path to a
  *	mesh gate (u8, 0 or 1)
+ * @NL80211_STA_INFO_AIRTIME_LINK_METRIC: airtime link metric for mesh station
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3168,6 +3169,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_RX_MPDUS,
 	NL80211_STA_INFO_FCS_ERROR_COUNT,
 	NL80211_STA_INFO_CONNECTED_TO_GATE,
+	NL80211_STA_INFO_AIRTIME_LINK_METRIC,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index cad6592..920ba09 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -270,6 +270,8 @@ struct mesh_path *
 int mesh_path_add_gate(struct mesh_path *mpath);
 int mesh_path_send_to_gates(struct mesh_path *mpath);
 int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
+u32 airtime_link_metric_get(struct ieee80211_local *local,
+			    struct sta_info *sta);
 
 /* Mesh plinks */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6950cd0..181ccd1 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -312,8 +312,8 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 		mesh_plink_broken(sta);
 }
 
-static u32 airtime_link_metric_get(struct ieee80211_local *local,
-				   struct sta_info *sta)
+u32 airtime_link_metric_get(struct ieee80211_local *local,
+			    struct sta_info *sta)
 {
 	struct rate_info rinfo;
 	/* This should be adjusted for each device */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c4a8f11..e24dd28 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2335,6 +2335,12 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->filled |=
 			BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG);
 	}
+
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_AIRTIME_LINK_METRIC);
+		sinfo->airtime_link_metric =
+			airtime_link_metric_get(local, sta);
+	}
 }
 
 u32 sta_get_expected_throughput(struct sta_info *sta)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 74150ad..326493a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4888,6 +4888,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(TX_RETRIES, tx_retries, u32);
 	PUT_SINFO(TX_FAILED, tx_failed, u32);
 	PUT_SINFO(EXPECTED_THROUGHPUT, expected_throughput, u32);
+	PUT_SINFO(AIRTIME_LINK_METRIC, airtime_link_metric, u32);
 	PUT_SINFO(BEACON_LOSS, beacon_loss_count, u32);
 	PUT_SINFO(LOCAL_PM, local_pm, u32);
 	PUT_SINFO(PEER_PM, peer_pm, u32);
-- 
1.9.1

