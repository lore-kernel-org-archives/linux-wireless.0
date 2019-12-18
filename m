Return-Path: <SRS0=gBLi=2I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE317C2D0CD
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 14:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83E772176D
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 14:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLROGD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Dec 2019 09:06:03 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:54572 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727110AbfLROGC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Dec 2019 09:06:02 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2019 09:06:00 EST
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 18 Dec 2019 14:59:55 +0100
Received: from lx-merez2.mea.qualcomm.com ([10.18.173.102])
  by ironmsg03-ams.qualcomm.com with ESMTP; 18 Dec 2019 14:59:50 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 1/8] wil6210: dump Rx status message on errors
Date:   Wed, 18 Dec 2019 15:59:40 +0200
Message-Id: <20191218135947.5903-2-merez@codeaurora.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218135947.5903-1-merez@codeaurora.org>
References: <20191218135947.5903-1-merez@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Dump all the Rx status message on different errors to allow more
visibility of the case.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 02548d40253c..6a1671c3a2be 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -903,6 +903,11 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	if (unlikely(!wil_val_in_range(buff_id, 1, wil->rx_buff_mgmt.size))) {
 		wil_err(wil, "Corrupt buff_id=%d, sring->swhead=%d\n",
 			buff_id, sring->swhead);
+		print_hex_dump(KERN_ERR, "RxS ", DUMP_PREFIX_OFFSET, 16, 1,
+			       (void *)msg, wil->use_compressed_rx_status ?
+			       sizeof(struct wil_rx_status_compressed) :
+			       sizeof(struct wil_rx_status_extended), false);
+
 		wil_rx_status_reset_buff_id(sring);
 		wil_sring_advance_swhead(sring);
 		sring->invalid_buff_id_cnt++;
@@ -963,6 +968,11 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 
 	if (unlikely(dmalen > sz)) {
 		wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
+		print_hex_dump(KERN_ERR, "RxS ", DUMP_PREFIX_OFFSET, 16, 1,
+			       (void *)msg, wil->use_compressed_rx_status ?
+			       sizeof(struct wil_rx_status_compressed) :
+			       sizeof(struct wil_rx_status_extended), false);
+
 		stats->rx_large_frame++;
 		rxdata->skipping = true;
 	}
-- 
2.23.0

