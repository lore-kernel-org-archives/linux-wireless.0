Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF494ECDE4C
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A3520685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0A3520685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbeJaR4A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:56:00 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23734 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727735AbeJaR4A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:56:00 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2018 13:55:51 EDT
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418131"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:34 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147931"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:33 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 11/16] wil6210: fix L2 RX status handling
Date:   Wed, 31 Oct 2018 10:52:19 +0200
Message-Id: <1540975944-30576-12-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

L2 RX status errors should not be treated as a bitmap and the actual
error values should be checked.
Print L2 errors as wil_err_ratelimited for easier debugging
when such errors occurs.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index fe758f2..c8490e7 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -839,23 +839,24 @@ static int wil_rx_error_check_edma(struct wil6210_priv *wil,
 		wil_dbg_txrx(wil, "L2 RX error, l2_rx_status=0x%x\n",
 			     l2_rx_status);
 		/* Due to HW issue, KEY error will trigger a MIC error */
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_MIC) {
-			wil_dbg_txrx(wil,
-				     "L2 MIC/KEY error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_MIC) {
+			wil_err_ratelimited(wil,
+					    "L2 MIC/KEY error, dropping packet\n");
 			stats->rx_mic_error++;
 		}
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_KEY) {
-			wil_dbg_txrx(wil, "L2 KEY error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_KEY) {
+			wil_err_ratelimited(wil,
+					    "L2 KEY error, dropping packet\n");
 			stats->rx_key_error++;
 		}
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_REPLAY) {
-			wil_dbg_txrx(wil,
-				     "L2 REPLAY error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_REPLAY) {
+			wil_err_ratelimited(wil,
+					    "L2 REPLAY error, dropping packet\n");
 			stats->rx_replay++;
 		}
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_AMSDU) {
-			wil_dbg_txrx(wil,
-				     "L2 AMSDU error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_AMSDU) {
+			wil_err_ratelimited(wil,
+					    "L2 AMSDU error, dropping packet\n");
 			stats->rx_amsdu_error++;
 		}
 		return -EFAULT;
-- 
1.9.1

