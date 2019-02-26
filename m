Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C65C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65ACB20651
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:08:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ai9dWu+a";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IIJAwomM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfBZNIp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:08:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51310 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfBZNIp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:08:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 99F3E60F3C; Tue, 26 Feb 2019 13:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186524;
        bh=/AhjIOPfFsoa3ObJX8miPTNLDMiFUyCPvwouJsiJU/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ai9dWu+avz6iHs5SnPkOWpiKcssZIGltnqOCPsgKnLs7qGNJ37Y0uhBDyfo8SDXM3
         L5GYXLeiFPkOLv5EMzf38U9zBJeGsP+UXvHtke/Ahn/rVXNCgdvarVlUqyJzaSEGaX
         sqhGScN7b61V04KNDNk+tXHmY+OGz8Aj1pKXTbqo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E486160247;
        Tue, 26 Feb 2019 13:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186523;
        bh=/AhjIOPfFsoa3ObJX8miPTNLDMiFUyCPvwouJsiJU/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=IIJAwomMcSLdzqPoHbx9Itn/fM2oIJSpa3gclgGK3zqoMtbfVT763ZvQ+TSz1VWqh
         TlEAs5SjLuOGfffBkxlr1IaQ4hwRAMoAWvOPL+5u/DLSssIU4Jf1EccXR8L4sIO2ac
         op2wmMuTEsBaG9C/zgGOBwxXN2/qpKlRj3TIKRyI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E486160247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] ath9K: debugfs: Fix SPUR-DOWN field
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190221231257.6221-1-andrea.greco.gapmilano@gmail.com>
References: <20190221231257.6221-1-andrea.greco.gapmilano@gmail.com>
To:     Andrea Greco <a.greco@4sigma.it>
Cc:     johannes.berg@intel.com, Andrea Greco <a.greco@4sigma.it>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226130844.99F3E60F3C@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 13:08:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Andrea Greco <a.greco@4sigma.it> wrote:

> SPUR DOWN field returns spurup instead of spurdown.
> 
> Signed-off-by: Andrea Greco <a.greco@4sigma.it>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d0480d4326e2 ath9k: debugfs: Fix SPUR-DOWN field

-- 
https://patchwork.kernel.org/patch/10824837/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

