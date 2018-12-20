Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53960C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20E9B21720
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YmTv0pMl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="achpcDuQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbeLTHoZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 02:44:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbeLTHoZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 02:44:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 86AE2605A5; Thu, 20 Dec 2018 07:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545291864;
        bh=zLuBiKojDBTn93zznm5Ug2vtCDoV+QMULuobyVLdeAo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YmTv0pMleBP9D3q1Qq1+Cw0gq8rWZf0277khlE1GW9xaiJZVQn06EirQO6NsOkOZi
         2F5DoBqdKJkUlz5ll9ZoDLd4cgjA5Pr+YY8D++q2jRX0cyiO+FTirLaCoYLf9oIP4H
         Ej9AUqXYdb//O0r5dmBid8UNbhXFKfXSry+MXwrI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 677B7605A5;
        Thu, 20 Dec 2018 07:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545291864;
        bh=zLuBiKojDBTn93zznm5Ug2vtCDoV+QMULuobyVLdeAo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=achpcDuQp0jBv3F1uOxsRjH4XhrmfEIfPXmIe9w3OGasqZ5JzavYh3aRNQofvlWU2
         FABcx/s8zqYFOXPTHI1waoFRxancrHcTtAGgwzgdLYuUkGyPtPzP+rdO0dOx1Kx+mT
         UhZx6RqKrnWMgTatgKjZ3QB4NaHYOiFVemoYy4FA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 677B7605A5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless/wil6210: convert to DEFINE_SHOW_ATTRIBUTE
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181203132557.12269-1-tiny.windzz@gmail.com>
References: <20181203132557.12269-1-tiny.windzz@gmail.com>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     merez@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yangtao Li <tiny.windzz@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220074424.86AE2605A5@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 07:44:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yangtao Li <tiny.windzz@gmail.com> wrote:

> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

986b83488464 wil6210: convert to DEFINE_SHOW_ATTRIBUTE

-- 
https://patchwork.kernel.org/patch/10709547/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

