Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFA7C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B68AF2081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:52:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VCdf3gc3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Urdc7hgB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B68AF2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389378AbeKGCSH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:18:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389227AbeKGCSH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:18:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D6ED260B19; Tue,  6 Nov 2018 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523121;
        bh=g/aTL0R8A/TmKwfva+Z3st+WH7M47OksmTuaTL9ivMw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VCdf3gc3+S/+zBmFNBVo/KvuP70VGveh4KOro5MecNOoeeY02Xch3Hfw41qX5UN6I
         UYaO87ITN/R4P+pIQ2/3w4C8vKlOg1WEZaML79vZMrp1mVo5KLxW1k6epdayqnFiEn
         945G0V3yqz3Yq9Xx8Ee3D2ZNToC4wj0Syh5aSbDI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 97EA3602F4;
        Tue,  6 Nov 2018 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523121;
        bh=g/aTL0R8A/TmKwfva+Z3st+WH7M47OksmTuaTL9ivMw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Urdc7hgBQUfWd9h2uiiqejVy1jH7PCNYzaZ1/WlQVM/oPC7RXPp4/xrLkyZ+023a0
         Fa2OkXw6pLNkdY2Y9OpqxuI/zjXR8ya/yzIkjcdXTTaspTiFfw06J2s67R57Nviyo3
         N9q1Wbl9FhZEAiSbUEkF8oeXHRA6u5eZR0NQgWsI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 97EA3602F4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/2] brcmfmac: Add support for getting nvram contents
 from EFI variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181011095107.17073-1-hdegoede@redhat.com>
References: <20181011095107.17073-1-hdegoede@redhat.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106165201.D6ED260B19@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:52:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> wrote:

> Various X86 laptops with a SDIO attached brcmfmac wifi chip, store the
> nvram contents in a special EFI variable. This commit adds support for
> getting nvram directly from this EFI variable, without the user needing
> to manually copy it.
> 
> This makes Wifi / Bluetooth work out of the box on these devices instead of
> requiring manual setup.
> 
> This has been tested on the following models: Acer Iconia Tab8 w1-810,
> Acer One 10, Asus T100CHI, Asus T100HA, Asus T100TA, Asus T200TA and a
> Lenovo Mixx 2 8.
> 
> Tested-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

2 patches applied to wireless-drivers-next.git, thanks.

ce2e6db554fa brcmfmac: Add support for getting nvram contents from EFI variables
29ec3394f0bd brcmfmac: Fix ccode from EFI nvram when necessary

-- 
https://patchwork.kernel.org/patch/10636371/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

