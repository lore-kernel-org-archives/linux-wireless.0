Return-Path: <SRS0=E8CW=XQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB808C49ED7
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Sep 2019 06:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74BA12054F
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Sep 2019 06:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mXIxgFAg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="M8rfGF+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436964AbfIUGr4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 21 Sep 2019 02:47:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfIUGr4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Sep 2019 02:47:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 59C9B60736; Sat, 21 Sep 2019 06:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569048475;
        bh=GtnPkrkrPh+SadImv6m1ielDnGM4Hbs5LQQoKjVZaV4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=mXIxgFAg2TXFFSSZOm/0ubweqVzC+DTAOeK8cGuso48BoQMvtaF78pYcXg6l3Ju/q
         SOlN+IY49CosLdnEHWSo0xeXrw6I2A4at99ihJLxY8rG0Np75sMgzymMA/hHZ0HAOg
         w58okSS40Jrci0L0WVh9E+dlY0zMizu4mTfCASi4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6941A60863;
        Sat, 21 Sep 2019 06:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569048474;
        bh=GtnPkrkrPh+SadImv6m1ielDnGM4Hbs5LQQoKjVZaV4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=M8rfGF+cm/pRtzIQbYY7BUkMYfgpPQXOjxwJ1Ij3/Gx01JSJE6wUF3l4P27l5sKYI
         du/qdHzXKZESo3d88PvoICNndHjKbTHeZeTMhn/GJBRhWzUDu/A0S1c3ogvc9235vp
         LRIqEi2LFu1f77kt4zNS1pDdQc2Fj08kxnLCLfmQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6941A60863
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/2] dt: bindings: add dt entry for XO calibration
 support
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190401091926.19119-2-govinds@codeaurora.org>
References: <20190401091926.19119-2-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, robh@kernel.org,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190921064755.59C9B60736@smtp.codeaurora.org>
Date:   Sat, 21 Sep 2019 06:47:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> Add dt binding to get xo calibration data support for wifi rf clock.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

892022e108dd dt: bindings: ath10k: add dt entry for XO calibration support
75f545e85744 ath10k: Add xo calibration support for wifi rf clock

-- 
https://patchwork.kernel.org/patch/10879475/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

