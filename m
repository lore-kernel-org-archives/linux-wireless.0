Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248D3C282D0
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E953E2087E
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:50:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="f6nGzjEz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gpa4aOw5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfA2MuF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:50:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37010 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbfA2MuE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 07:50:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F3339601D1; Tue, 29 Jan 2019 12:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548766204;
        bh=n+2dctMZw0L6GZMd6CIdAEa0Ua9KWHz7R0lzN0rAk0I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=f6nGzjEzyE+k867+TLmHUD/nWkJ0/H2VUJIw6Ec9mhzClIPSx4QccvLUoWslq6JUO
         1JqGNmZc1MUuuIj0Hd+E5yu/gspYm4SSnI5D983417WaYDXa3uj5A4bar96p64Fq5O
         S64b/FhYcfiAOvC7i4VwFCU7tqEp77z2L1U0JR60=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0F20460159;
        Tue, 29 Jan 2019 12:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548766203;
        bh=n+2dctMZw0L6GZMd6CIdAEa0Ua9KWHz7R0lzN0rAk0I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gpa4aOw5CCV35dL+L4rux4TCgPjkZU1YSvJvisNvL6lTfJ7XV1dBf9rl34+hwHOvv
         X84KivKk7ghA+snMHDdsuKj0fbvaj73Ag4Pu9pHNYindTJdVTEdlX8t+wLv+sLJvod
         oqYqMwUJpmhxzK+AL5969OT40CI3ERiCJHxX1q1A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0F20460159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next] wireless: fix typos
References: <20190120232000.4940-1-mcroce@redhat.com>
        <87va2ioaee.fsf@kamboji.qca.qualcomm.com>
Date:   Tue, 29 Jan 2019 14:49:59 +0200
In-Reply-To: <87va2ioaee.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Mon, 21 Jan 2019 07:19:21 +0200")
Message-ID: <87zhrjsk5k.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Matteo Croce <mcroce@redhat.com> writes:
>
>> Fix spelling mistakes in brcm80211 and cfg80211: "lenght" -> "length".
>> The typos are also in the special comment blocks which
>> translates to documentation.
>>
>> Signed-off-by: Matteo Croce <mcroce@redhat.com>
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h     | 2 +-
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h     | 2 +-
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      | 2 +-
>>  include/net/cfg80211.h                                      | 2 +-
>
> cfg80211 changes go through mac80211-next. Can you please split these in
> two patches, cfg80211 and brcmfmac?

Strange, my previous comment didn't make it to patchwork. Let's try
again :)

https://patchwork.kernel.org/patch/10773337/

-- 
Kalle Valo
