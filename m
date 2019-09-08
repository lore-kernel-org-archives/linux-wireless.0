Return-Path: <SRS0=wUyo=XD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB79C4332F
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Sep 2019 08:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9069B20863
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Sep 2019 08:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfIHIjT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 8 Sep 2019 04:39:19 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:7970 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727407AbfIHIjR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Sep 2019 04:39:17 -0400
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 08 Sep 2019 10:33:04 +0200
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 08 Sep 2019 10:33:02 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 06/11] wil6210: verify cid value is valid
Date:   Sun,  8 Sep 2019 11:32:50 +0300
Message-Id: <1567931575-27984-7-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1567931575-27984-1-git-send-email-merez@codeaurora.org>
References: <1567931575-27984-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

cid value is not being verified in wmi_evt_delba(),
verification is added.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 73fe9bf..88d9e5a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1332,6 +1332,12 @@ static void wmi_evt_delba(struct wil6210_vif *vif, int id, void *d, int len)
 		cid = evt->cid;
 		tid = evt->tid;
 	}
+
+	if (!wil_cid_valid(wil, cid)) {
+		wil_err(wil, "DELBA: Invalid CID %d\n", cid);
+		return;
+	}
+
 	wil_dbg_wmi(wil, "DELBA MID %d CID %d TID %d from %s reason %d\n",
 		    vif->mid, cid, tid,
 		    evt->from_initiator ? "originator" : "recipient",
-- 
1.9.1

