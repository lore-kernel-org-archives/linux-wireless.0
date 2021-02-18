Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258F6C433DB
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Feb 2021 06:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E6664D9A
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Feb 2021 06:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhBRGRN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Feb 2021 01:17:13 -0500
Received: from z11.mailgun.us ([104.130.96.11]:26878 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232030AbhBRGKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Feb 2021 01:10:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613628612; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=iMz7EHT571xx8kxl+8qCeB4QCB5CKTslFq3goU5Cxz0=;
 b=SWYTzFkjAAEFyGEcM2PREyxQ3TI0LozIb7OSfVq8wnAg+F/u9IrfGqCzD4Gd3oxBZPaomcGw
 BYkIeIR9Q4VGuw+pi/k1E+2pZ2Uq96kxocVsGl9YEt1En6X3gb0rXs46HKuoi9hK5fP6nDhj
 gUt3RE1iUuMxISYFPpkh5lFstF0=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 602e04a8eb4f89cdf82957b7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 18 Feb 2021 06:09:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E0416C433CA; Thu, 18 Feb 2021 06:09:43 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9C7D1C433C6;
        Thu, 18 Feb 2021 06:09:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9C7D1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.12 1/2] mt76: fix tx skb error handling in
 mt76_dma_tx_queue_skb
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210216135119.23809-1-nbd@nbd.name>
References: <20210216135119.23809-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210218060943.E0416C433CA@smtp.codeaurora.org>
Date:   Thu, 18 Feb 2021 06:09:43 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> wrote:

> When running out of room in the tx queue after calling drv->tx_prepare_skb,
> the buffer list will already have been modified on MT7615 and newer drivers.
> This can leak a DMA mapping and will show up as swiotlb allocation failures
> on x86.
> 
> Fix this by moving the queue length check further up. This is less accurate,
> since it can overestimate the needed room in the queue on MT7615 and newer,
> but the difference is small enough to not matter in practice.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

2 patches applied to wireless-drivers.git, thanks.

ae064fc0e32a mt76: fix tx skb error handling in mt76_dma_tx_queue_skb
94f0e6256c2a mt76: mt7915: only modify tx buffer list after allocating tx token id

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210216135119.23809-1-nbd@nbd.name/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

