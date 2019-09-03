Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F76C3A5A7
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 498D72339D
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XmNFZIWL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="H8KzDMTY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfICNhs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:37:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfICNhs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:37:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3D1EE6058E; Tue,  3 Sep 2019 13:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517867;
        bh=bDTNNilYdpUlodPb6+yDWuW9svm70ZB2VEkJn2DvM4s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XmNFZIWLGqOVJHJRIIk6m3r0cM5Z4kNHXIL3pNPZwGI47uLmoMLNCgFjlTSNfQJW/
         YYETu1s1aOvmQ9zINve/Knz6qlqborT8lKyQC7J06UWUhhaBJZWq9bLF8Lz68b2nzX
         tsew+kWFmXDbd4yvVAw1qYyE0fY2Imzm0DFmO798=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D22C26058E;
        Tue,  3 Sep 2019 13:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517865;
        bh=bDTNNilYdpUlodPb6+yDWuW9svm70ZB2VEkJn2DvM4s=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=H8KzDMTYcajfm/oklsidWnBVMUXwxc8UG7Pw2qiWLXjdkQmRdEDfXdlLOYQ7hAUEC
         MrgOfRg7K7br/vyCLlvPWAGjrUKYKLkKcfW5r61CfUzGaxy0+uSu/nCOePhas4OPP+
         tSs8GrRFzpL7b+tutYs+SYdDJGutBdoHTlEFTxDc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D22C26058E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcm80211: Avoid possible null-pointer dereferences in
 wlc_phy_radio_init_2056()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190729095652.1976-1-baijiaju1990@gmail.com>
References: <20190729095652.1976-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net,
        pieter-paul.giesberts@broadcom.com, plaes@plaes.org,
        rvarsha016@gmail.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903133747.3D1EE6058E@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:37:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> In wlc_phy_radio_init_2056(), regs_SYN_2056_ptr, regs_TX_2056_ptr and
> regs_RX_2056_ptr may be not assigned, and thus they are still NULL.
> Then, they are used on lines 20042-20050:
>     wlc_phy_init_radio_regs(pi, regs_SYN_2056_ptr, (u16) RADIO_2056_SYN);
> 	wlc_phy_init_radio_regs(pi, regs_TX_2056_ptr, (u16) RADIO_2056_TX0);
> 	wlc_phy_init_radio_regs(pi, regs_TX_2056_ptr, (u16) RADIO_2056_TX1);
> 	wlc_phy_init_radio_regs(pi, regs_RX_2056_ptr, (u16) RADIO_2056_RX0);
> 	wlc_phy_init_radio_regs(pi, regs_RX_2056_ptr, (u16) RADIO_2056_RX1);
> 
> Thus, possible null-pointer dereferences may occur.
> 
> To avoid these bugs, when these variables are not assigned,
> wlc_phy_radio_init_2056() directly returns.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

b80df89f3909 brcm80211: Avoid possible null-pointer dereferences in wlc_phy_radio_init_2056()

-- 
https://patchwork.kernel.org/patch/11063553/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

