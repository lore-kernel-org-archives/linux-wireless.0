Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE8AC67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E55202086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:52:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PosKgbPN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rz58noel"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E55202086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbeLMOwd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:52:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbeLMOwc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:52:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 28C0360960; Thu, 13 Dec 2018 14:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544712752;
        bh=+iWQ0Q5a5sB4+yWqq4tZ4R7zqV21cme7RV5BytbWc5s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PosKgbPNcUgHslkrD2uFK2nzLBAZx4ioohje28QXy3ZMCjxOlN1HL1BJ3xgAS2Qgr
         vbcMx9/MupAwjBcLgPp2MCl2pGvOXtYgWuj2/YKGBGmyHbw8X+M6r6hhWivqKZWpF5
         oTDOZxm4fn0Vy00RO7JG4eDDbZwT9qK/RbpZClw0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 268596074E;
        Thu, 13 Dec 2018 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544712747;
        bh=+iWQ0Q5a5sB4+yWqq4tZ4R7zqV21cme7RV5BytbWc5s=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Rz58noeliP02p8alhCbqbD+fwyhfHA9iSsRPUbAQhx4Yq15L7vxkvsSXJAG87Sma/
         hPXtHaLN9R/ih75NQMHhK9vmCQBejMDg6UvSwn2RWNJecfJc+rrS7mv4Sz4S1yhScQ
         Xm2fnvxjpOrl8Y57ozHbkTdVDd7yMM+lPzxYegqc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 268596074E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: fix false-positive -Wmaybe-unintialized warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181210205555.3000038-1-arnd@arndb.de>
References: <20181210205555.3000038-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Lyude Paul <lyude@redhat.com>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213145232.28C0360960@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 14:52:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> When CONFIG_NO_AUTO_INLINE is set, we get a false-postive warning
> for the brcmf_fw_request_nvram_done() function, after gcc figures
> out that brcmf_fw_nvram_from_efi() might not set the 'data_len'
> variable, but fails to notice that it always returns NULL:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c: In function 'brcmf_fw_request_nvram_done':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c:560:11: error: 'data_len' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> Mark it 'inline' to force gcc to understand this.
> 
> Fixes: ce2e6db554fa ("brcmfmac: Add support for getting nvram contents from EFI variables")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Commit ce2e6db554fa is in w-d-next so this should go to that tree as well.

-- 
https://patchwork.kernel.org/patch/10722445/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

