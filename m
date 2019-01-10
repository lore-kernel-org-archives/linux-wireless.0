Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ED8C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 13:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63ADD214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 13:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AK1WYU39";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D8wAVoZb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfAJN3H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 08:29:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55658 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbfAJN3G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 08:29:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A8367607F4; Thu, 10 Jan 2019 13:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547126945;
        bh=k3aHeZl+dFpefaFzC1Fm+U9wEklipa+6AdjUswBHuSA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AK1WYU39vk1vh983xyzPOHTeId2rmTKRWnrJjdIf/Of+Lvt6jaa/AGda4mvNLMxRT
         Dr/1+I+lsAJvCuAQGLggTaxK6J3vt7r/LWfvsAZTC6+jn18yRNpVgCB0QmVYnCruv8
         gRovW20i1CDjpdrPyxvoraGNfIbH1NX6qq8QjIAg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DCF1660234;
        Thu, 10 Jan 2019 13:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547126945;
        bh=k3aHeZl+dFpefaFzC1Fm+U9wEklipa+6AdjUswBHuSA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=D8wAVoZbfcNdH3vRovOtzdtr+zlBRKljsKeOPEVFbI+XUp9enjBAgQax3Dv3JgiPz
         rknJfx5RVKAxDAOa3SOvTefJxsdizWkr3hxo5PU6LKmvUE0u5vU4Gnq21UaDHT/1Ms
         1dzp9EGEfZ2DsWOo5jgwYLTRwbUobxJjlv4xfWwo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DCF1660234
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Avoid OF no-EEPROM quirks without qca,no-eeprom
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181222060913.28434-1-cshored@thecshore.com>
References: <20181222060913.28434-1-cshored@thecshore.com>
To:     "Daniel F. Dickinson" <cshored@thecshore.com>
Cc:     ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        chunkeey@gmail.com, "Daniel F. Dickinson" <cshored@thecshore.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110132905.A8367607F4@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 13:29:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Daniel F. Dickinson" <cshored@thecshore.com> wrote:

> ath9k_of_init() function[0] was initially written on the assumption that
> if someone had an explicit ath9k OF node that "there must be something
> wrong, why would someone add an OF node if everything is fine"[1]
> (Quoting Martin Blumenstingl <martin.blumenstingl@googlemail.com>)
> 
> "it turns out it's not that simple. with your requirements I'm now aware
> of two use-cases where the current code in ath9k_of_init() doesn't work
> without modifications"[1]
> 
> The "your requirements" Martin speaks of is the result of the fact that I
> have a device (PowerCloud Systems CR5000) has some kind of default - not
> unique mac address - set and requires to set the correct MAC address via
> mac-address devicetree property, however:
> 
> "some cards come with a physical EEPROM chip [or OTP] so "qca,no-eeprom"
> should not be set (your use-case). in this case AH_USE_EEPROM should be
> set (which is the default when there is no OF node)"[1]
> 
> The other use case is:
> 
> the firmware on some PowerMac G5 seems to add a OF node for the ath9k
> card automatically. depending on the EEPROM on the card AH_NO_EEP_SWAP
> should be unset (which is the default when there is no OF node). see [3]
> 
> After this patch to ath9k_of_init() the new behavior will be:
> 
>     if there's no OF node then everything is the same as before
>     if there's an empty OF node then ath9k will use the hardware EEPROM
>       (before ath9k would fail to initialize because no EEPROM data was
>       provided by userspace)
>     if there's an OF node with only a MAC address then ath9k will use
>       the MAC address and the hardware EEPROM (see the case above)
>     with "qca,no-eeprom" EEPROM data from userspace will be requested.
>       the behavior here will not change
> [1]
> 
> Martin provides additional background on EEPROM swapping[1].
> 
> Thanks to Christian Lamparter <chunkeey@gmail.com> for all his help on
> troubleshooting this issue and the basis for this patch.
> 
> [0]https://elixir.bootlin.com/linux/v4.20-rc7/source/drivers/net/wireless/ath/ath9k/init.c#L615
> [1]https://github.com/openwrt/openwrt/pull/1645#issuecomment-448027058
> [2]https://github.com/openwrt/openwrt/pull/1613
> [3]https://patchwork.kernel.org/patch/10241731/
> 
> Fixes: 138b41253d9c ("ath9k: parse the device configuration from an OF node")
> Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Signed-off-by: Daniel F. Dickinson <cshored@thecshore.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ce938231bd3b ath9k: Avoid OF no-EEPROM quirks without qca,no-eeprom

-- 
https://patchwork.kernel.org/patch/10741449/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

