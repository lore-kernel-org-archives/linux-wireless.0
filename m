Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb1-f174.google.com ([209.85.219.174]:41833 "EHLO
        mail-yb1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeIQNlQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 09:41:16 -0400
Received: by mail-yb1-f174.google.com with SMTP id v10-v6so7365151ybm.8
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 01:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <4922c981d88ab8b16d6ebd130829b6c04d8bbc56.camel@mbuf.com>
 <CAA2SeNKshXx2e9z+iWf=pbM0SN0teT2cvnye4noEjBxtOo4Vvw@mail.gmail.com> <85af1917c8da6179f6455318d9db3132819ac1b4.camel@mbuf.com>
In-Reply-To: <85af1917c8da6179f6455318d9db3132819ac1b4.camel@mbuf.com>
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Mon, 17 Sep 2018 10:14:47 +0200
Message-ID: <CAA2SeN+ueC55MA8E5g0XcYF=6qZ0W+Dp6zNtpGOUcQBCM31wtA@mail.gmail.com> (sfid-20180917_101501_426687_29ABD0D0)
Subject: Re: desktop hard lock up (kernel panic) with Alfa AWUSB036ACM and
 wireless-testing 72d1e548defbf
To: davep@mbuf.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        dpoole@cradlepoint.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Hello. Here's the requested info.
>
> ...trillian:wireless-testing% gdb ./net/mac80211/mac80211.ko
> [...]
> (gdb) info address ieee80211_wake_txqs
> Symbol "ieee80211_wake_txqs" is a function at address 0x35890.
> [...]
> (gdb) l*(0x35890+0x1e3)
> 0x35a73 is in ieee80211_wake_txqs (net/mac80211/util.c:269).
> 264                     for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++)
> {
> 265                             struct ieee80211_txq *txq = sta-
> >sta.txq[i];
> 266
> 267                             txqi = to_txq_info(txq);
> 268
> 269                             if (ac != txq->ac)
> 270                                     continue;
> 271
> 272                             if
> (!test_and_clear_bit(IEEE80211_TXQ_STOP_NETIF_TX,
> 273                                                     &txqi->flags))

It should be fixed here:
https://marc.info/?l=linux-kernel&m=153694084922438&w=2
-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
