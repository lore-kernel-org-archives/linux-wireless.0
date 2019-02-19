Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753ADC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41BC421736
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eljBZsBp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FWX9mYuE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbfBSPLn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:11:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38826 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbfBSPLm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:11:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 684D76081B; Tue, 19 Feb 2019 15:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589101;
        bh=E8vYhvppKjv7eOQ2RFs0ilmz3jZnDQzGfB+JV8n1PNY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eljBZsBpSleZ7Es5va8ta5g1TJ5f5dbZ0Dq+VWStEoJkrrOxjrA9efcB8n/KQKgff
         Q58BnAOqQd5QUVV0CqauaTYuM5I+CZuQOdebQ3H1Pkje+fXsKIGwhTzb28ycIQLHV9
         0Knnvpggl1FzMC7GUej5JcXvEO1BjueCBHEsghBQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BAC246071A;
        Tue, 19 Feb 2019 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589100;
        bh=E8vYhvppKjv7eOQ2RFs0ilmz3jZnDQzGfB+JV8n1PNY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=FWX9mYuEY8LQuVma4/DNc9YpslJS690x5vvk++kDsc0KkZ80g0eYAg557rkz60PVf
         ImpFN4v6Pk0A+8NVuHKtZZ3lYB4yc4eZXCMLJpqqJoK/zYm/B7PKTx0jdaUY0QAqP8
         g6C3tgvQ/T5ri6y/CVo5SMN6KESvyl7h9CeTDacM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BAC246071A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas_tf: move the banner to a more appropriate place
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190210194811.18345-1-lkundrak@v3.sk>
References: <20190210194811.18345-1-lkundrak@v3.sk>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151141.684D76081B@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:11:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lubomir Rintel <lkundrak@v3.sk> wrote:

> Also, turn it to a dev_info() to make checkpatch.pl happy.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Reviewed-by: Steve deRosier <derosier@cal-sierra.com>

Patch applied to wireless-drivers-next.git, thanks.

c7a5682ded7e libertas_tf: move the banner to a more appropriate place

-- 
https://patchwork.kernel.org/patch/10804877/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

