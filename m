Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF73C282DA
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D9EF20863
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:38:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FD8DDOCh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UyO2YSS3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfBAMiK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:38:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54478 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfBAMiK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:38:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A74116085C; Fri,  1 Feb 2019 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024689;
        bh=jyqR1h7nA3nTxwmIC7lvM9XJKe0d9DqH2USDfGq2tHU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FD8DDOChSxnBZRWyo+r06V3pwsBmXwKYynRIV2KZPR06Mb0AeQuaPIFlHF32RUqbq
         27PBz0IkoASl4SsUJ0B877UzmoIwbDmEFUa3s+rZh3S95AOdwk27HjW3WvUUuX1jrI
         ZsnAB4EIdQzgvvaazj7tsY+U7Vxxv67W+ZzpUTm4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B725160590;
        Fri,  1 Feb 2019 12:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024687;
        bh=jyqR1h7nA3nTxwmIC7lvM9XJKe0d9DqH2USDfGq2tHU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=UyO2YSS3wqHICwTIBPCJ/GqT2W5yw1lftbFuctPL9TlVqu2/tEob1FtxpbZhbhELA
         yuxvBxpuk666SU0zRhu2RhFT6ky0FlmH0xvSYx9pgj5rgY1IR9n2FCY9O+sE4Duul9
         nY0Vp4N65GRpNA2kAFgUdRXD+1HJnWshcJWKj7vc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B725160590
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: no need to check return value of debugfs_create
 functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122152151.16139-32-gregkh@linuxfoundation.org>
References: <20190122152151.16139-32-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201123809.A74116085C@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:38:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> Cc: Wright Feng <wright.feng@cypress.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: brcm80211-dev-list@cypress.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Arend van Spriel

Patch applied to wireless-drivers-next.git, thanks.

9ae49980bdca brcmsmac: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/10775745/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

