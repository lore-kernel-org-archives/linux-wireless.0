Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0738C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1715720679
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:55:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JwISdxyd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Fnr85bSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfDYQz0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:55:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfDYQz0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:55:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6EEEF60736; Thu, 25 Apr 2019 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211325;
        bh=ttfHv9QusBSh12Dx/Z3hp9QgyGn+JQby9PVQ2hgGJ0o=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JwISdxydw/wVthBcJF+jZuRkCWbS8x+OeVMngmL8PlZiqHz6ruEnVsVxZazqCnmvD
         FVsfJCzJ2m/EkqO0uXpUd/g9J97DH8vBiFVSWizWRhICjTkpeo0S3zOUaqHnJ++hIB
         StL0/JMlJvsc6K4Fyol9V7IxvDFAqRl8A8qGrcao=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CE4C760252;
        Thu, 25 Apr 2019 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211324;
        bh=ttfHv9QusBSh12Dx/Z3hp9QgyGn+JQby9PVQ2hgGJ0o=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Fnr85bSzZoBwdCXY67PXjzdm1AGLnR8cCD2a6wYv1uWkwEHiuKOEvZGe8L3TBET0y
         E06vjh/u28cPcEtm3CMgk2q8e4ZvO1cWQvkHYp16RD3XRNl+sRMlxG3SAvVl50bUxz
         iBKQ8rhI7MGqDxXhnS0HYP7vtFdCUEnkr7cKBRXo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CE4C760252
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: fix spelling mistake "capabilties" ->
 "capabilities"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190415142649.18452-1-colin.king@canonical.com>
References: <20190415142649.18452-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165525.6EEEF60736@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:55:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There various spelling mistakes in function names and in message
> text. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Patch applied to wireless-drivers-next.git, thanks.

3b989e58e88a mwifiex: fix spelling mistake "capabilties" -> "capabilities"

-- 
https://patchwork.kernel.org/patch/10900921/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

