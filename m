Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D2FC10F0B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 07:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A4C20700
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 07:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GyqJdSJ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfDCHNQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 03:13:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfDCHNQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 03:13:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3378sC1076574;
        Wed, 3 Apr 2019 07:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=CM+YzCUG4IHW5M5r4fHwXZLZYMXzuBjuHzIxN7emmmU=;
 b=GyqJdSJ/MatFTT/VDYquAV/46DV/I1D7jfWWmUjl80RDjf475mt31PrOgAWMDECpixZd
 QaCrnYRSFoKprbjLFeBSM4KhmtCd8Y7+0QLKxG4nh6Mku1jMtHO/b9dbiHsx9mfHIJR1
 3YSD6doCz1CroKVXRHebBJltldFd4jNYwQe2KzuBwzi3d1tIEzINyc8TAYRo6auErFYa
 Jg3AL1PUbhuSVaIvsW3dTa8fMadBKbUziz7wN4eLG21VrcGKEV789bA65YJJ4NmiHncM
 jr1CN+Kejeorg34f9PGrFMgXwRxE7Mtg5nrPpqz42bk5ayfw8NE347CzNZi/xwdyPZhb cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2rj0dnpbng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 07:12:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x337BITk126086;
        Wed, 3 Apr 2019 07:12:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2rm8f56f0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 07:12:59 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x337Cv2m031849;
        Wed, 3 Apr 2019 07:12:57 GMT
Received: from kadam (/41.202.241.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Apr 2019 00:12:56 -0700
Date:   Wed, 3 Apr 2019 10:12:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc:     linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 1/2 net] NFC: nci: Add some bounds checking in
 nci_hci_cmd_received()
Message-ID: <20190403071248.GA5758@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030049
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904030049
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is similar to commit 674d9de02aa7 ("NFC: Fix possible memory
corruption when handling SHDLC I-Frame commands").

I'm not totally sure, but I think that commit description may have
overstated the danger.  I was under the impression that this data came
from the firmware?  If you can't trust your networking firmware, then
you're already in trouble.

Anyway, these days we add bounds checking where ever we can and we call
it kernel hardening.  Better safe than sorry.

Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/nfc/nci/hci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index ddfc52ac1f9b..c0d323b58e73 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -312,6 +312,10 @@ static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
 		create_info = (struct nci_hci_create_pipe_resp *)skb->data;
 		dest_gate = create_info->dest_gate;
 		new_pipe = create_info->pipe;
+		if (new_pipe >= NCI_HCI_MAX_PIPES) {
+			status = NCI_HCI_ANY_E_NOK;
+			goto exit;
+		}
 
 		/* Save the new created pipe and bind with local gate,
 		 * the description for skb->data[3] is destination gate id
@@ -336,6 +340,10 @@ static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
 			goto exit;
 		}
 		delete_info = (struct nci_hci_delete_pipe_noti *)skb->data;
+		if (delete_info->pipe >= NCI_HCI_MAX_PIPES) {
+			status = NCI_HCI_ANY_E_NOK;
+			goto exit;
+		}
 
 		ndev->hci_dev->pipes[delete_info->pipe].gate =
 						NCI_HCI_INVALID_GATE;
-- 
2.17.1

