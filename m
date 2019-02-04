Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632DEC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 09:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D46B2147A
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 09:47:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U/un+ZSb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbfBDJrg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 04:47:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41612 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfBDJrg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 04:47:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x149i0QJ193148;
        Mon, 4 Feb 2019 09:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=5KeGIercHUkbU3xq1ANDB5GJ6Xjh7YK41+RN186W30I=;
 b=U/un+ZSbso+OMe7NvejjAQuDt2URDibE7oShvR4Qb3Ou3SsG/HlBs+yYbhY5GtvFINJu
 vdjqzK8/SkDm5u4ANuharEKIZYnQvKn0yIgeS6Lj71XbkqoxySEOt9x9f3XPXTbEt4TI
 +NBvXbb4BMvxunDvp6f1leFJKzCECLUc0NG4aj09Fx148NJdkRvMcmqyrdXGVaY7xbst
 o/PSxqQX6vZi17694Pso41vOq67LCuB9QSIO/jvyNwaZkKNlv8K80jaFhb/emL7QMn0F
 w6+pbcqbNh6Eow/Q8PeP9Byd01QSuceRsGgA++dwN/oHbrBvUgXWF9pAjci0DPiZye2B Fw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2qd9ar453m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Feb 2019 09:47:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x149lTfC027732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Feb 2019 09:47:30 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x149lTZq021869;
        Mon, 4 Feb 2019 09:47:29 GMT
Received: from kadam (/197.157.0.20)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Feb 2019 09:47:28 +0000
Date:   Mon, 4 Feb 2019 12:47:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        Adham.Abozaeid@microchip.com
Subject: Re: [PATCH 08/15] staging: wilc1000: use correct condition in loops
 for 'vif_num' count
Message-ID: <20190204094723.GD2581@kadam>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
 <1549134974-5545-9-git-send-email-ajay.kathat@microchip.com>
 <20190204081357.GC2563@kadam>
 <fdcab6a0-cf91-dc85-d674-ce4a3c9bd54d@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdcab6a0-cf91-dc85-d674-ce4a3c9bd54d@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9156 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=882 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902040079
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 04, 2019 at 09:42:36AM +0000, Ajay.Kathat@microchip.com wrote:
> 
> 
> On 2/4/2019 1:43 PM, Dan Carpenter wrote:
> > On Sat, Feb 02, 2019 at 07:17:13PM +0000, Ajay.Kathat@microchip.com wrote:
> >> From: Ajay Singh <ajay.kathat@microchip.com>
> >>
> >> The value of 'vif_num'(interface count) starts with 0, so modified the
> >> loop conditions to execute for all interface.
> >>
> >> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > 
> > The right thing to do is to change ->vif_num = i + 1 in
> > wilc_netdev_init().  That's how it was originally.  Please, add a
> > Fixes tag.
> > 
> > Fixes: 735bb39ca3be ("staging: wilc1000: simplify vif[i]->ndev accesses")
> > 
> 
> Thanks. Sure, I will add Fixes tag and resubmit the changes.
> 
> Can other patches from the series be applied excluding this or should I
> resubmit the complete series?
> Please suggest.

I don't have an opinion on that.  I guess if you just resend them all,
that's the easiest for Greg.

regards,
dan carpenter

