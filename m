Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A628C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 557F820869
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JGbTL4Kv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="A0hhvXPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfBHNmu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:42:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfBHNmu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:42:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2E37D601C4; Fri,  8 Feb 2019 13:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549633369;
        bh=7WlItZRojM42UyzLD4zFmxBsBPySukjoXDhqpvvpQsE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JGbTL4KvnC+B9IvZtvAagpv05+1crNuw6VFliV+dBjmVmUK3nJV5fz50/mA5fo+uv
         lZ2HJG5sE2hayTX39SFGeegfPUgnhpRk6Yf50qL/r/RNMMHbhJgfqF03+x9jmrBpfl
         ElzvBkaczxGsbPBJ2QszpLxOYKklndDE/Z8u3Df8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C93D6601C4;
        Fri,  8 Feb 2019 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549633368;
        bh=7WlItZRojM42UyzLD4zFmxBsBPySukjoXDhqpvvpQsE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=A0hhvXPl/YPNh6Efd5a/mvUa8pKcedudeiuERGoXbaFY7wODh0bfs9QGlTKW4Fsgz
         e9ROgPSXB+dn61onSfdFz+eqONdhp+LiXgVvfJoA9XUSXp7/Keqxff2sJMe9Mo/AME
         /S4r7PP+l7FJR7c+tkbzKiRXX7dpWup43cVPCUs4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C93D6601C4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>
Cc:     wgong@qti.qualcomm.com, briannorris@chromium.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, Wen Gong <wgong@codeaurora.org>
Subject: Re: [PATCH] ath10k: support PCIe enter L1 state
References: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
        <20181115002836.GA71934@google.com>
        <c94346b26a6d4b11a045a176ca854051@aptaiexm02f.ap.qualcomm.com>
        <20181115184333.GA87504@google.com> <87va4x8q2c.fsf@codeaurora.org>
        <CABvG-CVAnwkiKVJik0PdsmRxF62kKv2N+aRKNq=nbopoExLvDA@mail.gmail.com>
Date:   Fri, 08 Feb 2019 15:42:44 +0200
In-Reply-To: <CABvG-CVAnwkiKVJik0PdsmRxF62kKv2N+aRKNq=nbopoExLvDA@mail.gmail.com>
        (=?utf-8?Q?=22Micha=C5=82?= Kazior"'s message of "Fri, 16 Nov 2018 08:56:27
 +0100")
Message-ID: <87y36q75wr.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Micha=C5=82 Kazior <kazikcz@gmail.com> writes:

> On Fri, 16 Nov 2018 at 08:00, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Brian Norris <briannorris@chromium.org> writes:
>> > On Thu, Nov 15, 2018 at 06:38:25AM +0000, Wen Gong wrote:
>> >> >
>> >> > Is there some reason L1 was disabled in the first place? Was it kno=
wn to be
>> >> > unreliable?
>> >>
>> >> Hi Brian,
>> >> It is a BUG for power, and it is not considered this BUG before.
>> >> So this change will fix the bug.
>> >
>> > I understand that the existing behavior is suboptimal for power, but on
>> > the other hand, code that goes out of its way to *clear* the L1 flag
>> > doesn't just pop up out of nowhere. Somebody clearly wrote that! If it
>> > just meant "we didn't verify L1 at first", then maybe it's fine to
>> > enable it unconditionally and see what happens, but if it meant "we
>> > tried L1 on some old chip XXXX and it caused problems", then it would =
be
>> > nice to know what those problems were.
>> >
>> > Or maybe that is hard to figure out, given there's no public git histo=
ry
>> > tracking the original code, and we just need to try it out.
>>
>> Yeah, it seems L1 was disabled already on the first ath10k commit:
>>
>> 5e3dd157d7e70 (Kalle Valo 2013-06-12 20:52:10 +0300 2404)
>> pcie_config_flags &=3D ~PCIE_CONFIG_FLAG_ENABLE_L1;
>>
>> I don't remember anymore why but my guess is that the proprietary driver
>> at the time didn't support it with QCA998X. Or maybe QCA988X doesn't
>> even support L1? Michal, do you remember?
>
> Proprietary driver has it ifdef-ed to enable/disable.
>
> Older driver enabled it only for some station-only target/product so
> by default QCA988X would build with L1 flag masked out. It made sense
> to be conservative and change as little as possible to avoid random
> bugs and breakage - so the logic was inherited minus the build-time
> ifdef.
>
> However 10.4 driver seems to enable it unconditionally. I'm not sure
> if this depends on target firmware in any way or if some other host
> driver or bus settings need to be pre-set before L1 can be expected to
> work reliably.
>
> I guess there's no way other than testing it out.

No replies from anyone (including Wen) for 3 months about testing this
patch on anything else than QCA6174. So I'll drop this now, please
resubmit once test coverage is better.

--=20
Kalle Valo
