Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78EDC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F4072081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="f99tU5UQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EMLPgTP0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F4072081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389567AbeKGC3s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:29:48 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389245AbeKGC3s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:29:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4C01760795; Tue,  6 Nov 2018 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523819;
        bh=2ZWmsU2kxGzNwX2t3cgTYvKPrwy/0cxGdWm/0lg+/fY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=f99tU5UQD7mGj1bQfXTBJTVf8qyTc8Us1d3NGzuByYMk2XHbHId49sBu5gHaNeMuN
         QxM+I35dE+Vu8R7ldEgcAWbU+rjrg02kh+SQCXPE9jFtU8ASw9HvCzhU9TVeKSgyQn
         zpofifLt5VVRxRX3ZC6uJmN1vMSE1e2FC67JUt70=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 938D560B7E;
        Tue,  6 Nov 2018 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523818;
        bh=2ZWmsU2kxGzNwX2t3cgTYvKPrwy/0cxGdWm/0lg+/fY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=EMLPgTP0gpbWXQiwNW78Ct+dNBluCrhTeRGgDmqzPWuHOeJ+RPzB14+t/Tr5q70kn
         Ub4SvKCYvlkcQvCm/1YNb+Avwp8W89jfvh+gwd0d0lDKH3nsdyt5Hht4VDBgCePf3C
         poFIHgo3b2t2LG2lXGwf4yulhV1BXDJYmAX0NTQg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 938D560B7E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] brcmutil: print invalid chanspec when WARN-ing
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181026112232.22699-1-zajec5@gmail.com>
References: <20181026112232.22699-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106170339.4C01760795@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 17:03:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> On one of my devices I got WARNINGs when brcmfmac tried to decode
> chanspec. I couldn't tell if it was some unsupported format or just a
> malformed value passed by a firmware.
> 
> Print chanspec value so it's possible to debug a possible problem.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

ae5848cb4511 brcmutil: print invalid chanspec when WARN-ing

-- 
https://patchwork.kernel.org/patch/10657255/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

