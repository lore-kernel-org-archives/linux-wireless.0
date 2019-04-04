Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B6EC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F36C20882
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ln8eGQTc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bVzr0GTW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbfDDKWv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:22:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42638 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfDDKWv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:22:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7E55661CCC; Thu,  4 Apr 2019 10:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373370;
        bh=yWDs5V/rHVkCiJE/mrmVvDr5bxI4I/D6hGIib6vKu/4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ln8eGQTc52x1FqbMvdqZYdH4uWuM7FRX9NQuaK3k8EHmNCGvx1OEwszpMnpAKf2ok
         DVa/+rLe5l7r02ir3DErvtns9xjj3tHHm3Pwmi7CUVRO3YsqsBLXPBXk1uROY4YuKg
         D4/3CHEGriBWSn2TksUqtR+dIOk/4YkvBNVT1zIQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4614961A40;
        Thu,  4 Apr 2019 10:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373369;
        bh=yWDs5V/rHVkCiJE/mrmVvDr5bxI4I/D6hGIib6vKu/4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=bVzr0GTWEy8dVpvNEF3LPNd72NxfYutWV3rmWhi44yCWbMgpBXv/WH/37fbVHVsR8
         Pba1TWSNslrrhaKi1cQHkVr78AV7ee0BNLsJuVNpSgLSuyRS5jIou+FX4+40uj/dc0
         wa4pocrDto3pzlJHeke0sUyIxq9YrgQosD9e8UF4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4614961A40
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/4] mwifiex: Flag wake-up interrupt as IRQ_NOAUTOEN
 rather than disabling it too late
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190224140426.3267-4-marc.zyngier@arm.com>
References: <20190224140426.3267-4-marc.zyngier@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404102250.7E55661CCC@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:22:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Marc Zyngier <marc.zyngier@arm.com> wrote:

> The mwifiex driver makes unsafe assumptions about the state of the
> wake-up interrupt. It requests it and only then disable it. Of
> course, the interrupt may be screaming for whatever reason at that
> time, and the handler will then be called without the interrupt
> having been registered with the PM/wakeup subsystem. Oops.
> 
> The right way to handle this kind of situation is to flag the
> interrupt with IRQ_NOAUTOEN before requesting it. It will then
> stay disabled until someone (the wake-up subsystem) enables it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/marvell/mwifiex/main.c).
error: could not build fake ancestor
Applying: mwifiex: Flag wake-up interrupt as IRQ_NOAUTOEN rather than disabling it too late
Patch failed at 0001 mwifiex: Flag wake-up interrupt as IRQ_NOAUTOEN rather than disabling it too late
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10827971/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

