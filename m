Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE1DC282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 19:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98A20222D0
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 19:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389113AbfBMTSw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 14:18:52 -0500
Received: from gateway36.websitewelcome.com ([192.185.194.2]:47773 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726234AbfBMTSw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 14:18:52 -0500
X-Greylist: delayed 1268 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2019 14:18:51 EST
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 127DA400DFC28
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2019 12:11:55 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id tzj4gwz8aYTGMtzj5gGX7v; Wed, 13 Feb 2019 12:57:43 -0600
X-Authority-Reason: nr=8
Received: from [189.250.119.20] (port=45012 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gtzj4-003hbN-9G; Wed, 13 Feb 2019 12:57:42 -0600
Date:   Wed, 13 Feb 2019 12:57:41 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Samuel Ortiz <sameo@linux.intel.com>,
        Kees Cook <keescook@chromium.org>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] NFC: pn533: mark expected switch fall-throughs
Message-ID: <20190213185741.GA5047@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.119.20
X-Source-L: No
X-Exim-ID: 1gtzj4-003hbN-9G
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.119.20]:45012
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 32
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch
cases where we are expecting to fall through.

This patch fixes the following warnings:

drivers/nfc/pn533/pn533.c: In function ‘pn533_transceive’:
drivers/nfc/pn533/pn533.c:2142:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (dev->tgt_active_prot == NFC_PROTO_FELICA) {
      ^
drivers/nfc/pn533/pn533.c:2150:2: note: here
  default:
  ^~~~~~~
drivers/nfc/pn533/pn533.c: In function ‘pn533_wq_mi_recv’:
drivers/nfc/pn533/pn533.c:2267:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (dev->tgt_active_prot == NFC_PROTO_FELICA) {
      ^
drivers/nfc/pn533/pn533.c:2276:2: note: here
  default:
  ^~~~~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Addresses-Coverity-ID: 1230487 ("Missing break in switch")
Addresses-Coverity-ID: 1230488 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/nfc/pn533/pn533.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index a0cc1cc45292..5961f14259e5 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2147,6 +2147,7 @@ static int pn533_transceive(struct nfc_dev *nfc_dev,
 
 			break;
 		}
+		/* fall through */
 	default:
 		/* jumbo frame ? */
 		if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
@@ -2273,6 +2274,7 @@ static void pn533_wq_mi_recv(struct work_struct *work)
 
 			break;
 		}
+		/* fall through */
 	default:
 		skb_put_u8(skb, 1); /*TG*/
 
-- 
2.20.1

