Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DD9C4332F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Apr 2022 09:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiDLJ4Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Apr 2022 05:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382263AbiDLIYz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Apr 2022 04:24:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42F55A0B0;
        Tue, 12 Apr 2022 00:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 769A7B81B6E;
        Tue, 12 Apr 2022 07:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACBDC385A6;
        Tue, 12 Apr 2022 07:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649750318;
        bh=S6Ecj+oMnzphF92CX567UA+xQmV0L3zOe3a4qBjW4mI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JqS1uE+bRV1nU6ZasB/x0T4MpbLev4IR8ayLND1nfOm1QBRKjluxjD978qBjLwoGs
         BL46i8KhSZk23+wrVVvYNGNjleli9Pw/BvyCvyn2p5o7s4Enrs12IULVQIzVOhDO9Q
         xChdSy6HrdOXcj13bn8DCKR6vpyA++RduWSaGMY6nOHwvIgkcyIM50Itd+Y/0zdnwi
         KaeWixq2OV6eQSWWJFXmEC60/Gitf834JoSjbCxgaGfIACaMFOBYQqfi/WYZ+sVFaD
         ETFWe/3YTCBYwKaDpD6jW17a3DYq6T6xrV3UeMQG4KuC7DJOfwvhGA5gRkE3y8luJY
         YL3oACFsv4c4A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Build regressions/improvements in v5.18-rc2
References: <CAHk-=wh0+DYC2+Aeu2=vfUtGaDqVuKxKrxyhwQFoG89rcynzww@mail.gmail.com>
        <20220411103528.2187797-1-geert@linux-m68k.org>
        <alpine.DEB.2.22.394.2204111240560.38484@ramsan.of.borg>
        <87zgkrqyff.fsf@tynnyri.adurom.net>
        <CAMuHMdUgdPBTwg8LN8x_sZRWWzdE9ZKytZuAna+qdKL1Ced5Vw@mail.gmail.com>
Date:   Tue, 12 Apr 2022 10:58:31 +0300
In-Reply-To: <CAMuHMdUgdPBTwg8LN8x_sZRWWzdE9ZKytZuAna+qdKL1Ced5Vw@mail.gmail.com>
        (Geert Uytterhoeven's message of "Tue, 12 Apr 2022 09:09:59 +0200")
Message-ID: <877d7upwbc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Hi Kalle,
>
> On Mon, Apr 11, 2022 at 8:15 PM Kalle Valo <kvalo@kernel.org> wrote:
>> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>> > On Mon, 11 Apr 2022, Geert Uytterhoeven wrote:
>> >> JFYI, when comparing v5.18-rc2[1] to v5.18-rc1[3], the summaries are:
>
>> >   + /kisskb/src/include/linux/compiler_types.h: error: call to '__compiletime_assert_491' declared with attribute error: FIELD_PREP: mask is not constant:  => 352:38
>> >   + /kisskb/src/include/linux/compiler_types.h: error: call to '__compiletime_assert_520' declared with attribute error: FIELD_PREP: mask is not constant:  => 352:38
>> >
>> > mipsel/mips-allmodconfig
>> > arm64-gcc5.4/arm64-allmodconfig
>> >
>> > Actual error is:
>> >
>> >     /kisskb/src/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c: In function 'mt76x2e_probe':
>> >     /kisskb/src/include/linux/compiler_types.h:352:38: error: call to '__compiletime_assert_520' declared with attribute error: FIELD_PREP: mask is not constant
>>
>> Does this commit fix it:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/commit/?id=dbc2b1764734857d68425468ffa8486e97ab89df
>>
>> Or is this another issue?
>
> I'm not in a position to verify this, but given both configs used gcc-5,
> I assume this will fix the issue.

Ok, do let me know if the commit doesn't fix the warning.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
