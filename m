Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66533C004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96B6420663
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:49:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96B6420663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbeJWFIm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 01:08:42 -0400
Received: from gateway24.websitewelcome.com ([192.185.51.35]:21185 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728266AbeJWFIm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 01:08:42 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id E04CB3F4D9
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 15:48:35 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Eh7kgYuW2BcCXEh7ogo0dY; Mon, 22 Oct 2018 15:48:35 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:51096 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEh7j-00275l-Hw; Mon, 22 Oct 2018 15:48:27 -0500
Date:   Mon, 22 Oct 2018 22:48:26 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 20/20] zd1201: mark expected switch fall-through
Message-ID: <0c2570ee8d3d4bcb4d45fc1b28f986846bd3d069.1540239684.git.gustavo@embeddedor.com>
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
X-Exim-ID: 1gEh7j-00275l-Hw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr (embeddedor) [86.245.173.13]:51096
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 138
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
 drivers/net/wireless/zydas/zd1201.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/zydas/zd1201.c
index 2534038..22c70f1 100644
--- a/drivers/net/wireless/zydas/zd1201.c
+++ b/drivers/net/wireless/zydas/zd1201.c
@@ -969,6 +969,7 @@ static int zd1201_set_mode(struct net_device *dev,
 			 */
 			zd1201_join(zd, "\0-*#\0", 5);
 			/* Put port in pIBSS */
+			/* Fall through */
 		case 8: /* No pseudo-IBSS in wireless extensions (yet) */
 			porttype = ZD1201_PORTTYPE_PSEUDOIBSS;
 			break;
-- 
2.7.4

