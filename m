Return-Path: <SRS0=Ysg0=ZR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293AAC432C0
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 11:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E63DA207FD
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 11:51:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="m7HTmIvq";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Qm7vv1Hl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKYLvK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Nov 2019 06:51:10 -0500
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:56438
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbfKYLvK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Nov 2019 06:51:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574682669;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=XpjGUJp83UVgBT72TD+mw58jNf4gK89doIdvMQ7q054=;
        b=m7HTmIvqYvMC4eFyq1uXWeriyVN8T2KJ1MKtpSScmYLfxhHlRdYaK8gHvH6eKbtX
        DcNZ9KRgrI+6WviNu21ZiMAUMJNOp11Ofx79NnuBJw0lOmlbDnta1zchP3k2aYge6D/
        8+qDiPzlq0KRDQOMksvNHdXBTd1kCT3BTmY6xH24=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574682669;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=XpjGUJp83UVgBT72TD+mw58jNf4gK89doIdvMQ7q054=;
        b=Qm7vv1HlZrOGNCRYuTJhYMhK4e1Jyk8Ho9urtHvKvBUo4pXTPxXu2RRAVyQDWsK7
        atxlbljWK+NJ8hRjDcahSCXPXPlaysR6mFvr6E//2mYe7ce+3HXTdcfZNTbzKd9a9jE
        uDHNveKux8mjE6+VaAu2sO7Pb9M0tQApBLaL26zk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E4E70C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: cosmetic cleanup to sdio files
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1571910849-11489-1-git-send-email-kvalo@codeaurora.org>
References: <1571910849-11489-1-git-send-email-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016ea266b0c8-ff4537a0-bfc2-4f05-9d2b-3e6cc871228c-000000@us-west-2.amazonses.com>
Date:   Mon, 25 Nov 2019 11:51:09 +0000
X-SES-Outgoing: 2019.11.25-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> Do some cosmetic cleanup while reviewing the files. No functional changes.
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

efd2f4c5016b ath10k: sdio: cosmetic cleanup
2246c2156590 ath10k: sdio: remove struct ath10k_sdio_rx_data::status

-- 
https://patchwork.kernel.org/patch/11208761/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

