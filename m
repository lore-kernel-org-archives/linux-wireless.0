Return-Path: <SRS0=ZKB3=N4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94288C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 11:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59E8320825
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 11:06:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PQ72fau8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XspddyFy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59E8320825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbeKQVWm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Nov 2018 16:22:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33992 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbeKQVWm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Nov 2018 16:22:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2602C607DC; Sat, 17 Nov 2018 11:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542452782;
        bh=HJYSzAR5PDW6emOvHsBxjhD6NTEv8DcmatNhOa7NPJ8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PQ72fau8lY6Xbp63Mig+0ixwfXiUf4MOisE4/UDFNNhuAqEAEYS0GuqLtCnS19iD9
         8e/5e4a6EbWRlij8oXmjPpVNam5DhEt2CZzYObflAuC5sAIi0DtuI0FT5Hh+syOkT7
         nO3VXKEK2OdXyIoZigsxODyqz4gyIUwnoLMkE+AU=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8F2A0601D1;
        Sat, 17 Nov 2018 11:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542452781;
        bh=HJYSzAR5PDW6emOvHsBxjhD6NTEv8DcmatNhOa7NPJ8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XspddyFyUFi2lHHU/CLIzYfgMbTEDRODHmoSbAxGdm9SrhCqUWjHQa6BxzzkIbX5M
         7v+y92sQSmKEFz4tlsGtXmr1R/i2OMakyuwYhq37upRfS+FSd/ID8ypVaIcdnzGggv
         2c0OkrWg07Wl/ro6X82eWA6+OMCTOAF6CtA3KyoM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8F2A0601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Priit Laes <plaes@plaes.org>
Cc:     Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
        Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] b43: Use cordic algorithm from kernel library
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
        <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
        <20181114194628.0f485637@wiggum>
        <20181117083628.sm6juvz75kiargz4@plaes.org>
Date:   Sat, 17 Nov 2018 13:06:15 +0200
In-Reply-To: <20181117083628.sm6juvz75kiargz4@plaes.org> (Priit Laes's message
        of "Sat, 17 Nov 2018 08:36:28 +0000")
Message-ID: <878t1s55g8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Priit Laes <plaes@plaes.org> writes:

> On Wed, Nov 14, 2018 at 07:46:28PM +0100, Michael B=C3=BCsch wrote:
>> On Wed, 14 Nov 2018 20:27:52 +0200
>> Priit Laes <plaes@plaes.org> wrote:
>>=20
>> > Kernel library has a common cordic algorithm which is identical
>> > to internally implementatd one, so use it and drop the duplicate
>> > implementation.
>>=20
>>=20
>> In v2 of the series it has been said that:
>>=20
>> Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
>> > I recall doing a comparison between the algorithms and thought I put=20
>> > that in the original commit message. However, it is not there. It is n=
ot=20
>> > exactly the same as in b43 so there are difference for certain angles,=
=20
>> > most results are the same however. This implementation is slightly mor=
e=20
>> > accurate on the full scale.
>>=20
>>=20
>> That's not my definition of "identical".
>>=20
>> Please do not apply this patch without doing a thorough regression test
>> on actual b43 LP hardware.
>
> Indeed, there's a big discrepancy in the results of both algorithms.
>
> Here's the test script:
> https://gist.github.com/plaes/284993a4fc65e0926d0628a11f0cf874
>
> So at current state, this is self-NAK from me too and this patch should
> be dropped.

Ok, I'll drop patch 3 but keep patches 1-2 still in review. Thanks for
verifying this!

But of course it would be better if somebody could test this properly on
a real device. When that happens, please resubmit patch 3.

--=20
Kalle Valo
