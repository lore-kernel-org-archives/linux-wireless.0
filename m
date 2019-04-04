Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADFDC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3687920855
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:44:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nbhlmk3q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfDDIoj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 04:44:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42648 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfDDIoj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 04:44:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x348hoHZ084244;
        Thu, 4 Apr 2019 08:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=qaVX+yQ9zO/qL9qIa7oRGFDQ6xYEpTxGDDAjwau/B/o=;
 b=Nbhlmk3qxAvtOdFp1u1jjuyzM2/gYpaf+CVviExT0KUcoi6vW0x6XlrsTmR72P1qdpCJ
 YroYet1nNUlcJAbLdlD2qVpzTmpfHoOEZ8cui+To4NacHx64FxlvpvTKp+rxP5HzwQtr
 gEHaiNzDPYFX9AdOmz7dkwOl8sf5HrH+sUaXzuT4LXLty8LeFOAYg4I561C4yetRSW0s
 KrsiaJ+sjZCdcVP5ekUbQRTt3X9GO77j+/+zUWmiNRAOZ5VIopzSCZv3ysty8O2mvYPU
 zFYdAutBQ2LPGsNzwSdnrPRyCfUpyUAu59xkPiKtReW7TcLaFGHDl8D3kBvOMF/ChI12 DQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2rhyvtdruw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Apr 2019 08:44:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x348hLog095314;
        Thu, 4 Apr 2019 08:44:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2rm8f5smmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Apr 2019 08:44:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x348iW8J025315;
        Thu, 4 Apr 2019 08:44:32 GMT
Received: from kadam (/41.202.241.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Apr 2019 01:44:32 -0700
Date:   Thu, 4 Apr 2019 11:44:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Cc:     Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] mwifiex: prevent an array overflow
Message-ID: <20190404084423.GB20193@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=938
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904040063
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=978 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904040063
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The "rate_index" is only used as an index into the phist_data->rx_rate[]
array in the mwifiex_hist_data_set() function.  That array has
MWIFIEX_MAX_AC_RX_RATES (74) elements and it's used to generate some
debugfs information.  The "rate_index" variable comes from the network
skb->data[] and it is a u8 so it's in the 0-255 range.  We need to cap
it to prevent an array overflow.

Fixes: cbf6e05527a7 ("mwifiex: add rx histogram statistics support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/marvell/mwifiex/cfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfp.c b/drivers/net/wireless/marvell/mwifiex/cfp.c
index bfe84e55df77..f1522fb1c1e8 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfp.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfp.c
@@ -531,5 +531,8 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 		rate_index = (rx_rate > MWIFIEX_RATE_INDEX_OFDM0) ?
 			      rx_rate - 1 : rx_rate;
 
+	if (rate_index >= MWIFIEX_MAX_AC_RX_RATES)
+		rate_index = MWIFIEX_MAX_AC_RX_RATES - 1;
+
 	return rate_index;
 }
-- 
2.17.1

