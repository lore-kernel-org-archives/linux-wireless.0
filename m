Return-Path: <SRS0=l33s=O6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B33AC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 22:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52EF221928
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 22:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392140AbeLUWMG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Dec 2018 17:12:06 -0500
Received: from gateway24.websitewelcome.com ([192.185.51.31]:34926 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730887AbeLUWMF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Dec 2018 17:12:05 -0500
X-Greylist: delayed 1451 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2018 17:12:05 EST
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 912B9292953
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2018 15:47:54 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id aSeAgha3eiQeraSeAgmfTK; Fri, 21 Dec 2018 15:47:54 -0600
X-Authority-Reason: nr=8
Received: from [189.250.106.44] (port=35234 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gaSe9-000fir-Vy; Fri, 21 Dec 2018 15:47:54 -0600
Date:   Fri, 21 Dec 2018 15:47:53 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] nfc: af_nfc: Fix Spectre v1 vulnerability
Message-ID: <20181221214753.GA2799@embeddedor>
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
X-Source-IP: 189.250.106.44
X-Source-L: No
X-Exim-ID: 1gaSe9-000fir-Vy
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.106.44]:35234
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 13
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

proto is indirectly controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability.

This issue was detected with the help of Smatch:

net/nfc/af_nfc.c:42 nfc_sock_create() warn: potential spectre issue 'proto_tab' [w] (local cap)

Fix this by sanitizing proto before using it to index proto_tab.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/nfc/af_nfc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/af_nfc.c b/net/nfc/af_nfc.c
index d3e594eb36d0..256f3c57059e 100644
--- a/net/nfc/af_nfc.c
+++ b/net/nfc/af_nfc.c
@@ -21,6 +21,7 @@
 
 #include <linux/nfc.h>
 #include <linux/module.h>
+#include <linux/nospec.h>
 
 #include "nfc.h"
 
@@ -37,6 +38,7 @@ static int nfc_sock_create(struct net *net, struct socket *sock, int proto,
 
 	if (proto < 0 || proto >= NFC_SOCKPROTO_MAX)
 		return -EINVAL;
+	proto = array_index_nospec(proto, NFC_SOCKPROTO_MAX);
 
 	read_lock(&proto_tab_lock);
 	if (proto_tab[proto] &&	try_module_get(proto_tab[proto]->owner)) {
-- 
2.20.1

