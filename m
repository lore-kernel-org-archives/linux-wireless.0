Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C8BECDE3B
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 22:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C7E321473
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 22:02:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=globallogic.com header.i=@globallogic.com header.b="YVzTxyDs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C7E321473
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=globallogic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbeJRGAQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 02:00:16 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38103 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbeJRGAQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 02:00:16 -0400
Received: by mail-lf1-f67.google.com with SMTP id x24-v6so5274303lfe.5
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2018 15:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=globallogic.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZlPwvpsObli1PXrobtxxhahilr9VlySHedGougIIT0A=;
        b=YVzTxyDs/1AJ8tP7Ts25J3GyxMsMC5+6wK8CeX23b6PjTgsM13U8azmdnzaJK3GKrc
         LmXL6Qumd2/CgztUsNiQOxbWVM/zSnACaweLn8y7YX/z1qk35TXjSXN3P1E3n+n+yLlm
         z1cPQCZZeHRdmwoApm50teJ9nPRDAZRSTahTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZlPwvpsObli1PXrobtxxhahilr9VlySHedGougIIT0A=;
        b=c7LFoMUrAR62uVvs32v7606lB+AVcrMjOLOYpKrb0yp03xMTFt2QoUujqXgjhh9bpI
         jMsQJ9v+a31Jr5OKMM6kKq5C/wJwnpOca5wkKGKe0H5V6N7LorxwF3SaHcvz78u3eA5G
         /KXVCnK0Ol4CaIvfnY3T2MyCV3d/sdPnjzr0DbGtAaLDfuFc20S3fH5Y4sBWFzRBytZa
         F3iW2wDugx88EoDdtcL+Gf+WcpMDenMUOJWRyF9Lhqar/TjiM4DVQVyvTN+sMucXz3ax
         0/T17esTBv2KIJ3q83MLN03MpEjodq7QXHSL02dmDH8J9YmUtvWFEpUtm53KB0ZNrPxz
         hQXg==
X-Gm-Message-State: ABuFfohP2JfE4zOAR8r9CcE+koa8om6PAAbuck7osNfmEGQV1NvDfhxv
        z4+4FJxtI354Nxi2wG2hM9l3Gw==
X-Google-Smtp-Source: ACcGV61FEom3RBXWrDIyxtXV1C/GijTZ8ukF0e40ggB30aa1GYj+944xrlNoexJtrMseoQgL0rPm5A==
X-Received: by 2002:a19:505a:: with SMTP id z26-v6mr8089042lfj.120.1539813754067;
        Wed, 17 Oct 2018 15:02:34 -0700 (PDT)
Received: from localhost.localdomain ([185.145.182.2])
        by smtp.gmail.com with ESMTPSA id p21-v6sm1952218lfj.94.2018.10.17.15.02.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 17 Oct 2018 15:02:32 -0700 (PDT)
From:   Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>
X-Google-Original-From: Vasyl Vavrychuk <vvavrychuk@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>
Subject: [PATCH] mac80211_hwsim: Timer should be initialized before device registered
Date:   Thu, 18 Oct 2018 01:02:12 +0300
Message-Id: <20181017220212.15240-1-vvavrychuk@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>

Otherwise if network manager starts configuring Wi-Fi interface
immidiatelly after getting notification of its creation, we will get
NULL pointer dereference:

  BUG: unable to handle kernel NULL pointer dereference at           (null)
  IP: [<ffffffff95ae94c8>] hrtimer_active+0x28/0x50
  ...
  Call Trace:
   [<ffffffff95ae9997>] ? hrtimer_try_to_cancel+0x27/0x110
   [<ffffffff95ae9a95>] ? hrtimer_cancel+0x15/0x20
   [<ffffffffc0803bf0>] ? mac80211_hwsim_config+0x140/0x1c0 [mac80211_hwsim]

Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1068757ec42e..d0e0a9f5bf98 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2890,6 +2890,10 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
+	tasklet_hrtimer_init(&data->beacon_timer,
+			     mac80211_hwsim_beacon,
+			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
 		pr_debug("mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
@@ -2914,10 +2918,6 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 				    data->debugfs,
 				    data, &hwsim_simulate_radar);
 
-	tasklet_hrtimer_init(&data->beacon_timer,
-			     mac80211_hwsim_beacon,
-			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
-
 	spin_lock_bh(&hwsim_radio_lock);
 	err = rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
 				     hwsim_rht_params);
-- 
2.19.1

