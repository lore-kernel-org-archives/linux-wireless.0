Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C5CC3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39C2923697
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:49:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OkcLQLxS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OujeYDO3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfICNtr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:49:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbfICNtr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:49:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1F7A16076A; Tue,  3 Sep 2019 13:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518587;
        bh=wcqjGHMbDfVzd1c7B8Z/0LN2Jhg14exZB5iri3Sjtbs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OkcLQLxSkmKHjooQx5YoytH7S1utFUrSB3yM5fBWUxRBKiEfpwzcfWRvr6MDuQAfm
         JzJ8U217OFB2nTJiZFPBE55UBsAxJfJE5i2/4ukxWUZa6PwrLHleBbYFZBIUyuge12
         dchiF9HVDQTCsQfnziY8OeImTVhnZWaf7DLN9NAg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4267960159;
        Tue,  3 Sep 2019 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518586;
        bh=wcqjGHMbDfVzd1c7B8Z/0LN2Jhg14exZB5iri3Sjtbs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=OujeYDO3e1AaDyPqnwVDdP1l6hGNYM+tOpnppV7b+SmgKi+RXiuruhSdDWhcYPnGX
         /J9u5LGTV7mYH3b55WPb2eLVghRlPq0MsmR6cQTR/yvoKMtOC4pox39Gvzcyxnds5Y
         bdChHqoLn0jZeRQ/f+Y6i27AfR57v2gtre8y0/2Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4267960159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5.3] mt76: mt76x0e: disable 5GHz band for MT7630E
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1565703416-10669-1-git-send-email-sgruszka@redhat.com>
References: <1565703416-10669-1-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>, Roy Luo <royluo@google.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903134947.1F7A16076A@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:49:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> MT7630E hardware does support 5GHz, but we do not properly configure phy
> for 5GHz channels. Scanning at this band not only do not show any APs
> but also can hang the firmware.
> 
> Since vendor reference driver do not support 5GHz we don't know how
> properly configure 5GHz channels. So disable this band for MT7630E .
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers.git, thanks.

70702265a04a mt76: mt76x0e: disable 5GHz band for MT7630E

-- 
https://patchwork.kernel.org/patch/11092285/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

