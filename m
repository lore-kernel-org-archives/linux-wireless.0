Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72008C3A5A7
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EF4B2343A
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g8noLUsx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TIlpV6Be"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfICNkr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:40:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfICNkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:40:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D15F660907; Tue,  3 Sep 2019 13:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518046;
        bh=kGoj/xp0kX7mOwdsd2X5M3W7dTHktSJCTS0WiuYdXKA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=g8noLUsxOpTFeCU8y5QURhp2EV9OVmtVoHU6OmoxL0Ws8a/6Ca/9LYajuOttA1j1F
         2c0WYrxo2WKmqURU8LE8twh1EcaFSMYL0I4qKmCqOPbvs+17r+Df4K13g0lUhCmd1v
         m3uWz2Ujvw6Zc89MrT4yPICMylkzri9AlsJOEB2k=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E43AE605A2;
        Tue,  3 Sep 2019 13:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518046;
        bh=kGoj/xp0kX7mOwdsd2X5M3W7dTHktSJCTS0WiuYdXKA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TIlpV6BeruheFKPvxmNS4/No17Ba5o+UDxz0JXVRHEXf2pw8rDNKKo0wdD9QTdVm2
         p6z9RlH39dPT7ZNO6OzwAOr57wdUvD68lgX3nKeNzgvwYMS5GbA2ViXQIF9BAvG4tk
         NmfIi2gNznLjJIiyehTFjHPcy9S+inwMx5SpI/G4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E43AE605A2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2x00: fix spelling mistake "initializationg" ->
 "initialization"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190822220025.5690-1-colin.king@canonical.com>
References: <20190822220025.5690-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903134046.D15F660907@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:40:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in an IPW_DEBUG_INFO message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

14aba89386a4 ipw2x00: fix spelling mistake "initializationg" -> "initialization"

-- 
https://patchwork.kernel.org/patch/11110159/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

