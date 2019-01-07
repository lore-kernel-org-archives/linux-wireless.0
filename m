Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E94C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 12:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 813C020651
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 12:55:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UCA9puy3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfAGMzo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 07:55:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60954 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfAGMzn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 07:55:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x07CnSss030048;
        Mon, 7 Jan 2019 12:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=uz4LkBO1vBAjKUDA/RMmMBcHEt2I72G1OKaBaDKEfBE=;
 b=UCA9puy3aEQtXmNRB+yUtFbvRRzYIp1qH58yIJlwfb3n3fIMSL45I/oLpeRXOW1qkRNy
 0yfA4xm8usflhZDbPg3fgRj0vAYsEZnL5lZjUJl25mxuQz3sEUGqywSDLnLn37icl5zc
 zqDnq3e5WXR9IUWoMTwHtgvlqYX9Da7/OvVKbbuA+jOU9pYwv7NxwePE/+d/QBhFEiqi
 ohHx513+3nnOhHS6J+mc346VQw2WuaXUOrOiX8RAYpU1+x1vxYCswFQbNgz72ptSEaUt
 OVmzz/I/AmRJyG6BHHnF5xZ23neHB137urLB6YrLLcW0Lwykm6tiuzr1BwGmWjdvG/3G wA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2ptm0twk7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Jan 2019 12:55:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x07CtZfq013551
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Jan 2019 12:55:35 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x07CtZ3P013565;
        Mon, 7 Jan 2019 12:55:35 GMT
Received: from kadam (/197.157.0.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Jan 2019 04:55:34 -0800
Date:   Mon, 7 Jan 2019 15:54:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?Q?J=FAlius?= Milan <julikmilan@gmail.com>,
        kbuild test robot <lkp@intel.com>
Cc:     linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, ajay.kathat@microchip.com,
        linux-wireless@vger.kernel.org, adham.abozaeid@microchip.com
Subject: Re: [PATCH] staging: wilc1000: fix cast to restricted __le32
Message-ID: <20190107125437.GA3200@kadam>
References: <20190105082323.GA27838@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190105082323.GA27838@localhost.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9128 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901070114
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I'm sort of surprised that the zero day bot didn't complain about this.
It probably should.

The endianness checking is not turned on by default in Sparse.  You have
to do "make C=1 CF=-D__CHECK_ENDIAN__" to turn it on.

regards,
dan carpenter

On Sat, Jan 05, 2019 at 09:23:23AM +0100, Július Milan wrote:
> Fixes the following sparse warnings:
> 
> drivers/staging/wilc1000/host_interface.c:2360:30: warning:
>  incorrect type in assignment (different base types)
>     expected restricted __le32 [addressable] [assigned] [usertype] frame_type
>     got restricted __le16 [usertype] <noident>
> 
> Fixes: 147ccfd451024 ("staging: wilc1000: handle mgmt_frame_register ops from cfg82011 context")
> Signed-off-by: Július Milan <jmilan.dev@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 5dae6e7155d3..07c3d6293573 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2357,7 +2357,7 @@ void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
>  	default:
>  		break;
>  	}
> -	reg_frame.frame_type = cpu_to_le16(frame_type);
> +	reg_frame.frame_type = cpu_to_le32(frame_type);
>  	result = wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
>  				      wilc_get_vif_idx(vif));
>  	if (result)
> -- 
> 2.14.5
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
