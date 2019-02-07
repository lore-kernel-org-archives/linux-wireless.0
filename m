Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743EAC282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37AFA21872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="276eWrT0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfBGLk5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:40:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57590 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfBGLk5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 06:40:57 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x17BcvPH044170;
        Thu, 7 Feb 2019 11:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=I9SvguprerubbLH7i7K6bC4P8bKFNdDwurp26S03D7w=;
 b=276eWrT0NyQB7XmeizsmHvloFzc0zhuDAdyPO4M9ZxmVZ7cyLhqZ04pYUwohBkKuemmC
 1PdBdJcWtBXWg4LT3Oxq4m4KHLbG1AHNmqCekJuE7Sp3PWjD0JGQPg5yGJDNyZ1FgavW
 OEjLK579vjH74t3WGOc4Ko922MFILJ4LefEQMc75P9CQ+usussAf5rcCGRlAcmPsAD8i
 zUTkU0W3Iq+dn8sPljsLqu4Bbrdzjwp7sztkKkwO+/TqQ+RDtcMHerlr80LyLrpl3Msr
 sidOPvIDIK1YFezQUuJmdv5ui9N9mtkVhb5RT8Sxl214oQcTvOSJsB73fzGAZC8KCwuc sA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2qd97f6ehy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Feb 2019 11:40:50 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x17BemcL028337
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Feb 2019 11:40:49 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x17Bem7h031938;
        Thu, 7 Feb 2019 11:40:48 GMT
Received: from kadam (/41.202.241.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 11:40:47 +0000
Date:   Thu, 7 Feb 2019 14:40:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Adham.Abozaeid@microchip.com, johannes@sipsolutions.net
Subject: Re: [PATCH v2 1/8] staging: wilc1000: fix to set correct value for
 'vif_num'
Message-ID: <20190207114030.GF1978@kadam>
References: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
 <1549538913-17463-2-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549538913-17463-2-git-send-email-ajay.kathat@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9159 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=633 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902070092
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thanks so much!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

