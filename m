Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BDCC282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 08:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15AA42083B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 08:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kcDDjfvJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfBGI1L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 03:27:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39566 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfBGI1L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 03:27:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x178NYrR072330;
        Thu, 7 Feb 2019 08:27:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Mk4sK98hPs0JBHgHGOZ9sxJAd9av3DEpGymf+FrE2m4=;
 b=kcDDjfvJ5pGHQfgNHuT7Nnudr+ykDa5Yv+zhi4oBt4GHUyYKx90fj/MeIyoFZ7TNJXiv
 fBGW8E2vywVOo+itKQKkO7oCSnW8bfzVtiT4ZuRZHhMjpxRm9l0C5rL2ZgYl8Cpcf2Pz
 Ep4upQdcK6i0/5h3x5hznNYkxNWuUitbpvjGdR61UqjmZYoWeMU3e7rO8i5ZHJivGaO0
 yYan+y4eU2NhQKJbXuPph/2eFRpQhkwI8eM3qHwZQb2nstmEYfSN6vhNqDvEZFi2ulgT
 CX1DFS8kpLhwLytNaa/0uaAww3howCi49R71eTd8bWSIu8XNFAKBgc9qEh/PicTqF9a0 sg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qd97f5feq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Feb 2019 08:27:04 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x178Qwnd032020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Feb 2019 08:26:58 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x178Qv0Q005138;
        Thu, 7 Feb 2019 08:26:58 GMT
Received: from kadam (/41.202.241.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 00:26:57 -0800
Date:   Thu, 7 Feb 2019 11:26:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Adham.Abozaeid@microchip.com, johannes@sipsolutions.net
Subject: Re: [PATCH 2/9] staging: wilc1000: fix to set the correct value for
 'vif_num'
Message-ID: <20190207082646.GD1978@kadam>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
 <1549519927-2651-3-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549519927-2651-3-git-send-email-ajay.kathat@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9159 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=924 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902070067
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 07, 2019 at 07:22:25AM +0000, Ajay.Kathat@microchip.com wrote:
> From: Ajay Singh <ajay.kathat@microchip.com>
> 
> Set correct interface count value in '->vif_num'.
> 'vif_num' was incorrectly set one less than total number of interfaces
> because 'i' is used to set its value, which starts from 0.
> 
> Fixes: 735bb39ca3be ("staging: wilc1000: simplify vif[i]->ndev accesses")
> Cc: <stable@vger.kernel.org> # v4.10
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 648b658..8fa5f90 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -1021,7 +1021,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,

The line before the diff looks like this:

		vif->idx = wl->vif_num;

can we can change that to:

		vif->idx = i;

It's the same thing, but more clear.

>  		vif->wilc = *wilc;
>  		vif->ndev = ndev;
>  		wl->vif[i] = vif;
> -		wl->vif_num = i;
> +		wl->vif_num = i + 1;
>  		ndev->netdev_ops = &wilc_netdev_ops;

regards,
dan carpenter

