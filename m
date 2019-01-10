Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C64BC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49C39206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L0ed/QbQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VmuslJGa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbfAJLlk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:41:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54428 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfAJLlk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:41:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E4956608A5; Thu, 10 Jan 2019 11:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120498;
        bh=kj+jUV+lvaRb5JSUzXbs08zH90ImkpuDcO/vNVlMBbc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=L0ed/QbQefZDehzKrH6aNHNBeDUM9OI7MWsJ581iiSR9kYSsC9A5iYee1vgdYWqZp
         jLxcjRP/xWxCOu9zQmkfAKTD1RRv0TVHiQz4EE19x0Oi+7wHdx4S29AjsW7Hqo/49k
         jjG0bHedcbfOx/tGgRpCZv5N//S9pYvVY9azMUVk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2035A60386;
        Thu, 10 Jan 2019 11:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120497;
        bh=kj+jUV+lvaRb5JSUzXbs08zH90ImkpuDcO/vNVlMBbc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=VmuslJGaPYnh/VELUN/2MkS4sV94heK7Z+UGrpa6nGcMEoIEDqTvCJdIAOefs5tc3
         UYZgKJmtbqNWZ5EyyRXrRMHRS2N00bQmu+iNY/YrRjNlxM12cjtIYi57KhNxy+8NW3
         bm3wF1XI3B8y1Sn+IkwIjC6YYQ4OZJwoRUU3xrEQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2035A60386
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brcmfmac: Use firmware_request_nowarn for the clm_blob
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190107133327.9297-1-hdegoede@redhat.com>
References: <20190107133327.9297-1-hdegoede@redhat.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110114138.E4956608A5@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:41:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> wrote:

> The linux-firmware brcmfmac firmware files contain an embedded table with
> per country allowed channels and strength info.
> 
> For recent hardware these versions of the firmware are specially build for
> linux-firmware, the firmware files directly available from Cypress rely on
> a separate clm_blob file for this info.
> 
> For some unknown reason Cypress refuses to provide the standard firmware
> files + clm_blob files it uses elsewhere for inclusion into linux-firmware,
> instead relying on these special builds with the clm_blob info embedded.
> This means that the linux-firmware firmware versions often lag behind,
> but I digress.
> 
> The brcmfmac driver does support the separate clm_blob file and always
> tries to load this. Currently we use request_firmware for this. This means
> that on any standard install, using the standard combo of linux-kernel +
> linux-firmware, we will get a warning:
> "Direct firmware load for ... failed with error -2"
> 
> On top of this, brcmfmac itself prints: "no clm_blob available (err=-2),
> device may have limited channels available".
> 
> This commit switches to firmware_request_nowarn, fixing almost any brcmfmac
> device logging the warning (it leaves the brcmfmac info message in place).
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

4ad0be160544 brcmfmac: Use firmware_request_nowarn for the clm_blob

-- 
https://patchwork.kernel.org/patch/10750585/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

