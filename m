Return-Path: <SRS0=DQ7G=T4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2F4C072B1
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 12:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD09F208C3
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 12:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AVgCSGUs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P1pv4LSa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfE1MZY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 May 2019 08:25:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33284 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfE1MZY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 May 2019 08:25:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DF3AF601D4; Tue, 28 May 2019 12:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559046323;
        bh=AI20FMSNCMoT+7BIugoyP/HWgsbE34P8Gvcfdx+kBm8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AVgCSGUsuZtpSO5eqj6pCwcNAjF4ueGf8qXUgJVduZZHHW3ZDWRs/jVYDVa16hAfo
         aq2Lms1V8hnQRyDGDpjb5UnXYTDXbkL1HUlW2rVG0BBc/gCFT/GD+CoIdyMhzXqwSl
         KTMV5Cq69VkFUA0UTZ9ZIVYFi6ujnxCOKEe4MW7Q=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7AC39601D4;
        Tue, 28 May 2019 12:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559046323;
        bh=AI20FMSNCMoT+7BIugoyP/HWgsbE34P8Gvcfdx+kBm8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=P1pv4LSaJNbCFuRRT7xH+xrkJlJHNz9JT5LVnHBYSJmJ5+ChNtfulkgT5jp/W7rvO
         bCI+oRHyK/gzJEQsxUUvGcvjCedtTacbsiej+zBKLvah3n+0eU7ZFiUAuev1QzUDbP
         n6wtT0VuEKTn4LbKOTG33GiiLEQ2Zpy146H6/Ufo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7AC39601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brcmfmac: fix typos in code comments
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190520122825.981-1-houweitaoo@gmail.com>
References: <20190520122825.981-1-houweitaoo@gmail.com>
To:     Weitao Hou <houweitaoo@gmail.com>
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net, houweitaoo@gmail.com,
        rafal@milecki.pl, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528122523.DF3AF601D4@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 12:25:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Weitao Hou <houweitaoo@gmail.com> wrote:

> fix lengh to length
> 
> Signed-off-by: Weitao Hou <houweitaoo@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

b07e1ae2ce53 brcmfmac: fix typos in code comments

-- 
https://patchwork.kernel.org/patch/10950995/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

