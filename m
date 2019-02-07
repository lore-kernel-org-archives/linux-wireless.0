Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7D2C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 08:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E7C52175B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 08:13:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="34jXVDZZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfBGINA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 03:13:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52174 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfBGINA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 03:13:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1789JP6060231;
        Thu, 7 Feb 2019 08:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=t18w5ERADOJmglxXugw7p/3JNoNEpWwIvlrrTjomLb0=;
 b=34jXVDZZY5i1tskHrnZOrWTDgVsGW4InbN2wNygqOjv7WTkLWYL7D1tGQaBwyO2gsrdI
 OgSY7nL7mIOFyUQjkQjzUhf7wkn/fEWRBz7+0fh0TG6F+PVw0C8B1JtkKBwRenO8O8so
 45oLjdBu5PojsE+J0mtrWpVyu+v6x/PY0CxRXC5ZjJ3TigoudVOJZRks+563qAEuhOa8
 iflE7O3oh/B3Za5gbyb9qoVdceIXpE5eP48Px049TF4e0r/CAS/Zo3z6xJhyWWmaViJk
 ULSFjgJfx6cvPqQMqhYbnI5E4vJYbII2Ef8//GkCCt+izs4jvbBJWDAKXnxFlSX3tmfo JQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qd97f5d4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Feb 2019 08:12:52 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x178CpHb008651
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Feb 2019 08:12:51 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x178CoHE030675;
        Thu, 7 Feb 2019 08:12:50 GMT
Received: from kadam (/41.202.241.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 08:12:49 +0000
Date:   Thu, 7 Feb 2019 11:12:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Adham.Abozaeid@microchip.com, johannes@sipsolutions.net
Subject: Re: [PATCH 1/9] staging: wilc1000: revert fix related to vif index
Message-ID: <20190207081242.GC1978@kadam>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
 <1549519927-2651-2-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549519927-2651-2-git-send-email-ajay.kathat@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9159 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=701 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902070065
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch was very confusing to review...

From a process perspective, you really should fold patches 1 and 2
together.  Otherwise we're re-introducing a bug.

regards,
dan carpenter

