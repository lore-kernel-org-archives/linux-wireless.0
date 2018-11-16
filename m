Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF62C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 09:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCFBA20892
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 09:55:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X7k/IcgE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h4VBrsez"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCFBA20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389354AbeKPUHJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 15:07:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbeKPUHJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 15:07:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7ADC560F39; Fri, 16 Nov 2018 09:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542362133;
        bh=Y3UWqNAs3MwQiTqo2NRx6/FqQ6koAZdPiMS5g3qw1/I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=X7k/IcgEz1N5qfa+vV7JFCyPv5G8wAmYnALvcPi5KkVSFl51ruhZ5SyzLkxgMmlUj
         I+Sl+KhbuhmbHcqCIaX/cjLzYrPlTRSDw/NpeSul3V3FVK3aybecNZX4ZuLiZtduIR
         5UCbeF52oofy/neYf4+e8l4Uan14Y7RewhGzrn6Y=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D53E60B26;
        Fri, 16 Nov 2018 09:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542362132;
        bh=Y3UWqNAs3MwQiTqo2NRx6/FqQ6koAZdPiMS5g3qw1/I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=h4VBrsezDb7brg80Zf9pIvl6mn61co6kU1PpXRhLGLoNE0Rc4r7kJV0/fBqbliJHK
         vslbdEJwtYc0tRFNYirF/BbrynGfbjOUtpcPKw+fKBAiJLiNnxRuUcqS9Bp2gG/QR2
         zgo3EYJKlQpEes0eKOGRoAtvTOj26xe4ycSDJKrE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4D53E60B26
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, srirrama@codeaurora.org,
        bpothuno@codeaurora.org, akolli@codeaurora.org,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        yintang@qti.qualcomm.com, pillair@codeaurora.org,
        ath10k@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH] ath10k: avoid -Wmaybe-uninitialized warning
References: <20181102161833.2956376-1-arnd@arndb.de>
        <CA+ASDXPVJMge_B-AUXj1sKc4dB+3FcXew8T5FYEXVsncKYotiw@mail.gmail.com>
Date:   Fri, 16 Nov 2018 11:55:27 +0200
In-Reply-To: <CA+ASDXPVJMge_B-AUXj1sKc4dB+3FcXew8T5FYEXVsncKYotiw@mail.gmail.com>
        (Brian Norris's message of "Fri, 2 Nov 2018 09:34:53 -0700")
Message-ID: <87sh0173e8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> Hi,
>
> On Fri, Nov 2, 2018 at 9:19 AM Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> In some configurations the inlining in gcc is suboptimal, causing
>> a false-positive warning:
>>
>> drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_mac_init_rd':
>> drivers/net/wireless/ath/ath10k/mac.c:8374:39: error: 'rd' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>>   ar->ath_common.regulatory.current_rd = rd;
>>
>> If we initialize the output of ath10k_mac_get_wrdd_regulatory()
>> before returning, this problem goes away.
>>
>> Fixes: 209b2a68de76 ("ath10k: add platform regulatory domain support")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index a1c2801ded10..0d5fde28ee44 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -8321,6 +8321,8 @@ static int ath10k_mac_get_wrdd_regulatory(struct ath10k *ar, u16 *rd)
>>         u32 alpha2_code;
>>         char alpha2[3];
>>
>> +       *rd = ar->hw_eeprom_rd;
>> +
>
> Maybe it's just me, but it seems kinda weird for this function to
> assign a (valid) value to its "output" and still potentially return an
> error.
>
> If you really need to work around this compiler bug, maybe just put
> the eeprom assignment back in ath10k_mac_init_rd()? I'll leave it up
> to Kalle as to whether he wants to work around the compiler at all :)

In general I'm happy take workaround to compiler problems, I prefer to
keep ath10k warning free much as possible.

> Oh wait, one more thing: this is actually an invalid refactoring. See
> how this function assigns '*rd' later in error cases. Today, we still
> treat those as errors and clobber those with the eeprom value, but
> now, you're making the fallback case continue to use the erroneous
> value (0xffff). You need to make that use a local variable and avoid
> clobbering *rd, if you want this to be correct.

But I agree with Brian here, I don't think this patch is correct.

-- 
Kalle Valo
