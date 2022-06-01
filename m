Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD6DC433F5
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Jun 2022 07:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350118AbiFAHBe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 Jun 2022 03:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241833AbiFAHBd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Jun 2022 03:01:33 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22B54B853
        for <linux-wireless@vger.kernel.org>; Wed,  1 Jun 2022 00:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654066892; x=1685602892;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ZpEZUbTyOlHdQb3s50ph6E8UgE+hAIWuG+XNzFNjdOE=;
  b=BPMpKEixV2hS6537UYzWBvW9Zdf8NFye1MkSlbkRNdANpp8QOXOR/MTN
   TsgHwUURNQMPmL4Z9HxUaiMxmZskmeR7feQrzh4OUcvPcZZXvmb+93D2a
   A8vw5eO6yULvxSYCP/0kGbmxMZH2KoxZCcC7rhZykUcVMBk62YcbLu0pl
   4=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 01 Jun 2022 00:01:32 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 00:01:32 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 1 Jun 2022 00:01:31 -0700
Received: from adisi-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 1 Jun 2022 00:01:30 -0700
From:   Aditya Kumar Singh <quic_adisi@quicinc.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <johannes@sipsolutions.net>,
        Aditya Kumar Singh <quic_adisi@quicinc.com>
Subject: [PATCH] mac80211: fix mesh airtime link metric estimating
Date:   Wed, 1 Jun 2022 12:31:15 +0530
Message-ID: <20220601070115.24340-1-quic_adisi@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ieee80211s_update_metric function uses sta_set_rate_info_tx
function to get struct rate_info data from ieee80211_tx_rate
struct, present in ieee80211_sta->tx_stats. However, drivers
can skip tx rate calculation by setting rate idx as -1. Such
drivers provides rate_info directly and hence ieee80211s
metric is updated incorrectly since ieee80211_tx_rate has
inconsistent data.

Add fix to use rate_info directly if present instead of
sta_set_rate_info_tx for updating ieee80211s metric.

Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
---
 net/mac80211/mesh_hwmp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 44a6fdb6efbd..3c80e7b68298 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -310,7 +310,12 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 			LINK_FAIL_THRESH)
 		mesh_plink_broken(sta);
 
-	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
+	/* use rate info set by the driver directly if present */
+	if (st->rate)
+		rinfo = sta->tx_stats.last_rate_info;
+	else
+		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
+
 	ewma_mesh_tx_rate_avg_add(&sta->mesh->tx_rate_avg,
 				  cfg80211_calculate_bitrate(&rinfo));
 }
-- 
2.17.1

