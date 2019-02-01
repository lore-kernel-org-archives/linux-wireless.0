Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0759C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF19721872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ViGjhPfx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L9ETFJJN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfBAMMk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:12:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfBAMMk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:12:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 171C26030D; Fri,  1 Feb 2019 12:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023160;
        bh=Fs22LpZlRc0BWBy2A328/9nvKQ2gNjBZoAAra83qk6E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ViGjhPfxDVJ0zg7tKifYYovJi+v7h2UsoXEbz8giek2RV8eIu9dqeIIsoYFgBiwzl
         DzNoT1cGhc91Cuj5sI88eXVBDS7k9NTFFtn88GzMgvdZzP9sr8t/6/agpd0Fc1Z3/h
         r70qFr8XcqxxHLZtYmnXhsngLNLVsK5SiOCTe2DY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7706F6047C;
        Fri,  1 Feb 2019 12:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023158;
        bh=Fs22LpZlRc0BWBy2A328/9nvKQ2gNjBZoAAra83qk6E=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=L9ETFJJN4pkbTwgnF8Wf5DB1Kza0kHteZf0ik4BA/msH+crM3JRBOh/TVOzfUyRqU
         e4Mu568Wt9NAVLtNCcl3q0NS+izfSXZRzpLZoY0zTffJ4Y+B1Z/LdZgfphx687jzgl
         myHwMUb8zsde45T0rR6yuZtatVGv2kQfxg0wY8pY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7706F6047C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/9] qtnfmac: support EBUSY errcode for QLINK protocol
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190114093925.9061-2-sergey.matyukevich.os@quantenna.com>
References: <20190114093925.9061-2-sergey.matyukevich.os@quantenna.com>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201121240.171C26030D@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:12:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> From: Andrey Shevchenko <ashevchenko@quantenna.com>
> 
> Add support of EBUSY error code for remote procedures over QLINK protocol.
> 
> Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>

9 patches applied to wireless-drivers-next.git, thanks.

126824f5ce67 qtnfmac: support EBUSY errcode for QLINK protocol
d1365e794eb3 qtnfmac: fix INTx interrupt handling
de624a355d92 qtnfmac: add support for 4addr mode
9fe504a13172 qtnfmac: switch to 32bit values for RTS/FRAG thresholds
f3c8bd46c774 qtnfmac: do not reject retry changes in driver
ff233cb51503 qtnfmac: convert to SPDX license identifiers
23781af74152 qtnfmac: add missing bss record to host scan cache
324b8cad8cfc qtnfmac: remove unused declarations
3844dec0f45d qtnfmac: qtnf_cmd_send_with_reply cleanup

-- 
https://patchwork.kernel.org/patch/10761781/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

