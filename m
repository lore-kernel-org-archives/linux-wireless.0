Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADADC5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 07:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C402F2098A
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 07:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y+S4M+6C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C402F2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbeJRPiZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 11:38:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35502 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbeJRPiZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 11:38:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9I7XlUQ150438;
        Thu, 18 Oct 2018 07:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=Z6JqPiGIgeo1TunCz0GAVgIDp3tiPCFY8KPBltZzBZ4=;
 b=Y+S4M+6CDf42kCFlvEBm44OCyfPABRZS9mSFRI5dSMUjouzPSOGtVOuZzZyGPkAJqgEG
 9VSIp+Wo26SNK1pQFaupyBei7IhVzN+wVdr2/rJnLqw3V+HCg1VCbNbs/Ld+QlTDn2Os
 wnMYaNK/cET29a71n7QWJDqqEzccILreTz1vXYXXEMy95Kv7XSKLO+pRFWMB7+JdA4AO
 3t5wAhVe0KspylC03WHnqrjbboGLfdQs5zodGuX7icad6iSRiOYFFkzL7dpE7b28YaeY
 bzOZk7QKxGBNypyheOvrEZjXtDCJ7duByXyb5sUCXFPflSacSUshWsqTNxQ/BcTPFOWi 6w== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2n38nqcr8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 07:36:27 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9I7aRZT012970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 07:36:27 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9I7aRto010528;
        Thu, 18 Oct 2018 07:36:27 GMT
Received: from kili.mountain (/129.205.6.86)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Oct 2018 00:36:26 -0700
Date:   Thu, 18 Oct 2018 10:36:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ath10k: Fixup extended per sta tx statistics
Message-ID: <20181018073619.c2cxj74enkramhjr@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810180072
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I had a couple concerns with this code.  First, we definitely need to
set the error code if the kzalloc() fails.  Secondly, I was worried that
if we didn't set "arsta->tx_stats" to NULL after freeing it, then it
looks to me like it might lead to a use after free.  I can't test that,
but it's harmless to set it to NULL so I did.

Fixes: a904417fc876 ("ath10k: add extended per sta tx statistics support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a1c2801ded10..2b8c8bf80b0d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6296,8 +6296,10 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		if (ath10k_debug_is_extd_tx_stats_enabled(ar)) {
 			arsta->tx_stats = kzalloc(sizeof(*arsta->tx_stats),
 						  GFP_KERNEL);
-			if (!arsta->tx_stats)
+			if (!arsta->tx_stats) {
+				ret = -ENOMEM;
 				goto exit;
+			}
 		}
 
 		num_tdls_stations = ath10k_mac_tdls_vif_stations_count(hw, vif);
@@ -6385,8 +6387,10 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   "mac vdev %d peer delete %pM sta %pK (sta gone)\n",
 			   arvif->vdev_id, sta->addr, sta);
 
-		if (ath10k_debug_is_extd_tx_stats_enabled(ar))
+		if (ath10k_debug_is_extd_tx_stats_enabled(ar)) {
 			kfree(arsta->tx_stats);
+			arsta->tx_stats = NULL;
+		}
 
 		if (sta->tdls) {
 			ret = ath10k_mac_tdls_peer_update(ar, arvif->vdev_id,
-- 
2.11.0

