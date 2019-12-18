Return-Path: <SRS0=gBLi=2I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387F1C43603
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 19:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04FF5218AC
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 19:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="bUrMSw6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfLRTJ0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Dec 2019 14:09:26 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:53979 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727380AbfLRTJZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Dec 2019 14:09:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576696165; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=FmrSbughRb5n8XyH5anHgOxG9yeV+T7JSqx4uUH0uYQ=;
 b=bUrMSw6lPKe/lKlndQttcUObbteSgVZM5sUkFJxz6LDDTyvAaE2AJH8NHftMsYL1+stYDngO
 buTxw63oXsINicQXsWbvhuMAnLZUUQx2F6KOts21Vyp5VlBvuG0A+C16dDS7PkN3mn2JNdS7
 kHvtWAylfsbGVqNhwbB280yp8pI=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa7960.7f9b77a610a0-smtp-out-n02;
 Wed, 18 Dec 2019 19:09:20 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A4AF8C447A0; Wed, 18 Dec 2019 19:09:20 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66E4DC43383;
        Wed, 18 Dec 2019 19:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 66E4DC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] brcmfmac: Keep OOB wake-interrupt disabled when it
 shouldn't be enabled
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191215184224.11827-1-digetx@gmail.com>
References: <20191215184224.11827-1-digetx@gmail.com>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218190920.A4AF8C447A0@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 19:09:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Osipenko <digetx@gmail.com> wrote:

> NVIDIA Tegra SoCs do not like when OOB wake is enabled and WiFi interface
> is in DOWN state during suspend. This results in a CPU hang on programming
> OOB wake-up state of the GPIO controller during of system's suspend.
> 
> The solution is trivial: don't enable wake for the OOB interrupt when it
> should be disabled.
> 
> This fixes hang on Tegra20 (Acer A500) and Tegra30 (Nexus 7) devices which
> are using BCM4329 and BCM4330 WiFi chips respectively.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

a32de68edab7 brcmfmac: Keep OOB wake-interrupt disabled when it shouldn't be enabled

-- 
https://patchwork.kernel.org/patch/11293127/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
