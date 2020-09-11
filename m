Return-Path: <SRS0=g1I5=CU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF777C43461
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 09:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84D8B2078D
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 09:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U0RZCo8P";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="TVTlS3B/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgIKJ7X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Sep 2020 05:59:23 -0400
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:47052
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgIKJ7T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Sep 2020 05:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599818359;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=U0meEUz4aGuUw+kGbyj6MMa66pIP6tpJxlVsPbQ3jvQ=;
        b=U0RZCo8PH2fWGCET0rglrRu/nrGrud8rNNfjVqY4l7ZDUNBsZ7kJ2DUzFYRVbwJQ
        GMVk7qdmW84hIzFCl7/MWDdgxLX0RyIJzGs0g86PPgVhoetO/myQJh5s1ocL/dzUBeJ
        UNpOS0YKRwnnX298DFHh6S0WFyGA/+y0uuX/bzcE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599818359;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=U0meEUz4aGuUw+kGbyj6MMa66pIP6tpJxlVsPbQ3jvQ=;
        b=TVTlS3B/xbNZw1CwU8+fsf/P3djUnJkgdxREWK7Tpg7dFwgroPIkGHIEYTFactBr
        y0mbqACnqJU2N0dxXNm0Y63gRF+op1lLBZslGnpi6QwZ7bdDY/4OMVKRtUUaoSZZpM4
        utM6WOxd3+EFS6jYTkJa/F/qbh2Pql7jZnb5o40I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5867BC433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Remove unused macro ATH10K_ROC_TIMEOUT_HZ
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200909135834.38448-1-yuehaibing@huawei.com>
References: <20200909135834.38448-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <010101747c9ae0e8-fd3a6153-8f8f-4b94-9368-96729d6a71a6-000000@us-west-2.amazonses.com>
Date:   Fri, 11 Sep 2020 09:59:19 +0000
X-SES-Outgoing: 2020.09.11-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> There is no caller in tree, so can remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

42a08ff79ff5 ath10k: Remove unused macro ATH10K_ROC_TIMEOUT_HZ

-- 
https://patchwork.kernel.org/patch/11765703/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

