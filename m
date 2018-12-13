Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B225C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 324A02086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lbOFkc9u";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Xi8IWeLw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 324A02086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbeLMO7T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:59:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48676 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbeLMO7T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:59:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6335A607DE; Thu, 13 Dec 2018 14:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713158;
        bh=4+REwWo0kCpLa7q0OYVauAxnbmMjyfbWeSeNpNHJ3fw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lbOFkc9uAufJu7uPjOvnO4ra/q5xROm96Ck7fD2UbkSpd6RQiGwD5XzFXW4WrTkoz
         zUOdX4fG3HsH+UBpw7xmvw6dLkYDl9rsG/5X3m9dhEd65FKmo6vndHtv+ydqleFp/I
         Z4g+rwaKmI3gcmrKYP4IHHi06O+Ehafq4x4jWtIU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6778F6013C;
        Thu, 13 Dec 2018 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713157;
        bh=4+REwWo0kCpLa7q0OYVauAxnbmMjyfbWeSeNpNHJ3fw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Xi8IWeLwQAlD86blyxyTW8WszmOa2x08MC4JOGlvA0pANIY1baJMtoDGtNYUZ343/
         fPtPravC/Q2rlFqJTtlD+fP+U7ZtzLTpBE4NhzuH7dvFru8NsJj2BM8NDzIbK0o7Qu
         6h4tdcRDh3q/Kah4wl4JFQ8i2koB0Up5uqFmm+wE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6778F6013C
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
Message-Id: <20181213145918.6335A607DE@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 14:59:18 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

412dd15c8177 brcmfmac: fix false-positive -Wmaybe-unintialized warning

-- 
https://patchwork.kernel.org/patch/10722445/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

