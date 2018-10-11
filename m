Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD77C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FD7D2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YF7rhYWr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FD7D2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbeJKPgG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 11:36:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59972 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbeJKPgG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 11:36:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B88xkn066811;
        Thu, 11 Oct 2018 08:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=0jVr7p1NjnICzg6i3c4jxhIk7n8b4knkgV7DpwFACvI=;
 b=YF7rhYWrzNhrShNLMzZb/azPoSkQ2z3QUW3wo2gWn6S7d05iDU5z35XQ1ykw276DcanB
 13XWXN8LfAUjDfQrjHHPJlNCDqNs+kBuqherR6jKZoA5blWcPcpWgjIFuzgiaYEJ5m5K
 0lJTjlpmKMEdCy4JdbQ7rmVcuS9EMykQ7leAfbRqqJ+mnRq+q+Y7KrYwyFOOXgAltXye
 yYHEgnwqk44n+aTj9U0YKbRn0wgxi4n/JRBoWUApAw1l4jmlmfsiuaFBnMhta5cZgyiA
 OU1DGzeC736k+6mJzed+N0VzL+Nli/vUnMTcGx7xvhMmcdsPHOp+nnW+OgeZTYIRZWjm 7w== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mxn0qagxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 08:09:32 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9B89QkE009255
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 08:09:26 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9B89Q7t026365;
        Thu, 11 Oct 2018 08:09:26 GMT
Received: from mwanda (/197.232.248.111)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 08:09:26 +0000
Date:   Thu, 11 Oct 2018 11:09:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ath10k: htt: remove some dead code
Message-ID: <20181011080920.GA15131@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110081
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We added an unnecessary condition here in commit a904417fc876 ("ath10k:
add extended per sta tx statistics support").  "legacy_rate_idx" is a u8
so it can't be negative.  The caller doesn't pass negatives either.  I
have deleted this code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I didn't use the Fixes tag because it's not really a bug.

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f2405258a6d3..13717a287848 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2680,8 +2680,6 @@ ath10k_accumulate_per_peer_tx_stats(struct ath10k *ar,
 		STATS_OP_FMT(RETRY).ht[1][ht_idx] += pstats->retry_pkts;
 	} else {
 		mcs = legacy_rate_idx;
-		if (mcs < 0)
-			return;
 
 		STATS_OP_FMT(SUCC).legacy[0][mcs] += pstats->succ_bytes;
 		STATS_OP_FMT(SUCC).legacy[1][mcs] += pstats->succ_pkts;
