Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E942AC04EBA
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 14:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0658205C9
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 14:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uRkjh+oP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0658205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732676AbeK3BaD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 20:30:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42778 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731418AbeK3BaC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 20:30:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wATEOBTP032010;
        Thu, 29 Nov 2018 14:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=z0HMQ0FMaiN2gG5w3fbStGaOhBIrOhoBtrax2U450G0=;
 b=uRkjh+oPkStMRA7zIDEXTONqU+LXu4K0US09zQZUex5NiopRI4iAU5W1scwNRXM0ITwR
 Cu9ucqztsgCqMFfvBaHdyMalr/FaG2EcH6kWI8xtWRr3ovWuuUQaHG21K8YOTcmafA/k
 zY8lJrJDlAZMJrK+heBTz9yi5ZNqkbkhwKnXx6PzrBI2zqcQ5+q/rXhPYUL5eZ6MlJ2a
 gVv7CqjF/5mV3cl6jOozr2SNmMqVjEwNxZ1rB/kf1N2orlBl8ILt0Ob3O5kbvGQWAjtI
 XSItAimq6DLqkkTwMoe2uZKV7GaiOR8w+EinT62LkQdHsVywL/ebfvJ+N4G5Y+JBM4xV Ew== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nxxkqre0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Nov 2018 14:24:15 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wATEOFLg010832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Nov 2018 14:24:15 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wATEOEhZ030754;
        Thu, 29 Nov 2018 14:24:14 GMT
Received: from unbuntlaptop (/197.157.34.169)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 06:24:13 -0800
Date:   Thu, 29 Nov 2018 17:24:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, kernel-janitors@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: remove an unnecessary NULL check
Message-ID: <20181129142406.GV3073@unbuntlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181129103214.5tudci6izlfaasqx@kili.mountain>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9091 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811290121
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The "survey" pointer is the address of an array element.  We know that
it can't be NULL so this check can be removed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Resending with linux-wireless Cc for patchwork.

 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 659513bf4ddc..6a04727b63ce 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2578,7 +2578,7 @@ static void ath10k_wmi_event_chan_info_unpaired(struct ath10k *ar,
 
 	survey = &ar->survey[idx];
 
-	if (!params->mac_clk_mhz || !survey)
+	if (!params->mac_clk_mhz)
 		return;
 
 	memset(survey, 0, sizeof(*survey));
-- 
2.11.0
