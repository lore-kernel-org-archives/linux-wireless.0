Return-Path: <SRS0=y/91=EK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45692C4742C
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Nov 2020 15:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D66922074B
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Nov 2020 15:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Ic0bmXoq";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="hweQ57R0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgKDP0g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Nov 2020 10:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgKDP0g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Nov 2020 10:26:36 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166D1C0613D3;
        Wed,  4 Nov 2020 07:26:36 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604503594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mya6qnHxG9AXVPmFpoE4wa1heR7bPv0DOYb/oQLjAeo=;
        b=Ic0bmXoqTr6HTkP4cJAXSzV+J0goXTVrkQ/5tfYNXzl2DyYQUFumUr1ABimRUZwGamCmwg
        BBtE/evwgolSOA1fZ19uyk6iIf4ofFTZBGSQWq4gy3MKDTpO2ZrQGvTLWoMbm61TkSbF+0
        fpLjAaUPHpRfYng642E160gp7/BlzZeAGati40fEaq85ZjLBF0aDVnG9nGXumYQ5MiEqCi
        pibjTckHZnWb/e/XQt3JpXvr4H3r1nN2iDUJNZveKC1olXKKlNMCXEodnB5CW+jqtDUzAC
        2kCVEh/SsiGgyZUbcZLykpM9zQcWjfQyb3wxkHYb/TdvD4QoGu3g+5HkfMNRog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604503594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mya6qnHxG9AXVPmFpoE4wa1heR7bPv0DOYb/oQLjAeo=;
        b=hweQ57R00/7rF+4i5Iq4qtDckFFjTGC8CD76pnxn5H/D46dP0TdCmBWw5AGbUXvBd82rMl
        /hdRVyRfYiWpHTBw==
To:     Thomas Krause <thomaskrause@posteo.de>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Govind Singh <govinds@codeaurora.org>, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, Devin Bayer <dev@doubly.so>,
        ath11k@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: pci_alloc_irq_vectors fails ENOSPC for XPS 13 9310
In-Reply-To: <fa26ac8b-ed48-7ea3-c21b-b133532716b8@posteo.de>
References: <20201103160838.GA246433@bjorn-Precision-5520> <874km61732.fsf@nanos.tec.linutronix.de> <fa26ac8b-ed48-7ea3-c21b-b133532716b8@posteo.de>
Date:   Wed, 04 Nov 2020 16:26:34 +0100
Message-ID: <87mtzxkus5.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 04 2020 at 14:04, Thomas Krause wrote:
> config) but CONFIG_INTEL_IOMMU_DEFAULT_ON needed to be set manually. I 
> hope this helps, if there is more I can do to debug it on my side I'm 
> happy to do so.

> [    0.050130] DMAR: [Firmware Bug]: Your BIOS is broken; DMAR reported at address 0!
>                BIOS vendor: Dell Inc.; Ver: 1.1.1; Product Version:

> [    0.103693] DMAR: Host address width 39
> [    0.103693] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.103697] DMAR: dmar0: reg_base_addr fed90000 ver 4:0 cap 1c0000c40660462 ecap 69e2ff0505e
> [    0.103698] DMAR: DRHD base: 0x000000fed84000 flags: 0x0
> [    0.103701] DMAR: dmar1: reg_base_addr fed84000 ver 1:0 cap d2008c40660462 ecap f050da
> [    0.103702] DMAR: DRHD base: 0x000000fed86000 flags: 0x0
> [    0.103706] DMAR: dmar2: reg_base_addr fed86000 ver 1:0 cap d2008c40660462 ecap f050da
> [    0.103707] DMAR: DRHD base: 0x00000000000000 flags: 0x1
> [    0.103707] DMAR: Parse DMAR table failure.

which disables interrupt remapping and therefore the driver gets only
one MSI which makes it unhappy.

Not that I'm surprised, it's Dell.... Can you check whether they have a
BIOS update for that box?

Thanks,

        tglx
