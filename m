Return-Path: <SRS0=hdaX=2H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B1DC43603
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Dec 2019 15:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F3C124650
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Dec 2019 15:30:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="hz98iM5p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfLQPaF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Dec 2019 10:30:05 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:42656 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728118AbfLQPaF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Dec 2019 10:30:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576596604; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Sxp0Uxph9M80mn/VZBTi9arxxIqvGaiv+JDv/KfaTdo=;
 b=hz98iM5pv+9nU7Z56P09tv7ZgEH8KWfHp6/IzILayg132V5Q202HHDho8FlAx0h3BgYqwRMe
 LAH+eQXuo6uLegXTKjNDLeJIOwrT2gDhRmhpcFCaQZfS47KYBFAty91XeesW1SywSTDZFxdA
 ciwUo3KgQ4GKrsSc0i8lNtLf6n0=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df8f478.7efb7ed1be30-smtp-out-n01;
 Tue, 17 Dec 2019 15:30:00 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76AB1C4479C; Tue, 17 Dec 2019 15:30:00 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2505CC433A2;
        Tue, 17 Dec 2019 15:29:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2505CC433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [RESEND] ath10k: add tx hw 802.11 encapusaltion offloading support
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191216092207.31032-1-john@phrozen.org>
References: <20191216092207.31032-1-john@phrozen.org>
To:     John Crispin <john@phrozen.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191217153000.76AB1C4479C@smtp.codeaurora.org>
Date:   Tue, 17 Dec 2019 15:30:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

John Crispin <john@phrozen.org> wrote:

> This patch adds support for ethernet rxtx mode to the driver. The feature
> is enabled via a new module parameter. If enabled to driver will enable
> the feature on a per vif basis if all other requirements were met.
> 
> Testing on a IPQ4019 based hardware shows a increase in TCP throughput
> of ~20% when the feature is enabled.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> Signed-off-by: John Crispin <john@phrozen.org>

Depends on:

50ff477a8639 mac80211: add 802.11 encapsulation offloading support

Currently in mac80211-next.

Patch set to Awaiting Upstream.

-- 
https://patchwork.kernel.org/patch/11293627/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
