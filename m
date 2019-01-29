Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DD5C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 08:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B4B20857
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 08:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C61lU9Zs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfA2IkK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 03:40:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46208 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfA2IkJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 03:40:09 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0T8cuVF182830;
        Tue, 29 Jan 2019 08:40:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=c1kfOXa4WnBBwU4aeA9Bs6uISsl8to9riqyfIsSzyRQ=;
 b=C61lU9Zs4rIBKafIEpdSqo7/doMVanWVTW20J4EnHcQMbJgBFfZbmlIDYRTaQWj/nTPy
 oDYcBHTkr83jvetiCHl1qsntiEhTK3TkyW2M+ZqpQY+S/61C9bKtjZiuqyxLschbHWIV
 AgEpMHipDo6MHC63ZQUTY3hv0/BFaNXuMY8I6djUZjcCdLGNqJPURUPRjDf9Oef2EFvQ
 lO9tte1YQUSfHbowesf/fKrXyK+peTVUhv9KHIbOlFQvZyY/Gis4UkvVOVfhBQTE7hrl
 AyugGT5gakIwB7D8VWd58OI3yluo9Q1zPzLXUfknxHffmzfXaYv/ByO4Gll24qFYbYIa Qw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2q8d2e32en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jan 2019 08:40:02 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0T8e1ap027656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jan 2019 08:40:01 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0T8e1XM026610;
        Tue, 29 Jan 2019 08:40:01 GMT
Received: from kadam (/197.157.0.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Jan 2019 00:40:00 -0800
Date:   Tue, 29 Jan 2019 11:39:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Adham.Abozaeid@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        Ajay.Kathat@microchip.com
Subject: Re: [PATCH 1/1] staging: wilc1000: remove redundant reset of station
 statistics
Message-ID: <20190129083952.GM1795@kadam>
References: <20190128223111.19400-1-adham.abozaeid@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128223111.19400-1-adham.abozaeid@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9150 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901290066
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 10:38:20PM +0000, Adham.Abozaeid@microchip.com wrote:
> From: Adham Abozaeid <adham.abozaeid@microchip.com>
> 
> Driver sends configuration wids to reset connection statistics in the
> device, but the device already resets it when starting a new connection
> 
> Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index fbb61de20304..286685e426c1 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -342,29 +342,11 @@ static int wilc_send_connect_wid(struct wilc_vif *vif)
>  {
>  	int result = 0;
>  	struct wid wid_list[8];
                   ^^^^^^^^^^^
We could make this array smaller as well.

> -	u32 wid_cnt = 0, dummyval = 0;
> +	u32 wid_cnt = 0;

regards,
dan carpenter
