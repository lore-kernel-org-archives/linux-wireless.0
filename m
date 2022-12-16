Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DDEC3DA6E
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Dec 2022 21:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbiLPVHI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Dec 2022 16:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLPVHF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2022 16:07:05 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18457DEFE;
        Fri, 16 Dec 2022 13:07:02 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1671224820; bh=axhudcVXxWeMFjRH00TDHWDe3TrhCw4MAqJ4cjCF7CE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=VHKc/0Nfg+89Ggfn/Rwm8IuZRYQDPGo4fNdcuZ2Svnb2a+lnyvgJgRCdQNVNje0tN
         vQY5MOxogiokXBfqj4H3rD7fPapGP7mAIG+/dozwtWR17y2ct7skL2gewbmRxUevM7
         dlP7fqHf1iiUa9IPDonOwP+PBblEe0Jeq++RthiNqrhwNkMzw/2sjhsinjfDOmN1El
         yCbH2m0lcOUwWwsuh46C2TptFGcKpdhR3BwPnDpWiuXPlOkN02+WAKGQaKDVC8a7tX
         A+dnUjK1AZmMczNjBAIDTF+FHQcDuKXa8d3NBQ8o2wcp6RmeWLGQY8s5EfMq5SUZrt
         xYxP0dL7jqJ5g==
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: use proper statements in conditionals
In-Reply-To: <87359fkt1q.fsf@kernel.org>
References: <20221215165553.1950307-1-arnd@kernel.org>
 <87cz8jbeq8.fsf@toke.dk> <87359fkt1q.fsf@kernel.org>
Date:   Fri, 16 Dec 2022 22:06:59 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v8mb9hxo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>
>> Arnd Bergmann <arnd@kernel.org> writes:
>>
>>> From: Arnd Bergmann <arnd@arndb.de>
>>>
>>> A previous cleanup patch accidentally broke some conditional
>>> expressions by replacing the safe "do {} while (0)" constructs
>>> with empty macros. gcc points this out when extra warnings
>>> are enabled:
>>>
>>> drivers/net/wireless/ath/ath9k/hif_usb.c: In function 'ath9k_skb_queue_=
complete':
>>> drivers/net/wireless/ath/ath9k/hif_usb.c:251:57: error: suggest braces =
around empty body in an 'else' statement [-Werror=3Dempty-body]
>>>   251 |                         TX_STAT_INC(hif_dev, skb_failed);
>>>
>>> Make both sets of macros proper expressions again.
>>>
>>> Fixes: d7fc76039b74 ("ath9k: htc: clean up statistics macros")
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> I'll queue this to v6.2.

Sounds good, thanks!

-Toke
