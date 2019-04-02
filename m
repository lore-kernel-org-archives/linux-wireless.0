Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F040DC43381
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 07:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDD80206BA
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 07:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e5L4COcU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfDBHDy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 03:03:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46590 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfDBHDx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 03:03:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3273jTO176567;
        Tue, 2 Apr 2019 07:03:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=6g54tw/pqLGqiV4vCAmhP/QZdO9/DaUGgXt4q3oSsCc=;
 b=e5L4COcUsI4Uuihh0bMTqtntc7gS0eupaTBGqHEilfHY8akF4eMpJioddFh35UtWz103
 5fnjUiSjpYkh3KsPTKev8xrowrP+/Cwp1eZTbr8nxDUa5cG9OVKAINsW6WfbrijUdwB8
 08riW4gG1EZQpel2dm7SQSn7Anbr+nTFbSxJrEQAhawwbvoIwsP/5KS75AVg4XbXmSRL
 KzfNG4//SoXiwosqZ/R/6lEuEZuhRLeMIMio3R03FdAhJILW/vqFKNl8Wf0itPdr3CIB
 YnIm/Y+WXPXyXmS4e5nNFplnDVZnYilBb6cWkJWdwsyHEcMlDUkUP+f75BOV7aGSsoqw Kw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2rj13q33a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Apr 2019 07:03:48 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x3273m23017075
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Apr 2019 07:03:48 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3273lsq020094;
        Tue, 2 Apr 2019 07:03:47 GMT
Received: from kadam (/41.202.241.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 00:03:46 -0700
Date:   Tue, 2 Apr 2019 10:03:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>
Cc:     Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] mwifiex: add a bounds check in
 mwifiex_process_sta_rx_packet()
Message-ID: <20190402070338.GB15171@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9214 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020052
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Smatch complains that "local_rx_pd->priority" can't be trusted because
it comes from skb->data and it can go up to 255 instead of being capped
in the 0-7 range.  A few lines earlier, on the other side of the if
statement, we cap priority so it seems harmless to add a bounds check
here as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_rx.c b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
index fb28a5c7f441..52a2ce2e78b0 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
@@ -250,7 +250,8 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 							     local_rx_pd->nf);
 		}
 	} else {
-		if (rx_pkt_type != PKT_TYPE_BAR)
+		if (rx_pkt_type != PKT_TYPE_BAR &&
+		    local_rx_pd->priority < MAX_NUM_TID)
 			priv->rx_seq[local_rx_pd->priority] = seq_num;
 		memcpy(ta, priv->curr_bss_params.bss_descriptor.mac_address,
 		       ETH_ALEN);
-- 
2.17.1

