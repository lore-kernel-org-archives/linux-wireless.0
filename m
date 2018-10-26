Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E058AECDE44
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 09:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9455020834
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 09:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k3Du+TuK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9455020834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbeJZSNe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 14:13:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbeJZSNe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 14:13:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9Q9YW7u029704;
        Fri, 26 Oct 2018 09:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=c19ye0jH1E1Qb1Y/rc5ZiWGnl9m0jM7fCjTswo5EPi8=;
 b=k3Du+TuKFizjbm3POmbeWbebmuMzlQdGkktzXCgS39PdzEXpmXw21iJchylZ2OREl5Ev
 sA7uKRrROwC314nVtK4pe75EG5QX0/OsyEs9H9e/uCm6MW/7uuyUXH2IkTGkW5sYuh+R
 PAvmcmIFZNvHM1q8T6lHct2Yg1Eo062pm5lBzMY1OiKec+J4MaiLres6a3j8qYWMxSRo
 se4RzMXDqfUuhCcxwunIZNXlSnWZMt0XJcK3NVrMf8DL0pqC7yY5GWRstNJVHkign7kF
 aVErCtLEoWmKdAve9IGL2DClKL8yohkTM+fO18DTRWab/L/JCDnV/a1QXP4VcaBSe+en 5A== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2n7w0r68fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Oct 2018 09:37:06 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9Q9b5fs030925
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Oct 2018 09:37:05 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9Q9b4tF025539;
        Fri, 26 Oct 2018 09:37:04 GMT
Received: from mwanda (/129.205.6.86)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 26 Oct 2018 02:37:04 -0700
Date:   Fri, 26 Oct 2018 12:36:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Adham.Abozaeid@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Venkateswara.Kaja@microchip.com, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Mrutyunjaya.Satapathy@microchip.com,
        Aditya.Shankar@microchip.com, Sripad.Balwadgi@microchip.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 2/4] stagign: wilc1000: validate cfg parameters before
 scheduling the work
Message-ID: <20181026093640.4b34wgabx5jmxo47@mwanda>
References: <20181025210849.20006-1-adham.abozaeid@microchip.com>
 <20181025210849.20006-3-adham.abozaeid@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181025210849.20006-3-adham.abozaeid@microchip.com>
User-Agent: NeoMutt/20170609 (1.8.3)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9057 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=392
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810260085
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 25, 2018 at 09:11:00PM +0000, Adham.Abozaeid@microchip.com wrote:

You'll need to resend these because your email from header is in the
wrong format.  Also there is a typo in the subject.  s/stagign/staging/.

regards,
dan carpenter

