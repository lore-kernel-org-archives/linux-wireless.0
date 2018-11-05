Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96265C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D57F2085A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LSY3wZCC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fRVaKPdr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D57F2085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387467AbeKFAOv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 19:14:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387465AbeKFAOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 19:14:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 220E4607CA; Mon,  5 Nov 2018 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541429685;
        bh=s0fEBYdz/bB4E2xo1PX2jwHst/MNI9qTCJGd14ma4Pk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LSY3wZCC/cRpnjZV0GsmCP171vjOht9NPYrhYLcZtTLz3af455RqcZOM3Mg0P79PG
         SbMc3h61U0aTwvvb0284uOnQefAY/HPaqgHXZfdB8n1jNwBO2aZc+mp0Kbmar3Nv+T
         IGtwQXtAnVPAortHGfo+s4rjrdurd/x0r8XuPI5o=
Received: from x230.qca.qualcomm.com (87-93-163-19.bb.dnainternet.fi [87.93.163.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 09D666044B;
        Mon,  5 Nov 2018 14:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541429684;
        bh=s0fEBYdz/bB4E2xo1PX2jwHst/MNI9qTCJGd14ma4Pk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fRVaKPdrGlHQcoJmR9rzcLWLzcI91JoY+0XzmHgXi9q1Y/Iow+/i6zMWQxFwwOk9B
         P9Zb6Aq0AbIHiFA+nAa7mW5dYTtGpgEiN6JwyYFPM6SW+O6XbN4BOxr+ywEjew/AT9
         tWQvti9yYuxdSaOU/YzvHrg+eWcFKUjV7BYaXTZU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 09D666044B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH] mt76: fix building without CONFIG_LEDS_CLASS
References: <cover.1541150589.git.lorenzo.bianconi@redhat.com>
        <5d0d7286445acef822a806dc89fcbf9eb2672ade.1541150589.git.lorenzo.bianconi@redhat.com>
        <87r2g3btnd.fsf@purkki.adurom.net>
        <20181102132006.GA27823@localhost.localdomain>
Date:   Mon, 05 Nov 2018 16:54:40 +0200
In-Reply-To: <20181102132006.GA27823@localhost.localdomain> (Lorenzo
        Bianconi's message of "Fri, 2 Nov 2018 14:20:07 +0100")
Message-ID: <87k1lrfubz.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> 
>> > From: Arnd Bergmann <arnd@arndb.de>
>> >
>> > When CONFIG_LEDS_CLASS is disabled, or it is a loadable module while
>> > mt76 is built-in, we run into a link error:
>> >
>> > drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_register_device':
>> > mac80211.c:(.text+0xb78): relocation truncated to fit:
>> > R_AARCH64_CALL26 against undefined symbol
>> > `devm_of_led_classdev_register'
>> >
>> > We don't really need a hard dependency here as the driver can presumably
>> > work just fine without LEDs, so this follows the iwlwifi example and
>> > adds a separate Kconfig option for the LED support, this will be available
>> > whenever it will link, and otherwise the respective code gets left out from
>> > the driver object.
>> >
>> > Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>> 
>> Should this go to 4.20? A linker error is pretty bad, even though I
>> think this is few months old issue already.
>
>  I guess so. The patch is based on top of Felix's repository so it apply with a
>  'fuzz' on net-next/wireless-drivers-next but the patch is ok. Do I need to
>  resend or it is ok?

Doesn't seem to apply to wireless-drivers (which I fast forwarded to
v4.20-rc1 today):

Failed to apply the patch: ['git', 'am', '-s', '-3'] failed: 128
fatal: sha1 information is lacking or useless (drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c).
error: could not build fake ancestor

So please rebase and resend.

-- 
Kalle Valo
