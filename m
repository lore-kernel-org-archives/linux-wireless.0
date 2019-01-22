Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88ECC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 793D720870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:24:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LSLh7O3c";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JeNtrQcX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbfAVQYX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:24:23 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728669AbfAVQYX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 11:24:23 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A2EFE609C2; Tue, 22 Jan 2019 16:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548174261;
        bh=iwuux+PLy64yLtyeY1kzGq3fqWTXjGf1OJ8fz5xddeo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LSLh7O3cMGU1IAaMNnCdzWz9Yz5Krl/WCJsjT3jz6B2j1xIIi3bMmCQuLfpWRp3OG
         SdIDWR9/y1NiypCWgyiXLdyrVjPDEWxrQop9HhiFpus0GU5qoiLuJKxaB8W3MDQlca
         VtoP5j2laBUBnh9z2CjqeT9ndBxYH6l2tde77Wu4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D938D60995;
        Tue, 22 Jan 2019 16:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548174259;
        bh=iwuux+PLy64yLtyeY1kzGq3fqWTXjGf1OJ8fz5xddeo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=JeNtrQcXAWJgXNsjbWWiC6gZMQrcDbWuHFHFGq1chskqxAoAkC2KwZYSa4Sa9OKQn
         P2lUU1nLWzrNIKsp0JJOQEeAXBdPhvNd7IIagYERcHN9sj3KpRw5x8vXEZGcEOkSLf
         /qLJ/e2jIKdrABKz0/lxl/qjIDXSloMTZZ4NSIlE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D938D60995
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190116113723.15668-1-ulf.hansson@linaro.org>
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190122162421.A2EFE609C2@smtp.codeaurora.org>
Date:   Tue, 22 Jan 2019 16:24:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> wrote:

> During "wlan-up", we are programming the FW into the WiFi-chip. However,
> re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
> is made in-between the programmings.
> 
> To conform to this requirement and to fix the regression in a simple way,
> let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
> (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
> current code is to treat this scenario as an error, but unfortunate this
> doesn't work as expected, so let's fix this.
> 
> The other part is to guarantee that a power cycle of the SDIO card has been
> completed when wl12xx_sdio_power_on() returns, as to allow the FW
> programming to succeed. However, relying solely on runtime PM to deal with
> this isn't sufficient. For example, userspace may prevent runtime suspend
> via sysfs for the device that represents the SDIO card, leading to that the
> mmc core also keeps it powered on. For this reason, let's instead do a
> brute force power cycle in wl12xx_sdio_power_on().
> 
> Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Anders Roxell <anders.roxell@linaro.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Patch applied to wireless-drivers.git, thanks.

13e62626c578 wlcore: sdio: Fixup power on/off sequence

-- 
https://patchwork.kernel.org/patch/10765781/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

