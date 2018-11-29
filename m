Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B44C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74E1B21019
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:32:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O1zNsrcZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ia5lOwPh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74E1B21019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbeK3Ci0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 21:38:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbeK3Ci0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 21:38:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0E676606DC; Thu, 29 Nov 2018 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543505562;
        bh=uLFtMsXiDKtSGV+rVHDvxTLOq/uuCxBIFnMN3Y4R99E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=O1zNsrcZDSq8wr/QDbuhEw+jmqeI69eN6j7vtHykZqeDfKoWrIIfbwPrxpsWORVut
         mV8BDa3FuVV2HUd3jeO7I096fDl0mVSLXIAbDV6Jl96xk0q5rPJNaCpZ4+eNiw8hkc
         45hOMboN/jhISIRNtX8UTvrAQZkMNRJwZ8lrOnfs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5AD9B606DC;
        Thu, 29 Nov 2018 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543505561;
        bh=uLFtMsXiDKtSGV+rVHDvxTLOq/uuCxBIFnMN3Y4R99E=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ia5lOwPh6J9ALNl94CsD80WUNJFDPPnrjVV3RyiRpQtlf/v/Nwg1RA7wb8PG5LH1E
         2MUkKEUchjvBKwnR3n/2vG7Kvy8IBcS0IPukZdGd/eQIDOrvVJHCx91fxfPwlhYQqU
         BfPdPphz5Ziq6CIq4QBUVOi9herpePODiDd9ic6I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5AD9B606DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Call brcmf_dmi_probe before brcmf_of_probe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181123091148.12742-1-hdegoede@redhat.com>
References: <20181123091148.12742-1-hdegoede@redhat.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Peter Robinson <pbrobinson@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181129153242.0E676606DC@smtp.codeaurora.org>
Date:   Thu, 29 Nov 2018 15:32:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> wrote:

> ARM systems with UEFI may have both devicetree (of) and DMI data in this
> case we end up setting brcmf_mp_device.board_type twice.
> 
> In this case we should prefer the devicetree data, because:
> 1) The devicerree data is more reliable
> 2) Some ARM systems (e.g. the Raspberry Pi 3 models) support both UEFI and
>    classic uboot booting, the devicetree data is always there, so using it
>    makes sure we ask for the same nvram file independent of how we booted.
> 
> This commit moves the brcmf_dmi_probe call to before the brcmf_of_probe
> call, so that the latter can override the value of the first if both are
> set.
> 
> Fixes: bd1e82bb420a ("brcmfmac: Set board_type from DMI on x86 based ...")
> Cc: Peter Robinson <pbrobinson@gmail.com>
> Tested-and-reported-by: Peter Robinson <pbrobinson@gmail.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

554da3868eb1 brcmfmac: Call brcmf_dmi_probe before brcmf_of_probe

-- 
https://patchwork.kernel.org/patch/10695255/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

