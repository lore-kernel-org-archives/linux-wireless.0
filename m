Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE4CC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D602085B
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mycPkhx/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W2aVy826"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387884AbfAaNkq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 08:40:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732715AbfAaNkV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 08:40:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 887D46047C; Thu, 31 Jan 2019 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548942019;
        bh=HAr3sKQJorDzOLtZoa8FuYNjBqXagWj4JipTasxcGIM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mycPkhx/U/CgqbNXXla3nGulwet1Ma0qnVKkZw4ev7mRgo7sFBjJb94acar11p1Vy
         hzUojq5bq4NNf5H9CYoGtjwoRN/ArQM7yrhegx1e4UxD6lRgkjCCK0brg7/oi+DkcO
         ueP93jjQsGZF0x6hID1q7xF3ms6tIdCmcdjPuDQY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0120060867;
        Thu, 31 Jan 2019 13:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548942018;
        bh=HAr3sKQJorDzOLtZoa8FuYNjBqXagWj4JipTasxcGIM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W2aVy826oaxG/HA0v233RhaUyPASKcNOkeKDzRadGo+c9uUrgNreEvRRBHKtE5hOO
         BlQ4yYn06pYupR2wMQtG/j2Q41cZkXTXsUEXT3+4eu6xl0MsdqAOuG7fYgaLyTWkcC
         9qMoUsdPaxhiI5Nv8ySMlE/jgE5kQSw4CTfQE+5k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0120060867
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka\@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 09/13] rtw88: chip files
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
        <1548820940-15237-10-git-send-email-yhchuang@realtek.com>
        <20190130194453.GA156750@google.com>
        <F7CD281DE3E379468C6D07993EA72F84D179ABC2@RTITMBSVM04.realtek.com.tw>
        <87ef8tjb7n.fsf@kamboji.qca.qualcomm.com>
        <e1e062f20e61e61e1428802436248782be08ea7d.camel@sipsolutions.net>
Date:   Thu, 31 Jan 2019 15:40:13 +0200
In-Reply-To: <e1e062f20e61e61e1428802436248782be08ea7d.camel@sipsolutions.net>
        (Johannes Berg's message of "Thu, 31 Jan 2019 12:55:15 +0100")
Message-ID: <87a7jhj682.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2019-01-31 at 13:52 +0200, Kalle Valo wrote:
>> Tony Chuang <yhchuang@realtek.com> writes:
>>=20
>> > > From: Brian Norris [mailto:briannorris@chromium.org]
>> > >=20
>> > > > +static inline void
>> > > > +rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32=
 data)
>> > > > +{
>> > > > +	BUILD_BUG_ON(addr < 0xC00 || addr >=3D 0xD00);
>> > >=20
>> > > This seems to be a non-traditional use of BUILD_BUG_ON(). Normally, I
>> > > see this used for stuff that's guaranteed to be known at compile tim=
e --
>> > > structure offsets, constants, etc. This is usually (always?) a const=
ant,
>> > > but it passes through a function parameter, so I'm not sure if that's
>> > > really guaranteed.
>> > >=20
>> > > Anyway...this is failing confusingly for me when I try to build:
>> > >=20
>> > > drivers/net/wireless/realtek/rtw88/rtw8822b.c: In function
>> > > =E2=80=98rtw_write32s_mask=E2=80=99:
>> > > drivers/net/wireless/realtek/rtw88/rtw8822b.c:230:176: error: call to
>> > > =E2=80=98__compiletime_assert_230=E2=80=99 declared with attribute e=
rror: BUILD_BUG_ON
>> > > failed: addr < 0xC00 || addr >=3D 0xD00
>> > >   BUILD_BUG_ON(addr < 0xC00 || addr >=3D 0xD00);
>> > >=20
>> > > ^
>> > >=20
>> > > I tried to pinpoint which call yielded this, and I think once I dele=
ted
>> > > enough calls to rtw_write32s_mask() it came down to this one:
>> > >=20
>> > >         rtw_write32s_mask(rtwdev, REG_RFEINV, BIT(11) | BIT(10) | 0x=
3f,
>> > > 0x0);
>> > >=20
>> > > which doesn't really make sense, as that's a value of 0xcbc.
>> > >=20
>> > > What I really think it comes down to is that you can't guarantee
>> > > rtw_write32s_mask() will get inlined, and so BUILD_BUG_ON() may not =
know
>> > > what to do with it.
>> >=20
>> > Yeah, you're right. I think we should turn it into macro.
>>=20
>> Does this really need to be a build time check? Like Brian said, this is
>> not really common use of BUILD_BUG_ON(). I would just change it to
>> WARN_ON_ONCE() or a ratelimited warning message so that we don't to have
>> an ugly macro.
>
> Well, it *is* strictly stronger as a build-time check, so that makes
> sense?

Sure, it's a lot stronger check. But IMHO this isn't that important (or
difficult to spot) that it would need to be a compile time check and a
runtime check would suffice as well.

> I'd probably still suggest doing something like this:
>
> static inline void _rtw_write32s_mask(...)
> {
>   ... as before w/o BUILD_BUG_ON ...
> }
> #define rtw_write32s_mask(bla, bla) do { \
>    BUILD_BUG_ON(...); \
>    _rtw_write32s_mask(...); \
> } while (0)
>
> so you also get the type checks etc. from having actual function args.

Yes, this would be a perfect compromise.

--=20
Kalle Valo
