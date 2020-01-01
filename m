Return-Path: <SRS0=adVY=2W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0489FC2D0DC
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Jan 2020 17:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D37182073D
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Jan 2020 17:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgAARst (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 Jan 2020 12:48:49 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:58254 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgAARss (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Jan 2020 12:48:48 -0500
Received: from legolas.fritz.box (unknown [87.147.48.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id BC6F6580068;
        Wed,  1 Jan 2020 18:48:46 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH] iw: info: print missing extended feature flag information
Date:   Wed,  1 Jan 2020 18:48:36 +0100
Message-Id: <20200101174836.5513-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some extended feature flags were not considered before.

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 info.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/info.c b/info.c
index 38362d8..0f24dae 100644
--- a/info.c
+++ b/info.c
@@ -676,7 +676,17 @@ broken_combination:
 		ext_feat_print(tb, DFS_OFFLOAD, "DFS offload");
 		ext_feat_print(tb, CONTROL_PORT_OVER_NL80211,
 			       "control port over nl80211");
+		ext_feat_print(tb, ACK_SIGNAL_SUPPORT,
+			       "ack signal level support");
 		ext_feat_print(tb, TXQS, "FQ-CoDel-enabled intermediate TXQs");
+		ext_feat_print(tb, SCAN_RANDOM_SN,
+			       "use random sequence numbers in scans");
+		ext_feat_print(tb, SCAN_MIN_PREQ_CONTENT,
+			       "use probe request with only rate IEs in scans");
+		ext_feat_print(tb, CAN_REPLACE_PTK0,
+			       "can safely replace PTK 0 when rekeying");
+		ext_feat_print(tb, ENABLE_FTM_RESPONDER,
+			       "enable FTM (Fine Time Measurement) responder");
 		ext_feat_print(tb, AIRTIME_FAIRNESS,
 			       "airtime fairness scheduling");
 		ext_feat_print(tb, AP_PMKSA_CACHING,
-- 
2.24.1

