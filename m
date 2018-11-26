Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FF1C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 08:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 962D82082F
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 08:12:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qX3/n0zv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 962D82082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbeKZTFg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 14:05:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbeKZTFg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 14:05:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAQ83kku065235;
        Mon, 26 Nov 2018 08:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=e6D4lfK2FmHZ0WU2nj9+12Qi2FPCbpsHsKfuZE0P7gk=;
 b=qX3/n0zvhKxZtFMhrcspc0tBoJlJFecjf7n/8ZYgcFeGQBdVaWHjzgX2t9wxkuxt/WwZ
 gIlLwacHtPaDeq+nfUL8kg+Epb7OlDv9pEwCg4YEPC7haQlGKUC5KrRXq0PeNDltPA9f
 aiWEDI7wqB9uIKbRUg2YXwk9xZ3oSP9ilwTvvc/KROXN9Jm74oFuVDRlQQta3338NyJ2
 Ff57TZ5igXlHvL0o5df2qqYwqXuecqsCGTe+57YFtL9JGpoTtACKh9Fjuk3VPi1Vt7xt
 NJwMfxBFjfcfS8Q9QYhbntAVmiHFyYaMQbeqNtfcKLx+OSiO7Qkqfb7RGaNjX2ScX/33 Mw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nxy9qv3cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Nov 2018 08:12:02 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAQ8C1TJ016932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Nov 2018 08:12:01 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAQ8C1f7021397;
        Mon, 26 Nov 2018 08:12:01 GMT
Received: from kili.mountain (/41.202.241.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Nov 2018 00:12:00 -0800
Date:   Mon, 26 Nov 2018 11:11:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ath10k: fix a NULL vs IS_ERR() check
Message-ID: <20181126081143.tvu55aimdc3safcq@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9088 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=909
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811260076
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The devm_memremap() function doesn't return NULLs, it returns error
pointers.

Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index f0429bee35c2..37b3bd629f48 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -931,9 +931,9 @@ static int ath10k_qmi_setup_msa_resources(struct ath10k_qmi *qmi, u32 msa_size)
 		qmi->msa_mem_size = resource_size(&r);
 		qmi->msa_va = devm_memremap(dev, qmi->msa_pa, qmi->msa_mem_size,
 					    MEMREMAP_WT);
-		if (!qmi->msa_va) {
+		if (IS_ERR(qmi->msa_va)) {
 			dev_err(dev, "failed to map memory region: %pa\n", &r.start);
-			return -EBUSY;
+			return PTR_ERR(qmi->msa_va);
 		}
 	} else {
 		qmi->msa_va = dmam_alloc_coherent(dev, msa_size,
-- 
2.11.0

