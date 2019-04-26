Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8523C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A490205ED
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfDZPt7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:49:59 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:21641 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726601AbfDZPt7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:49:59 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2019 11:49:53 EDT
X-IronPort-AV: E=Sophos;i="5.60,398,1549926000"; 
   d="scan'208";a="2367524"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 26 Apr 2019 17:43:45 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="7889773"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 26 Apr 2019 17:43:45 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 9/9] wil6210: remove HALP for Talyn devices
Date:   Fri, 26 Apr 2019 18:43:37 +0300
Message-Id: <1556293417-27097-10-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
References: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In Talyn the HW is responsible for power management enter / exit
flow, hence the deep sleep exit latency is significantly shorter than
in Sparrow.
In such a case HALP feature, that is meant to prevent long PCIe blocking
accesses, is no longer needed and can be removed for Talyn.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index efdb6e1..3c30076 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1940,6 +1940,9 @@ void wil_halp_vote(struct wil6210_priv *wil)
 	unsigned long rc;
 	unsigned long to_jiffies = msecs_to_jiffies(WAIT_FOR_HALP_VOTE_MS);
 
+	if (wil->hw_version >= HW_VER_TALYN_MB)
+		return;
+
 	mutex_lock(&wil->halp.lock);
 
 	wil_dbg_irq(wil, "halp_vote: start, HALP ref_cnt (%d)\n",
@@ -1971,6 +1974,9 @@ void wil_halp_vote(struct wil6210_priv *wil)
 
 void wil_halp_unvote(struct wil6210_priv *wil)
 {
+	if (wil->hw_version >= HW_VER_TALYN_MB)
+		return;
+
 	WARN_ON(wil->halp.ref_cnt == 0);
 
 	mutex_lock(&wil->halp.lock);
-- 
1.9.1

