Return-Path: <SRS0=EA+v=SB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC61C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 06:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2F00218A6
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 06:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pG27VudW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G6dLAxSy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfC3GIk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 30 Mar 2019 02:08:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730047AbfC3GIk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Mar 2019 02:08:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B56B96081E; Sat, 30 Mar 2019 06:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553926119;
        bh=uXFMR+qQ9MU1kXbyJWeI2UPOE12YR3MK/gLmhHknfsk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pG27VudWOPROS0WJ0x2m9PapF2RQ/H5iS0S0HhHaubvU3JdUJ/abyywVsaZnry962
         4W+XUBHCA9WmOsh19yYcBUn8/BhQDfWr6pVcHxhpUuiSrdvT4XuhXHeS5d31hG3aG0
         WglOWQoZ7h9iSidmLYfaZiKk+R422XW7JBNdntLw=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D72E6602BA;
        Sat, 30 Mar 2019 06:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553926118;
        bh=uXFMR+qQ9MU1kXbyJWeI2UPOE12YR3MK/gLmhHknfsk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=G6dLAxSy0iTsACn2xZjIW2DBDEY8R0KTpAeswWRh5VPySi7GVai5eo900YbEdWskt
         N/Zce4Sd/gQA57khC0SIMmnGKZzekgjCpNynIfBOBAejHda4wF0wH9yRl1CG1MVMGl
         XrjyE4C4Zn82l5+sbUuDpn30TRjvI5O3fDvofm38=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D72E6602BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ryder Lee <ryder.lee@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Roy Luo <royluo@google.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        YF Luo <yf.luo@mediatek.com>, Kai Lin <kai.lin@mediatek.com>,
        Rorscha Yang <rorscha.yang@mediatek.com>,
        Kyle Lee <kyle.lee@mediatek.com>,
        Miller Shen <miller.shen@mediatek.com>,
        Haipin Liang <haipin.liang@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH 1/4] mt76: add mac80211 driver for MT7615 PCIe-based chipsets
References: <cover.1553607739.git.ryder.lee@mediatek.com>
        <2849359e0b0ede6c13ae9f142aff77a016fd0a80.1553607739.git.ryder.lee@mediatek.com>
Date:   Sat, 30 Mar 2019 08:08:32 +0200
In-Reply-To: <2849359e0b0ede6c13ae9f142aff77a016fd0a80.1553607739.git.ryder.lee@mediatek.com>
        (Ryder Lee's message of "Tue, 26 Mar 2019 22:28:07 +0800")
Message-ID: <87lg0wyjvj.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ryder Lee <ryder.lee@mediatek.com> writes:

> This driver is for a newer generation of MediaTek MT7615 4x4 802.11ac
> PCIe-based chipsets, which support wave2 MU-MIMO up to 4 users/group
> and also support up to 160MHz bandwidth.
>
> The driver fully supports AP, station and monitor mode.
>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> Signed-off-by: Roy Luo <royluo@google.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

[...]

> --- /dev/null
> +++ b/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
> @@ -0,0 +1,204 @@
> +// SPDX-License-Identifier: GPL-2.0

mt76 is under ISC so why did you choose GPLv2 here? I don't think it's a
good idea to use different licenses within the same driver.

Also mt76 does not use SPDX tags yet. I would prefer that the whole
driver is converted in one go to have consistent licensing information.

-- 
Kalle Valo
