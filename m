Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA45AC282D8
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 10:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA81920857
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 10:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o3+t8H0t";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UyJ6BEfa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfA3Krz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:47:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfA3Krz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 05:47:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EF83A60AA2; Wed, 30 Jan 2019 10:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548845274;
        bh=nrdkc5I1wZOKtOrOqqerqLTnBgd1/U5OemhQ9RA6JGA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=o3+t8H0tVc2UJEmr1p4kj3Mg7XEx8BfhfwFR2Qje8fn7aBt7e7eVuJdq7HQKVdudi
         jiNFnA8rvZqMxH2Acykr5a4nyZpgO+wM6sjUbixkVVyyuWbkwMydQW5dlR5uwAfXqD
         ThyqajHFcccHp7dfwRfWuCxWMw5ibWqrvsGy7W1E=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B1FA060A97;
        Wed, 30 Jan 2019 10:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548845273;
        bh=nrdkc5I1wZOKtOrOqqerqLTnBgd1/U5OemhQ9RA6JGA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UyJ6BEfaThrOMOGVoQe4lK4ArRCNbGvCg22ESTEVE/3mWGN0GNa2x2542MTBBgoo/
         1dX5TdJF36uX3QIPJC+mm6u0m25rW7LxfTVzJQqlgifLv2wl4O6NBEuI7L51y+4gkT
         2Pzd9ZCfDnTnRkMzpZ9mub9cuMM5ccfJ6QKZVnS4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B1FA060A97
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     "yuehaibing\@huawei.com" <yuehaibing@huawei.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: remove set but not used variable 'cmd_seq'
References: <1536667978-10556-1-git-send-email-yuehaibing@huawei.com>
        <581817ea-a414-e6ed-3615-5e44837a5221@huawei.com>
        <e37bae9c-c920-56cf-7813-0004c017f02a@huawei.com>
        <1548811903.17195.1.camel@realtek.com>
Date:   Wed, 30 Jan 2019 12:47:49 +0200
In-Reply-To: <1548811903.17195.1.camel@realtek.com> (pkshih@realtek.com's
        message of "Wed, 30 Jan 2019 01:31:54 +0000")
Message-ID: <87zhrijuay.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

> On Tue, 2019-01-29 at 14:03 +0800, YueHaibing wrote:
>> +cc netdev@vger.kernel.org
>>=20
>> On 2019/1/29 13:57, YueHaibing wrote:
>> > ping...
>> >=C2=A0
>> > On 2018/9/11 20:12, YueHaibing wrote:
>> >> Fixes gcc '-Wunused-but-set-variable' warning:
>> >>
>> >> drivers/net/wireless/realtek/rtlwifi/base.c: In function
>> 'rtl_c2h_content_parsing':
>> >> drivers/net/wireless/realtek/rtlwifi/base.c:2313:13: warning:
>> >>=C2=A0=C2=A0variable 'cmd_seq' set but not used [-Wunused-but-set-vari=
able]
>> >>
>> >> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>
> Thanks for your fix.
>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

For some reason I couldn't find the original patch from patchwork.
I didn't find the version sent today though:

https://patchwork.kernel.org/patch/10787619/

BTW YueHaibing, you can check the linux-wireless patch status yourself from
the patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#checking_state_of_patches_from_patchwork

--=20
Kalle Valo
