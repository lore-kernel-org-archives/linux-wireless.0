Return-Path: <SRS0=Sl5Z=XU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D5AC432C2
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 11:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D693B21D79
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 11:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WXIYtU+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403781AbfIYLAC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Sep 2019 07:00:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48494 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390611AbfIYLAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Sep 2019 07:00:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsSwm039681;
        Wed, 25 Sep 2019 10:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=pw+m52Dw3fR68sPSFV1DM9suPWwDDCArrqQx6Je7DL4=;
 b=WXIYtU+5nASD6o2SrArZSyqgCQz+KRFFxLNEUtrOb+SqJyqGAPwWQpVcMviiiKcsWCQ1
 5tJDtS9xr0SBiGuckr36x4DxgbCx6m7xHz7IuvoHPcn4foEgAJ9l10kiswf9uQfwBMGH
 R3J+drpDxiPZxIxeJfyZRqzlhioSAr1cT2rA1wAe8FadW0MzPabSmfkTHMEduyDomHx5
 kePy1GgPbLweWrWzmHbgnWgyZ/o082dGEVuM8jyBZP10KGEz5VpGGdEMo6rD5umHR96N
 3E2tdn0dWVEKz9Ffr5Jby4pIT6488AVYcECBPr7G2ovKhfoyzNMn6o20J8f+4E2viy6P jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btq3w15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:59:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAxAn6147971;
        Wed, 25 Sep 2019 10:59:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v829uuuva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:59:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PAxn0T019966;
        Wed, 25 Sep 2019 10:59:50 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 03:59:49 -0700
Date:   Wed, 25 Sep 2019 13:59:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Solomon Peachy <pizza@shaftnet.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cw1200: Fix a signedness bug in cw1200_load_firmware()
Message-ID: <20190925105943.GJ3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250112
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The "priv->hw_type" is an enum and in this context GCC will treat it
as an unsigned int so the error handling will never trigger.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/st/cw1200/fwio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/fwio.c b/drivers/net/wireless/st/cw1200/fwio.c
index 6574e78e05ea..da767c33dfbb 100644
--- a/drivers/net/wireless/st/cw1200/fwio.c
+++ b/drivers/net/wireless/st/cw1200/fwio.c
@@ -321,7 +321,7 @@ int cw1200_load_firmware(struct cw1200_common *priv)
 	}
 
 	priv->hw_type = cw1200_get_hw_type(val32, &major_revision);
-	if (priv->hw_type < 0) {
+	if ((int)priv->hw_type < 0) {
 		pr_err("Can't deduce hardware type.\n");
 		ret = -ENOTSUPP;
 		goto out;
-- 
2.20.1

