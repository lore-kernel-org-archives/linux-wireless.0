Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B14DECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC232214C3
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:55:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L9AguzQR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC232214C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbeJQPuR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 11:50:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35422 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbeJQPuR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 11:50:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9H7nb7u051471;
        Wed, 17 Oct 2018 07:55:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=W8S4CnMwTeH3mvnsdEbIXr34YoHhHVp1a4fZhyTC7Q4=;
 b=L9AguzQRY2qlu0I27Ce1L1Nvcaq5SPr6INpJNJ+n6ocRQI1JR+i3hpgWVcgHxlru5DOD
 3f4kcyhpIX90fBZIGlFujlmm11POy9eymuiCLcRenY3EcVR1VKuLBcRRiq1hItZdW0W4
 h395x93MS6tcNqaizC4rn1QeBb890O5mJLfyZ7r/vsKr+wMgveyYo2bPBrjSCgt0IMtg
 1cbYRuTbgc3sq5FCK/DOOq8yMA4oi9uNplsnOkC2r0S/aFilg7daUgLhkHsr64SbH3zP
 U8YnACPSspG5PndiX99yEihTwjgPLe4Kbti5CddBTKapSm4rLcFxrHeCnxZN9CidB29N GA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2n384u5d00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 07:55:49 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9H7tgdt029029
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 07:55:43 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9H7tguS023023;
        Wed, 17 Oct 2018 07:55:42 GMT
Received: from kili.mountain (/129.205.6.86)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 00:55:41 -0700
Date:   Wed, 17 Oct 2018 10:55:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     johannes.berg@intel.com
Cc:     linux-wireless@vger.kernel.org
Subject: [bug report] iwlwifi: mvm: kill INACTIVE queue state
Message-ID: <20181017075534.anxr76wuf2rg4xxe@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9048 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=373
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170072
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Johannes Berg,

The patch 724fe7710ac5: "iwlwifi: mvm: kill INACTIVE queue state"
from Jul 4, 2018, leads to the following static checker warning:

	drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1243 iwl_mvm_inactivity_check()
	warn: 'iwl_mvm_remove_inactive_tids(mvm, mvmsta, i, inactive_tid_bitmap, &unshare_queues, &changetid_queues)' is unsigned

drivers/net/wireless/intel/iwlwifi/mvm/sta.c
  1223                  /*
  1224                   * If the STA doesn't exist anymore, it isn't an error. It could
  1225                   * be that it was removed since getting the queues, and in this
  1226                   * case it should've inactivated its queues anyway.
  1227                   */
  1228                  if (IS_ERR_OR_NULL(sta))
  1229                          continue;
  1230  
  1231                  mvmsta = iwl_mvm_sta_from_mac80211(sta);
  1232  
  1233                  /* this isn't so nice, but works OK due to the way we loop */
  1234                  spin_unlock(&mvm->queue_info_lock);
  1235  
  1236                  /* and we need this locking order */
  1237                  spin_lock(&mvmsta->lock);
  1238                  spin_lock(&mvm->queue_info_lock);
  1239                  ret = iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
  1240                                                     inactive_tid_bitmap,
  1241                                                     &unshare_queues,
  1242                                                     &changetid_queues);
  1243                  if (ret >= 0 && free_queue < 0)
                            ^^^^^^^^

The iwl_mvm_remove_inactive_tids() returns a bool so it doesn't make
sense to test for >= 0.  Probably we should test for ret == true?

  1244                          free_queue = ret;
  1245                  /* only unlock sta lock - we still need the queue info lock */
  1246                  spin_unlock(&mvmsta->lock);
  1247          }

regards,
dan carpenter
