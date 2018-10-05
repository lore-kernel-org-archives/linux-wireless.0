Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0D8C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B5C520875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WQdukqnF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oNeJ3jBU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B5C520875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbeJEPbk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:31:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbeJEPbj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:31:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C9DA6601A0; Fri,  5 Oct 2018 08:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728438;
        bh=+Rsmz3LP5oBd0o5He9sI0EnSRFac4rI0HffYz2VHby8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WQdukqnFbkIokDgOk6/MjXGbPcihQcRdXRyXldbbrKIHd5sF/6vRrZTvr7OzfVFHb
         InuyR4V0dv/SsTGoUt4Yvjd8gUjd9YvrhGJmnXanFbvG+vc1oFVUC2f/AwDbn7S8wp
         j1/Cpi4f4x2RsEweGdkMyzwHGFNYXtiEsaZqQT+o=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 43079601A1;
        Fri,  5 Oct 2018 08:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728438;
        bh=+Rsmz3LP5oBd0o5He9sI0EnSRFac4rI0HffYz2VHby8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=oNeJ3jBUnCmkZdXgLaapsbNmeFoZFEeUhV/9Sna95XwdN+E9IZfz/Zib/CBl80/U4
         jDIonbv7CJPmxjwuZe5gJrijo1HDBO9x9i4XxSy9keXx6QqNumPE2Qae3PuuhBWNl1
         cO1VPDXUz7nstmnga7S8P860LbH2HQ7zCRRBHFEY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 43079601A1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: Add support for optional wakeirq
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181001214110.86774-1-tony@atomide.com>
References: <20181001214110.86774-1-tony@atomide.com>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181005083358.C9DA6601A0@smtp.codeaurora.org>
Date:   Fri,  5 Oct 2018 08:33:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Lindgren <tony@atomide.com> wrote:

> Now with wlcore using PM runtime, we can also add support for Linux
> generic wakeirq handling for it if configured in the dts file.
> 
> The wakeirq can be configured as the second interrupt in the dts file
> with interrupts-extended property where it is the padconf irq of the OOB
> GPIO pin used for wlcore interrupt.
> 
> Note that eventually we should also allow configuring wlcore to use the
> SDIO dat1 IRQ for wake-up, and in that case the the wakeirq should be
> configured to be the padconf interrupt of the dat1 pin and not the
> padconf interrupt of the OOB GPIO pin.
> 
> Cc: Eyal Reizer <eyalr@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

3c83dd577c7f wlcore: Add support for optional wakeirq

-- 
https://patchwork.kernel.org/patch/10622795/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

