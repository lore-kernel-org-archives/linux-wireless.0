Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB41C10F12
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 15:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E4C20880
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 15:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfDOPpp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 11:45:45 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.124]:34516 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726034AbfDOPpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 11:45:44 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Apr 2019 11:45:44 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id B455C13C29
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2019 09:56:51 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id G32RhZFVJ2qH7G32RhvLYw; Mon, 15 Apr 2019 09:56:51 -0500
X-Authority-Reason: nr=8
Received: from [189.250.55.242] (port=43596 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hG32Q-001eJq-Be; Mon, 15 Apr 2019 09:56:51 -0500
Date:   Mon, 15 Apr 2019 09:56:46 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] wil6210: fix potential out-of-bounds read
Message-ID: <20190415145646.GA16597@embeddedor>
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
X-Source-IP: 189.250.55.242
X-Source-L: No
X-Exim-ID: 1hG32Q-001eJq-Be
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.55.242]:43596
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Notice that *rc* can evaluate to up to 5, include/linux/netdevice.h:

enum gro_result {
        GRO_MERGED,
        GRO_MERGED_FREE,
        GRO_HELD,
        GRO_NORMAL,
        GRO_DROP,
        GRO_CONSUMED,
};
typedef enum gro_result gro_result_t;

In case *rc* evaluates to 5, we end up having an out-of-bounds read
at drivers/net/wireless/ath/wil6210/txrx.c:821:

	wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
		     len, gro_res_str[rc]);

Fix this by adding element "GRO_CONSUMED" to array gro_res_str.

Addresses-Coverity-ID: 1444666 ("Out-of-bounds read")
Fixes: 194b482b5055 ("wil6210: Debug print GRO Rx result")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4ccfd1404458..d74837cce67f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -750,6 +750,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		[GRO_HELD]		= "GRO_HELD",
 		[GRO_NORMAL]		= "GRO_NORMAL",
 		[GRO_DROP]		= "GRO_DROP",
+		[GRO_CONSUMED]		= "GRO_CONSUMED",
 	};
 
 	wil->txrx_ops.get_netif_rx_params(skb, &cid, &security);
-- 
2.21.0

