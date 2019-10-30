Return-Path: <SRS0=eZlD=YX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C66CA9EC6
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Oct 2019 15:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA4252087E
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Oct 2019 15:00:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gXiyGPdM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="V5LmxwlF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfJ3PAN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:00:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfJ3PAN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Oct 2019 11:00:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5CBE661132; Wed, 30 Oct 2019 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572447612;
        bh=M145wklyaQ/9eq5X3CsZxVwiMjOf/lG6nY/1ZPp+I5g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gXiyGPdMGa7JFDN6tmD5cWLVzEqQo5oimEfC+D6XsyK9NcrsZuCFaaKolOuQBek/S
         mtYBykznWpV10S08T61JNjEJ6OwFl/9F/5ONLUg1GIhuuOuzHhBU0Qh74dLmitaHAI
         2legmIspXOyAzfagh9FngJ3wgnPfAp7NwbBdIX0g=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6809661132;
        Wed, 30 Oct 2019 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572447609;
        bh=M145wklyaQ/9eq5X3CsZxVwiMjOf/lG6nY/1ZPp+I5g=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=V5LmxwlFd9B9yc2zcPpQ1hVxHSTy0CmnO67tEGU8HmqjyvBAg0z4DJ/4nvst4qlqG
         uRCDC49P2Tl4oSmR0YNkYSMKAx+AmsfWoC+4zfJiVV/ppyIj+BZFFCFpZKBKbqjaJ0
         wU1IIE636BTJg+uqym02aAChhuQ6YwL2uJRyAkro=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6809661132
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm
 by default
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <cbd541284b80a966e2050ac809a495c55cfb591e.1572204430.git.lorenzo@kernel.org>
References: <cbd541284b80a966e2050ac809a495c55cfb591e.1572204430.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, hkallweit1@gmail.com,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191030150012.5CBE661132@smtp.codeaurora.org>
Date:   Wed, 30 Oct 2019 15:00:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> On same device (e.g. U7612E-H1) PCIE_ASPM causes continuous mcu hangs and
> instability. Since mt76x2 series does not manage PCIE PS states, first we
> try to disable ASPM using pci_disable_link_state. If it fails, we will
> disable PCIE PS configuring PCI registers.
> This patch has been successfully tested on U7612E-H1 mini-pice card
> 
> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

2 patches applied to wireless-drivers.git, thanks.

f37f05503575 mt76: mt76x2e: disable pcie_aspm by default
7bd0650be63c mt76: dma: fix buffer unmap with non-linear skbs

-- 
https://patchwork.kernel.org/patch/11214309/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

