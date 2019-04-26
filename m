Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4617C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A8C9208CB
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfDZPuB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:50:01 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:21644 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbfDZPt7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:49:59 -0400
X-IronPort-AV: E=Sophos;i="5.60,398,1549926000"; 
   d="scan'208";a="2367517"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 26 Apr 2019 17:43:41 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="7889765"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 26 Apr 2019 17:43:41 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 2/9] wil6210: fix _desc access in __wil_tx_vring_tso
Date:   Fri, 26 Apr 2019 18:43:30 +0300
Message-Id: <1556293417-27097-3-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
References: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

_desc is defined in __wil_tx_vring_tso() and may not be set in
case len is 0, verify _desc is set.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4ccfd14..a8f315b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1760,6 +1760,9 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct wil6210_vif *vif,
 		}
 	}
 
+	if (!_desc)
+		goto mem_error;
+
 	/* first descriptor may also be the last.
 	 * in this case d pointer is invalid
 	 */
-- 
1.9.1

