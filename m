Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1A3ECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 08:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D0C1214C3
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 08:00:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D0C1214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727292AbeJQPzM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 11:55:12 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41996 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJQPzM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 11:55:12 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gCgl0-0003fo-Eo; Wed, 17 Oct 2018 10:00:42 +0200
Message-ID: <361341a653e523dfe73a0dbcc9472b2246c18d63.camel@sipsolutions.net>
Subject: Re: [bug report] iwlwifi: mvm: kill INACTIVE queue state
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-wireless@vger.kernel.org, sara.sharon@intel.com
Date:   Wed, 17 Oct 2018 10:00:29 +0200
In-Reply-To: <20181017075534.anxr76wuf2rg4xxe@kili.mountain> (sfid-20181017_095553_400686_E94AC3D4)
References: <20181017075534.anxr76wuf2rg4xxe@kili.mountain>
         (sfid-20181017_095553_400686_E94AC3D4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dan,

>   1239                  ret = iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
>   1240                                                     inactive_tid_bitmap,
>   1241                                                     &unshare_queues,
>   1242                                                     &changetid_queues);
>   1243                  if (ret >= 0 && free_queue < 0)
>                             ^^^^^^^^
> 
> The iwl_mvm_remove_inactive_tids() returns a bool so it doesn't make
> sense to test for >= 0.  Probably we should test for ret == true?

Huh, thanks for the report, we'll check.

johannes

