Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05976C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA1CB2077B
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MzXWLW7s";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mggjI7E9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfBSPTp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:19:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfBSPTp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:19:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D27A46085F; Tue, 19 Feb 2019 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589584;
        bh=C+28GfTbzckEHc3YFJhmZ+27A5jDlUS3C0DNdpg6Nx8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MzXWLW7s8gM5gH/veyF+zzSH2AESmGhycb5aOFnG5Jvv8V9ZjxMUU3FTX9pUpFpaT
         80IQ7AnXeZbvJrxNTaG/gWawukXYELzDUl2iIeag75vVk0T0VQZr0OsOCkBBKPmXxf
         +63bjkpL8axmwfCd/dyrHbdbXaV1nijRlMGON4wE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3741160740;
        Tue, 19 Feb 2019 15:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589584;
        bh=C+28GfTbzckEHc3YFJhmZ+27A5jDlUS3C0DNdpg6Nx8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=mggjI7E9vGkeob7nOrwc57lnI88KQ3c6CRsZBc3qbrBC9jsCURdIZnYng8wF+o2Ej
         Y0PTtX28qbWMkH4d15YHpUT+pnQqbVGpIRE9ZzOsYcYT84O7kjyqXoqmcya1Gh9kFM
         QW1VOyxozZKm2qhtHq3aEjC9Ah1wJ4R0n2CitKg4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3741160740
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 1/5] rt2x00: remove unneeded check
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550052556-7158-2-git-send-email-sgruszka@redhat.com>
References: <1550052556-7158-2-git-send-email-sgruszka@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        =?utf-8?q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151944.D27A46085F@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:19:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> From: Tomislav Požega <pozega.tomislav@gmail.com>
> 
> Remove band check from rf53xx channel config routine since all chips
> using it are single band.
> 
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

5 patches applied to wireless-drivers-next.git, thanks.

17ae2acd1a6f rt2x00: remove unneeded check
5991a2ecd070 rt2x00: remove confusing AGC register
9ad3b5565445 rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band
7aca14885ede rt2800: enable TX_PIN_CFG_RFRX_EN only for MT7620
c7ff1bfeaf1c rt2800: comment and simplify AGC init for RT6352

-- 
https://patchwork.kernel.org/patch/10809543/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

