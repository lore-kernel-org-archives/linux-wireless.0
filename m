Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E0EC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59D5120883
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CDWx0EoH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391429AbfAOXcD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:32:03 -0500
Received: from mail-qt1-f202.google.com ([209.85.160.202]:55684 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbfAOXcD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 18:32:03 -0500
Received: by mail-qt1-f202.google.com with SMTP id b16so3926698qtc.22
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 15:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kyADy8HwewODXD3z9C9hlY3CFEudvtZA2b6A6GGfG6k=;
        b=CDWx0EoHrXZd0D99rofbFstF0vm6ptoWz1kH1Y8Cg8teCdzq9uP7bCOsxxYjBJsfA1
         JdmUK6Wefnes8suvmWsrLGZrgRm5u4gjtvy6uceox9eBu9zBgceFFrsVe/NFISePxkVE
         //LUz4s8gfKTPKiEGfeJs43DeYyHaov35yUskb0i6uby89/HRP1tJeKnEI84mx9YDvrL
         G015QmBlfvK/96pJZ96nWjo2pzg+P/DxNPHldrrxSisIvUjBv+zUT18d45BqeIVFg/uI
         fYOPbweJv+usnMhwTp3/KhO2V3qhihmPyvqjnW6Rw8Qfh8ACZHkI/zG/gxIfxioN4iCD
         OU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kyADy8HwewODXD3z9C9hlY3CFEudvtZA2b6A6GGfG6k=;
        b=b6g49ILnyrNTZorjQ5ALnrpJqx5mSOwucmXKcECFw6Pg1etH8b1QFqbZXsIknztMXz
         bECUO8pwennIwBgk0zEgrXsO5+b7LRr58kTFG7frYirPZcKmoGPzTz+NObGQML2RCXeD
         XYcPghevp4dq3QiWsx+QCmk4fwQ5s3FXUmYckXSoLYLZeWq+4W3dzCe/5grP9v+soMhk
         aUnWFKUslSP058zhthVZIWsUT/nQJlaJjIA4SCvzW82zQqoTWXGqPsVPzKX4tSw9nDyl
         1td8AEXIVAD6YOP+nEo/oUdRvrDej8A/4Vj2nk0Z8ibTRgRowtV+Pal8fRzsJ3BYC3lc
         gkyQ==
X-Gm-Message-State: AJcUukexbqeqYDSm5WNt0kfA3ZzYw/d0lbLHjYz33S8XRVtFQDocekNq
        S29lFxMaC9/UUvceOkH5ry/I7gTYifdPTw==
X-Google-Smtp-Source: ALg8bN49cVUQFEDM1Lod0Ntyuaphxd1+7j2ilvkx5ZZD5Gm0OpP2c+PHrTWAlWG6JR+cs3GJZ/xliL6vpMGG+w==
X-Received: by 2002:a0c:9219:: with SMTP id a25mr3486560qva.39.1547595122048;
 Tue, 15 Jan 2019 15:32:02 -0800 (PST)
Date:   Tue, 15 Jan 2019 15:31:56 -0800
Message-Id: <20190115233156.225963-1-julanhsu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.20.1.97.g81188d93c3-goog
Subject: [PATCH] mac80211: mesh: use average bitrate for link metric calculation
From:   julanhsu@google.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Julan Hsu <julanhsu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Julan Hsu <julanhsu@google.com>

Use bitrate moving average to smooth out link metric and stablize path
selection.

Signed-off-by: Julan Hsu <julanhsu@google.com>
---
 net/mac80211/cfg.c       | 5 +++++
 net/mac80211/mesh_hwmp.c | 9 ++++++---
 net/mac80211/sta_info.h  | 4 ++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 818aa0060349..31a47d3a122d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1231,6 +1231,11 @@ static void sta_apply_mesh_params(struct ieee80211_local *local,
 			ieee80211_mps_sta_status_update(sta);
 			changed |= ieee80211_mps_set_sta_local_pm(sta,
 				      sdata->u.mesh.mshcfg.power_mode);
+
+			ewma_mesh_tx_rate_avg_init(&sta->mesh->tx_rate_avg);
+			/* init at low value */
+			ewma_mesh_tx_rate_avg_add(&sta->mesh->tx_rate_avg, 10);
+
 			break;
 		case NL80211_PLINK_LISTEN:
 		case NL80211_PLINK_BLOCKED:
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6950cd0bf594..34f11be04e64 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -300,6 +300,7 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 {
 	struct ieee80211_tx_info *txinfo = st->info;
 	int failed;
+	struct rate_info rinfo;
 
 	failed = !(txinfo->flags & IEEE80211_TX_STAT_ACK);
 
@@ -310,12 +311,15 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	if (ewma_mesh_fail_avg_read(&sta->mesh->fail_avg) >
 			LINK_FAIL_THRESH)
 		mesh_plink_broken(sta);
+
+	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
+	ewma_mesh_tx_rate_avg_add(&sta->mesh->tx_rate_avg,
+				  cfg80211_calculate_bitrate(&rinfo));
 }
 
 static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
-	struct rate_info rinfo;
 	/* This should be adjusted for each device */
 	int device_constant = 1 << ARITH_SHIFT;
 	int test_frame_len = TEST_FRAME_LEN << ARITH_SHIFT;
@@ -339,8 +343,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 		if (fail_avg > LINK_FAIL_THRESH)
 			return MAX_METRIC;
 
-		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
-		rate = cfg80211_calculate_bitrate(&rinfo);
+		rate = ewma_mesh_tx_rate_avg_read(&sta->mesh->tx_rate_avg);
 		if (WARN_ON(!rate))
 			return MAX_METRIC;
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9a04327d71d1..b94aeb680d2d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -343,6 +343,7 @@ struct ieee80211_fast_rx {
 
 /* we use only values in the range 0-100, so pick a large precision */
 DECLARE_EWMA(mesh_fail_avg, 20, 8)
+DECLARE_EWMA(mesh_tx_rate_avg, 8, 16)
 
 /**
  * struct mesh_sta - mesh STA information
@@ -365,6 +366,7 @@ DECLARE_EWMA(mesh_fail_avg, 20, 8)
  * @processed_beacon: set to true after peer rates and capabilities are
  *	processed
  * @fail_avg: moving percentage of failed MSDUs
+ * @tx_rate_avg: moving average of tx bitrate
  */
 struct mesh_sta {
 	struct timer_list plink_timer;
@@ -392,6 +394,8 @@ struct mesh_sta {
 
 	/* moving percentage of failed MSDUs */
 	struct ewma_mesh_fail_avg fail_avg;
+	/* moving average of tx bitrate */
+	struct ewma_mesh_tx_rate_avg tx_rate_avg;
 };
 
 DECLARE_EWMA(signal, 10, 8)
-- 
2.20.1.97.g81188d93c3-goog

