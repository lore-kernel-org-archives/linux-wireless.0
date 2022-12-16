Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95817C4332F
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Dec 2022 20:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiLPULl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Dec 2022 15:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiLPULk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2022 15:11:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AA032B82;
        Fri, 16 Dec 2022 12:11:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A9EB81DFF;
        Fri, 16 Dec 2022 20:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359ADC433EF;
        Fri, 16 Dec 2022 20:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671221496;
        bh=c36cyYZ6f9o0WhZCEckS0zAx9IQ/4jg44Mug8y2mRQU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iFQs0uGzwd6R1tS+LzZe4DWr011uE8YAZeSx+qLLd1tjTLz5I29/zRqumOrv9DMwg
         yXdPXhzPgS2PLcjkMqri/HDiFuC0CNwkkIAD3i7y41TK1aQK6FqFqNkmXv1pf5U9Y+
         mVZ9BuNNndHYesCrnZG3g+TziBTW4G4kdJbBeubuSIfyhrvdEwPnqtwQJjjTXacUdp
         r6oqm2XNchVhXqfqmIBQjaL6I2/ca/ynMqEfgbifWYnidZlT9tHlunAbnzptNjTP13
         Rk6hGIWXR4mIGQiweb0SiSNhQa4Y0aYcIfMR7RLggD8Vnx9E63MNUJHZ2qR9DABAG/
         E//NS/7qZtcjw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
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
References: <20221215165553.1950307-1-arnd@kernel.org>
        <87cz8jbeq8.fsf@toke.dk>
Date:   Fri, 16 Dec 2022 22:11:29 +0200
In-Reply-To: <87cz8jbeq8.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Fri, 16 Dec 2022 15:33:19 +0100")
Message-ID: <87359fkt1q.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Arnd Bergmann <arnd@kernel.org> writes:
>
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> A previous cleanup patch accidentally broke some conditional
>> expressions by replacing the safe "do {} while (0)" constructs
>> with empty macros. gcc points this out when extra warnings
>> are enabled:
>>
>> drivers/net/wireless/ath/ath9k/hif_usb.c: In function 'ath9k_skb_queue_c=
omplete':
>> drivers/net/wireless/ath/ath9k/hif_usb.c:251:57: error: suggest braces a=
round empty body in an 'else' statement [-Werror=3Dempty-body]
>>   251 |                         TX_STAT_INC(hif_dev, skb_failed);
>>
>> Make both sets of macros proper expressions again.
>>
>> Fixes: d7fc76039b74 ("ath9k: htc: clean up statistics macros")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

I'll queue this to v6.2.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
