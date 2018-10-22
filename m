Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B439C004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61D6620663
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:42:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61D6620663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbeJWFCq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 01:02:46 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.89]:11863 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728944AbeJWFCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 01:02:46 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 1791E40114414
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 15:42:42 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Eh20gYjaUBcCXEh25gnpkH; Mon, 22 Oct 2018 15:42:41 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:51008 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEh1z-0023aZ-Sl; Mon, 22 Oct 2018 15:42:32 -0500
Date:   Mon, 22 Oct 2018 22:42:29 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 10/20] prism54: isl_38xx: Mark expected switch fall-through
Message-ID: <d40a482ceb15f96f99f45ca3fd10bea5a6bf2e60.1540239684.git.gustavo@embeddedor.com>
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
X-Exim-ID: 1gEh1z-0023aZ-Sl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr (embeddedor) [86.245.173.13]:51008
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 72
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114944 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/intersil/prism54/isl_38xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intersil/prism54/isl_38xx.c b/drivers/net/wireless/intersil/prism54/isl_38xx.c
index ce9d4db..b0eb58a 100644
--- a/drivers/net/wireless/intersil/prism54/isl_38xx.c
+++ b/drivers/net/wireless/intersil/prism54/isl_38xx.c
@@ -235,6 +235,7 @@ isl38xx_in_queue(isl38xx_control_block *cb, int queue)
 		/* send queues */
 	case ISL38XX_CB_TX_MGMTQ:
 		BUG_ON(delta > ISL38XX_CB_MGMT_QSIZE);
+		/* fall through */
 
 	case ISL38XX_CB_TX_DATA_LQ:
 	case ISL38XX_CB_TX_DATA_HQ:
-- 
2.7.4

