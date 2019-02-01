Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33ECBC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 10:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0072920815
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 10:39:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VVeKsWEQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VVeKsWEQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbfBAKjp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:39:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44284 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbfBAKjp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 05:39:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EA18960867; Fri,  1 Feb 2019 10:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549017583;
        bh=cB+hA2zf3e3SV9AaTYgaUNuPMKl3ZU/2RF0pzPx5BdA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VVeKsWEQ1IGjFvqXVqD/CzKAHFnGwDjmrWNaP+g9LrHluqEjnA441fe2war5eQ2eq
         Q7KCrl5VFWU/b2Qnn8o5U8nH22eg8Sgoe0xNYBd/XtNOTfWtAmDHb17ujxzl6yxr7A
         ZMZDGcMMog/HoQSuwkTik9UJV7iQlK9gYBhBMBC4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B2FB6043F;
        Fri,  1 Feb 2019 10:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549017583;
        bh=cB+hA2zf3e3SV9AaTYgaUNuPMKl3ZU/2RF0pzPx5BdA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VVeKsWEQ1IGjFvqXVqD/CzKAHFnGwDjmrWNaP+g9LrHluqEjnA441fe2war5eQ2eq
         Q7KCrl5VFWU/b2Qnn8o5U8nH22eg8Sgoe0xNYBd/XtNOTfWtAmDHb17ujxzl6yxr7A
         ZMZDGcMMog/HoQSuwkTik9UJV7iQlK9gYBhBMBC4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2B2FB6043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        amit karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [PATCH] MAINTAINERS: add entry for redpine wireless driver
References: <1549014070-3930-1-git-send-email-siva8118@gmail.com>
        <87tvhnhlqn.fsf@kamboji.qca.qualcomm.com>
        <CANGSkXQ5YtmG8uLzsn4J6iOPP=jSdp1Hqsu9vzpbSH2jX8dfAw@mail.gmail.com>
Date:   Fri, 01 Feb 2019 12:39:39 +0200
In-Reply-To: <CANGSkXQ5YtmG8uLzsn4J6iOPP=jSdp1Hqsu9vzpbSH2jX8dfAw@mail.gmail.com>
        (Siva Rebbagondla's message of "Fri, 1 Feb 2019 15:54:54 +0530")
Message-ID: <87lg2zhjx0.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> writes:

> Hi Kalle,
> On Fri, Feb 1, 2019 at 3:30 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Siva Rebbagondla <siva8118@gmail.com> writes:
>>
>> > From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> >
>> > Create an entry for Redpine wireless driver and add Amit and myself as
>> > maintainers.
>> >
>> > Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> > ---
>> >  MAINTAINERS | 7 +++++++
>> >  1 file changed, 7 insertions(+)
>> >
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index 32d44447..c4e8fb4 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -16923,6 +16923,13 @@ L:   linux-mm@kvack.org
>> >  S:   Maintained
>> >  F:   mm/zswap.c
>> >
>> > +REDPINE WIRELESS DRIVER
>> > +M:   Siva Rebbagondla <siva8118@gmail.com>
>> > +M:   Amitkumar Karwar <amitkarwar@gmail.com>
>> > +L:   linux-wireless@vger.kernel.org
>> > +S:   Maintained
>> > +F:   drivers/net/wireless/rsi/
>> > +
>> >  THE REST
>> >  M:   Linus Torvalds <torvalds@linux-foundation.org>
>> >  L:   linux-kernel@vger.kernel.org
>>
>> Like documented in the beginning of the file these should be in
>> alphabetical order. Please fix and resend.
>
> Huh. I missed it. I will keep maintainers names in alphabetical order
> and send you again.

Sorry, I meant that the driver entries ("REDPINE WIRELESS DRIVER") needs
to be in alphabetical order. So you need to move that up in the file.

-- 
Kalle Valo
