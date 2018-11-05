Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFF8C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 08:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCBDC20685
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 08:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lqrHoQ6V";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YckzqTUg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCBDC20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbeKERZj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 12:25:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43874 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725737AbeKERZj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 12:25:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 34B636077A; Mon,  5 Nov 2018 08:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541405231;
        bh=Zy48dvwrMzBPVA6dpsWiFTfR1XVxnliavp47YHWKYWs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lqrHoQ6V5c0myV/59ulejX82VXnshwpeVbx09moR0le6c2jZ27+JlDM19EBAKMk6R
         81Zx1c3wEBJw3WDn7NgF+mXriD3q6EjSD2/iuVLq7N2/vw1qZ7SM2OZenhOUxS46/L
         mwmkAigPCSTXDeWu1bMdhNvJoLe6AqEjimqNKtWQ=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5C4D860588;
        Mon,  5 Nov 2018 08:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541405230;
        bh=Zy48dvwrMzBPVA6dpsWiFTfR1XVxnliavp47YHWKYWs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YckzqTUgXq8w/6TV85oirCRHLSOQPHk/8YcQ7AzU+0NbCJXLLdHPTuZfDibBPhBOk
         5fvtSW9XyDghJwrWrR9laBU/etWn/lUYaVXrLuMaQEs79+VAJ7hF+pZu+bV1By/N0L
         2tvr5BajxAqIkl+e+J1T70SzVNQTW+OAakKWHrSY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5C4D860588
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Priit Laes <plaes@plaes.org>
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH 0/5] Use common cordic algorithm for b43
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
        <87muqoar5i.fsf@purkki.adurom.net>
Date:   Mon, 05 Nov 2018 10:07:07 +0200
In-Reply-To: <87muqoar5i.fsf@purkki.adurom.net> (Kalle Valo's message of "Mon,
        05 Nov 2018 10:02:17 +0200")
Message-ID: <87in1caqxg.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Priit Laes <plaes@plaes.org> writes:
>
>> b43 wireless driver included internal implementation of cordic
>> algorithm which has now been removed in favor of library
>> implementation.
>>
>> During the process, brcmfmac was driver was also cleaned.
>>
>> Please note that this series is only compile-tested, as I
>> do not have access to the hardware.
>>
>> Priit Laes (5):
>>   lib: cordic: Move cordic macros and defines to header file
>>   brcmfmac: Use common CORDIC_FLOAT macro from lib
>>   brcmfmac: Drop unused cordic defines and macros
>>   b43: Use common cordic algorithm from kernel lib
>>   b43: Drop internal cordic algorithm implementation
>>
>>  drivers/net/wireless/broadcom/b43/Kconfig                      |  1 +-
>>  drivers/net/wireless/broadcom/b43/phy_common.c                 | 47 +-------
>>  drivers/net/wireless/broadcom/b43/phy_common.h                 |  9 +-
>>  drivers/net/wireless/broadcom/b43/phy_lp.c                     | 13 +-
>>  drivers/net/wireless/broadcom/b43/phy_n.c                      | 13 +-
>>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h |  7 +-
>>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c |  4 +-
>>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c   |  4 +-
>>  include/linux/cordic.h                                         |  9 +-
>>  lib/cordic.c                                                   | 23 +---
>>  10 files changed, 35 insertions(+), 95 deletions(-)
>
> I don't see patch 1 in linux-wireless patchwork:
>
> https://patchwork.kernel.org/project/linux-wireless/list/?series=38033&state=*
>
> Via which tree are you planning to push these? These could potentially
> go via my wireless-drivers-next tree (if review goes ok) but I need to
> have all five patches in patchwork.

Oh, forgot to mention that please resubmit all five patches, not just
patch 1, because then it's easier for me to apply them.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#resubmit_the_whole_patchset

-- 
Kalle Valo
