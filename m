Return-Path: <SRS0=d+R+=CQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA32C433E2
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 08:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 180EC2145D
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 08:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pH1bzz8l";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="RuuTjXiY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgIGIc5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Sep 2020 04:32:57 -0400
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:49546
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727807AbgIGIc4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Sep 2020 04:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599467575;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=bdt7CH4iBSXvYVstdfe3DscgulNl5vlG+Xnzvjd1Z3s=;
        b=pH1bzz8lHwd139vbBgrE8jIlxo/A9dBcxAvqXqN6ztDGuh2+8xY3Z8zYvyDYDMb2
        3UHJdGQsxHkPo+2WAPd9m7rzt6aJJzlNhg9SLOcepTPXgwEk830k8EJq66BpnyO2fpB
        6lHY3odgDDxzZSbVR9tHQ93IklEYwqghrs9sbaJo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599467575;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=bdt7CH4iBSXvYVstdfe3DscgulNl5vlG+Xnzvjd1Z3s=;
        b=RuuTjXiYCAA27D3aNmsbuFawqPMMKRJxSmpPvalQrpmzl7/SyplR/WegfQaTXk/T
        +iwJM2yIJmvC6zmZH89mcX4vDjFwpbQd+TNoT+e4jejdARmSk6WYxbLq/yy/uJRWmTc
        hCVjtCrdFogDsvUdZBdQi4hONz4DTz/3Do1BotJs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A151AC2BBDF
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mwifiex: wmm: Fix -Wunused-const-variable warnings
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200902140846.29024-1-yuehaibing@huawei.com>
References: <20200902140846.29024-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <amitkarwar@gmail.com>, <ganapathi.bhat@nxp.com>,
        <huxinming820@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017467b259ad-76b3249a-44bd-4d07-b4e5-2b809c85197a-000000@us-west-2.amazonses.com>
Date:   Mon, 7 Sep 2020 08:32:55 +0000
X-SES-Outgoing: 2020.09.07-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> In file included from drivers/net/wireless/marvell/mwifiex//cmdevt.c:26:0:
> drivers/net/wireless/marvell/mwifiex//wmm.h:41:17: warning: ‘tos_to_tid_inv’ defined but not used [-Wunused-const-variable=]
>  static const u8 tos_to_tid_inv[] = {
>                  ^~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex//wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
>  static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>                   ^~~~~~~~~~~~~~~~~~~~~~~
> 
> move the variables definition to .c file, and leave declarations
> in the header file to fix these warnings.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

d56ee19a148e mwifiex: wmm: Fix -Wunused-const-variable warnings

-- 
https://patchwork.kernel.org/patch/11750655/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

