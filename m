Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73E6C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF35B2080F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SYdvCDkm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dkmOEAHf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfBHPbq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 10:31:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfBHPbp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 10:31:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5945B60791; Fri,  8 Feb 2019 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639904;
        bh=Pjr1mJ/JYGq610KW8+Zo+w8vA35OMjozL9MlB+/89Z0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SYdvCDkmTDislJMGZvC4k2vkWQWcsdL9sAlXgrMjY0K9mVc8+2eUpz1cvqRujhmm0
         qaaOS7AIncQo2uEAr8MMxJehPalWz6SnFWBTGvsvJqPZQuGWu3SOO/02ZVqeriZCLQ
         K3XLMiW57tKUXu2C/rdHso4d/1kOysriKs+kgkPI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C49F260791;
        Fri,  8 Feb 2019 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639902;
        bh=Pjr1mJ/JYGq610KW8+Zo+w8vA35OMjozL9MlB+/89Z0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=dkmOEAHfljicNhl6Fll5Fs3fzoRaoPF7oLadeLExccjBRaenWL0+cBMv2s4pkMCEx
         M7kTXkg73HulFtasFLCC4317rH8MwrvaGCzXktQ/YYldyRO4mT2/HhEc/OujwQyeOs
         i96+pETaKAEnZ08RqwhDSrvFegrzQi8QM2dUIvz4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C49F260791
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi:  fix indentation issue with a code block
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190207121141.28336-1-colin.king@canonical.com>
References: <20190207121141.28336-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208153144.5945B60791@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 15:31:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a block of code that is indented at the wrong level. Fix this
> with extra tabbing.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

34025a1056a3 rsi: fix indentation issue with a code block

-- 
https://patchwork.kernel.org/patch/10801013/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

