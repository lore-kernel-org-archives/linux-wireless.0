Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25F9C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AF472075C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714895;
	bh=kgyC4AFq3DDzsDi/XjOf0++6sqCrex772RFyGxRgOwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BPjDxEKYaexSAxd1Z4JKcslknOpIEnfAPCT29iwzT1hdbY2FDMbfX212ruQZzBxz3
	 jkpZ5LP+R2jEo+mCGriylyBLlpsLPoH1KzpbrsSQuqWRxfADr5va4LDBwEoB7ZlpCN
	 g6kh6wepkOJZqKSn7bqC2OlD4FyIvKI1Sc+3aRTM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbfC0T2J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731242AbfC0SE1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:04:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58B6F2183F;
        Wed, 27 Mar 2019 18:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709866;
        bh=kgyC4AFq3DDzsDi/XjOf0++6sqCrex772RFyGxRgOwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vmZh5RvmUa/9B0qMfKiGNrIHDjlTIKD2F7lMAHXCAH2Tw6+8SAYTmA++me2KHrnb
         3kk/dANDvXGTDPNtpvSqGNPr6EEkn8RAH+MzZRBNVdRa5imfFrOcAmUBSU2oic79EI
         0hkyZ8mso6ArZLZpxSIBTnKvbyfMZ3ZNHQyX4G0E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Wen Gong <wgong@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 079/262] ath10k: don't report unset rssi values to mac80211
Date:   Wed, 27 Mar 2019 13:58:54 -0400
Message-Id: <20190327180158.10245-79-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

[ Upstream commit 7d444522303177f3a3c09b9abb104ddeea470a70 ]

The SDIO firmware does not provide RSSI value to the host, it's only set to
zero. In that case don't report the value to mac80211. One risk here is that
value zero might be a valid value with other firmware, currently there's no way
to detect that.

Without the fix, the rssi value indicated by iw changes between the actual
value and -95.

Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00005-QCARMSWP-1.

Co-developed-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f42bac204ef8..ecf34ce7acf0 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2130,9 +2130,15 @@ static bool ath10k_htt_rx_proc_rx_ind_hl(struct ath10k_htt *htt,
 	hdr = (struct ieee80211_hdr *)skb->data;
 	rx_status = IEEE80211_SKB_RXCB(skb);
 	rx_status->chains |= BIT(0);
-	rx_status->signal = ATH10K_DEFAULT_NOISE_FLOOR +
-			    rx->ppdu.combined_rssi;
-	rx_status->flag &= ~RX_FLAG_NO_SIGNAL_VAL;
+	if (rx->ppdu.combined_rssi == 0) {
+		/* SDIO firmware does not provide signal */
+		rx_status->signal = 0;
+		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
+	} else {
+		rx_status->signal = ATH10K_DEFAULT_NOISE_FLOOR +
+			rx->ppdu.combined_rssi;
+		rx_status->flag &= ~RX_FLAG_NO_SIGNAL_VAL;
+	}
 
 	spin_lock_bh(&ar->data_lock);
 	ch = ar->scan_channel;
-- 
2.19.1

