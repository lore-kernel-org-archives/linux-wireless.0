Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3545C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 09:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FC6A20818
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 09:00:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ve423dsI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfBIJAW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 04:00:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47526 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfBIJAW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 04:00:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x198wmYO134053;
        Sat, 9 Feb 2019 09:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=m4n/Gp8z35HWMck4rGTXrZJtQLqwtnieH+ty0D7Lmas=;
 b=Ve423dsI6cmorI/CWoN8r8gwvsVeaWHkrALSzIiB+T9pMWHhn9v+C9PlNJeVBpUpaHjb
 mJG2n9tWqL6cyOTosBmbcdnWWWPgLRkKXR26VxlPhWJnMT1KDvDgFM/PUArutbxXnNl6
 qu5IA1ETbCUO+rCugU/tKEzpoA3NgxY8C/BWfBoGFBHsb+KYxXALwVveeD2fhD0LaQh6
 XJ+8JbstiS7snkre3XqkXXczlM38RiJHryUM+douSSQMWpJ1pF1CPRLI6IqQoVGfRgCv
 xFPFAEBTG6xiT9JgoRfpCOX25PCSdsrfkPzEt7qIS7mNIHBdADRIUE/qZsaNSdEc0zua lw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qhrek07uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Feb 2019 09:00:18 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1990HCx017995
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 9 Feb 2019 09:00:17 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1990HWH019985;
        Sat, 9 Feb 2019 09:00:17 GMT
Received: from kadam (/197.157.0.32)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Feb 2019 01:00:17 -0800
Date:   Sat, 9 Feb 2019 12:00:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc:     Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] rsi: fix a typo in a debug message
Message-ID: <20190209090009.GA4865@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9161 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902090067
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is a \b (backspace) character in the message that wasn't intended.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index aded1ae4fad5..1dbc0fbbef3f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -285,7 +285,7 @@ static void rsi_mac80211_cancel_hw_scan(struct ieee80211_hw *hw,
 			common->bgscan_en = false;
 		info.aborted = false;
 		ieee80211_scan_completed(adapter->hw, &info);
-		rsi_dbg(INFO_ZONE, "Back ground scan cancelled\b\n");
+		rsi_dbg(INFO_ZONE, "Back ground scan cancelled\n");
 	}
 	common->hwscan = NULL;
 	mutex_unlock(&common->mutex);
-- 
2.17.1

