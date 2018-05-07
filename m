Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41742 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbeEGTNI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 15:13:08 -0400
Message-ID: <1525720384.22388.2.camel@sipsolutions.net> (sfid-20180507_211311_414349_F50C87C3)
Subject: Re: [PATCH 1/3] cfg80211: Expose TXQ stats and parameters to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Mon, 07 May 2018 21:13:04 +0200
In-Reply-To: <20180219170224.14816-2-toke@toke.dk> (sfid-20180219_180300_682375_800CE1A2)
References: <20180219170224.14816-1-toke@toke.dk>
         <20180219170224.14816-2-toke@toke.dk>
         (sfid-20180219_180300_682375_800CE1A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 18:02 +0100, Toke Høiland-Jørgensen wrote:
> This adds support for exporting the mac80211 TXQ stats via nl80211 by
> way of a nested TXQ stats attribute, as well as for configuring the
> quantum and limits that were previously only changeable through debugfs.

So I finally (sorry) decided to apply this, but I get a few issues with
it (aside from trivial rebase issues). If you're not able to fix them
now let me know and I can:

1) Lots of places put the sinfo on the stack, but it's now way bigger,
so we get warnings like

net/mac80211/ethtool.c: In function ‘ieee80211_get_stats’:
net/mac80211/ethtool.c:204:1: warning: the frame size of 1752 bytes is larger than 1024 bytes [-Wframe-larger-than=]
net/mac80211/ethtool.c:74 ieee80211_get_stats() warn: 'sinfo' puts 1672 bytes on stack

I guess we need to pull those out to dynamic allocations.

net/mac80211/cfg.c:3762:12: warning: context imbalance in 'ieee80211_get_txq_stats' - different lock contexts for basic block
net/mac80211/tx.c: In function ‘ieee80211_txq_set_params’:
net/mac80211/tx.c:1478:1: warning: control reaches end of non-void function [-Wreturn-type]

also show up.

johannes
