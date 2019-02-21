Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3DBC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 18:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E15D220818
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 18:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A4d7DnBT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbfBUS3U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 13:29:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60664 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728872AbfBUS3U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 13:29:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1LINfnh006958;
        Thu, 21 Feb 2019 18:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=quhVMXRzpB6fLGW5rHl+VUvJpSl/cLWp+xBanzZgyXA=;
 b=A4d7DnBTtXCOSj/ig7TfG03AAY3/NZ+DqaNWsITozJ5W2S3nv9QUAOvvsuuwOqMTsq4C
 NdBci7D7n3F67k//DjGqB1uPDiGL2xgXrjUanYBh6Dks5jGajiv4IGXECn7G3X3LL55S
 R9C9KAgyDDH4Kr11037/a9YXvQzowXeK8Ntk6o2kpS/5/g1PbJQ0vuZbbP4/k0NkU+Zm
 eHVTDaDl64a3j3jdQZQ9X7qiP5/vsjl+w76Hnrvq08ouv9plL+iSMgaPIGEYDnV3Birn
 2HRqlxo3xEbgdeBSsIGBczMMECekSTmIEb6jRX4xlAGcZ+fece5iuiSFpqWiYtlId+G/ CQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2qpb5rst54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Feb 2019 18:29:15 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1LITA6x002629
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Feb 2019 18:29:10 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1LIT9Tp021054;
        Thu, 21 Feb 2019 18:29:10 GMT
Received: from kadam (/197.157.0.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Feb 2019 10:29:09 -0800
Date:   Thu, 21 Feb 2019 21:29:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     lkundrak@v3.sk
Cc:     linux-wireless@vger.kernel.org
Subject: [bug report] libertas_tf: don't defer firmware loading until start()
Message-ID: <20190221182900.GA26432@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9174 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=778 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902210129
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Lubomir Rintel,

This is a semi-automatic email about new static checker warnings.

The patch baa0280f08c7: "libertas_tf: don't defer firmware loading 
until start()" from Feb 20, 2019, leads to the following Smatch 
complaint:

    drivers/net/wireless/marvell/libertas_tf/if_usb.c:256 if_usb_disconnect()
    warn: variable dereferenced before check 'priv' (see line 254)

drivers/net/wireless/marvell/libertas_tf/if_usb.c
   253	
   254		if_usb_reset_device(priv);
                                    ^^^^^
The patch introduces a new dereference (inside the function).

   255	
   256		if (priv)
                    ^^^^
Old code assumes "priv" could be NULL.

   257			lbtf_remove_card(priv);
   258	

regards,
dan carpenter
