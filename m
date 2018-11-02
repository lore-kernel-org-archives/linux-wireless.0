Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064BFC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3716204FD
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RsbnY8+8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RsbnY8+8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3716204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbeKBUkz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:40:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45110 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbeKBUkz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:40:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E4C7360590; Fri,  2 Nov 2018 11:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541158442;
        bh=B+1pD3Nih/QUlqxY3oXMnG6/wHN59W1+89bc8ynweII=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RsbnY8+8UildlPgS+h/wMAynwlscNLx0qXOfwsrIO0KlFlhkSeorLx0w8JNOyzxOn
         GMX2O2OSRgd+7knXkNuarBWWMZG8tGfmBNcSBa/URreHW+SOIBGI7IVpa4jBeFJCAS
         U6S7/2yTiud8R4wdId2BHuqKS/jyupP24IZMIZaw=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8AAFB6074C;
        Fri,  2 Nov 2018 11:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541158442;
        bh=B+1pD3Nih/QUlqxY3oXMnG6/wHN59W1+89bc8ynweII=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RsbnY8+8UildlPgS+h/wMAynwlscNLx0qXOfwsrIO0KlFlhkSeorLx0w8JNOyzxOn
         GMX2O2OSRgd+7knXkNuarBWWMZG8tGfmBNcSBa/URreHW+SOIBGI7IVpa4jBeFJCAS
         U6S7/2yTiud8R4wdId2BHuqKS/jyupP24IZMIZaw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8AAFB6074C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH] mt76: fix building without CONFIG_LEDS_CLASS
References: <cover.1541150589.git.lorenzo.bianconi@redhat.com>
        <5d0d7286445acef822a806dc89fcbf9eb2672ade.1541150589.git.lorenzo.bianconi@redhat.com>
Date:   Fri, 02 Nov 2018 13:33:58 +0200
In-Reply-To: <5d0d7286445acef822a806dc89fcbf9eb2672ade.1541150589.git.lorenzo.bianconi@redhat.com>
        (Lorenzo Bianconi's message of "Fri, 2 Nov 2018 10:32:32 +0100")
Message-ID: <87r2g3btnd.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

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

Should this go to 4.20? A linker error is pretty bad, even though I
think this is few months old issue already.

And are conflicts with -next version of mt76 likely?

-- 
Kalle Valo
