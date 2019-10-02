Return-Path: <SRS0=/cM4=X3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73910C352AA
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 17:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4823520659
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 17:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bFBueE0n";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HUAty5JT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfJBRVL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Oct 2019 13:21:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:32812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfJBRVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Oct 2019 13:21:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5F86261156; Wed,  2 Oct 2019 17:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570036870;
        bh=e0mkWPheC4RLsC5Ev5u60gSM5LPK0EZWhf9MXAn5Wxk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bFBueE0nDNHOzLJFtsoX8EQCBogQMXqjfEjNHrOYCRJd3eWfFt51sw1ADQUZ3JOEI
         g9wO+FBhAn1asSu+6V0cv5sz6lix9aDayqhKvg+15ul+eW9ZI+XLuTRc3KVXeBzsB/
         JaZzas0meod3MRi6YPXR6GAYvAFX1XdKgagvRt2A=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A13FD60790;
        Wed,  2 Oct 2019 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570036869;
        bh=e0mkWPheC4RLsC5Ev5u60gSM5LPK0EZWhf9MXAn5Wxk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=HUAty5JTjljLZbFbl9uElQDhWLknEpT9YJLkslzKx/+dF76M/C8WuXIrif1UIESR/
         tdQWjPHTq/YH9na8lAWATDHy8WCsFIKPxbCnvoIIMBsOyNhx4rWrUeQu0wymCgRUqi
         ngV/FfOTDBCZmDJqUDNerQXWaKCzniNBl2T2/SC4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A13FD60790
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: add support for hardware rfkill
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <156985855686.10126.201242458794108566.stgit@potku.adurom.net>
References: <156985855686.10126.201242458794108566.stgit@potku.adurom.net>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002172110.5F86261156@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 17:21:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> When hardware rfkill is enabled in the firmware it will report the
> capability via using WMI_TLV_SYS_CAP_INFO_RFKILL bit in the WMI_SERVICE_READY
> event to the host. ath10k will check the capability, and if it is enabled then
> ath10k will set the GPIO information to firmware using WMI_PDEV_SET_PARAM. When
> the firmware detects hardware rfkill is enabled by the user, it will report it
> via WMI_RFKILL_STATE_CHANGE_EVENTID. Once ath10k receives the event it will
> send wmi command WMI_PDEV_SET_PARAM to the firmware to enable/disable the radio
> and also notifies cfg80211.
> 
> We can't power off the device when rfkill is enabled, as otherwise the
> firmware would not be able to detect GPIO changes and report them to the
> host. So when rfkill is enabled, we need to keep the firmware running.
> 
> Tested with QCA6174 PCI with firmware
> WLAN.RM.4.4.1-00109-QCARMSWPZ-1.
> 
> Signed-off-by: Alan Liu <alanliu@codeaurora.org>
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

1382993f882b ath10k: add support for hardware rfkill

-- 
https://patchwork.kernel.org/patch/11166921/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

