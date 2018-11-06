Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7554BC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BC882085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hUTqZRIb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S9IP3k7k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BC882085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389541AbeKGCNW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:13:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34668 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389262AbeKGCNW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:13:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1E22E6083C; Tue,  6 Nov 2018 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541522838;
        bh=sY/o63L7aUE6FwoNqQkUmXI6L2fn4xye5vMHbiwYVhU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hUTqZRIbPr9ktro73vuM8oUohgxE5/pp0QhFxR7s7b0Rpe6VCghRYiygWpySbKRje
         fe12B1ZwCtGoSp2t2O1mlzERoFchrWCmIa46hFw5WiBj/k9OHiXfw0UdoWx6Nb6vBB
         tq+jWwM6fxHwUKcjh5KV0mFOg4YmmoIlcM/iWKlA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AE2F76038E;
        Tue,  6 Nov 2018 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541522837;
        bh=sY/o63L7aUE6FwoNqQkUmXI6L2fn4xye5vMHbiwYVhU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=S9IP3k7kCDQBmkLMTpNjmSvFhD0+Pcesqunp6uJ/l8Zd6dKIvkEveO7Uvwu0mtRfG
         rznk2lgU5CoLh8Ge5usUOpyCSI8p0l7Y8qSFfriF7scmQfZr3DcGGcIq1l4u+rd05m
         FyaZ/ihiEPLV6K8+cqL49pkBqi9WSRr9eIIAdfkk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AE2F76038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mt76: fix building without CONFIG_LEDS_CLASS
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <33a74f5182ddf9bf90c883884924dc93547a5fb4.1541432864.git.lorenzo.bianconi@redhat.com>
References: <33a74f5182ddf9bf90c883884924dc93547a5fb4.1541432864.git.lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com,
        arnd@arndb.de
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106164718.1E22E6083C@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:47:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_LEDS_CLASS is disabled, or it is a loadable module while
> mt76 is built-in, we run into a link error:
> 
> drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_register_device':
> mac80211.c:(.text+0xb78): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `devm_of_led_classdev_register'
> 
> We don't really need a hard dependency here as the driver can presumably
> work just fine without LEDs, so this follows the iwlwifi example and
> adds a separate Kconfig option for the LED support, this will be available
> whenever it will link, and otherwise the respective code gets left out from
> the driver object.
> 
> Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers.git, thanks.

b374e8686fc3 mt76: fix building without CONFIG_LEDS_CLASS

-- 
https://patchwork.kernel.org/patch/10668565/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

