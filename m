Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D687E7B60F
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Oct 2023 13:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242568AbjJDNWU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Oct 2023 09:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjJDNWT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2023 09:22:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2056EA9;
        Wed,  4 Oct 2023 06:22:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36839C433C7;
        Wed,  4 Oct 2023 13:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696425735;
        bh=XcNVHacYiIbSwWhIVO7sCT66vTxeZhDiJBmFYdVfMQA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UmE4ZMKFpiTI5ejNFIKrUnbyTIICN9g07PoKMfRFBspih3a8vN5E72+NozXhztg53
         7jIL+111n84DW7dqaVpSRk3YXeCkXimZ1W2RL54TM1vvW/JshuECieVscKc8Und4K0
         r8p2QwcOlcwNh2gWhfW3V6MUfzVlkRTz5XK+BgXKCimZrkVKQhNHfGCeTqfRj0PsAN
         DqWRl/8Y+OIpdkOYGFVmrH11kSKHJQZN19oDji5MSGOuWRSBwJAx9Ftm8gXIuUNWiQ
         k0IQuuzaEh1N3Q+qIMorlswYRf5Xzbq9WIOAeRGNRZyWzT0xLRzqyMEJk10+SG+exA
         OghsHYOu492dw==
From:   Kalle Valo <kvalo@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Felipe Negrelli Wolter <felipe.negrelliwolter@silabs.com>,
        Olivier Souloumiac <olivier.souloumiac@silabs.com>,
        Alexandr Suslenko <suslenko.o@ajax.systems>
Subject: Re: [PATCH v2] wifi: wfx: fix case where rates are out of order
References: <20231004123039.157112-1-jerome.pouiller@silabs.com>
        <8734yq7dg0.fsf@kernel.org> <2534699.vzjCzTo3RI@pc-42>
Date:   Wed, 04 Oct 2023 16:22:12 +0300
In-Reply-To: <2534699.vzjCzTo3RI@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Wed,
        04 Oct 2023 15:00:49 +0200")
Message-ID: <87y1gi5xq3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

>> > v2:
>> >   - Fix malformed tags in commit body. (checkpatch still complains abo=
ut
>> >     missing Close tag, but the bug tracker is not public and I don't h=
ave
>> >     the exact URL)
>>=20
>> Just out of curiosity why does the checkpatch complain about a missing
>> Close tag? I don't get it why there should be one.
>
> I am on top of v6.6-rc3. I get:
>
>     $ ./scripts/checkpatch.pl -g HEAD^..HEAD
>     WARNING: Prefer a maximum 75 chars per line (possible unwrapped commi=
t description?)
>     #26:
>                       best    ____________rate__________    ____statistic=
s___    _____last____    ______sum-of________
>
>     WARNING: Reported-by: should be immediately followed by Closes: with =
a URL to the report
>     #57:
>     Reported-by: Alexandr Suslenko <suslenko.o@ajax.systems>
>     Co-developed-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.co=
m>
>     [...]

Ah, thanks. Now I understand. But that rule doesn't make any sense to
me, for example I get reports privately as well and add a Reported-by
without a Closes tag. So always feel free to ignore that checkpatch
warning.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
