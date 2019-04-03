Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2547CC10F0B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 07:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E9D21473
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 07:16:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nm0nsNJy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfDCHQK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 03:16:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfDCHQK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 03:16:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3379IXo076793;
        Wed, 3 Apr 2019 07:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=LE0uoSUKVmSxSJRJzkp5I4IG+yuvVP2PpG1nsDsaPAk=;
 b=nm0nsNJyIz5pLimP3II4DrlOyTG8HqdPPe5bTQYjyAvm+KC0cskKZS6KrR5QQTUyE/m3
 UfktATbX34ND73YhFXpILqaciw9VTpDPqOEfOo7lMP7FJOCyvay3f/4iI7495L8ic5NI
 b+s0V23ezWiUeyKAkxPFl3SD526zdB/rQ4JpLLGiWSQycWqm8/5Ibxot6HDTuwUtZR4c
 1rU5TRddumKWK/aAPJmXPsAgBFx8bVSf+dy3vIIwWzyAxk4Lc7vHzGYoU7uJkwWVraYy
 dkgqoStz+r050GzT6HPdD9rkBULUEz8DmW64VP+EYubViG5hxM1v0zcDPSEnTHpmFkgp sQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2rj0dnpc9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 07:16:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x337DvBD084931;
        Wed, 3 Apr 2019 07:14:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2rm8f4xf0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 07:14:03 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x337E2ih032499;
        Wed, 3 Apr 2019 07:14:02 GMT
Received: from kadam (/41.202.241.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Apr 2019 00:14:01 -0700
Date:   Wed, 3 Apr 2019 10:13:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc:     linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 2/2 net] nfc: nci: Potential off by one in ->pipes[] array
Message-ID: <20190403071351.GB5758@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403071248.GA5758@kadam>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030049
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904030049
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is similar to commit e285d5bfb7e9 ("NFC: Fix the number of pipes")
where we changed NFC_HCI_MAX_PIPES from 127 to 128.

As the comment next to the define explains, the pipe identifier is 7
bits long.  The highest possible pipe is 127, but the number of possible
pipes is 128.  As the code is now, then there is potential for an
out of bounds array access:

    net/nfc/nci/hci.c:297 nci_hci_cmd_received() warn: array off by one?
    'ndev->hci_dev->pipes[pipe]' '0-127 == 127'

Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 include/net/nfc/nci_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 87499b6b35d6..df5c69db68af 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -166,7 +166,7 @@ struct nci_conn_info {
  * According to specification 102 622 chapter 4.4 Pipes,
  * the pipe identifier is 7 bits long.
  */
-#define NCI_HCI_MAX_PIPES          127
+#define NCI_HCI_MAX_PIPES          128
 
 struct nci_hci_gate {
 	u8 gate;
-- 
2.17.1

