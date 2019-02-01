Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C56C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56D3F21872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Yyo6cG1e";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B0rAmK4y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfBAMOS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:14:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53996 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfBAMOS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:14:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6748C605FC; Fri,  1 Feb 2019 12:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023257;
        bh=kWLrTFs8v5bbSlynnGUb63/30cU40yaPhOP7VbqLLQU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Yyo6cG1eDqT55emhy5Cb8BKOcfjhk4CDhX54sXml7BlMz+htTNRnWKIHx2bWVDIvB
         W/z1dC+T/4NhLvkwZkKDCx01vDTL6RFSjPNDkh5yRsZ20zB75AWBVDxM1QFavbCNBo
         xSKE7zaTZt0NHIykD8beztuBoGr07wJU5Y3hrCcY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4ED236030D;
        Fri,  1 Feb 2019 12:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023256;
        bh=kWLrTFs8v5bbSlynnGUb63/30cU40yaPhOP7VbqLLQU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=B0rAmK4y2epwa6tFe3LqlDbbSNbAUeBnNXCEuYWLTR1NKdCy37JZKjxjK+Azkdjdc
         XhC083+mDpZPhaqYOoV42aJppWR0DDvIDmnZtnhH5owYjQJf3bvIWEGg4y2J1Nw3nT
         xV2m4abbMxkJkhdaYKQLJ33CaP2OReurFkasEt6k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4ED236030D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 1/2] brcmfmac: modify __brcmf_err() to take bus as a
 parameter
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190115121217.18276-1-zajec5@gmail.com>
References: <20190115121217.18276-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201121417.6748C605FC@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:14:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far __brcmf_err() was using pr_err() which didn't allow identifying
> device that was affected by an error. It's crucial for systems with more
> than 1 device supported by brcmfmac (a common case for home routers).
> 
> This change allows passing struct brcmf_bus to the __brcmf_err(). That
> struct has been agreed to be the most common one. It allows accessing
> struct device easily & using dev_err() printing helper.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Fails to build for me:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c: In function 'brcmf_pcie_pm_enter_D3':
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1948:20: error: redeclaration of 'bus' with no linkage
  struct brcmf_bus *bus;
                    ^~~
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1946:20: note: previous definition of 'bus' was here
  struct brcmf_bus *bus = dev_get_drvdata(dev);
                    ^~~
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c: In function 'brcmf_pcie_pm_leave_D3':
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1978:20: error: redeclaration of 'bus' with no linkage
  struct brcmf_bus *bus;
                    ^~~
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1976:20: note: previous definition of 'bus' was here
  struct brcmf_bus *bus = dev_get_drvdata(dev);
                    ^~~
make[6]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.o] Error 1
make[6]: *** Waiting for unfinished jobs....
drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c: In function '__brcmf_err':
drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:35:15: error: dereferencing pointer to incomplete type 'struct brcmf_bus'
   dev_err(bus->dev, "%s: %pV", func, &vaf);
               ^~
make[6]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.o] Error 1
make[5]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac] Error 2
make[4]: *** [drivers/net/wireless/broadcom/brcm80211] Error 2
make[3]: *** [drivers/net/wireless/broadcom] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

2 patches set to Changes Requested.

10764369 [V2,1/2] brcmfmac: modify __brcmf_err() to take bus as a parameter
10764371 [V2,2/2] brcmfmac: pass bus to the __brcmf_err() in pcie.c

-- 
https://patchwork.kernel.org/patch/10764369/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

