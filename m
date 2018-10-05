Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C739CC65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8513D20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:35:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MjfxL+nt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZNDq3Dse"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8513D20875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbeJEPdR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:33:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46150 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbeJEPdR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:33:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BDBE36024C; Fri,  5 Oct 2018 08:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728535;
        bh=h/f1mnxffZIaVy9cMlH2+sYSjz0bzAtVGQXcz4qZ7Gw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MjfxL+ntGongYV8e9RJFPnCuX8nH6z04+PruBiIvoA8EthNYKBaNBL4agvoWX1hxd
         Kz/IqGKMoU9V8MpxfTG4yzM2ovkQJo3r4Ua7PlpUUYyM32P8zMR9AFABsV05lflePU
         979/u6otna9ju+SjV8+54R8DzgwXFNzMAXZJKDHg=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DD504601A0;
        Fri,  5 Oct 2018 08:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728534;
        bh=h/f1mnxffZIaVy9cMlH2+sYSjz0bzAtVGQXcz4qZ7Gw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZNDq3Dseb6J6dQd+e2EfiJuLfyCGijyUKqdJL0s7TZFf7rx0g/1vJMA0UdKpD38j7
         129a724L3yZe5jiEfhf1CJrckHDD5NgJguHrQrvu0FIfyOP/KCTBSUAkP60VHkit1P
         VjcIECGSK+8gQLtUy7L2dlNOdyDgDNXR3h0IY5uc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DD504601A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 08/16] zd1211rw: Replace spin_is_locked() with lockdep
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181003053902.6910-9-ldr709@gmail.com>
References: <20181003053902.6910-9-ldr709@gmail.com>
To:     Lance Roy <ldr709@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Lance Roy <ldr709@gmail.com>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181005083535.BDBE36024C@smtp.codeaurora.org>
Date:   Fri,  5 Oct 2018 08:35:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lance Roy <ldr709@gmail.com> wrote:

> lockdep_assert_held() is better suited to checking locking requirements,
> since it won't get confused when someone else holds the lock. This is
> also a step towards possibly removing spin_is_locked().
> 
> Signed-off-by: Lance Roy <ldr709@gmail.com>
> Cc: Daniel Drake <dsd@gentoo.org>
> Cc: Ulrich Kunitz <kune@deine-taler.de>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: <linux-wireless@vger.kernel.org>
> Cc: <netdev@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

209e957b467b zd1211rw: Replace spin_is_locked() with lockdep

-- 
https://patchwork.kernel.org/patch/10624325/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

