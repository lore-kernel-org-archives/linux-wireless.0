Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17086C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 14:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDF7F2081C
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 14:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E6/rQzQl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDF7F2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbeK3CBD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 21:01:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39990 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731118AbeK3B1P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 20:27:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wATEDoN6023337;
        Thu, 29 Nov 2018 14:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=kouNDRNXPYPwHvM+xkQeMP8FN+V8Rigi7Ab8bK03KMM=;
 b=E6/rQzQlHD6w9603Kvt4HdnADln9RFlqGSgmoHH+c+6uqI3NXZHLzA+n9uyUJEtqDmRk
 RQaYA3BI5Xd/LkRXz0WA005eSgS5KrIoULDAc1lRZONfbFzEBC0SxaqkPy9zu6qGCAeQ
 dt7pOVw8ozeBsbIJFY3UAB15HkRs5Hy0YWqGuBveCk6UVv12Tc+CTRjFabHAxpwKRpvA
 TBP5KNSBgKqvU9CDKOQ/6hmFijnz0DpfYi7iHtvXOfjjTs/tBWwPCDc10l96HUAxTkZx
 GY0QjHt8E3CXXlsbIQhukgGhfFgkBABxBk6tERunWd/vC2SVovWNxtrqJYhA6Gd/fe6w Pw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nxxkqrdh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Nov 2018 14:21:28 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wATELMGe031880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Nov 2018 14:21:22 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wATELMXr029112;
        Thu, 29 Nov 2018 14:21:22 GMT
Received: from unbuntlaptop (/197.157.34.169)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 06:21:21 -0800
Date:   Thu, 29 Nov 2018 17:21:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: remove an unnecessary NULL check
Message-ID: <20181129142113.GU3073@unbuntlaptop>
References: <20181129103214.5tudci6izlfaasqx@kili.mountain>
 <87sgzk56w3.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgzk56w3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9091 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811290120
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 29, 2018 at 03:51:24PM +0200, Kalle Valo wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> > The "survey" pointer is the address of an array element.  We know that
> > it can't be NULL so this check can be removed.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> > index 659513bf4ddc..6a04727b63ce 100644
> > --- a/drivers/net/wireless/ath/ath10k/wmi.c
> > +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> > @@ -2578,7 +2578,7 @@ static void ath10k_wmi_event_chan_info_unpaired(struct ath10k *ar,
> >  
> >  	survey = &ar->survey[idx];
> >  
> > -	if (!params->mac_clk_mhz || !survey)
> > +	if (!params->mac_clk_mhz)
> >  		return;
> 
> Can you please CC linux-wireless so that patchwork sees this?
> 

Sure.  I can resend.

regards,
dan carpenter

