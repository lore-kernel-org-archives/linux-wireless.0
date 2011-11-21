Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:43389 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753648Ab1KUVdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 16:33:51 -0500
Date: Mon, 21 Nov 2011 22:33:22 +0100
From: Cedric Sodhi <manday@gmx.net>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: Panic/likely regression ath9k, frequent
Message-ID: <20111121213322.GA2209@slate> (sfid-20111121_223354_520581_C4BE893B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

03:00.0 0280: 168c:002b (rev 01)

AR9285

3.2.something from a not-network-related repo. Everything network
related should be equivalent to mainline.

So far I could not obtain any details, because I've no idea how to make
ramoops succeed requesting memory and unfortunally my last attempt at
using vmcore failed because somehow I lost dbg symbols. The backtrace
that I get from the vmcore looks little promising though, even without
symbols:

(gdb) bt
#0  0xffffffff8119ff42 in ?? ()
#1  0x0000000000000000 in ?? ()

Even less promising looks the size of the vmcore, which I assume to be
the size of the actual RAM in use at the point of the panic:

-r--------  1 root   root   4014652552 Nov 21 20:19 vmcore

Compared to the output in normal operation, which is when the panics
occur. At the asbolute most, 2 Gigabytes including caches.

I'm afraid, that if my interpretion of the size of vmcore is correct,
ath eats up all RAM and thereby cause the panic, milliseconds before the
crash.

Why I think it's ath9k? This panic occurs, though not clearly
reproducibly, with moderate load on the wifi, that is listening to
online radio. And a few times I could witness a panic log on the console
(mostly everything freezes right in X) and ath was clearly involved.

As I said, I'm trying to obtain anything more definite, but it could be
hard, unless I get ramoops to work, which currently refuses to accept
any memory address to write the dump to.

Of course, I readily provide any info I can from the vmcore and will try
to get a bt with proper symbols asap.

Until then, this appears to be a regression somewhere since 3.1.1 (or
possibly 3.1.0). It's hard to tell though, since it's not readily
reproducible but I have never had the panic in neither of those
versions.

Cedric
