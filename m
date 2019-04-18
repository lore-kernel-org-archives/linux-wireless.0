Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7355C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87ADA20674
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iJ8/0xu0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZGByBbwZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389174AbfDRNta (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:49:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388073AbfDRNt3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 09:49:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0AD39607CA; Thu, 18 Apr 2019 13:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555595369;
        bh=45Y6N+S7OaB9LhOtPy3nchhklMezWadHzyiI6mL38pg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iJ8/0xu0OhpjQauMRD1myRMkvAFtMgzMKyPWIE6tHOrBttL7W4sFuMfXQB6zyJvav
         U7D6oM0HpH2ZBjKtQZyd9jpGKDFHcpvXbEXO4w+34DujD05K1bJjSe4lpyW1pUvyce
         0w8Vc52xLaZac8XVPJ1eYDpirh6S9QyvlsRAsxXQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E4B1E602A7;
        Thu, 18 Apr 2019 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555595368;
        bh=45Y6N+S7OaB9LhOtPy3nchhklMezWadHzyiI6mL38pg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZGByBbwZ5zOXZPTpF53ZsV11me581YNEYMamDq3y14y/3FB9bxdm3Apw7Zq2UrAhs
         5BvMuXL54ZbfA77/JpHaS7S9kqQrnB/yCO5PjDK4WtD0p2F3grqPzKS8QdL807CvYF
         6CPgyPh33tzXQ6TU909vENa3x7qjjHCOo06lkSv8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E4B1E602A7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with the wireless-drivers tree
References: <20190415120853.39e0e46a@canb.auug.org.au>
Date:   Thu, 18 Apr 2019 16:49:24 +0300
In-Reply-To: <20190415120853.39e0e46a@canb.auug.org.au> (Stephen Rothwell's
        message of "Mon, 15 Apr 2019 12:08:53 +1000")
Message-ID: <87k1fr2zkr.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Today's linux-next merge of the wireless-drivers-next tree got a
> conflict in:
>
>   drivers/net/wireless/intel/iwlwifi/pcie/drv.c
>
> between commits:
>
>   0d5bad14226a ("iwlwifi: rename structs to fit the new names")
>   972d8e137779 ("iwlwifi: add new 0x2723/0x2080 card for 22000")
>
> from the wireless-drivers tree and commit:
>
>   ef8a913766cd ("iwlwifi: remove misconfigured pci ids from 22260 series")
>
> from the wireless-drivers-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Thanks, I'll let Dave know about this when he pulls w-d-next.

-- 
Kalle Valo
