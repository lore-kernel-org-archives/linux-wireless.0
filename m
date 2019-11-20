Return-Path: <SRS0=CMgv=ZM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A83C432C0
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Nov 2019 07:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF2520872
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Nov 2019 07:48:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KnL6bNv9";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="NjwOIFCd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfKTHsd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Nov 2019 02:48:33 -0500
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:40898
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbfKTHsd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Nov 2019 02:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574236112;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=Td9UoIh2oxTOly9i8kPl6hT3h1jyV40o2qD3doA/8oc=;
        b=KnL6bNv9tXjTgxS0MjioLABLMiUPPMIYctVZz8mUmTdpEykLPgBXgHCUhgIKb4Te
        57B4D+dk1NwMYI6jMsjU6+1+FV/CiUYWbWJknRp6pkMq3vyTJS4cp9NlOGIEIcHY7GQ
        t0epU1ZZItu490FOKNH3dzXrmrnBWcDtBYJNMjJo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574236112;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=Td9UoIh2oxTOly9i8kPl6hT3h1jyV40o2qD3doA/8oc=;
        b=NjwOIFCd6lPPLGX1owDgnTjiql/zakAEB0kECFxbvLbsgdJk13yHktpdyI36Aln/
        jqMarJjoinl8SUQK9R87NDNx8R9UuVCEKhq4E/l0Q6Q1Jk/gM4Jlkza7GWRzAL7uO/C
        VWwxKpYGlhwLmh3Smv256wdA+1nohnfbwAYeFvxo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8F9BBC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next v2] rtl8xxxu: Remove set but not used variable 'vif', 'dev',
 'len'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1574130314-25626-1-git-send-email-zhengbin13@huawei.com>
References: <1574130314-25626-1-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <Jes.Sorensen@gmail.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016e87c8c611-98e24f38-e5d6-45ae-b904-5a1ca8e3de9a-000000@us-west-2.amazonses.com>
Date:   Wed, 20 Nov 2019 07:48:32 +0000
X-SES-Outgoing: 2019.11.20-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5396:24: warning: variable vif set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5397:17: warning: variable dev set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5400:6: warning: variable len set but not used [-Wunused-but-set-variable]
> 
> They are introduced by commit e542e66b7c2e ("rtl8xxxu:
> add bluetooth co-existence support for single antenna"), but never used,
> so remove them.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Reviewed-by: Chris Chiu <chiu@endlessm.com>

Patch applied to wireless-drivers-next.git, thanks.

eac08515d7bd rtl8xxxu: Remove set but not used variable 'vif','dev','len'

-- 
https://patchwork.kernel.org/patch/11250639/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

