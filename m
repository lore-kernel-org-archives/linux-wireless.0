Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEF0C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 07:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D9E520675
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 07:27:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lx8+gPqK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbfCFH1D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 02:27:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57028 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfCFH1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 02:27:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x267NMrW057331;
        Wed, 6 Mar 2019 07:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=1rpHDUHA5jJc9X4G0TMuwhlEDcL+vwA8XnYP39g7osg=;
 b=lx8+gPqKeUtXilDBxr2m8IPftnxjN2LLMWGhP0HI6MvVIPX7oHCIOuoYVVwuH66GrJCI
 NkBel+ZBE2zvu7an/LAiJPm++hSGNLGFA+o5WbrWB5/46aKzuePQVs/+tmSHJ5jhXL+L
 u+9uai+GeqUr8ob1SnUTlYc5HJ6IALDwKjJ1x8DdpIso1eab/snFnR/8IvEUqtRSOZeP
 16L2jtmmdMOQxg+OgrUqAT7lkkQweJeArUuJaV2jM9CDlkNaisiENvr2oTSiJEeWGMmH
 YWHiLFjJ6fDxi7lmXQEthADtKP5ZCiXQy02P2JKfQ4z5zxcJgjXSRhzy9N1adweJqkpt qg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qyh8ua1nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Mar 2019 07:26:47 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x267Qkun004670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Mar 2019 07:26:46 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x267QggI021022;
        Wed, 6 Mar 2019 07:26:45 GMT
Received: from kadam (/41.202.241.15)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Mar 2019 23:26:42 -0800
Date:   Wed, 6 Mar 2019 10:26:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] mt76: Fix an IS_ERR() vs NULL check in mt76_wmac_probe()
Message-ID: <20190306072633.GA2625@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9186 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903060051
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The devm_ioremap_resource() function never returns NULL, it returns
error pointers.

Fixes: c8846e101502 ("mt76: add driver for MT7603E and MT7628/7688")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
index e13fea80d970..b920be1f5718 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
@@ -23,9 +23,9 @@ mt76_wmac_probe(struct platform_device *pdev)
 	}
 
 	mem_base = devm_ioremap_resource(&pdev->dev, res);
-	if (!mem_base) {
+	if (IS_ERR(mem_base)) {
 		dev_err(&pdev->dev, "Failed to get memory resource\n");
-		return -EINVAL;
+		return PTR_ERR(mem_base);
 	}
 
 	mdev = mt76_alloc_device(&pdev->dev, sizeof(*dev), &mt7603_ops,
-- 
2.17.1

