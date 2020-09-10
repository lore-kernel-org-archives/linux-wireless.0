Return-Path: <SRS0=qoP/=CT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B3AC433E2
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 16:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B107520829
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 16:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="b2kjpfb+";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="VCf1Y3n7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgIJQc6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Sep 2020 12:32:58 -0400
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:41792
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726434AbgIJQce (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Sep 2020 12:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599755553;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=4Fjo2jbfKJs0jj/mE1J1uJ+YhzsgWtAsfAtLfkSlWn8=;
        b=b2kjpfb+a4yp/EfmWpeN6OdgMxKHrgDqTNLh9LbkaDPICz4PftWjcDkL6UfOv8AE
        sPPt5SOrxNEkHSiX3d/tRXtriTF//FVN67Vu9Lkq/JoUZW+wb9ChFGp3aMZr3BwV2oB
        cFXiEDUVvwYYTImRYZSrIbLYq/qqs3/8VE/FLIPQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599755553;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=4Fjo2jbfKJs0jj/mE1J1uJ+YhzsgWtAsfAtLfkSlWn8=;
        b=VCf1Y3n7j14mzluf7LeETP5YzFuQ8sKGxlF95RB77dlyWBHH7fiPuaBFEyGu/UHO
        fjhknMNms+iuPLrSpkPwgESipLGVCP8mkM/HF4FeonNtUG/uO0xcr8ANnVtCt8N0kR0
        q4FJWgC3KCHIydBzYrWgpPJivA3t0P3mKRdfMhTE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BC1E2C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 25/29] ath9k: ar9001_initvals: Remove unused array
 'ar5416Bank6_9100'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910065431.657636-26-lee.jones@linaro.org>
References: <20200910065431.657636-26-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017478dc89a2-6deb7f77-18a0-4361-9c5e-975b047d556e-000000@us-west-2.amazonses.com>
Date:   Thu, 10 Sep 2020 16:32:33 +0000
X-SES-Outgoing: 2020.09.10-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/ath9k/ar9001_initvals.h:462:18: warning: ‘ar5416Bank6_9100’ defined but not used [-Wunused-const-variable=]
> 
> Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Already fixed in ath.git.

error: patch failed: drivers/net/wireless/ath/ath9k/ar9001_initvals.h:459
error: drivers/net/wireless/ath/ath9k/ar9001_initvals.h: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11766813/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

