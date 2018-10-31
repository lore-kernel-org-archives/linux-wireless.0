Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A14ECDE46
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F230720838
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F230720838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbeJaR4D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:56:03 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23737 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727760AbeJaR4B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:56:01 -0400
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418136"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:37 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147936"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:36 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH 16/16] wil6210: fix locking in wmi_call
Date:   Wed, 31 Oct 2018 10:52:24 +0200
Message-Id: <1540975944-30576-17-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lior David <liord@codeaurora.org>

Switch from spin_lock to spin_lock_irqsave, because
wmi_ev_lock is used inside interrupt handler.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index f46c703..345f059 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1966,16 +1966,17 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, u8 mid, void *buf, u16 len,
 {
 	int rc;
 	unsigned long remain;
+	ulong flags;
 
 	mutex_lock(&wil->wmi_mutex);
 
-	spin_lock(&wil->wmi_ev_lock);
+	spin_lock_irqsave(&wil->wmi_ev_lock, flags);
 	wil->reply_id = reply_id;
 	wil->reply_mid = mid;
 	wil->reply_buf = reply;
 	wil->reply_size = reply_size;
 	reinit_completion(&wil->wmi_call);
-	spin_unlock(&wil->wmi_ev_lock);
+	spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
 
 	rc = __wmi_send(wil, cmdid, mid, buf, len);
 	if (rc)
@@ -1995,12 +1996,12 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, u8 mid, void *buf, u16 len,
 	}
 
 out:
-	spin_lock(&wil->wmi_ev_lock);
+	spin_lock_irqsave(&wil->wmi_ev_lock, flags);
 	wil->reply_id = 0;
 	wil->reply_mid = U8_MAX;
 	wil->reply_buf = NULL;
 	wil->reply_size = 0;
-	spin_unlock(&wil->wmi_ev_lock);
+	spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
 
 	mutex_unlock(&wil->wmi_mutex);
 
-- 
1.9.1

