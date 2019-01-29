Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CCBC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 08:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0255214DA
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 08:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cLEwEhH8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mYfHCg6T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfA2IEU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 03:04:20 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46004 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbfA2IET (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 03:04:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1485460B3C; Tue, 29 Jan 2019 08:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548749058;
        bh=vt5ipQ4IecWhfln5Ff6Ob9/s5An7w0tuuxcIWW9I4gQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cLEwEhH8cD2xDANDJ80LrFsHJmDgA7FuJzZEQj7HRAHxziFo+xrFthCMAPHRou/ao
         X1UMyAyVIhXo0SDq2WB7WrFMLgqc2AlOc6j7aNJ2GIEH2AGzulrawAcGH2E+7PtdOL
         fjH64iE0euLSfnEB1hrUFPLvCvXysV7xxzBM3QIg=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C217F60B1E;
        Tue, 29 Jan 2019 08:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548749055;
        bh=vt5ipQ4IecWhfln5Ff6Ob9/s5An7w0tuuxcIWW9I4gQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mYfHCg6TDwDaQYcbWOTBZoUfcoZX4zj/gJdRKluFLM1lyHpUSELxsBSYiVgugK2lK
         UJqhxMVQYW7OC73+AKaNouHKEs9zTaPV+UKaepV4u2LEnqplPCO6iTIdskyeZxdMqK
         sWbB0ltP7i0U+Yi9NJpkC+5jMWR/gfPLlPDOvU7s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C217F60B1E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sid Hayn <sidhayn@gmail.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH 4.20.x 0/7] mt76x0 fixes for 4.20 stable
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
        <CAM0KTbBz4hLWuN5oAGJV9rXEGuHP1UDPsL2fYaKJA6pRJG1MDA@mail.gmail.com>
Date:   Tue, 29 Jan 2019 10:04:12 +0200
In-Reply-To: <CAM0KTbBz4hLWuN5oAGJV9rXEGuHP1UDPsL2fYaKJA6pRJG1MDA@mail.gmail.com>
        (Sid Hayn's message of "Mon, 28 Jan 2019 11:06:41 -0500")
Message-ID: <87h8drubyb.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sid Hayn <sidhayn@gmail.com> writes:

> On Tue, Jan 22, 2019 at 7:41 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>
>> There ware several bugs introduced in 4.20 development cycle
>> for mt76x0 driver, that were fixed later but missed 4.20
>> release. This patche set fixes issues for MT7610U and
>> MT7630E.
>>
>> Bug reference:
>> https://bugzilla.kernel.org/show_bug.cgi?id=202243
>>
>> Lorenzo Bianconi (1):
>>   mt76x0: phy: unify calibration between mt76x0u and mt76x0e
>>
>> Stanislaw Gruszka (6):
>>   mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
>>   mt76x0: use band parameter for LC calibration
>>   mt76x02: run calibration after scanning
>>   mt76x02: assure we update gain after scan
>>   mt76x0: do not perform MCU calibration for MT7630
>>   mt76x0: antenna select corrections
>>
>>  drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
>>  drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |   9 +-
>>  drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |   5 +
>>  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 170 +++++++--------------
>>  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   1 +
>>  drivers/net/wireless/mediatek/mt76/mt76x02.h       |   1 +
>>  .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |  10 +-
>>  drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |   1 +
>>  .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   3 +
>>  9 files changed, 76 insertions(+), 125 deletions(-)
>>
>> --
>> 1.9.3
>>
>
> Please forgive if I'm mistaken, but I haven't seen this hit the stable
> queue or see any response at all.  Did this get missed or just hasn't
> been reached yet?

It's been only 7 days since the patches were submitted. The maintainers
have a lot to do and a lot of email to process, don't expect that
everything will be done instantly.

-- 
Kalle Valo
