Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931D5C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F7822146D
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KitFy4xV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iycql8/d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F7822146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbeKPAcu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 19:32:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36266 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbeKPAcu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 19:32:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B7F5C60722; Thu, 15 Nov 2018 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542291886;
        bh=mSWYe34A/34TfFjgmRc5JK60o7Ym+5sji+jFsBkkpMM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KitFy4xVYxVemAyMVk73AY0LTrF5MY98PHGAv45UFBxIem0EnGv12fN1ORP1oxIUy
         2YkKS7PuaWvpb6JvTbDzy8Du5YbC1l4lRwkYLSpU6qCyNhWx+PT3eAX+15FcsnbDCA
         8KqEJNJ08oa+lDKOnaWnUphR5p0TqGwA27MVyh7s=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 551B360386;
        Thu, 15 Nov 2018 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542291885;
        bh=mSWYe34A/34TfFjgmRc5JK60o7Ym+5sji+jFsBkkpMM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iycql8/dIMfFVTW9rECHTsnKeqe4oH4AzaW4XfopSuSc4scDg1dAA//RXEOyGXvy1
         kMC0XktkksXUARoTBWlAmnl9G9SzB64yftNFz1jFzIRW3wTECdxCg9lCspk0QJvQ+v
         U3nKAu2YBTeF5gngqiM8U4Jw4zsn6Gw533ch1vyA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 551B360386
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
Subject: Re: [PATCH 1/6] brcmfmac: Remove firmware-loading code duplication
References: <20181009124755.25402-1-hdegoede@redhat.com>
        <c6dd19e3-58e2-2eb2-5724-e6718b3fb2cf@broadcom.com>
        <87a7mnbm45.fsf@purkki.adurom.net>
        <0c34fc2f-8402-df5c-d34d-0915ba27ce40@redhat.com>
Date:   Thu, 15 Nov 2018 16:24:40 +0200
In-Reply-To: <0c34fc2f-8402-df5c-d34d-0915ba27ce40@redhat.com> (Hans de
        Goede's message of "Mon, 5 Nov 2018 16:10:04 +0100")
Message-ID: <87pnv6a05z.fsf@codeaurora.org>
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
> On 05-11-18 16:05, Kalle Valo wrote:
>> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>>
>>> On 10/9/2018 2:47 PM, Hans de Goede wrote:
>>>> brcmf_fw_request_next_item and brcmf_fw_request_done both have identical
>>>> code to complete the fw-request depending on the item-type.
>>>>
>>>> This commit adds a new brcmf_fw_complete_request helper removing this code
>>>> duplication.
>>>
>>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> For some reason you commented on v1 but there was v2 posted already:
>>
>> https://patchwork.kernel.org/patch/10634355/
>>
>> I guess I can take v2 still?
>
> Yes the only thing different in v2 was dropping the SPDX license header
> for the new drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
> file and replacing it with the full ISC license text as seen in other
> brcmfmac files. Nothing else was changed, so the review of v1 is
> valid for v2 too.
>
> Arend had one very minor comment on the name of a variable in the fifth
> patch, but that is not important so if you want to pick up v2 as is
> go for it.
>
> Note the ISC license text is now in Torvald's tree as:
> LICENSES/other/ISC
>
> So could even go with v1, but I guess you prefer to move all files of
> a driver over to the SPDX headers in one go ...

Correct, I really would prefer move to SPDX headers in one go.

-- 
Kalle Valo
