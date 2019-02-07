Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572BCC282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2761D21872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gUzqH3N5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GPBDQi5k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfBGOxo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:53:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGOxn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:53:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 82C0360264; Thu,  7 Feb 2019 14:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551222;
        bh=UuGl5VCobxOkav+2uGpwQF7pJ5isPMXsoDDTYjwqonE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gUzqH3N59wVFeEhBQPxzSXEmSa9NWRENGsOSKZnTMjxXfzJ6RWIzv5yhaNelf51Nw
         sAprvaVoGS3twB23ZvOIKQLz3jbv8crC1/KGSUMtmMPIJiu+8mUcqtd0lkBEgksUaU
         4eUgkEnVQBt/XTNjGR1DxSm4gFxolC1xwlH4gcYo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ABE3760247;
        Thu,  7 Feb 2019 14:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551221;
        bh=UuGl5VCobxOkav+2uGpwQF7pJ5isPMXsoDDTYjwqonE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=GPBDQi5keGSG4P63BK8JOs56Mvwbhi0MkuAy+lBbbWVvvpzL0cvl9cejy4ZW/Gcm0
         HtCp9JXaFvwlu5bQxFiBDDyDO39GsgDg7lSTCdymbWIbxXzrM+JJl1ZmMHqny1A0fq
         5+x045buUktSBnmUA8sxEJl3bsH4FpwZ+An7w0p8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ABE3760247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: sdio: add .owner field
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190129231448.83305-1-briannorris@chromium.org>
References: <20190129231448.83305-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Wen Gong <wgong@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207145342.82C0360264@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:53:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> sdio_register_driver() doesn't do this for us, unlike (for example)
> platform_driver_register(). This is important for helping track
> module-to-device relationships.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ea6959840814 ath10k: sdio: add .owner field

-- 
https://patchwork.kernel.org/patch/10787307/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

