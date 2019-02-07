Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155FAC282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 10:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4914218FE
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 10:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dU8SDZG1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfBGKCn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 05:02:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37628 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfBGKCm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 05:02:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x179siFh153016;
        Thu, 7 Feb 2019 10:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ATyNVxlxObVvI4vZL2hk1KfjzAuJEdedWoRuALIH0ps=;
 b=dU8SDZG1dBC38CdxV4SNhyv9AZNJfd6svbcyX4KJH5Jgbo9r74AP33/9YxT5TaSihaQh
 27i0miLEHmF/RbG2fliXFcyT8tWRLIJG3PK7QHq9ZD4mVU0s7MYOMQaluRGX78++MuOC
 /NUa/KukJ6FXsV4E1I3sZVhtrUWAtANktNOVqsQ2bE+sLsB1tKBDGvQct3HFJf8+aUuX
 wdbdic8iENQclnSF2r5H1MidmmXv+5lDCHVxEe6o6b31tlm0GgfCQ7xFH2XfqRVPSfbp
 wqoKL4gYLQBdw11wCfL70H4w/MQbVKS7mHNx7pFLuuzx9LFtq6AeCnp03dEVO3Irg5aB dA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2qd98ne159-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Feb 2019 10:02:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x17A2Z7G028920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Feb 2019 10:02:35 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x17A2Y7k029984;
        Thu, 7 Feb 2019 10:02:35 GMT
Received: from kadam (/41.202.241.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 02:02:34 -0800
Date:   Thu, 7 Feb 2019 13:02:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ajay.Kathat@microchip.com
Cc:     devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Adham.Abozaeid@microchip.com, johannes@sipsolutions.net
Subject: Re: [PATCH 1/9] staging: wilc1000: revert fix related to vif index
Message-ID: <20190207100225.GE1978@kadam>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
 <1549519927-2651-2-git-send-email-ajay.kathat@microchip.com>
 <20190207081242.GC1978@kadam>
 <8952ae4a-52a9-354b-2368-76419d15e6af@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8952ae4a-52a9-354b-2368-76419d15e6af@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9159 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902070079
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 07, 2019 at 09:39:54AM +0000, Ajay.Kathat@microchip.com wrote:
> Hi Dan,
> 
> On 2/7/2019 1:42 PM, Dan Carpenter wrote:
> > This patch was very confusing to review...
> 
> Apologies for the confusion.
> 
> > From a process perspective, you really should fold patches 1 and 2
> > together.  Otherwise we're re-introducing a bug.
> 
> Patch 1 and Patch 2 both are required if commit 0e490657c721 ("staging:
> wilc1000: Fix problem with wrong vif index") is applied else Patch 2 is
> enough for complete fix. For the above reason, I have divided the fixes
> into 2 patches.
> Please suggest, if I should go ahead and submit this in a single patch.
> Should I put 2 'Fixes:' tag in that merge commit or only 0e490657c721
> commit is enough.
> 

I always just go with the oldest one.  Another option is to include
both.

regards,
dan carpenter

