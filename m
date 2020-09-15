Return-Path: <SRS0=aUvw=CY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C03C43461
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Sep 2020 07:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7792221974
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Sep 2020 07:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="mc5t4Ime"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgIOHsu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:48:50 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:59078 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbgIOHs2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Sep 2020 03:48:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600156079; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=W32IgH57Hj5dl+0sEOytcbwKGgZ4gitRgZ5Qp0ad3f4=; b=mc5t4ImeliOf8rz75LZzzijXWv9jsjO5QjHD94lWzh/5DWllXjBnJhH+l+/2bR+DkDRDpgf1
 cUhXSdyWglOJz+ms+douEHVQOFNPhN9gHOK5vNvnxMlW4QJ9tXC3NPJmyRXszckGtp9OHLio
 H4K3myjKgnbSrbhTLuKZBdStNn4=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f60719c25e1ee7586331312 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Sep 2020 07:47:40
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BB42BC433CA; Tue, 15 Sep 2020 07:47:39 +0000 (UTC)
Received: from Pillair (unknown [49.205.240.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4EE2C433C8;
        Tue, 15 Sep 2020 07:47:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A4EE2C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     <ath10k@lists.infradead.org>, "'Kalle Valo'" <kvalo@codeaurora.org>
Cc:     <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1593197633-9014-1-git-send-email-pillair@codeaurora.org>
In-Reply-To: <1593197633-9014-1-git-send-email-pillair@codeaurora.org>
Subject: RE: [PATCH v2 0/2] ath10k: Fixes during subsystem recovery
Date:   Tue, 15 Sep 2020 13:17:34 +0530
Message-ID: <005d01d68b34$7bfc4960$73f4dc20$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHK1UA7L8ou4VjNidoeHu16b5pDlqmAvSNg
Content-Language: en-us
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Rakesh Pillai <pillair@codeaurora.org>
> Sent: Saturday, June 27, 2020 12:24 AM
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org; Rakesh
> Pillai <pillair@codeaurora.org>
> Subject: [PATCH v2 0/2] ath10k: Fixes during subsystem recovery
> 
> This patch series includes some fixes when the device
> is in recovery mode, i.e. when the firmware goes down.
> 
> - Pausing TX queues when FW goes down
> - Removed unwanted/extra error logging in pkt TX path
> - Skipping wait for FW response for delete cmds
> - Handling the -ESHUTDOWN error code in case of SSR.
> 
> Rakesh Pillai (2):
>   ath10k: Pause the tx queues when firmware is down
>   ath10k: Skip wait for delete response if firmware is down
> 
>  drivers/net/wireless/ath/ath10k/core.h |  1 +
>  drivers/net/wireless/ath/ath10k/mac.c  | 36 ++++++++++++++++++++++---
> ---------
>  drivers/net/wireless/ath/ath10k/snoc.c |  3 +++
>  3 files changed, 28 insertions(+), 12 deletions(-)

Hi Kalle,
I see that this patch series is in Deferred state. Is there something
missing or blocking this ?


> 
> --
> 2.7.4


