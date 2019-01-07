Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB12AC43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 11:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7C132070C
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 11:52:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o/wxrPcL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VA72F+OQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfAGLw4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:52:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36282 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfAGLw4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 06:52:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 529D760709; Mon,  7 Jan 2019 11:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546861975;
        bh=+ujLRGpiMA70K5JYL1/9D01T/2n+wS/qe5QF5Kgr+bM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=o/wxrPcLWaA39Fg/z39WElTHZaFbA4cygxD1NbQQft4Zkk6wbKOjBx9iMV+HgRD/Q
         B6X6RQGK5zJKFoQ2pg0ya0yceI1cmMDgNykF+zwmBitZy0saDy2MmQImFRB4BDEbDa
         +vOryAf23mFldajgURIUsQQDHWOX+0Qo46ZFHThc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0097F602A8;
        Mon,  7 Jan 2019 11:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546861974;
        bh=+ujLRGpiMA70K5JYL1/9D01T/2n+wS/qe5QF5Kgr+bM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VA72F+OQT93nZKrGcGZs/i4emOoXsE3H79qayAnpT759rs8W/5inLCfQK8SvDmmuZ
         hdwqITc6nsK6Cz94AGjhFVAnbHUKiM+6txvCOhsfKI0uiPhN3B+odRIscASyN+1fgq
         dWxgIamA1QDKXb5gD0VZbIfxQ9JutwkF46D+ApXc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0097F602A8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH] brcmfmac: Use request_firmware_direct for the clm_blob
References: <20190107113401.6824-1-hdegoede@redhat.com>
Date:   Mon, 07 Jan 2019 13:52:49 +0200
In-Reply-To: <20190107113401.6824-1-hdegoede@redhat.com> (Hans de Goede's
        message of "Mon, 7 Jan 2019 12:34:01 +0100")
Message-ID: <87wongsmzy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> writes:

> The linux-firmware brcmfmac firmware files contain an embedded table with
> per country allowed channels and strength info.
>
> These versions of the firmware are specially build for linux-firmware,
> the firmware files directly available from Broadcom / Cypress rely on
> a separate clm_blob file for this info.
>
> For some unknown reason Broadcom / Cypress refuse to provide the standard
> firmware files + clm_blob files it uses elsewhere for inclusion into
> linux-firmware, instead relying on these special builds with the clm_blob
> info embedded. This means that the linux-firmware firmware versions often
> lag behind, but I digress.
>
> The brcmfmac driver does support the separate clm_blob file and always
> tries to load this. Currently we use request_firmware for this. This means
> that on any standard install, using the standard combo of linux-kernel +
> linux-firmware, we will get a warning:
> "Direct firmware load for ... failed with error -2"
>
> On top of this, brcmfmac itself prints: "no clm_blob available (err=-2),
> device may have limited channels available" and we will get a slow
> fallback to the userspace firmware loading mechanism.
>
> This commit fixes both almost any brcmfmac device logging the warning
> (leaving the brcmfmac info message in pace), as well as the slow and
> unnecesary fallback by switching to request_firmware_direct for
> the clm_blob.
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 0bb16bf574e3..e0a5e78ee437 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -149,7 +149,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
>  		return err;
>  	}
>  
> -	err = request_firmware(&clm, clm_name, bus->dev);
> +	err = request_firmware_direct(&clm, clm_name, bus->dev);

If you just want to avoid the warning shouldn't this be
firmware_request_nowarn()? On ath10k we also did the workaround using
_direct() variant but that caused problems with openwrt.

-- 
Kalle Valo
