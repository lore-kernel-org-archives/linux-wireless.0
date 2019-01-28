Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914DDC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 08:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B5092148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 08:21:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MLTN3X+8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="A61Zhf7O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfA1IVm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:21:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfA1IVl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 03:21:41 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 60B0A605A5; Mon, 28 Jan 2019 08:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548663700;
        bh=YqrxPF6UWHwvNw6hXK9SUGTN4I1gzsdcpUYJtbgS3KY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MLTN3X+83hzBD+1yIb7yueyDocaat/gdLUwiQCpLAK7J8HV2igEQ+EOfNiruBKgoq
         qRaLhNJ6J9v+e5pvkx5Qmm4m3R1yvWs2DhPXKmo84SPDfZwSvqd7EaJCowqYHwO9B+
         BHzug0/4dbVBK1MArvpCM9tTZ+FoyplLPNuxfmyY=
Received: from x230.qca.qualcomm.com (87-93-85-88.bb.dnainternet.fi [87.93.85.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A5D0A60740;
        Mon, 28 Jan 2019 08:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548663699;
        bh=YqrxPF6UWHwvNw6hXK9SUGTN4I1gzsdcpUYJtbgS3KY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=A61Zhf7OkIrxY8HjDzh+V7bXSCy65z4RoqSp3QpKoor3h0UaVbvcfOIT/5f6qHjyt
         edXBT7wB0bJ6d5h24U3dOcYxxkRp3D6p9UXhfsxwMuN94VCqm44E14sShZ52MBOi60
         36dPMB3Utnux7p++NSWFGadks+O/udnZ7QfrXjYY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A5D0A60740
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Franky Lin <franky.lin@broadcom.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        netdev@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: wireless: prefix header search paths with $(srctree)/
References: <1548429480-22137-1-git-send-email-yamada.masahiro@socionext.com>
Date:   Mon, 28 Jan 2019 10:21:31 +0200
In-Reply-To: <1548429480-22137-1-git-send-email-yamada.masahiro@socionext.com>
        (Masahiro Yamada's message of "Sat, 26 Jan 2019 00:18:00 +0900")
Message-ID: <8736pd2nw4.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Masahiro Yamada <yamada.masahiro@socionext.com> writes:

> Currently, the Kbuild core manipulates header search paths in a crazy
> way [1].
>
> To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
> the search paths in the srctree. Some Makefiles are already written in
> that way, but not all. The goal of this work is to make the notation
> consistent, and finally get rid of the gross hacks.
>
> Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
> ("kbuild: do not drop -I without parameter").
>
> I also removed one header search path in:
>
>   drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile
>
> I was able to compile without it.
>
> [1]: https://patchwork.kernel.org/patch/9632347/
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
>
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile | 4 ++--
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile | 6 +++---
>  drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile | 4 +---
>  drivers/net/wireless/intel/iwlwifi/dvm/Makefile           | 2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/Makefile           | 2 +-
>  drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile     | 2 +-
>  drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile     | 2 +-
>  7 files changed, 10 insertions(+), 12 deletions(-)

Luca, is it ok if I take this to wireless-drivers-next even though it
touches iwlwifi makefiles?

-- 
Kalle Valo
