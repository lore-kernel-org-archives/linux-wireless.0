Return-Path: <SRS0=6X60=5E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D30EC4332B
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Mar 2020 23:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E568C20740
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Mar 2020 23:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="rVAHQaU8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgCSXy2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Mar 2020 19:54:28 -0400
Received: from gateway36.websitewelcome.com ([50.116.126.2]:29532 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726663AbgCSXy2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Mar 2020 19:54:28 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2020 19:54:27 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 9B33842421D26
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2020 17:21:31 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id F4EBjlMjMAGTXF4EBjBIZ8; Thu, 19 Mar 2020 18:05:27 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PkyvVLMHBHqMPWT31a0jBtqErXjcZ8hF5wABACYJtDM=; b=rVAHQaU8O0rqha3dDwUExIF5P+
        YHNt1ee8au7BJy8b/vQPARN3rqyTeHU/oJv9suW4Kd9VrqPgR/vb3ELT3qKguvPPQpQdyuFxlSfEs
        AzZ1jjkhl4OEaQ+mGawBLkbrDpDtyrFPfVmnxCodEF26ZbMzlrc2UlXnEKpicFvprcu3ifTvQhX3H
        osGVUxH5poFvNBUx9b3kVmG60ibKmiEfddJK7gF8VJ3UIX9ruHaPAnoQ/uVKW/EkZkh/yAu0m4cgw
        UntGMEAGmWruA2qlv5IC0Kf/gyFJoxQqGf4hLW/hZcexxdPKysKbLQqhtVEJNEHcZ8ZmVjtEY2B4t
        eH88wXRA==;
Received: from cablelink-189-218-116-241.hosts.intercable.net ([189.218.116.241]:54028 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jF4EA-002OZf-7O; Thu, 19 Mar 2020 18:05:26 -0500
Date:   Thu, 19 Mar 2020 18:05:25 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: wireless: rayctl.h: Replace zero-length array
 with flexible-array member
Message-ID: <20200319230525.GA14835@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.218.116.241
X-Source-L: No
X-Exim-ID: 1jF4EA-002OZf-7O
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: cablelink-189-218-116-241.hosts.intercable.net (embeddedor) [189.218.116.241]:54028
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/rayctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rayctl.h b/drivers/net/wireless/rayctl.h
index 668444f6bf07..e89e58a5850d 100644
--- a/drivers/net/wireless/rayctl.h
+++ b/drivers/net/wireless/rayctl.h
@@ -570,7 +570,7 @@ struct phy_header {
 };
 struct ray_rx_msg {
     struct mac_header mac;
-    UCHAR  var[0];
+	UCHAR	var[];
 };
 
 struct tx_msg {
-- 
2.23.0

