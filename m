Return-Path: <SRS0=E8CW=XQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33F0C49ED7
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Sep 2019 06:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3C4C208C0
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Sep 2019 06:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r69DMaVg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbfIUGB6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 21 Sep 2019 02:01:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38206 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfIUGB6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Sep 2019 02:01:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L5xXW1070980;
        Sat, 21 Sep 2019 06:01:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=KrLWCrL39L3KzKDyRZJFxW428Ske5D6YnhVp0I3al+c=;
 b=r69DMaVgor6ohn/WxIkkem1lzr+TQSqvQbTVSWg+uWQdtQUZ0ehRj45CmG17P8Uvaztr
 /A7rxpRJxTvIuRKmaxzmLKBRmV8DzNvwnyvdkhuS5/SWjv15r0DRX9ib6Zp2NvG/129q
 6bHPUg1gIBdOL+I0rtRgSq14Vj9FDmybgx0O/cNuRf5UHncTVvSqVP/yJgXgtAXU4qY1
 cFD6iI3LhJ66m4LVqRG8fluk67d1+Ac/e4f0V4rG9XxFRdtQ6nNOIITdd1dIVnnEFfqH
 GHmDET7GSiIB8d7kF1dNoeRWo3gOi8OX4mxOY9mr0xyZvhGljgE0rXcc6iMYJE64j0Yk ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btpg6qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 06:01:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L5vuBV179428;
        Sat, 21 Sep 2019 06:01:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v5bpbycqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 06:01:53 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8L61p8b017123;
        Sat, 21 Sep 2019 06:01:52 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 23:01:51 -0700
Date:   Sat, 21 Sep 2019 09:01:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Maya Erez <merez@codeaurora.org>,
        Dedy Lansky <dlansky@codeaurora.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, kernel-janitors@vger.kernel.org
Subject: [PATCH] wil6210: use after free in wil_netif_rx_any()
Message-ID: <20190921060145.GD18726@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=755
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909210065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=835 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909210066
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The debug code dereferences "skb" to print "skb->len" so we have to
print the message before we free "skb".

Fixes: f99fe49ff372 ("wil6210: add wil_netif_rx() helper function")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index cb13652491ad..598c1fba9dac 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1012,11 +1012,11 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 	skb_orphan(skb);
 
 	if (security && (wil->txrx_ops.rx_crypto_check(wil, skb) != 0)) {
+		wil_dbg_txrx(wil, "Rx drop %d bytes\n", skb->len);
 		dev_kfree_skb(skb);
 		ndev->stats.rx_dropped++;
 		stats->rx_replay++;
 		stats->rx_dropped++;
-		wil_dbg_txrx(wil, "Rx drop %d bytes\n", skb->len);
 		return;
 	}
 
-- 
2.20.1

