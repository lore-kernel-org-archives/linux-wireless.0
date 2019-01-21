Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BA5C2F3A0
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 13:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6FE52084C
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 13:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sqlg/3Rk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfAUNOc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:14:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57372 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfAUNOb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 08:14:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0LDEMbh012054;
        Mon, 21 Jan 2019 13:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=DB2FZuzd+5+NV8reuHBixiK2cQYeuwlt4eJJ/GqrztI=;
 b=Sqlg/3Rkwjsd6Gr6kKObpFQgRW3FEbhrmPfEqpXaku4CEwAM4yAWpy45Aq3geejmQDj0
 IOq3IVWFGWo6BmwRsyRGTRWEAluwygN54DROtSAnHC2RoCYg2oNDqeH17HO70vRtP9aR
 vYz7/eKUxJ2IZoZI8lrh3x+xUhUThY/Y+pQOw5GqPGKcH485dSR/UrJedLn0Z36zDi8J
 AszrY5EnjdCiypiJiBQxvugbBQnLg07OGYNy6TmrS7xEPGaxLcVHe9OWobl4IpuptRXd
 3w6e5PSsIUCw+E7uKJccy1iWPr8I1pkwHJa5OWAp/09gICPKNc2glgL4MYeCJeMZo4Mu BQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2q3vhrek5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jan 2019 13:14:24 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0LDEOQJ003190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jan 2019 13:14:24 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0LDENms019227;
        Mon, 21 Jan 2019 13:14:23 GMT
Received: from kadam (/197.157.0.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Jan 2019 05:14:22 -0800
Date:   Mon, 21 Jan 2019 16:14:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        Adham.Abozaeid@microchip.com
Subject: Re: [PATCH 01/13] staging: wilc1000: make use of
 get_unaligned_le16/le32 to pack data
Message-ID: <20190121131401.GG4482@kadam>
References: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
 <1547731250-18518-2-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547731250-18518-2-git-send-email-ajay.kathat@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9142 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=881
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901210104
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 17, 2019 at 01:21:10PM +0000, Ajay.Kathat@microchip.com wrote:
> From: Ajay Singh <ajay.kathat@microchip.com>
> 
> Make use of get_unaligned_le16/le32 framework api's to pack data.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 15 +++------------
>  drivers/staging/wilc1000/wilc_wlan_cfg.c  | 27 +++++++++++++--------------
>  2 files changed, 16 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index c05c120..a718842 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2154,10 +2154,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
>  	struct host_if_drv *hif_drv;
>  	struct wilc_vif *vif;
>  
> -	id = buffer[length - 4];

Not related to this patch, but so far as I can see, length can't be zero
but there is nothing preventing if from being less than four so this
could be reading from buffer[-3].

regards,
dan carpenter


