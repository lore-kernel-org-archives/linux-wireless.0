Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC85C282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 11:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DCFA2087F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 11:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WwdA4qG8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SfAeZiOe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732228AbfAaLwj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 06:52:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54136 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbfAaLwj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 06:52:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BB0BF60A60; Thu, 31 Jan 2019 11:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548935557;
        bh=6dMshSwp/Kq18tHQmrK81SVabb7MrZhTzkIhxnELAc4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WwdA4qG8WMuHmOiY709iAui4RH/i7PXYq9oPc2gDNTZyzxCw3h63MyDPQV48gfZk1
         EmUv/zyvFw5Udyh0mrQhFQYEsZezhZ7DbOOmFpw+qmRcOC9nQ6Fl7OvLZDKQGt5/pS
         129O2nA4nNbxndqzh3dDbrB2ud3XxSrL5j6eF5qg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6788B60AD7;
        Thu, 31 Jan 2019 11:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548935553;
        bh=6dMshSwp/Kq18tHQmrK81SVabb7MrZhTzkIhxnELAc4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SfAeZiOesV6xcOLO6jGFFolZv8AgW27/L9joOU22bIiPtycsI5vOY+3cD84DCImA8
         +J/jGH+GDxcRyL07hn6QlQK7vc6sbs0ZavKMyE4gxFjFxnG9EtR6PZs+rGbvyLHGWk
         8dauz048+c/pwHEG0kdNy7EnLUhQo2CLSRLsLSXQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6788B60AD7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        "johannes\@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka\@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 09/13] rtw88: chip files
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
        <1548820940-15237-10-git-send-email-yhchuang@realtek.com>
        <20190130194453.GA156750@google.com>
        <F7CD281DE3E379468C6D07993EA72F84D179ABC2@RTITMBSVM04.realtek.com.tw>
Date:   Thu, 31 Jan 2019 13:52:28 +0200
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D179ABC2@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Thu, 31 Jan 2019 11:36:35 +0000")
Message-ID: <87ef8tjb7n.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> From: Brian Norris [mailto:briannorris@chromium.org]
>>=20
>> > +static inline void
>> > +rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 dat=
a)
>> > +{
>> > +	BUILD_BUG_ON(addr < 0xC00 || addr >=3D 0xD00);
>>=20
>> This seems to be a non-traditional use of BUILD_BUG_ON(). Normally, I
>> see this used for stuff that's guaranteed to be known at compile time --
>> structure offsets, constants, etc. This is usually (always?) a constant,
>> but it passes through a function parameter, so I'm not sure if that's
>> really guaranteed.
>>=20
>> Anyway...this is failing confusingly for me when I try to build:
>>=20
>> drivers/net/wireless/realtek/rtw88/rtw8822b.c: In function
>> =E2=80=98rtw_write32s_mask=E2=80=99:
>> drivers/net/wireless/realtek/rtw88/rtw8822b.c:230:176: error: call to
>> =E2=80=98__compiletime_assert_230=E2=80=99 declared with attribute error=
: BUILD_BUG_ON
>> failed: addr < 0xC00 || addr >=3D 0xD00
>>   BUILD_BUG_ON(addr < 0xC00 || addr >=3D 0xD00);
>>=20
>> ^
>>=20
>> I tried to pinpoint which call yielded this, and I think once I deleted
>> enough calls to rtw_write32s_mask() it came down to this one:
>>=20
>>         rtw_write32s_mask(rtwdev, REG_RFEINV, BIT(11) | BIT(10) | 0x3f,
>> 0x0);
>>=20
>> which doesn't really make sense, as that's a value of 0xcbc.
>>=20
>> What I really think it comes down to is that you can't guarantee
>> rtw_write32s_mask() will get inlined, and so BUILD_BUG_ON() may not know
>> what to do with it.
>
> Yeah, you're right. I think we should turn it into macro.

Does this really need to be a build time check? Like Brian said, this is
not really common use of BUILD_BUG_ON(). I would just change it to
WARN_ON_ONCE() or a ratelimited warning message so that we don't to have
an ugly macro.

--=20
Kalle Valo
