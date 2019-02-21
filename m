Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEF0C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F357520836
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XljIhkc+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MPixtv6e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfBUQWN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:22:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59302 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfBUQWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 11:22:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 31D7360F5C; Thu, 21 Feb 2019 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766132;
        bh=+GwZXD4xWjUcnuWSVQ8CBcuz6yezp42EyM9DZzoPnvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XljIhkc+0apbBVRE6btTvT33O9ooURdN7Ye677T3V+m7zPvjBAC25ao3jjP0XjuGd
         SQRl1LgLk+DfHaPsnveWe3SMtmG9Oef4kJ7NRNVHolsjww18vp5dG9xrTk2FWUImbu
         CHFfrntPLnjV6xneuRdu0iN8Dw0NusXY771J2U3M=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1167260F40;
        Thu, 21 Feb 2019 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766129;
        bh=+GwZXD4xWjUcnuWSVQ8CBcuz6yezp42EyM9DZzoPnvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPixtv6eGoZffmefN73kbozXby6PABiUcU4GEJZYmLf2WbCMN0dSiZOwl0h9cAqlc
         CUQ7qYHZWPhQt+J0D5MX2fMYy1EmIE37Ptmv0oTnIYvNa9kIgdEbE+7icCCjl/NZxQ
         bJga742SVLmEjMsliRa+xjYBUD2Aoyb6ofPjCqWI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1167260F40
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>,
        Wen Gong <wgong@codeaurora.org>
Subject: [PATCH 4/4] ath10k: don't report unset rssi values to mac80211
Date:   Thu, 21 Feb 2019 18:21:58 +0200
Message-Id: <1550766118-31703-5-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550766118-31703-1-git-send-email-kvalo@codeaurora.org>
References: <1550766118-31703-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

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
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 4fc885617de1..62479b037210 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2119,9 +2119,15 @@ static bool ath10k_htt_rx_proc_rx_ind_hl(struct ath10k_htt *htt,
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
2.7.4

