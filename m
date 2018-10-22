Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2451AC7112C
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4978320672
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:04:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4978320672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbeJWFYr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 01:24:47 -0400
Received: from gateway20.websitewelcome.com ([192.185.54.2]:32078 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbeJWFYq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 01:24:46 -0400
X-Greylist: delayed 1344 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2018 01:24:46 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id B9F66400D97FB
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 15:42:17 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Eh1bgqf2caSeyEh1ggAApZ; Mon, 22 Oct 2018 15:42:17 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:51004 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEh1a-0023Jx-Ct; Mon, 22 Oct 2018 15:42:06 -0500
Date:   Mon, 22 Oct 2018 22:42:04 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 09/20] orinoco_usb: mark expected switch fall-through
Message-ID: <5b3d73031e6528651c709f96ca22c818368327cd.1540239684.git.gustavo@embeddedor.com>
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
X-Exim-ID: 1gEh1a-0023Jx-Ct
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr (embeddedor) [86.245.173.13]:51004
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 66
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
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 21bb684..40a8b941 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -908,6 +908,7 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
 	case EZUSB_CTX_REQ_SUBMITTED:
 		if (!ctx->in_rid)
 			break;
+		/* fall through */
 	default:
 		err("%s: Unexpected context state %d", __func__,
 		    state);
-- 
2.7.4

