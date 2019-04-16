Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67439C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 15:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36620204EC
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 15:58:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BsZwSojn";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X1RPsmNs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfDPP6o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 11:58:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52084 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfDPP6n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 11:58:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1A8466115C; Tue, 16 Apr 2019 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555430323;
        bh=2iSnsL6nCXDFvKbHQVNli99G2u/NY2G9WK3HTqOuijI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BsZwSojnWkNentz5v72KPeVjkxifk22w3abPVHr9F63cFR7TTqH6fEnCV3nbcgUzw
         xHcBntUNi+2kCWX9PDA72pkpkad05dC2N60PrO2JQCr7cTAOaMKbBed3MZrS/jfRJB
         Fz12FOfHS8GhKqbHLlp1ypI4ACqsJ/dI4jHbCfWs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA96960A0A;
        Tue, 16 Apr 2019 15:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555430322;
        bh=2iSnsL6nCXDFvKbHQVNli99G2u/NY2G9WK3HTqOuijI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=X1RPsmNsf0VsEfNZUCUVLbtaPeuR6GPejdZKn1UAoQRs8ZffKJbswTXXwx4VvPP+m
         e++HszhqcolfPKRGA73ebrV4p45b+NwWgP8qyritVWWOPCBTCd62I2grlUpN/Ur0EK
         prvNqbyBtl64JAXbKQzCfy+Zettomu3zgQReVGdQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA96960A0A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH wireless-drivers] rtlwifi: rtl8723ae: Fix missing break in switch statement
References: <20190416003626.GA16834@embeddedor>
        <87h8ay8vu9.fsf@kamboji.qca.qualcomm.com>
        <90c56883-6ef3-9f9e-5231-6c2fc65d747d@embeddedor.com>
Date:   Tue, 16 Apr 2019 18:58:38 +0300
In-Reply-To: <90c56883-6ef3-9f9e-5231-6c2fc65d747d@embeddedor.com> (Gustavo A.
        R. Silva's message of "Tue, 16 Apr 2019 10:08:55 -0500")
Message-ID: <87ftqi54cx.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> On 4/15/19 10:36 PM, Kalle Valo wrote:
>> "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
>> 
>>> Add missing break statement in order to prevent the code from falling
>>> through to case 0x1025, and erroneously setting rtlhal->oem_id to
>>> RT_CID_819X_ACER when rtlefuse->eeprom_svid is equal to 0x10EC and
>>> none of the cases in switch (rtlefuse->eeprom_smid) match.
>>>
>>> This bug was found thanks to the ongoing efforts to enable
>>> -Wimplicit-fallthrough.
>>>
>>> Fixes: 238ad2ddf34b ("rtlwifi: rtl8723ae: Clean up the hardware info routine")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> 
>> You have marked this for wireless-drivers but the commit is 2.5 years
>> old, so I think wireless-drivers-next is more approriate.
>> 
>
> Yeah. This can actually be applied to both of them.  What I'd like is
> to have this applied to stable, so I thought wireless-drivers was a
> more straightforward way.

Sure, makes sense. But I just want to keep the number of patches going
to wireless-drivers to the minimum, I really want to avoid conflicts as
much as possible. That's why I'm keeping the bar high for w-d.

> Anyway, I'll update the tag and respin.

Thanks.

-- 
Kalle Valo
