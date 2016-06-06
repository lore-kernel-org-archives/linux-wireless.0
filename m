Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34570 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbcFFR0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 13:26:50 -0400
Received: by mail-oi0-f66.google.com with SMTP id r4so6700312oib.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2016 10:26:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA93jw7fdZhQvgCx7PXdB9yOS7ssKQFv6RG=RR2Hw9rjeXDYNQ@mail.gmail.com>
References: <CAA93jw4bwvzfOVqVAzAYJO1tmrpqEV3-=EjChgWdF-6qRhB+3Q@mail.gmail.com>
 <E1b9nQv-0001fc-00@www.xplot.org> <CAA93jw7fdZhQvgCx7PXdB9yOS7ssKQFv6RG=RR2Hw9rjeXDYNQ@mail.gmail.com>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 6 Jun 2016 10:26:49 -0700
Message-ID: <CAA93jw6_A=jjzd9KAS_k9R8xYn3a003tqORU0ufKb=eOb62auQ@mail.gmail.com> (sfid-20160606_192655_270446_B6594B33)
Subject: Re: [RFC/RFT 2/5] ath9k: use mac80211 intermediate software queues
To: Tim Shepard <shep@alum.mit.edu>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the record, michal's lastest patchset for the ath10k is here:

https://github.com/kazikcz/linux/tree/fqmac-v5

which includes the reworked codel.h support (which also landed in
net-next as of april 22) (no, haven't tried it yet, I'm only a day
back from vacation)

... but it would pay to leverage rate control more, for the ath9k, and
I'd like folk to agree on a standardized set of statistics in a std
location that can be polled for all implementations (ath9k, ath10k,
mt76)


I am also reviewing this:

http://info.iet.unipi.it/~luigi/papers/20160511-mysched-preprint.pdf

as we have a chance to innovate and use less locking with all this
stuff happening at the mac80211 layer.
