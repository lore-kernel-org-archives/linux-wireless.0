Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CEDC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 420E121841
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l7yHoi5C";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R3rsOuGU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfA2JxS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:53:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57266 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfA2JxS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 04:53:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2F0B660712; Tue, 29 Jan 2019 09:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548755597;
        bh=4uFhOxkb31FPtL1mb35fXjjN5B/0hVhxN7/ok4zDcBg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=l7yHoi5CoFhjV6ohchlQDc/cMTY7ZFl96/jfacK2xFPaUxwDOzeZwR+iFd+ttgjaA
         UTbcgMAGLd3/De2Ic0+8lIL6CbQz/ZMPQcMOX3RpWSdF1fEK0qhBabzwE/a03czvbZ
         Q+Wpznqe1BVtJCs6WLUBi9nE+wvD/9qdCnIjClDo=
Received: from x230.qca.qualcomm.com (87-93-85-88.bb.dnainternet.fi [87.93.85.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7B0FB60112;
        Tue, 29 Jan 2019 09:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548755596;
        bh=4uFhOxkb31FPtL1mb35fXjjN5B/0hVhxN7/ok4zDcBg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=R3rsOuGUpBknuBYf4pZmfULyz9wfXwSsUB9cn4bMD6JN+K/iZd66foBK5Zq/OxcT+
         MTyKd9fOgaVIVYowUM6OzI22Pl7xJoGqrXfgSUFQFX98Z2vnVcuzw4fIu2Jq028dGl
         3I+Zxwhkk+dEB2cQrd8YuLb6H7nOTpnLPaOpRGbE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7B0FB60112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH wireless-drivers] mt76x0: eeprom: fix chan_vs_power map in mt76x0_get_power_info
References: <cover.1548587542.git.lorenzo.bianconi@redhat.com>
        <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
        <87tvhstujr.fsf@purkki.adurom.net>
        <20190128205002.GA2165@localhost.localdomain>
        <87bm40ym88.fsf@codeaurora.org>
        <CAJ0CqmVPK6R45F511Bnc4EXGFkEnwRsYhPTGpfvy59v8RbsOBg@mail.gmail.com>
Date:   Tue, 29 Jan 2019 11:53:13 +0200
In-Reply-To: <CAJ0CqmVPK6R45F511Bnc4EXGFkEnwRsYhPTGpfvy59v8RbsOBg@mail.gmail.com>
        (Lorenzo Bianconi's message of "Tue, 29 Jan 2019 08:28:11 +0100")
Message-ID: <87o97zx01i.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>>
>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>>
>> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> >>
>> >> > Report correct eeprom per channel power value.
>> >> > Fix chan_vs_power map in mt76x0_get_power_info routine
>> >> >
>> >> > Fixes: f2a2e819d672 ("mt76x0: remove eeprom dependency from mt76x0_get_power_info")
>> >> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>> >>
>> >> So what's the actual bug this fixes? The commit log is not really clear
>> >> on that. Wondering because you marked this for wireless-drivers.
>> >
>> > Hi Kalle,
>> >
>> > You are right, I have been not so clear in the commit log.
>> > Offsets in chan_map were wrong since mt76x02_eeprom_get() reads at even addresses.
>> > Moreover 'if' condition in the for loop was wrong (chan->hw_value and
>> > chan_map[i].chan were swapped)
>>
>> But how does this affect from user's point of view? I mean what feature
>> is broken and how does this fix that?
>>
>> --
>> Kalle Valo
>
> mt76x0_get_power_info() is used to read from eeprom the global max tx
> power according to the operating channel.
> mt76x02_eeprom_get() reads just at even addresses and it reports -1
> for odd ones (so offset must be a even).
> This issue will affect the tx power that userspace is able to configure.
> Do you think it is better to merge it in wireless-drivers-next?

Ok, I think this is fine for wireless-drivers. I just want to understand
the bug being fixed before I apply the patch to w-d.

If no objections I'll queue this for 5.0.

-- 
Kalle Valo
