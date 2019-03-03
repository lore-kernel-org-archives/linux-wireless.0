Return-Path: <SRS0=pcPV=RG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51A6C43381
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 19:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86DBD20835
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 19:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=jrdltd-co-uk.20150623.gappssmtp.com header.i=@jrdltd-co-uk.20150623.gappssmtp.com header.b="Qtb4kjmv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfCCTEQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 14:04:16 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37564 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfCCTEQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 14:04:16 -0500
Received: by mail-ot1-f68.google.com with SMTP id b3so2432176otp.4
        for <linux-wireless@vger.kernel.org>; Sun, 03 Mar 2019 11:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrdltd-co-uk.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=+fBlg82t8o4Ect7xI6SaLBbFZW4Wj8Gy7CvsjCSRBjs=;
        b=Qtb4kjmv+gt4/LOoYYemW3nbpXfgayJLV3wsbC1GlnF/diZ+C5ytNdzvI2PMDGonEz
         NnocuDDb+lrPOgH8k97HlrS6VkBa/s4JZ1sCcXafOUnSQK4s39+QCYDdEl47kLoJumhi
         Dn1LQ9WsTDBdfaSSbeErY2ifJZP0UGxsGKKXH+XvDFZ/OOuIi0HXn/D5sRLMPFhZJOMn
         oDDawZroCnE2XBIw+uFezTl23IRdk1qFCwcsyeVJG5r98DAMxi3cuWXrbfwXAdm1Eora
         AvqrymfaFqdXwp7pG/UWMyQhSJBR6UO3JkHrP1VcHDF/2uHbIZIBNyuUwceF1npVgo0a
         MGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=+fBlg82t8o4Ect7xI6SaLBbFZW4Wj8Gy7CvsjCSRBjs=;
        b=Rxn81fqId+8j2RAQoLZ1QCq2Cm5aLzezP0cXUTOYBqA3rFnQ9qpRBJLtyu8vMGLYu0
         YZyV+eADeelDhsA1LFxGSsYBTGppdtwpHJtiioyMNNNNpvIu0RDYK4KWQzHgqULndIEU
         dOGafG1cg3lVHPOWGk0mXz93HDrX84TfwjvoWX/5SIaypEyoYwiM4yYfxdLbFhu6Jfe0
         Y+PWHuTTQwQArnuQFSHD6KNFp+n6/5Ac8MbAPiS/QroUuS4qx8k/5Hj74xvFwW0Omnvl
         PEhyXk7Wj9Bc50r94ctPF5N+ZTndJ8kOeLjueotIOAdAMEqclIztv3rNAZNX8MSeyElP
         9jkw==
X-Gm-Message-State: APjAAAUi2l+gEc+L7lKpY4zeh0TxPG24kMe8099DLYpTzS2tjl4MWGzT
        acIQLjXPa2EI9uLhQr41oxfjRjMJEhIGiBaJi6dwpfdKnGs=
X-Google-Smtp-Source: APXvYqyUv9wOnAtxlxUmjb30xKH8fgrHwotnRU2JiLu95URXr8/IUB9W1GhwWMGixjx4Luzpn/1+hPFhcpyxfMNdTVA=
X-Received: by 2002:a9d:6c96:: with SMTP id c22mr9487354otr.38.1551639855229;
 Sun, 03 Mar 2019 11:04:15 -0800 (PST)
MIME-Version: 1.0
References: <CAAUgxQLVXy4X-h+dLK0WrU5_cvbx0+mxvyFRFuNkYkybP4f_1g@mail.gmail.com>
In-Reply-To: <CAAUgxQLVXy4X-h+dLK0WrU5_cvbx0+mxvyFRFuNkYkybP4f_1g@mail.gmail.com>
From:   Krzysiek Rosinski <krzysiek@jrdltd.co.uk>
Date:   Sun, 3 Mar 2019 20:04:04 +0100
Message-ID: <CAAUgxQ+PU4Z5Nhj8K5r3ijKm87-GvTg9QffSjOenHWDRDauZSg@mail.gmail.com>
Subject: Re: brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Mar 3, 2019 at 10:22 AM Krzysiek Rosinski <krzysiek@jrdltd.co.uk> wrote:
>
> Hi,
>
> I'm working on a custom board with cyw4343 connected to osd3358-sm (TI
> am3358), when I load the brcmfmac driver I get 'HT Avail timeout'
> error. The same combination of driver+firmware works fine on Raspberry
> Pi Zero W.
>
> I've tried to gather as much information I can from both; the custom
> board and pi. This is available here:
>
> https://www.dropbox.com/s/vqejyrixbxx1z8d/logs.tar.gz?dl=0
>
> I have a custom board with cyw4343 chip fitted and also flyleded
> Murata 1DX to the PocketBeagle, both give the same error code.
>
> My setup is as follows:
>
> osd335x-sm (TI am3348), cyw4343, 37.4 MHz xtal.
> Linux beaglebone 4.14.93-bone17.1 #1 PREEMPT Mon Feb 25 16:27:58 UTC
> 2019 armv7l GNU/Linux
> brcmfmac: cypress v4.14.52-backports
> brcm43430-sdio.bin: Version: 7.45.98.38
>
> Is there something obvious which I'm doing wrong? Can you give me a
> hint on how to move with this further, please?
>
> Kind regards,
> Krzysztof

Hi,

Actually, I've managed to fix this with information from the "AP6335
with mainline kernel" thread:

"boardflags3 (...) to 0x101188"

this fixed my problem too. Is there documentation which says what
boardflags3 means, please?

Once I've fixed this problem this show up:

[ 378.143229] omap_hsmmc 47810000.mmc: MMC start dma failure
[ 378.148856] brcmfmac: brcmf_sdiod_sglist_rw: CMD53 sg block write failed -22
[ 378.159997] brcmfmac: brcmf_sdio_txfail: sdio error, abort command
and terminate frame

I've managed to fix this by applying patch from here:

https://e2e.ti.com/support/processors/f/791/t/541016?AM335X-Error-message-in-SDIO-driver

Kind regards,
Krzysztof
