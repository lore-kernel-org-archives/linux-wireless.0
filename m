Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B314EC282C5
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4785220870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:18:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XJkyOJhq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kBAFTqyL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfAVQR7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:17:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54760 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbfAVQR6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 11:17:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 46AC860740; Tue, 22 Jan 2019 16:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548173877;
        bh=1J2e1Wig3CxLYt+X5PQyl0071E8oRbOPrMdLYtS7NO0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XJkyOJhqPtRq9kjdokzPG3RoTxtFQsQGCk5wc0PffGm2nGJ/sagHeWomCwRlBqvPl
         1YWomTHEDZk0CdSxJxBcJ4oO+0hqwFyI3bnq2+G894/NqmONem4clGwWumMmpApgj/
         9M4Y0DChnNyAOayuN9a/aobv5BbIvKfDLluMNkhk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 93B1F60712;
        Tue, 22 Jan 2019 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548173876;
        bh=1J2e1Wig3CxLYt+X5PQyl0071E8oRbOPrMdLYtS7NO0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kBAFTqyLWr0KtWHeReOA/wQMKcn6LZK/sFhqJvPIFGwy/heDcipSb9rOzVOqL2Rke
         ircOJjSzT3GH5dLS2/3vTMPae2E4Q/7l9+5sQgauseP2kxXkPXG8tBx6+qQWhg9AxU
         VjbTIJOe8fKfP3eyEDywyHtDOxrczzRYBisG/xZs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 93B1F60712
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sinan Kaya <okaya@kernel.org>
Cc:     Luciano Coelho <luciano.coelho@intel.com>,
        linux-next@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [for next][PATCH] iwlwifi: Fix unmet dependency error for IWLWIFI_LEDS
References: <20190121233102.13705-1-okaya@kernel.org>
        <ef50896ee3ecc895c72a9fbdedca65ac6433fef2.camel@intel.com>
        <d00c99a7-423a-9a70-5f50-f95c5d044f85@kernel.org>
Date:   Tue, 22 Jan 2019 18:17:52 +0200
In-Reply-To: <d00c99a7-423a-9a70-5f50-f95c5d044f85@kernel.org> (Sinan Kaya's
        message of "Tue, 22 Jan 2019 11:12:06 -0500")
Message-ID: <87munsmztb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sinan Kaya <okaya@kernel.org> writes:

> On 1/22/2019 5:15 AM, Luciano Coelho wrote:
>> On Mon, 2019-01-21 at 23:31 +0000, Sinan Kaya wrote:
>>> There is an unresolved dependency as follows:
>>>
>>> IWLWIFI_LEDS selects MAC80211_LEDS.
>>> MAC80211_LEDS depends on MAC80211.
>>>
>>> It is possible to choose MAC80211_LEDS (y) but not choose MAC80211
>>> (n)
>>>
>>> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>>>    Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=n] &&
>>> LEDS_CLASS [=y]
>>>    Selected by [y]:
>>>    - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] &&
>>> WLAN_VENDOR_INTEL [=y] && IWLWIFI [=y] && (LEDS_CLASS [=y]=y ||
>>> LEDS_CLASS [=y]=IWLWIFI [=y])
>>>
>>> Move the MAC80211 dependency into IWLWIFI_LEDS so that we avoid this
>>> configuration.
>>>
>>> Signed-off-by: Sinan Kaya <okaya@kernel.org>
>>> ---
>>
>> Thanks for your patch! But we already have another patch to fix this
>> issued queued for 5.0-rc4 (it's currently in wireless-drivers.git):
>>
>> https://patchwork.kernel.org/patch/10762079/
>
> Is it possible to queue this up soon? There is an effort to clean up
> linux-next against randconfig failures and this issue showed up there.

It already should be in linux-next:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=ec5aecc0b227f5509d25853537f989ca303e2be1

But it's not in Linus' tree, yet.

-- 
Kalle Valo
