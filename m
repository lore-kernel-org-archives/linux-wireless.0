Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96260C004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83FB020652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:01:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83FB020652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbeJWFVz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 01:21:55 -0400
Received: from gateway36.websitewelcome.com ([192.185.184.18]:45073 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbeJWFVy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 01:21:54 -0400
X-Greylist: delayed 1441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2018 01:21:54 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 3737E400EB265
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 14:45:12 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id EgxIgYZMXBcCXEgxOgnfZX; Mon, 22 Oct 2018 15:37:49 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:50954 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEgxH-0020rP-M2; Mon, 22 Oct 2018 15:37:39 -0500
Date:   Mon, 22 Oct 2018 22:37:38 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 02/20] ath9k: ar5008_phy: mark expected switch fall-through
Message-ID: <1727f5c9f0bb87651831d267e35af5aa1ed1f98b.1540239684.git.gustavo@embeddedor.com>
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
X-Exim-ID: 1gEgxH-0020rP-M2
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr (embeddedor) [86.245.173.13]:50954
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 25
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1056532 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 11d6f975..dae9540 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -586,7 +586,7 @@ static void ar5008_hw_init_chain_masks(struct ath_hw *ah)
 			REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, 0x7);
 			break;
 		}
-		/* else: fall through */
+		/* fall through */
 	case 0x1:
 	case 0x2:
 	case 0x7:
-- 
2.7.4

