Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9876BC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 19:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67AFE20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 19:03:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67AFE20875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbeJFCD7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 22:03:59 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.182]:17946 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728446AbeJFCD7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 22:03:59 -0400
X-Greylist: delayed 1271 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2018 22:03:59 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id A2417837616
        for <linux-wireless@vger.kernel.org>; Fri,  5 Oct 2018 13:42:48 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8V3ogdhsJkBj68V3ogkNFC; Fri, 05 Oct 2018 13:42:48 -0500
X-Authority-Reason: nr=8
Received: from 174.206.93.92.rev.sfr.net ([92.93.206.174]:41754 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1g8V3n-004OSx-FH; Fri, 05 Oct 2018 13:42:47 -0500
Date:   Fri, 5 Oct 2018 20:42:45 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ath10k: htt_rx: Fix signedness bug in
 ath10k_update_per_peer_tx_stats
Message-ID: <20181005184245.GA11700@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 92.93.206.174
X-Source-L: No
X-Exim-ID: 1g8V3n-004OSx-FH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 174.206.93.92.rev.sfr.net (embeddedor) [92.93.206.174]:41754
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently, the error handling for the call to function
ath10k_get_legacy_rate_idx() doesn't work because
*rate_idx* is of type u8 (8 bits, unsigned), which
makes it impossible for it to hold a value less
than 0.

Fix this by changing the type of variable *rate_idx*
to s8 (8 bits, signed).

Addresses-Coverity-ID: 1473914 ("Unsigned compared against 0")
Fixes: 0189dbd71cbd ("ath10k: get the legacy rate index to update the txrate table")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f240525..edd0e74 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2753,7 +2753,8 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 				struct ath10k_per_peer_tx_stats *peer_stats)
 {
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
-	u8 rate = 0, rate_idx = 0, sgi;
+	u8 rate = 0, sgi;
+	s8 rate_idx = 0;
 	struct rate_info txrate;
 
 	lockdep_assert_held(&ar->data_lock);
-- 
2.7.4

