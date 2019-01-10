Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29070C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECC6C206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jzml+IM8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mav3cJmv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfAJLdh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:33:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48456 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbfAJLdh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:33:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F385B608A5; Thu, 10 Jan 2019 11:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120017;
        bh=A2Jrrkpg2uKxmAeiPGpbVlUXfq4aTSsMqD1bQCB2OMA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jzml+IM8QNmc2uczzg2hSXpOOyJachj0SVZrGcgEj8tjVP2v+KeX3de7LqI971MOQ
         +Y1MOMrjGGY/lRI4LpyvbEkcroueAth04hs00TJPevKc3lUxH4beoM27P/2vgEX7D/
         aV4QLawFDUGzApVXB1w/2YvGhPoOgqy8SfG8fOx8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 74B6D601D1;
        Thu, 10 Jan 2019 11:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120016;
        bh=A2Jrrkpg2uKxmAeiPGpbVlUXfq4aTSsMqD1bQCB2OMA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Mav3cJmvCmVjwLzTKJ68h2ljweXTgcS/yx1jfOYj46ekpeXJfenVo2ue5Osf0ynG1
         8Ix3GCdF7FszMOgy6OokgHiTWhXRjGP4rFUy9giwN8zgpxkcvCbrbuO0x2QI2CJJB4
         T00gXjw6h9Lkm4lJeCk3wWBfxrs07ZaZdVjLMvRY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 74B6D601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Add DMI nvram filename quirk for PoV
 TAB-P1006W-232 tablet
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181220164058.19203-1-hdegoede@redhat.com>
References: <20181220164058.19203-1-hdegoede@redhat.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110113336.F385B608A5@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:33:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> wrote:

> The Point of View TAB-P1006W-232 tablet contains quite generic names in
> the sys_vendor and product_name DMI strings, without this patch brcmfmac
> will try to load: brcmfmac43340-sdio.Insyde-BayTrail.txt as nvram file
> which is a bit too generic.
> 
> Add a DMI quirk so that a unique and clearly identifiable nvram file
> name is used on the PoV TAB-P1006W-232 tablet.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

4d95f99c59b8 brcmfmac: Add DMI nvram filename quirk for PoV TAB-P1006W-232 tablet

-- 
https://patchwork.kernel.org/patch/10739171/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

