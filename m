Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB15C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 792FA2081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ltU1qq2T";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L5p26fea"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 792FA2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389547AbeKGC0z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:26:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGC0y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:26:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0C98E6053D; Tue,  6 Nov 2018 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523647;
        bh=CrI7q0jneloLOpDoz+IoAKiqCZMUtdwfFxmhByKRO3k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ltU1qq2TBJV/bg2a6lQeinYCw/TPcVcSiev3OZFnjcJfzqwsq+Wuw0aHGOup7M2ao
         8Y6WZyyqHXAh6jZXxN6qjOVPHunySwA0XVZUK2CdAkMq9p4QihGXBO4m4kGEmREd7c
         NqE3447LT0RDeqUhdChi5osA/ptaesxYVil7LQlk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2CE8C601DA;
        Tue,  6 Nov 2018 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523646;
        bh=CrI7q0jneloLOpDoz+IoAKiqCZMUtdwfFxmhByKRO3k=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=L5p26fea6RkffJ95WzU3J1igRuzTAsSCs1aNZwMoe8sE/9dS/iyHgCPGdsyl9z8ud
         NTsnU1xWyrIwvXFmZxkC5LyPvZNPPynlu0l9mYhDbFkMjdVNc8OzQCRgLQicYDL7Gh
         AzRWGSptN7C/mhvl3k9ju1YOh2RgxolRaBWoj2aI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2CE8C601DA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 07/20] iwlegacy: 4965-mac: mark expected switch
 fall-through
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <8d72b8a6f1529906672ac458e96d272bc55a1410.1540239684.git.gustavo@embeddedor.com>
References: <8d72b8a6f1529906672ac458e96d272bc55a1410.1540239684.git.gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106170047.0C98E6053D@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 17:00:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

14 patches applied to wireless-drivers-next.git, thanks.

e9904084dd1b iwlegacy: 4965-mac: mark expected switch fall-through
af71f8fef45c iwlegacy: common: mark expected switch fall-throughs
d56b26801e1d orinoco_usb: mark expected switch fall-through
d22b8fadd08e prism54: isl_38xx: Mark expected switch fall-through
3d238b9d5048 prism54: isl_ioctl: mark expected switch fall-through
38a0792d08e9 prism54: islpci_dev: mark expected switch fall-through
63fdc952df36 mwifiex: Mark expected switch fall-through
6eba8fd22352 rt2x00: rt2400pci: mark expected switch fall-through
10bb92217747 rt2x00: rt2500pci: mark expected switch fall-through
916e6bbcfcff rt2x00: rt2800lib: mark expected switch fall-throughs
641dd8068ecb rt2x00: rt61pci: mark expected switch fall-through
d22d2492a35d ray_cs: mark expected switch fall-throughs
89e54fa4562e rtlwifi: rtl8821ae: phy: Mark expected switch fall-through
7cbbe1597e44 zd1201: mark expected switch fall-through

-- 
https://patchwork.kernel.org/patch/10652563/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

