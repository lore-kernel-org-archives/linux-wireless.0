Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C4DC433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Feb 2022 00:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244755AbiBPACG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:02:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244957AbiBPACE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Feb 2022 19:02:04 -0500
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F205F70311
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2022 16:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1644969711; x=1676505711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i433qmisurIIc5NMNpDM+rm43/7fslPE8Hq5V4AYONs=;
  b=BMYeUT3Z+C4yEttf8ib2dKTFDCHjRqCBAa+0haraip4j/sZtNB4TVrhm
   r4ikAtiEDufCuDgxU/vtQY92PEoCIJ/nJTVL9urage6Q6+xUjntF8ElQI
   jeKcu0F6MunycjvKSxSIe35+cCa9DHTIURkhTbvfbZ5h2qmoTqsuy6Pvx
   g=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 15 Feb 2022 16:01:51 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 16:01:50 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 15 Feb 2022 16:01:50 -0800
Received: from alokad-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Tue, 15 Feb 2022 16:01:49 -0800
From:   Aloka Dixit <quic_alokad@quicinc.com>
To:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
CC:     Muna Sinada <quic_msinada@quicinc.com>,
        Aloka Dixit <quic_alokad@quicinc.com>
Subject: [PATCH 2/2] mac80211: support disabling EHT mode
Date:   Tue, 15 Feb 2022 16:01:37 -0800
Message-ID: <20220216000137.29276-3-quic_alokad@quicinc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220216000137.29276-1-quic_alokad@quicinc.com>
References: <20220216000137.29276-1-quic_alokad@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Muna Sinada <quic_msinada@quicinc.com>

Allow userspace to disable EHT mode.
This forces EHT capable interfaces to disable during association.

Signed-off-by: Muna Sinada <quic_msinada@quicinc.com>
Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
---
 net/mac80211/mlme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3c17da28964f..ed9da4bde7d0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5764,7 +5764,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			ifmgd->flags |= IEEE80211_STA_DISABLE_HE;
 			ifmgd->flags |= IEEE80211_STA_DISABLE_EHT;
 			netdev_info(sdata->dev,
-				    "disabling HT/VHT/HE due to WEP/TKIP use\n");
+				    "disabling HT/VHT/HE/EHT due to WEP/TKIP use\n");
 		}
 	}
 
@@ -5926,6 +5926,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		ifmgd->flags |= IEEE80211_STA_DISABLE_EHT;
 	}
 
+	if (req->flags & ASSOC_REQ_DISABLE_EHT)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_EHT;
+
 	err = ieee80211_prep_connection(sdata, req->bss, true, override);
 	if (err)
 		goto err_clear;
-- 
2.31.1

