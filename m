Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA0EC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 587B82172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aqPR/5wG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 587B82172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbeI1PvZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 11:51:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38228 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbeI1PvZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 11:51:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8S9NiTI060744;
        Fri, 28 Sep 2018 09:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=rq+GREca+4DscrSeI35+5JwS8bGdYV/0rH7BcI80TMo=;
 b=aqPR/5wGgDbSXQozJEglsMZnInsg0neW80LRjBVxxBoJPim9JihJREPhYrFUhWkyRx6+
 TNR7WeAtJYpaiTCVnDekIAEssncatMqKKmGNHPistbvvFyfLU7VmLEZK1VKiPxuiaXeE
 zQMxwe3MgnxcpuTnedcQDI7OGRLYnwr46aaydDU4J+WbwEtnJi9134rJjB/sTYbAGsD6
 BINM80T8lNgnOoJZtU26SpOlzSpBjNwRhjeIMNlLQQZZDbSxkWpkO+4O0MlonhsCcjvE
 o7cvRUzNjgJadSsMHMXsWNOWjslsmDfnN012Fty27bgGHZ8X2E20vsBYU7iew0SQ38zR Cg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mnvtv5qyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Sep 2018 09:28:32 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8S9SVWg032232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Sep 2018 09:28:31 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8S9SVap008452;
        Fri, 28 Sep 2018 09:28:31 GMT
Received: from mwanda (/197.232.248.111)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Sep 2018 02:28:31 -0700
Date:   Fri, 28 Sep 2018 12:28:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     christophe.ricard@gmail.com
Cc:     linux-wireless@vger.kernel.org
Subject: [bug report] NFC: st21nfca: Fix some skb memory leaks
Message-ID: <20180928092826.GA2420@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9029 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=92 spamscore=0 mlxscore=0 mlxlogscore=528
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809280098
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Christophe Ricard,

The patch c490c557b67f: "NFC: st21nfca: Fix some skb memory leaks"
from Jan 25, 2015, leads to the following static checker warning:

	drivers/nfc/st21nfca/core.c:742 st21nfca_hci_complete_target_discovered()
	warn: 'nfcid_skb' was already freed.

drivers/nfc/st21nfca/core.c
   712                          /* NFC Forum Digital Protocol Table 44 */
   713                          if (target->sensf_res[0] == 0x01 &&
   714                              target->sensf_res[1] == 0xfe)
   715                                  target->supported_protocols =
   716                                                          NFC_PROTO_NFC_DEP_MASK;
   717                          else
   718                                  target->supported_protocols =
   719                                                          NFC_PROTO_FELICA_MASK;
   720                  } else {
   721                          kfree_skb(nfcid_skb);
                                ^^^^^^^^^^^^^^^^^^^^
Freed.

   722                          /* P2P in type A */
   723                          r = nfc_hci_get_param(hdev, ST21NFCA_RF_READER_F_GATE,
   724                                          ST21NFCA_RF_READER_F_NFCID1,
   725                                          &nfcid_skb);
                                                ^^^^^^^^^^
This is set to a different new skb on some error paths but if we return
-EADDRNOTAVAIL then it's still the same freed skb.

   726                          if (r < 0)
   727                                  goto exit;
                                        ^^^^^^^^^
We hit this goto and double free.

   728  
   729                          if (nfcid_skb->len > NFC_NFCID1_MAXSIZE) {
   730                                  r = -EPROTO;
   731                                  goto exit;
   732                          }
   733                          memcpy(target->sensf_res, nfcid_skb->data,
   734                                  nfcid_skb->len);
   735                          target->sensf_res_len = nfcid_skb->len;
   736                          target->supported_protocols = NFC_PROTO_NFC_DEP_MASK;
   737                  }
   738                  target->hci_reader_gate = ST21NFCA_RF_READER_F_GATE;
   739          }
   740          r = 1;
   741  exit:
   742          kfree_skb(nfcid_skb);
   743          return r;
   744  }

regards,
dan carpenter
