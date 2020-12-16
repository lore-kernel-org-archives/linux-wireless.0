Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC9EC4361B
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 19:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E64223E8
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 19:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733191AbgLPTHP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Dec 2020 14:07:15 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:41206 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733186AbgLPTHP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Dec 2020 14:07:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608145616; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=uPMZDqrSKV67hPSm7dD++P6l/wj/xXDR5YeFpsCDBdk=; b=JYfm/soDgtOtH5SidR9dsh97LLbyOBJ1DKiOj5JQfjyb+xry1reQiGS/HUpl1uZb8ymuC3BR
 AEurG5arKyeReky0pGy7/HmFCM2AMGUYMV/BACkP2FyDJyS2IrBsbX1+q8IzC12Vjs2Jn7fP
 qtg3rJ9brHIHynJ335uNta+cRF8=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fda5ab40564dfefcd0fa3a3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Dec 2020 19:06:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 31D5EC433CA; Wed, 16 Dec 2020 19:06:28 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA179C433C6;
        Wed, 16 Dec 2020 19:06:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA179C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name
Subject: Re: Fwd: [PATCH] mt76: mt76u: fix NULL pointer dereference in mt76u_status_worker
References: <20201216184429.GG2036@lore-desk>
Date:   Wed, 16 Dec 2020 21:06:24 +0200
In-Reply-To: <20201216184429.GG2036@lore-desk> (Lorenzo Bianconi's message of
        "Wed, 16 Dec 2020 19:44:29 +0100")
Message-ID: <87pn39vadr.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Since net-next is closed now I guess we can consider this patch for
> wireless-drivers

Ok, I assigned the two patches to me in patchwork. Felix, is this ok? I
hope you have not applied these to your tree yet.

Lorenzo, please don't forward patches as patchwork when creates a new
patch and the discussion is not visible in the original patch. Instead
reply normally to the original patch, this way patchwork stays clean.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
