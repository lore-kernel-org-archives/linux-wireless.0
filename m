Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D5DC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02E2D214DA
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HFymXzns";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HFymXzns"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02E2D214DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbeJJPBP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 11:01:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47642 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbeJJPBP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 11:01:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BDDE0600C1; Wed, 10 Oct 2018 07:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539157221;
        bh=G5g0pKN5YjBifN7RM1tMOWg8YiEw1v/22tnmYKEC5lU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HFymXznsdmllBJlsYTMPyYNJmjgrW1/Nt29JpHDDnVNW/vRSa2BQyMQm6DbEhcwXU
         IPlroVbMwSTKLMQHuqwlbaufACjUXM3FvRw4TVe7FfFzLlC0R5j7b+Cfqo8/iHIJqv
         JMLPDlLTsj+nrFs+uOXHO3vFYxiVjAkr9eZzHeBU=
Received: from x230.qca.qualcomm.com (188-67-121-187.bb.dnainternet.fi [188.67.121.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 38AEA60769;
        Wed, 10 Oct 2018 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539157221;
        bh=G5g0pKN5YjBifN7RM1tMOWg8YiEw1v/22tnmYKEC5lU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HFymXznsdmllBJlsYTMPyYNJmjgrW1/Nt29JpHDDnVNW/vRSa2BQyMQm6DbEhcwXU
         IPlroVbMwSTKLMQHuqwlbaufACjUXM3FvRw4TVe7FfFzLlC0R5j7b+Cfqo8/iHIJqv
         JMLPDlLTsj+nrFs+uOXHO3vFYxiVjAkr9eZzHeBU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 38AEA60769
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based machines
References: <20181009124755.25402-1-hdegoede@redhat.com>
        <20181009124755.25402-5-hdegoede@redhat.com>
        <87murmxop9.fsf@codeaurora.org>
        <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com>
Date:   Wed, 10 Oct 2018 10:40:11 +0300
In-Reply-To: <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com> (Hans de
        Goede's message of "Wed, 10 Oct 2018 09:28:57 +0200")
Message-ID: <87in2axnac.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> writes:

> Hi,
>
> On 10-10-18 09:09, Kalle Valo wrote:
>> Hans de Goede <hdegoede@redhat.com> writes:
>>
>>> For x86 based machines, set the board_type used for nvram file selection
>>> based on the DMI sys-vendor and product-name strings.
>>>
>>> Since on some models these strings are too generic, this commit also adds
>>> a quirk table overriding the strings for models listed in that table.
>>>
>>> The board_type setting is used to load the board-specific nvram file with
>>> a board-specific name so that we can ship files for each supported board
>>> in linux-firmware.
>>>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> [...]
>>
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
>>> @@ -0,0 +1,104 @@
>>> +// SPDX-License-Identifier: ISC
>>
>> I don't see the ISC file in LICENSES directory[1] and I don't feel
>> comfortable taking SPDX tags which which don't have a license file.
>
> Ok. I need to do a patch for the LICENSES directory anyways, so I will
> also submit the ISC license upstream while at it, I will hopefully
> get around to doing that today.

That would be awesome, thanks! Then I could do the SPDX conversion also
on ath10k.

> So how do you want to proceed with this, do you want me to just
> put the full ISC text in the header for now as the rest of brcmfmac
> does?

Yeah, I think this is the fastest way.

> Then later someone (me if I get around to it) can replace all of
> the headers with // SPDX-License-Identifier: ISC once it has been
> added under LICENSES.

Sounds good to me.

-- 
Kalle Valo
