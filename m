Return-Path: <SRS0=yxJm=R7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7219AC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 14:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CCA7217F9
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 14:41:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G48StnBJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfC1OlI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Mar 2019 10:41:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33086 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbfC1OlI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Mar 2019 10:41:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SEcebK062250;
        Thu, 28 Mar 2019 14:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=OT5dAE0pEBQ+Lim9CilUecZtGHBiMqs6hw198UkfN2M=;
 b=G48StnBJDh5Atdv+1yB86nssuBw5BKQ40UiFTZWP1/sKs0Q6jPNwckDU8xwRr0ZzPVCf
 PFA5supIkNCh1qPwZmwS7w1jaf+zPvPowYlrFTL+eu1ZDK6/TlBfw10wC5wcnHexYXNj
 bK8OB0894SiPjYvwVLCxTlOXMsRSOMHYiE7LZ8gcYNxTEar5Gq7/kGYY2Xzqmxc1Ggaj
 qTWz/9WqUATCRfI4iAqHUtfcOO2ugQA3Rzwlfo5hpLG2HEoS5i7JE+5l6ahZ9H/czYhG
 j/FLF4CJJtkz1+5IxdYTfdRKopwQRb0ra+fjfJM7oT2WLBQDIPCYYwCYsTCZU9F86oxM Vw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2re6g1f0ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 14:41:05 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2SEf44G010615
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 14:41:04 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2SEf3cd022811;
        Thu, 28 Mar 2019 14:41:04 GMT
Received: from kadam (/41.202.241.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 07:41:02 -0700
Date:   Thu, 28 Mar 2019 17:40:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] NFC: pn533: potential buffer overflow in
 pn533_target_found_type_a()
Message-ID: <20190328144056.GR32590@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9208 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999
 adultscore=10 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1903280100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Smatch doesn't trust information that comes from skb->data.  It
complains that "nfc_tgt->nfcid1_len" is a u8 so it could be up to 255
bytes, but the destination buffer is only 10 bytes large.

Fixes: c3b1e1e8a76f ("NFC: Export NFCID1 from pn533")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/nfc/pn533/pn533.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index a0cc1cc45292..9f9bbf912687 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -724,6 +724,8 @@ static int pn533_target_found_type_a(struct nfc_target *nfc_tgt, u8 *tgt_data,
 	nfc_tgt->sens_res = be16_to_cpu(tgt_type_a->sens_res);
 	nfc_tgt->sel_res = tgt_type_a->sel_res;
 	nfc_tgt->nfcid1_len = tgt_type_a->nfcid_len;
+	if (nfc_tgt->nfcid1_len > sizeof(nfc_tgt->nfcid1))
+		return -EINVAL;
 	memcpy(nfc_tgt->nfcid1, tgt_type_a->nfcid_data, nfc_tgt->nfcid1_len);
 
 	return 0;
-- 
2.17.1

