Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2B2C67863
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 09:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0638420824
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 09:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FvBe22k8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0638420824
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbeJXRev (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 13:34:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36206 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbeJXReu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 13:34:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9O92vmq056716;
        Wed, 24 Oct 2018 09:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=F4WVKrvX072Xbih1WthNhuggLVKA5JdKov2tiZ+sYQA=;
 b=FvBe22k8uO0eBYwZ8/TevvjcKMwO1Z+t5TQTXEhsEGrFFI9RzOkkenaWglj66210o3gX
 OaJILa9msdoH//hOsnzdOlmZ7jfTN4wdp59+UHb9IJQ/dJhk53uDoA1foVQGdzbMit3l
 SEAvg9Lf+l+nBSuiZkDE+Ujq/jYG4bjZQqesGpxwsGjeu247hwsWGV+W0C00Nc0eJbmB
 dxQYRp7e/9clqA7o1K2oF/gAr2ckjZT2uHYyspVYCBPdqXw9dOl6Re9svjcDcv1IWD62
 KdAYdwkI5qa/Hm6w/7Z+aREN+JA+RW0T3Wp8+Crs1yMvHErKZDIertZregTeWrBCUc7k qg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2n7vaq29ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Oct 2018 09:07:30 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9O97TML032043
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Oct 2018 09:07:29 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9O97S6V023606;
        Wed, 24 Oct 2018 09:07:29 GMT
Received: from mwanda (/129.205.6.86)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Oct 2018 02:07:28 -0700
Date:   Wed, 24 Oct 2018 12:07:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] wireless: airo: potential buffer overflow in sprintf()
Message-ID: <20181024090721.uxgwo6h6p3h6u5vp@mwanda>
References: <20181024083334.a6pxsifew3iztuun@kili.mountain>
 <87sh0vsox6.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sh0vsox6.fsf@codeaurora.org>
User-Agent: NeoMutt/20170609 (1.8.3)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9055 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=873
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810240082
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 24, 2018 at 11:56:53AM +0300, Kalle Valo wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> > It looks like we wanted to print a maximum of BSSList_rid.ssidLen bytes
> > of the ssid, but we accidentally use "%*s" (width) instead of "%.*s"
> > (precision) so if the ssid doesn't have a NUL terminator this could lead
> > to an overflow.
> >
> > Fixes: e174961ca1a0 ("net: convert print_mac to %pM")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > Static analsysis.  Not tested.
> 
> IMHO this part (after "---" line) is important information and should be
> part of commit log. I can fix that.
> 

In my experience most maintainers disagree (with varying degrees of
intensity).

regards,
dan carpenter
