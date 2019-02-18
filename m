Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A0EC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 09:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 426EB2184A
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 09:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E01bylT6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbfBRJeD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 04:34:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729730AbfBRJcH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 04:32:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1I9TnKm004407;
        Mon, 18 Feb 2019 09:32:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=v2AOGaOECPdt0Ot7Rvf7Ap3r6arzKxWZmsW2YYFz4Eg=;
 b=E01bylT6yO3ENPNUWuGcksEaWovErYMic59jQwHOii2elMtXbF+wj3dp9TDxJHpQj6v6
 CZ7uNb1ordsT4r3xmBsZw5b5QzVjBHvWU2jpXr96utN8AjQAish3EluCr+1lj609Hfkn
 N137Y8Ugh5b8/DociH7CDqFUbQrzVZdK2WKeNjdgtva+BmO4UONY/aSYc7RPZegzd2dk
 GTtbwdLh/B6xGvpD/uH6FvzALjbA3j9ConcBEMfhcavQ9rz9FClnGfxi/018CnTmya5T
 mPE/GKrfesvxuZT9QY19ESjBaq2/FoIwOLT2LVEPEshFaZMm18PocVOFPWWAAW8nknfU yw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qp9xtn6dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Feb 2019 09:32:03 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1I9W2EN019825
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Feb 2019 09:32:03 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1I9W29B018858;
        Mon, 18 Feb 2019 09:32:02 GMT
Received: from kadam (/197.157.0.22)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Feb 2019 01:32:01 -0800
Date:   Mon, 18 Feb 2019 12:31:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christian Lamparter <chunkeey@googlemail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] carl9170: clean up a clamp() call
Message-ID: <20190218093154.GC7712@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=856 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902180073
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The parameter order for clamp is supposed to be clamp(value, low, high).
When we write it in this order it's equivalent to
min(head->plcp[3] & 0x7f, 75) which works in this context where the min
is zero.  But it's not a correct use of the API.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/ath/carl9170/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index f7c2f19e81c1..8e154f6364a3 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -427,7 +427,7 @@ static int carl9170_rx_mac_status(struct ar9170 *ar,
 		if (head->plcp[6] & 0x80)
 			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
-		status->rate_idx = clamp(0, 75, head->plcp[3] & 0x7f);
+		status->rate_idx = clamp(head->plcp[3] & 0x7f, 0, 75);
 		status->encoding = RX_ENC_HT;
 		break;
 
-- 
2.17.1

