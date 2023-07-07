Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D506CEB64DA
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Jul 2023 13:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjGGNo4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Jul 2023 09:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjGGNoz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2023 09:44:55 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401F426A9;
        Fri,  7 Jul 2023 06:44:44 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1688737482; bh=uCuhTufCRaaXdnLKFmIMWVnD1T8kuwipzJVxUSjwA7c=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=dlsquq97LlWh4Cq1t+/166gbWWGi49X8vKT2jo9hCbgx2o6rZldmedRqPEtSm7kE8
         6KXAX1Bj1320Cafe/JT47wcu9nh850XAufj3lH6P55pC4WEzAHDOnWboH1JA9HwyIT
         +JQBikOCgPU+bSi28Ltg2Vx3Op4Lka3laaMYLz4/4RM/1gSInqLXSRh5/rOoFDeE42
         yEDdKU8rlepQ8iQijuNr5k7KvRDyAOKuVc361adBf0vmU5jm0BDEewfWdgwSb+189f
         oeaycFK4EB4lMmC1AFQXNB/Brdp49xro2DJt0BT4JTsrTFNJmYNbTiq5FbSu8emcqW
         E5cOVFIGxpEfw==
To:     Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>, Kalle Valo <kvalo@kernel.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] wifi: ath9k: fix printk specifier
In-Reply-To: <CAOiHx=kccbUFGsWMA_31UPW6p=k1qa+HyL5OGyzv50W2Mc111w@mail.gmail.com>
References: <20230706111700.14305-1-dzm91@hust.edu.cn>
 <87cz15s2gv.fsf@toke.dk>
 <CAOiHx=kccbUFGsWMA_31UPW6p=k1qa+HyL5OGyzv50W2Mc111w@mail.gmail.com>
Date:   Fri, 07 Jul 2023 15:44:41 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a5w7hm46.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jonas Gorski <jonas.gorski@gmail.com> writes:

> On Thu, 6 Jul 2023 at 13:39, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.=
dk> wrote:
>>
>> Dongliang Mu <dzm91@hust.edu.cn> writes:
>>
>> > Smatch reports:
>> >
>> > ath_pci_probe() warn: argument 4 to %lx specifier is cast from pointer
>> > ath_ahb_probe() warn: argument 4 to %lx specifier is cast from pointer
>> >
>> > Fix it by modifying %lx to %p in printk.
>> >
>> > Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
>>
>> Third time is the charm! :)
>>
>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> But do we *want* to replace %lx with %p? Because this now causes a
> change in behavior, as the kernel will omit the pointer's address,
> while before it printed the actual memory address. Using %px would
> have kept the original behavior.

So this is basically an informational log message, which really
shouldn't be leaking kernel pointer addresses. So I think %p is the
right choice here, and if someone wants to see the real address for
debugging they should be booting with no_hash_pointers.

> So if the change is desired, it should be noted in the commit message.

That is a fair point, documenting this in the commit message would be
good...

-Toke
