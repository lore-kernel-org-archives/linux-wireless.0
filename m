Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC600ECE589
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 09:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79BF821927
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 09:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Pbupdbo0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K5oPJifh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbfJAJOk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 05:14:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbfJAJOk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 05:14:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 92F7361156; Tue,  1 Oct 2019 09:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921279;
        bh=WSpjSRVXNNDez+8NXHpLgBQ3sbzicZGIgUaLTAUcw6g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Pbupdbo0x/D61h1lZ5vihY9nY9gzEXjh6jlntf9cXsDk4EKWFHxX6PFVsO61IPe2y
         ChmGBqyCJMYMA7mLMBhqQVzbdPZdzCERpK6xo9GSUZ2FSGbTkva128gyAD7cfMVkjn
         f+6n+Gykv1+rKPgaWwZBUxvdwTqitJM4PcLZ+swE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B499060112;
        Tue,  1 Oct 2019 09:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921279;
        bh=WSpjSRVXNNDez+8NXHpLgBQ3sbzicZGIgUaLTAUcw6g=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=K5oPJifhyAcUWV/UeZ3f3Q/2ah+BuInEyJM1QmjKWtYuZB0troQH66sjE2vTMHqXK
         yTK+akSmYjop6sh0gq+sBaOhED45HS3jylJsMibsqDWFDY0aeYt5Yi+5lc3p+98vhb
         BK0bcdb3Vb1cs+tQtCP6zXAppFJ/NjGwtPOL2Hs4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B499060112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] brcmfmac: don't WARN when there are no requests
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190925134458.1413790-1-adrian.ratiu@collabora.com>
References: <20190925134458.1413790-1-adrian.ratiu@collabora.com>
To:     Adrian Ratiu <adrian.ratiu@collabora.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martyn Welch <martyn.welch@collabora.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001091439.92F7361156@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 09:14:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Adrian Ratiu <adrian.ratiu@collabora.com> wrote:

> When n_reqs == 0 there is nothing to do so it doesn't make sense to
> search for requests and issue a warning because none is found.
> 
> Signed-off-by: Martyn Welch <martyn.welch@collabora.com>
> Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>

2 patches applied to wireless-drivers-next.git, thanks.

1524cbf36215 brcmfmac: don't WARN when there are no requests
e0ae4bac22ef brcmfmac: fix suspend/resume when power is cut off

-- 
https://patchwork.kernel.org/patch/11160709/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

