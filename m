Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E4DC433FE
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Dec 2020 04:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC5523770
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Dec 2020 04:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438232AbgLLEjF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Dec 2020 23:39:05 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:44451 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391871AbgLLEjA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Dec 2020 23:39:00 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607747914; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=IJ9BKtkmFurzufUByPFvKW2OloQiifc6SxwwsjEiHmQ=;
 b=j3RDzlantQB7XYgKtrS5z3ZIdVZqtodyQg6xDIF07Vn1IMRsIbSyBelnTgiNzYWgdEDiH6Vn
 4OmXJGenEWSDTy7Uy/1k4U0WCQx/Lkv39DVssFwCw7Z67CTwuUKpN1H8D97EVT0Z7LubYCCw
 UQvvDgStydva9s6+RHBgd7wN0mI=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fd4492465f116f287021b50 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Dec 2020 04:37:56
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 66D87C43462; Sat, 12 Dec 2020 04:37:56 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D3D5C433CA;
        Sat, 12 Dec 2020 04:37:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4D3D5C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] ath10k: add option for chip-id based BDF selection
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201207231824.v3.1.Ia6b95087ca566f77423f3802a78b946f7b593ff5@changeid>
References: <20201207231824.v3.1.Ia6b95087ca566f77423f3802a78b946f7b593ff5@changeid>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        pillair@codeaurora.org, briannorris@chromium.org,
        dianders@chromium.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201212043756.66D87C43462@smtp.codeaurora.org>
Date:   Sat, 12 Dec 2020 04:37:56 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> wrote:

> In some devices difference in chip-id should be enough to pick
> the right BDF. Add another support for chip-id based BDF selection.
> With this new option, ath10k supports 2 fallback options.
> 
> The board name with chip-id as option looks as follows
> board name 'bus=snoc,qmi-board-id=ff,qmi-chip-id=320'
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> Tested-on: QCA6174 HW3.2 WLAN.RM.4.4.1-00157-QCARMSWPZ-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

2bc2b87bb35a ath10k: add option for chip-id based BDF selection

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201207231824.v3.1.Ia6b95087ca566f77423f3802a78b946f7b593ff5@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

