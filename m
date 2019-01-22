Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07786C282C5
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC0FB20879
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:59:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cH8Z0c7W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfAVM7x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:59:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49910 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbfAVM7w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 07:59:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0MCxjrq048529;
        Tue, 22 Jan 2019 12:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=gVeSWBkxQiyX4GOjNwFiDyIaSwryxb/Os8cLeyaBFSA=;
 b=cH8Z0c7W7Ta9Mnrlwvz0U2TII/s8kBhg4CNlaYOf3XVX777jOSsFE3Dyr98jbGzee8mG
 jWZkQGguBuIIgzFXLIeUyPfoCXY+Np3iAoxU1hzW/suV1r0Q1VMz4Y+Cw/ny/Xqa583X
 2+PlLYmI+MP1cbFPL9QnfOOFcLuBhOmKdWk5a6okQ5bkdMemNPwtckGuKRwQU2n1xiyB
 1q4dP9gHv5Ny2oAfnvrwFSkzqFbTJD7mWsoS+IvkD98ae36n6aw6w+EB9TudnY9Nc0Uv
 uTYh7bdPJOjOP/QYgFqnvjletZsn5IORyjANBmCL7V9uE91tKsD0V2Su8euBmxDWMf9i pw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2q3vhrk9n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jan 2019 12:59:45 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0MCxRms023988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jan 2019 12:59:27 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0MCxQWu016639;
        Tue, 22 Jan 2019 12:59:26 GMT
Received: from kadam (/197.157.34.164)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Jan 2019 04:59:26 -0800
Date:   Tue, 22 Jan 2019 15:59:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Zhiwei Jiang <qq282012236@gmail.com>
Cc:     kbuild-all@01.org, qq282012236@gmail.com,
        ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath: move spin_lock_bh to spin_lock in tasklet
Message-ID: <20190122125902.GD11828@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190119105530.6079-1-qq282012236@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9143 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=901
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901220103
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Zhiwei,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Zhiwei-Jiang/ath-move-spin_lock_bh-to-spin_lock-in-tasklet/20190121-185529
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master

smatch warnings:
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:584 ath9k_tx_failed_tasklet() warn: inconsistent returns 'bottom_half:'.
  Locked on:   line 584
  Unlocked on: line 580

# https://github.com/0day-ci/linux/commit/953929a8fc22ae7ab9adafed62c84a11c4be2270
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 953929a8fc22ae7ab9adafed62c84a11c4be2270
vim +584 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c

27876a29 Sujith Manoharan 2011-04-13  572  
27876a29 Sujith Manoharan 2011-04-13  573  void ath9k_tx_failed_tasklet(unsigned long data)
27876a29 Sujith Manoharan 2011-04-13  574  {
27876a29 Sujith Manoharan 2011-04-13  575  	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
b587fc81 Sujith Manoharan 2011-04-13  576  
953929a8 Zhiwei Jiang     2019-01-19  577  	spin_lock(&priv->tx.tx_lock);
27876a29 Sujith Manoharan 2011-04-13  578  	if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
27876a29 Sujith Manoharan 2011-04-13  579  		spin_unlock_bh(&priv->tx.tx_lock);
                                                                   ^^^
Missed this one.

27876a29 Sujith Manoharan 2011-04-13  580  		return;
b587fc81 Sujith Manoharan 2011-04-13  581  	}
953929a8 Zhiwei Jiang     2019-01-19  582  	spin_unlock(&priv->tx.tx_lock);
b587fc81 Sujith Manoharan 2011-04-13  583  
27876a29 Sujith Manoharan 2011-04-13 @584  	ath9k_htc_tx_drainq(priv, &priv->tx.tx_failed);
b587fc81 Sujith Manoharan 2011-04-13  585  }
27876a29 Sujith Manoharan 2011-04-13  586  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
