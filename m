Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFA5C0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 00:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85F032077B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 00:41:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZuZ7hp1E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85F032077B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbeKHKN6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 05:13:58 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46111 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbeKHKN6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 05:13:58 -0500
Received: by mail-pl1-f196.google.com with SMTP id c13-v6so8644101plz.13
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2018 16:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HiC88We3WtpUAK5UV/yHi4vzd4IqfUz6PzgP46+jcjE=;
        b=ZuZ7hp1EkYQNcLT34WLFWbsiCign2BgHoy5e064xMbYbuoekBFt/PVP6DReHUq+L63
         wI/rmwEX7ecROgoCb3kPQ5RNoYj3pV1z7IC7kwffdTkwkbLYNSRU4JS2SlnqL49tCSEf
         81x/CZleQbgKPqsXXq0wglyoyA5MhexZOORu8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HiC88We3WtpUAK5UV/yHi4vzd4IqfUz6PzgP46+jcjE=;
        b=epl0H5IrqrtkUyFSIv1uvVxH7MuXl/WtbUn9bMjBmmBO7HusLmXrAS3VLcMmseFnug
         2IflZR3ogV8y978kuCi3PwGgto1ABO0okUEyut16cueV6UtL7om3AVeeuK/jXueEwyUl
         wbVSRXIA8qHadf32Yg11pwWET1tbNKwB8hb1UZxAXY3o5EkNmkHngu96nnIS5Z4Ds8Oh
         da6dKXjFn9/YORk6mZqDVHVBhRMeNPxVs1WqHAl2nY4MohN2DSi7ANBmRXkMlTxsoJ83
         4KmpX7Q9HsnryUbScGjZL2cpUf500lbEGOOSjF3vVWYB3+lLdKObxedFPyNl/YUnnO9M
         lh0A==
X-Gm-Message-State: AGRZ1gL4xY+HKPEqap3pv1Sr4IPFqbLPWXZVkbVUlskERVRVeoz0UERM
        ks/3OM87ZQuAh+OF2mdGIP0+kg==
X-Google-Smtp-Source: AJdET5fDSeW+md94UsjROkNazMSwESUTRyifgc8hzYp7ckSLaTutptA9SeBZt+h+vXkji/aqr3yuCg==
X-Received: by 2002:a17:902:4025:: with SMTP id b34-v6mr2519684pld.318.1541637665599;
        Wed, 07 Nov 2018 16:41:05 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id x63-v6sm2244685pfk.14.2018.11.07.16.41.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Nov 2018 16:41:04 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>,
        Wen Gong <wgong@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 4.20] ath10k: don't assume 'vif' is non-NULL in flush()
Date:   Wed,  7 Nov 2018 16:40:35 -0800
Message-Id: <20181108004035.136050-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.1.930.g4563a0d9d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

mac80211 may call us with vif == NULL, if the station is not currently
active (e.g., not associated). It is trivially easy to reproduce a crash
by suspending the system when not connected to an AP:

[   65.533934] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
...
[   65.574521] pc : ath10k_flush+0x30/0xd0 [ath10k_core]
[   65.574538] lr : __ieee80211_flush_queues+0x180/0x244 [mac80211]
[   65.599680] Process kworker/u12:1 (pid: 57, stack limit = 0x(____ptrval____))
[   65.599682] Call trace:
[   65.599695]  ath10k_flush+0x30/0xd0 [ath10k_core]
[   65.642064]  __ieee80211_flush_queues+0x180/0x244 [mac80211]
[   65.642079]  ieee80211_flush_queues+0x34/0x40 [mac80211]
[   65.642095]  __ieee80211_suspend+0xfc/0x47c [mac80211]
[   65.658611]  ieee80211_suspend+0x30/0x3c [mac80211]
[   65.658627]  wiphy_suspend+0x15c/0x3a8 [cfg80211]
[   65.672810]  dpm_run_callback+0xf0/0x1f0
[   65.672814]  __device_suspend+0x3ac/0x4f8
[   65.672819]  async_suspend+0x34/0xbc
[   65.684096]  async_run_entry_fn+0x54/0x104
[   65.684099]  worker_thread+0x4cc/0x72c
[   65.684102]  kthread+0x134/0x13c
[   65.684105]  ret_from_fork+0x10/0x18

Fixes: 9de4162f0999 ("ath10k: add peer flush in ath10k_flush for STATION")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a1c2801ded10..7e49342bae38 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6867,7 +6867,7 @@ static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	u32 bitmap;
 
 	if (drop) {
-		if (vif->type == NL80211_IFTYPE_STATION) {
+		if (vif && vif->type == NL80211_IFTYPE_STATION) {
 			bitmap = ~(1 << WMI_MGMT_TID);
 			list_for_each_entry(arvif, &ar->arvifs, list) {
 				if (arvif->vdev_type == WMI_VDEV_TYPE_STA)
-- 
2.19.1.930.g4563a0d9d0-goog

