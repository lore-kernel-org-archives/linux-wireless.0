Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F2AC10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1941920850
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:06:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pPtroUth";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="khywytro"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfDMLGW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 07:06:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbfDMLGW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 07:06:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 584FC61797; Sat, 13 Apr 2019 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555153581;
        bh=ByvRQxDQ6cwEAhXCB428k25jXLoHOM5ckU1AlIqcJ48=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pPtroUthC3Q5rSzUUVCsaWLUwjp87X0XTc5JpoGnFNDHkLYio92mDYSYm0iMwoFvK
         D9nTT4dzSiu4Iu/SoOwQ3mzlKlOKexZxkcm5I6dAIaPycoCsB3PJd3h/PHIpeIWvSH
         b8gB3ZP2ANvHxaQVDDNra4pHob5ExuqUzQopHONU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 76D7261577;
        Sat, 13 Apr 2019 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555153579;
        bh=ByvRQxDQ6cwEAhXCB428k25jXLoHOM5ckU1AlIqcJ48=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=khywytrozZdfSmoXWbYNtG0rJK1KGHKY18brAUsY3JtRz5fdLazMCNSggaX7o8GbQ
         /j96QjQeS36eLF/71/fRmKSkD7AD6vyYLs1yW3Ab7nEdFHVWNGlna+EM+hH45hbMhu
         /boVKj0VF09zGl4dyFvZGCX9i18iVLaOXD3g8X+E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 76D7261577
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 11/12] brcmfmac: Loading the correct firmware for brcm43456
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190405234514.6183-12-megous@megous.com>
References: <20190405234514.6183-12-megous@megous.com>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ondrej Jirman <megous@megous.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190413110621.584FC61797@smtp.codeaurora.org>
Date:   Sat, 13 Apr 2019 11:06:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

megous@megous.com wrote:

> From: Ondrej Jirman <megous@megous.com>
> 
> SDIO based brcm43456 is currently misdetected as brcm43455 and the wrong
> firmware name is used. Correct the detection and load the correct
> firmware file. Chiprev for brcm43456 is "9".
> 
> Signed-off-by: Ondrej Jirman <megous@megous.com>

Patch applied to wireless-drivers-next.git, thanks.

e3062e05e1cf brcmfmac: Loading the correct firmware for brcm43456

-- 
https://patchwork.kernel.org/patch/10888023/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

