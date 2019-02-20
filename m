Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027D4C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 20:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C71712146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 20:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y8ziMe5I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfBTU5g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 15:57:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47228 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfBTU5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 15:57:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1KKs5bF126342;
        Wed, 20 Feb 2019 20:57:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=rNihDsI6B+A4KO8vDb0BLzCY7M3tcW+QVQfDwSv+IpA=;
 b=y8ziMe5IpXqdDOBCDKZoDrckRYRU7912u7HFX1huu8FgCVUZ9cs2w5Yh0v2nXG1owmiA
 QJUdKcnlXc0rcmjLoTxbHTk6KhRurNUboQWvfHpwxLAidaaY0iALbBUS7EbPOcg0TT93
 uorjrtNPRVIvrn8lpB+LE4U32B7qUeL6hzz8DyHxH8CbsHaGkns7Sk8067aGSHbfnXK7
 Pmj8GEMZZF8IG++TJ7WDzuLlEJDwSp5wOeDGIjpizHY5SMqVrYDo9nS2BHjQDc9rfbzm
 l2ckQSbl3h9txloFqXLGw0nSBzjs3IthagGfwi0bnK+ohUFLQ4mqRcYsKEGVqO+ZoVqH xQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2qpb5rm150-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 20:57:27 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1KKvLc2031113
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 20:57:21 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1KKvL4j031802;
        Wed, 20 Feb 2019 20:57:21 GMT
Received: from kadam (/197.157.0.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Feb 2019 12:57:20 -0800
Date:   Wed, 20 Feb 2019 23:57:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     lorenzo.bianconi@redhat.com
Cc:     linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: [bug report] mt76: usb: fix possible memory leak in mt76u_buf_free
Message-ID: <20190220205713.GA26590@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9173 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=1 spamscore=0 clxscore=1011
 lowpriorityscore=1 mlxscore=0 impostorscore=0 mlxlogscore=300 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902200143
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Lorenzo Bianconi,

The patch cb83585e1121: "mt76: usb: fix possible memory leak in
mt76u_buf_free" from Feb 10, 2019, leads to the following static
checker warning:

	drivers/net/wireless/mediatek/mt76/usb.c:372 mt76u_buf_free()
	warn: address of 'urb->sg[i]' is non-NULL

drivers/net/wireless/mediatek/mt76/usb.c
    362 }
    363 
    364 void mt76u_buf_free(struct mt76u_buf *buf)
    365 {
    366 	struct urb *urb = buf->urb;
    367 	struct scatterlist *sg;
    368 	int i;
    369 
    370 	for (i = 0; i < urb->num_sgs; i++) {
    371 		sg = &urb->sg[i];
--> 372 		if (!sg)
                            ^^^
This address isn't NULL.  Was something else intended?

    373 			continue;
    374 
    375 		skb_free_frag(sg_virt(sg));
    376 	}
    377 	if (buf->buf)
    378 		skb_free_frag(buf->buf);
    379 
    380 	usb_free_urb(buf->urb);
    381 }

regards,
dan carpenter
