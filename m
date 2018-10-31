Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3FFC0044C
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56D1B20685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56D1B20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbeJaRzy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:55:54 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23736 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727519AbeJaRzy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:55:54 -0400
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418126"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:31 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147926"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:30 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH 06/16] wil6210: fix memory leak in wil_find_tx_bcast_2
Date:   Wed, 31 Oct 2018 10:52:14 +0200
Message-Id: <1540975944-30576-7-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lior David <liord@codeaurora.org>

A successful call to wil_tx_ring takes skb reference so
it will only be freed in wil_tx_complete. Consume the skb
in wil_find_tx_bcast_2 to prevent memory leak.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index c592c8e..3e1c831 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1395,6 +1395,8 @@ static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 			wil_dbg_txrx(wil, "BCAST DUP -> ring %d\n", i);
 			wil_set_da_for_vring(wil, skb2, i);
 			wil_tx_ring(wil, vif, v2, skb2);
+			/* successful call to wil_tx_ring takes skb2 ref */
+			dev_kfree_skb_any(skb2);
 		} else {
 			wil_err(wil, "skb_copy failed\n");
 		}
-- 
1.9.1

