Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CA7C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA9552080F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N9CEHhiQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UW5POzhZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfBHPbO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 10:31:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34612 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfBHPbO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 10:31:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 568916099A; Fri,  8 Feb 2019 15:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639873;
        bh=LvIU087JZ1lO7v95PtA5FXB5/YWVIGC8RrAPGGwM0W0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=N9CEHhiQeYWH8k2/Es1O99cyMEI9U5Jh3ZNyfS4fyitTKIlF9dAmgxmUEg/9Xh8v6
         bPhQCWPJZSS34eToqYm9srY5MZz6ouvxle7oIzTyjyiDmvvlWMzASGFGbeBW8TaaMg
         XWKhEPf5ydDRI0Mekk/x4zjqPFK5E6JryahqRJ9o=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 248356081B;
        Fri,  8 Feb 2019 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639868;
        bh=LvIU087JZ1lO7v95PtA5FXB5/YWVIGC8RrAPGGwM0W0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=UW5POzhZjBu0urjAIBj47k+pSg5Ce0Yvml9oYMpkL3Jg1Yx80tZVQg9Q7eqReRsmT
         Chx91XXmeNcs/qYlUoanA52R8KQB4y6nsR0dkXTj0eoJybaDloPgQyv0yQnwRXjrYM
         gbR+YEmk0S+setNbAfZBLcNQXN6rsucaDYTalO0g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 248356081B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] qtnfmac: enable WPA3 OWE support
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190205094842.31568-2-sergey.matyukevich.os@quantenna.com>
References: <20190205094842.31568-2-sergey.matyukevich.os@quantenna.com>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208153113.568916099A@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 15:31:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> In the case of OWE, STA should be able to pass DH IEs from AP assoc
> responses to wpa_s for processing. For this purpose DH IEs are
> received from firmware in BSS_JOIN events and passed to wireless
> core and then to wpa_s as additional optional rsp_ies parameter
> for cfg80211_connect_result.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

2 patches applied to wireless-drivers-next.git, thanks.

524d6323af5f qtnfmac: enable WPA3 OWE support
47b08e75a669 qtnfmac: enable WPA3 SAE support

-- 
https://patchwork.kernel.org/patch/10797195/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

