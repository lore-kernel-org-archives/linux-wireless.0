Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354CAC004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52A8C20652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:10:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52A8C20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbeJWFa5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 01:30:57 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.124]:20649 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728456AbeJWFa4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 01:30:56 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id ED0DC1A978
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 15:40:37 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id EgzzgqbuTaSeyEh05gA7hm; Mon, 22 Oct 2018 15:40:37 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:50986 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEgzy-0022Kk-Md; Mon, 22 Oct 2018 15:40:27 -0500
Date:   Mon, 22 Oct 2018 22:40:24 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Christian Lamparter <chunkeey@googlemail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 06/20] carl9170: tx: mark expected switch fall-throughs
Message-ID: <6417dc90fb7673ed10f1ceeebc6d7a2346ea7afd.1540239684.git.gustavo@embeddedor.com>
References: <cover.1540239684.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1540239684.git.gustavo@embeddedor.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 86.245.173.13
X-Source-L: No
X-Exim-ID: 1gEgzy-0022Kk-Md
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr (embeddedor) [86.245.173.13]:50986
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 49
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/carl9170/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 8c75651..2407931 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -830,10 +830,12 @@ static bool carl9170_tx_rts_check(struct ar9170 *ar,
 	case CARL9170_ERP_AUTO:
 		if (ampdu)
 			break;
+		/* fall through */
 
 	case CARL9170_ERP_MAC80211:
 		if (!(rate->flags & IEEE80211_TX_RC_USE_RTS_CTS))
 			break;
+		/* fall through */
 
 	case CARL9170_ERP_RTS:
 		if (likely(!multi))
@@ -854,6 +856,7 @@ static bool carl9170_tx_cts_check(struct ar9170 *ar,
 	case CARL9170_ERP_MAC80211:
 		if (!(rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
 			break;
+		/* fall through */
 
 	case CARL9170_ERP_CTS:
 		return true;
-- 
2.7.4

