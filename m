Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C4AC64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BB6A213A2
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bMmqdax7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lzal4T3s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BB6A213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727583AbeJCQff (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 12:35:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55122 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbeJCQff (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 12:35:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 04C9D6031A; Wed,  3 Oct 2018 09:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538560076;
        bh=knTaC0tLyqPmeu1k4ziI4HRQv2fomAU3z+x+v/GqAzw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bMmqdax7HMEqKZomOCz0+m/VKWIsTSnS32lCtxOvcpwCbn6c/+nyHYMbs2uX38Wa9
         KygiLaPTgd4iEL8P3goQuU7hG+U4MgsPsnzaZIWnqqoDyiKR3uYTmGKsu9OuLM8Diq
         jwKZ4XkDaufUNYrlBOKE6VzXsUCr3uciqYY/pMJY=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D8FAD6021C;
        Wed,  3 Oct 2018 09:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538560075;
        bh=knTaC0tLyqPmeu1k4ziI4HRQv2fomAU3z+x+v/GqAzw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lzal4T3sEtxpNTTeHMDK6ElLJ01BJaie3Uc4XRpqC/11TwxWlYcnvIWFTY7mXo6LA
         lZPLqP3YJ46dELJRiXuJB8/+Lw9rHK/mZUIoYCnFwTHIWTOZRfQW90A3NSqcAExugS
         vJm/IKu5lWbY0due3EiTuY4HiSVws0PjkJQOjN4Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D8FAD6021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kai Heng Feng <kai.heng.feng@canonical.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [RESEND] [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
References: <20181003073556.28154-1-kai.heng.feng@canonical.com>
        <20181003073556.28154-3-kai.heng.feng@canonical.com>
        <87y3bfiees.fsf@kamboji.qca.qualcomm.com>
        <265BAF93-4BFF-4850-92F7-80AC39496473@canonical.com>
        <87tvm3id0f.fsf@kamboji.qca.qualcomm.com>
Date:   Wed, 03 Oct 2018 12:47:50 +0300
In-Reply-To: <87tvm3id0f.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Wed, 03 Oct 2018 12:40:48 +0300")
Message-ID: <875zyjicop.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Kai Heng Feng <kai.heng.feng@canonical.com> writes:
>
>>> On Oct 3, 2018, at 5:10 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>=20
>>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>>>=20
>>>> To avoid the firmware loading race between Bluetooth and WiFi on Intel
>>>> 8260, load firmware exclusively when BT_INTEL is enabled.
>>>>=20
>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>=20
>>> Still the commit log tells nothing about the actual problem which makes
>>> review impossible.
>>
>> Sorry for that. The first two patches [1] only sends to linux-bluetooth =
and LMKL.
>
> For a patchset like this you should CC linux-wireless for all patches,
> otherwise people just get confused. And even more so as patch 3 seems to
> depend on the other patches.
>
>> I don=E2=80=99t know what really happened at hardware/firmware level, but
>> making btusb and iwlwifi load firmware sequentially can workaround the
>> issue.
>
> We don't apply ugly workarounds without understanding the issue.
>
>> Matt Chen may be able to explain this issue with more detail.
>
> Then you need to work with Matt so that the issue is properly explained
> in the commit log.

linux-bluetooth was not CCed, adding that.

--=20
Kalle Valo
