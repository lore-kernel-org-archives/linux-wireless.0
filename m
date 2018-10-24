Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0272C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 12:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61A5F2064A
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 12:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="goWW5v0K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61A5F2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbeJXVY6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 17:24:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37184 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbeJXVY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 17:24:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9OCnSDM094825;
        Wed, 24 Oct 2018 12:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=yN6f7Vf683zVbKWT67T2TDYzmNLP/4oCu2OOVL/tMCM=;
 b=goWW5v0KHA5jh/4rIHZZ182PYG0a/06+FwMld1hOigyzHc7fDiVvQ8J9f8TFgC7QLmVu
 UpBk662yBasuJvkBLjdE+EStIH1LKi2c2JVE1pK2peRtCiwV94P6rPhwB2/fLSb04z73
 fRcY9Wq2b0sZ7hYeRcrklTj5lEzY10kDDCKjO6jjftrCPSdOzmARV75bl6ZoTRgLkv7J
 JseIRSGQo/f8c+IEQLszh3nWlD8aG1lWgmbX+///eqT3TDTPjjvDFzj232IZQVz5ppk/
 dB/ICKyySpZD803hpcwFIl1DxcXo5y9BGA3eVhQaJh4QSxaMACscQD8grCLAVU4p3p5L Nw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2n7usubck3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Oct 2018 12:56:48 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9OCulSl017153
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Oct 2018 12:56:48 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9OCukp1005154;
        Wed, 24 Oct 2018 12:56:47 GMT
Received: from mwanda (/129.205.6.86)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Oct 2018 05:56:46 -0700
Date:   Wed, 24 Oct 2018 15:56:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix a locking bug in ath9k_add_interface()
Message-ID: <20181024125630.pqs6uae3owjvfdhr@mwanda>
References: <20181019200842.7qclbjs547sm7mbn@kili.mountain>
 <87tvlbuc3n.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tvlbuc3n.fsf@codeaurora.org>
User-Agent: NeoMutt/20170609 (1.8.3)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9055 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=876
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810240112
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 24, 2018 at 08:50:52AM +0300, Kalle Valo wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> > We tried to revert commit d9c52fd17cb4 ("ath9k: fix tx99 with monitor
> > mode interface") but accidentally missed part of the locking change.
> >
> > The lock has to be held earlier so that we're holding it when we do
> > "sc->tx99_vif = vif;" and also there in the current code there is a
> > stray unlock before we have taken the lock.
> >
> > Fixes: 6df0580be8bc ("ath9k: add back support for using active monitor interfaces for tx99")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> commit 6df0580be8bc is on it's way to v4.20 so should I also queue this
> to v4.20?

Yeah.  Obviously this is a static checker thing and I haven't tested it.

I don't know if add_interface() is ever called in parallel, but I can
imagine that it might be.  In that case the race condition is something
that would affect real life.

Anyway, it's a small obvious fix.

regards,
dan carpenter

