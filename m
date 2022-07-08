Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3D7C433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Jul 2022 16:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbiGHQ4D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Jul 2022 12:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237590AbiGHQ4C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jul 2022 12:56:02 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F147113
        for <linux-wireless@vger.kernel.org>; Fri,  8 Jul 2022 09:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657299362; x=1688835362;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9cIuyQcnKO4gTFKUDafBmsBbw/VxtE4K/uvvE513t1I=;
  b=tyLhigzM4ZsB6ACkbz5EciR3t0fwHQVuwt0+mCB6NOeDcpxcyPXyG4Gd
   WV+qOmVQHjwQekBVfdy0EjpqbRxy1r8lCTgmAqRjHhS1/irbjRvndX7lY
   zdoDGwAWffVYEkqCe9YFWIDAUBc9KohyJ+vxZDYSK4yqjR6VVHw1cJjE/
   0=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 08 Jul 2022 09:56:02 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 09:56:02 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 8 Jul 2022 09:56:01 -0700
Received: from cnss-mw-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 8 Jul 2022 09:56:00 -0700
From:   Veerendranath Jakkam <quic_vjakkam@quicinc.com>
To:     <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: fix a comment in cfg80211_mlme_mgmt_tx()
Date:   Fri, 8 Jul 2022 22:25:44 +0530
Message-ID: <20220708165545.2072999-1-quic_vjakkam@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A comment in cfg80211_mlme_mgmt_tx() is describing this API used only
for transmitting action frames. Fix the comment since
cfg80211_mlme_mgmt_tx() can be used to transmit any management frame.

Signed-off-by: Veerendranath Jakkam <quic_vjakkam@quicinc.com>
---
 net/wireless/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 2bb4da97b66a..14584488de67 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -755,7 +755,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			return -EINVAL;
 	}
 
-	/* Transmit the Action frame as requested by user space */
+	/* Transmit the management frame as requested by user space */
 	return rdev_mgmt_tx(rdev, wdev, params, cookie);
 }
 
-- 
2.25.1

