Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30091C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 12:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D33E920645
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 12:14:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kVIe2Nfb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kVIe2Nfb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D33E920645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbeJMTvp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 15:51:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbeJMTvo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 15:51:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E507E60866; Sat, 13 Oct 2018 12:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539432889;
        bh=e4tGnGKt9/Y0TP3odNG36pu9qMy5l6sAz5EARlgZbug=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kVIe2NfbXQU/z2DYuX2sWjZKKdLQWHkiKIlz1jpI7SGqGNFsLP8EVCn1qfr0agnKK
         89Y4MeSMQzvLSO/Zm2SdrzfU3fvYxN5Q3Bit7Ht5pqd/ahyueJSzhGEir12xZ8B3Uf
         w0+3HMjoxEJNthVBZp3JbPDYeNZJrdulWxKhtUkA=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DCB5B605A4;
        Sat, 13 Oct 2018 12:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539432889;
        bh=e4tGnGKt9/Y0TP3odNG36pu9qMy5l6sAz5EARlgZbug=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kVIe2NfbXQU/z2DYuX2sWjZKKdLQWHkiKIlz1jpI7SGqGNFsLP8EVCn1qfr0agnKK
         89Y4MeSMQzvLSO/Zm2SdrzfU3fvYxN5Q3Bit7Ht5pqd/ahyueJSzhGEir12xZ8B3Uf
         w0+3HMjoxEJNthVBZp3JbPDYeNZJrdulWxKhtUkA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DCB5B605A4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: Re: [PATCH 5/5] qtnfmac: add support for Topaz chipsets
References: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
        <20181008095551.18651-6-sergey.matyukevich.os@quantenna.com>
Date:   Sat, 13 Oct 2018 15:14:46 +0300
In-Reply-To: <20181008095551.18651-6-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Mon, 8 Oct 2018 09:56:05 +0000")
Message-ID: <87murioxft.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> This patch adds support for QSR1000/QSR2000 family of chipsets
> to qtnfmac_pcie platform driver.
>
> QSR1000/QSR2000 (aka Topaz) is a family of 80MHz, 11ac Wave2,
> 4x4/2x4/2x2 chips, including single and dual band devices.
> Depending on specific chip model and firmware in use, either
> STA or both STA and AP modes are supported.
>
> Patch adds Topaz support to qtnfmac_pcie driver. It is possible
> to enable both Topaz and Pearl support in kernel configuration.
> In that case proper platform bus will be selected on probing
> based on chip ID.
>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>

[...]

> +config QTNFMAC_TOPAZ_PCIE
> +	tristate "Quantenna QSR1000/QSR2000 PCIe support"
> +	default n
> +	depends on PCI && CFG80211
> +	select QTNFMAC
> +	select FW_LOADER
> +	select CRC32
> +	help
> +	  This option adds support for wireless adapters based on Quantenna
> +	  802.11ac QSR1000/QSR2000 (aka Topaz) FullMAC chipset
> +	  running over PCIe.
> +
> +	  If you choose to build it as a module, two modules will be built:
> +	  qtnfmac.ko and qtnfmac_pcie.ko.

I'm not really fond of adding a Kconfig option for every supported
hardware version unless there are very good reasons (memory savings
etc). So is this really needed?

A much better approach would be to have a generic QTNFMAC_PCIE option
which can be used to include or exclude all PCI code.

-- 
Kalle Valo
