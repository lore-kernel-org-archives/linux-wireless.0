Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AC4C10F01
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A6F62173C
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:37:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AIjTF+QX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733154AbfBROhT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:37:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38200 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390971AbfBROhF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 09:37:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1IEXokw061891;
        Mon, 18 Feb 2019 14:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=VLz2Sebdyc4VBnVjVw9yFpZIeyWWJVBaKYsgERbLDkw=;
 b=AIjTF+QXfK6X5XiMprtf2tHrS68zuiGx4muN+/qCbNuIu0yNy4OkGSGatZvoATZ8zibL
 8KvbGpFURiUIE3oits9egGtAaLkMvFe/7Cs6HwCvwkzxPEZTqJd0gkRaS0p8f9k78jfN
 i5Q0QALP2XGOiHJGL8Tq3XYg3G5YiChkIC61BWShzIplGnnUrGw+TDU+DRR6Is0b+40D
 GMbsG8b8+Y2C3GFlR3JEH8lmk2VOpY6YhBBcsgtizw63opYT8IVECMgpvSwkqvmlBKb4
 wIgO+J6VmkVFF9s6zyYpmmBYhMzV46t2jnXFA0lMfvs1tucY840LFK4h6WrXZ46QmtI4 yQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qp9xtpkuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Feb 2019 14:36:54 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1IEarNN012134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Feb 2019 14:36:53 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1IEaqjZ013692;
        Mon, 18 Feb 2019 14:36:53 GMT
Received: from kadam (/197.157.0.22)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Feb 2019 06:36:52 -0800
Date:   Mon, 18 Feb 2019 17:36:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     maowenan <maowenan@huawei.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        kvalo@codeaurora.org
Subject: Re: [PATCH net-next] cfg80211: pmsr: use eth_broadcast_addr() to
 assign broadcast address
Message-ID: <20190218143643.GE17104@kadam>
References: <20190216094710.127182-1-maowenan@huawei.com>
 <927ff17c-c506-734f-fc27-796d4c8fba98@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <927ff17c-c506-734f-fc27-796d4c8fba98@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=656 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902180109
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 18, 2019 at 09:25:06PM +0800, maowenan wrote:
> Add kalle Valo in mail list.
> 
> Hi Kalle Valo,
> Do you have any comments about this patch?
> 

It's not done against a recent net-next so it doesn't apply.

Please give people a few days to reply for networking changes.

regards,
dan caprenter


